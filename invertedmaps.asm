;===================================================================================================
; Overworld map16 overlay system
;
; Static overlays (flip-gated, seed-invariant) are written by Python to a fixed
; location and applied first:
;   OverworldStaticMapPointers @ SNES $A3B000
;     dw pointers for screens $00..$81
;     ; packed overlay payloads follow
; See source/overworld/OWTileChanges.py
;
; Dynamic overlays (runtime flags / events / custom commands) remain below as
; OverworldMapChangePointers. Flip-only entries should be migrated to Python and
; removed from this table so they are not applied twice.
;===================================================================================================

OWWriteSize = $00
OWWriteIncrement = $02
OWWriteTile = $06
OWWriteCommand = $08

OWSkipLookup = $00
OWSkipFlags = $03

;---------------------------------------------------------------------------------------------------

function OWW_RLESize(s) = s<<8

!OWW_STOP             = $8000
!OWW_END              = $FFFF

!OWW_SKIP             = $FFFF

!OWW_Vertical         = $0080
!OWW_Horizontal       = $0000

;===================================================================================================

Overworld_LoadNewTiles:
	PHB

	; static tile changes in bank of OverworldStaticMapPointers
	PEA.w OverworldStaticMapPointers>>8 : PLB : PLB
	LDX.w #OverworldStaticMapPointers
	JSR .do_overlay

	; dynamic tile changes in this bank
	PHK : PLB
	LDX.w #OverworldMapChangePointers
	JSR .do_overlay

	PLB
	JSL Overworld_LoadBonkTiles

	LDX.w #$001E
	LDA.w #$0DBE

	RTL

.do_overlay
	LDA.b OverworldIndex
	CMP.w #$0082
	BCS .changes_done

	ASL
	STX.b OWWriteSize
	CLC : ADC.b OWWriteSize
	TAX

	; give Y the pointer to our data
	LDA.w $0000,X
	TAY
	BNE .next_tile

.changes_done
	RTS

.next_tile
	; format:
	;   dw <tile>, <pos>
	; or if bit 15 is set
	;   dw <command>, <params>...
	; commands are:
	;   1sss ssss dccc cccc
	;     s - size (if applicable)
	;     d - direction (if applicable)
	;     c - command id
	;  FFFF is end
	LDA.w $0000,Y
	INY
	INY
	TAX
	BMI .command

	LDX.w $0000,Y
	STA.l $7E0000,X

	INY
	INY

	BRA .next_tile

	; when using commands, list parameters will never have bit-15 set
	; so we use that as our sentinel in data lists
	; we could encode the size for everything
	; but that makes adjustments more burdensome
.command
	CMP.w #!OWW_END
	BEQ .changes_done

	STA.b OWWriteCommand

	AND.w #$007F
	ASL
	TAX

	JSR (.command_vectors,X)

	BRA .next_tile

.command_vectors
	; dw !OWW_Stripe|!OWW_<direction>
	; dw <start>
	; dw <tile1>, <tile2>, ... <tileN>|!OWW_STOP
	;    use !SKIP to not place a tile but continue the stripe
	!OWW_Stripe                    = $8000
	dw .stripe                      ; 00

	; dw !OWW_StripeRLE|!OWW_<direction>|RLESize(<size>)
	; dw <tile>, <start>
	!OWW_StripeRLE                 = $8001
	dw .stripe_rle                  ; 01

	; dw !OWW_StripeRLEINC|!OWW_<direction>|RLESize(<size>)
	; dw <tile>, <start>
	!OWW_StripeRLEINC              = $8002
	dw .stripe_rle_inc              ; 02

	; dw !OWW_ArbTileCopy
	; dw <tile>
	; dw <pos1>, <pos2>, ... <posN>|!OWW_STOP
	!OWW_ArbTileCopy               = $8003
	dw .arbitrary_tile_copy         ; 03

	dw .nothing                     ; 04
	dw .nothing                     ; 05
	dw .nothing                     ; 06
	dw .nothing                     ; 07
	dw .nothing                     ; 08
	dw .nothing                     ; 09

	; dw !OWW_SkipAhead, <address>
	;    skips to <address> unconditionally
	!OWW_SkipAhead                 = $800A
	dw .skip_ahead                  ; 0A

	; dw !OWW_SkipIfFlagSet, <lookup>, <bitflags>, <address>
	;    skips to <address> when value at <lookup> has bits matching <bitflags>
	!OWW_SkipIfFlagSet             = $800B
	dw .flag_skip                   ; 0B

	; dw !OWW_SkipIfNotFlagSet, <lookup>, <bitflags>, <address>
	;    skips to <address> when value at <lookup> has bits not matching <bitflags>
	!OWW_SkipIfNotFlagSet          = $800C
	dw .flag_block                  ; 0C

	; dw !OWW_SkipIfInverted, <address>
	;    skips to <address> when inverted mode
	!OWW_SkipIfInverted            = $800D
	dw .inverted_skip               ; 0D

	; dw !OWW_SkipIfNotInverted, <address>
	;    skips to <address> when not inverted
	!OWW_SkipIfNotInverted         = $800E
	dw .inverted_block              ; 0E

	; dw !OWW_InvertedOnly
	;    cancels everything if not inverted
	!OWW_InvertedOnly              = $800F
	dw .inverted_only               ; 0F

	; dw !OWW_CustomCommand, <vector>
	!OWW_CustomCommand             = $8010
	dw .custom_command              ; 10

	; dw !OWW_SkipIfNotEqual, <lookup>, <value>, <address>
	;    skips to <address> when value at <lookup> is not equal to <value>
	!OWW_SkipIfNotEqual            = $8011
	dw .equal_block                 ; 11

	dw .nothing                     ; 12
	dw .nothing                     ; 13
	dw .nothing                     ; 14
	dw .nothing                     ; 15
	dw .nothing                     ; 16
	dw .nothing                     ; 17
	dw .nothing                     ; 18
	dw .nothing                     ; 19

;---------------------------------------------------------------------------------------------------

.custom_command
	TYX

	INY
	INY

	JMP.w ($0000,X)

;---------------------------------------------------------------------------------------------------

.skip_ahead
	LDX.w $0000,Y
	INY : INY

	TXY

	RTS

;---------------------------------------------------------------------------------------------------

.flag_skip
	LDX.w $0000,Y : STX.b OWSkipLookup
	INY : INY
	LDX.w $0000,Y : STX.b OWSkipFlags-1
	INY : INY
	LDX.w $0000,Y
	INY : INY

	SEP #$20
	LDA.b [OWSkipLookup]
	AND.b OWSkipFlags
	CMP.b OWSkipFlags
	REP #$20
	BNE .nothing

	TXY

	RTS

;---------------------------------------------------------------------------------------------------

.flag_block
	LDX.w $0000,Y : STX.b OWSkipLookup
	INY : INY
	LDX.w $0000,Y : STX.b OWSkipFlags-1
	INY : INY
	LDX.w $0000,Y
	INY : INY

	SEP #$20
	LDA.b [OWSkipLookup]
	AND.b OWSkipFlags
	CMP.b OWSkipFlags
	REP #$20
	BEQ .nothing

	TXY

	RTS

;---------------------------------------------------------------------------------------------------

.inverted_skip
	LDX.w $0000,Y

	INY
	INY

	PHX
		SEP #$20
		LDX.b OverworldIndex : LDA.l OWTileMapAlt, X
		REP #$20
	PLX
	AND.w #$0001
	BEQ .nothing

	TXY

.nothing
	RTS

;---------------------------------------------------------------------------------------------------

.inverted_block
	LDX.w $0000,Y
	INY
	INY
	BRA .check_inverted

#ReliableOWWSentinel:
	dw !OWW_END

.inverted_only
	LDX.w #ReliableOWWSentinel

.check_inverted
	PHX
		SEP #$20
		LDX.b OverworldIndex : LDA.l OWTileMapAlt, X
		REP #$20
	PLX
	AND.w #$0001
	BNE .nothing

	TXY

	RTS

;---------------------------------------------------------------------------------------------------

.equal_block
	LDX.w $0000,Y : STX.b OWSkipLookup
	INY : INY
	LDX.w $0000,Y : STX.b OWSkipFlags-1
	INY : INY
	LDX.w $0000,Y
	INY : INY

	SEP #$20
	LDA.b [OWSkipLookup]
	CMP.b OWSkipFlags
	REP #$20
	BEQ .nothing

	TXY

	RTS

;---------------------------------------------------------------------------------------------------

.get_increment
	LDA.b OWWriteCommand
	AND.w #$0080
	BNE .vertical_increment

	LDA.w #$0002

.vertical_increment
	STA.b OWWriteIncrement

	RTS

;---------------------------------------------------------------------------------------------------

.stripe
	JSR .get_increment

	LDX.w $0000,Y

	BRA ++ ; to increment at start of loop properly

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

++	INY
	INY

	LDA.w $0000,Y
	BMI .end_stripe_maybe

	STA.l $7E0000,X
	BRA --

.end_stripe_maybe
	CMP.w #!OWW_SKIP ; just skip, so we can have fewer discontinuous commands
	BEQ --

	AND.w #$7FFF
	STA.l $7E0000,X

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.stripe_rle_inc
	JSR .get_increment
	JSR .get_rle_size_and_tile

	LDX.w $0000,Y
	BRA ++

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

	LDA.b OWWriteTile
	INC
	STA.b OWWriteTile

++	STA.l $7E0000,X

	DEC.b OWWriteSize
	BNE --

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.get_rle_size_and_tile
	LDA.b OWWriteCommand+1
	AND.w #$007F
	STA.b OWWriteSize

	LDA.w $0000,Y
	STA.b OWWriteTile

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.stripe_rle
	JSR .get_increment
	JSR .get_rle_size_and_tile

	LDX.w $0000,Y
	BRA ++

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

	LDA.b OWWriteTile

++	STA.l $7E0000,X

	DEC.b OWWriteSize
	BNE --

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------
; Don't use SKIP with this, since that's not really meaningful anyways...
;---------------------------------------------------------------------------------------------------
.arbitrary_tile_copy
	LDA.w $0000,Y

--	INY
	INY

	LDX.w $0000,Y
	BMI .last_arb

	STA.l $7E0000,X
	BRA --

.last_arb
	PHA

	TXA
	AND.w #$7FFF
	TAX

	PLA

	STA.l $7E0000,X

	INY
	INY

	RTS

;===================================================================================================

OverworldMapChangePointers:
	; light world
	dw $0000      ; 00
	dw $0000      ; 01
	dw $0000      ; 02
	dw $0000      ; 03
	dw $0000      ; 04
	dw $0000      ; 05
	dw $0000      ; 06
	dw .map07     ; 07
	dw $0000      ; 08
	dw $0000      ; 09
	dw $0000      ; 0A
	dw $0000      ; 0B
	dw $0000      ; 0C
	dw $0000      ; 0D
	dw $0000      ; 0E
	dw $0000      ; 0F
	dw $0000      ; 10
	dw $0000      ; 11
	dw $0000      ; 12
	dw $0000      ; 13
	dw $0000      ; 14
	dw .map15     ; 15
	dw $0000      ; 16
	dw $0000      ; 17
	dw $0000      ; 18
	dw $0000      ; 19
	dw $0000      ; 1A
	dw .map1B     ; 1B
	dw $0000      ; 1C
	dw $0000      ; 1D
	dw .map1E     ; 1E
	dw $0000      ; 1F
	dw $0000      ; 20
	dw $0000      ; 21
	dw $0000      ; 22
	dw $0000      ; 23
	dw $0000      ; 24
	dw $0000      ; 25
	dw $0000      ; 26
	dw $0000      ; 27
	dw $0000      ; 28
	dw $0000      ; 29
	dw $0000      ; 2A
	dw $0000      ; 2B
	dw $0000      ; 2C
	dw $0000      ; 2D
	dw $0000      ; 2E
	dw $0000      ; 2F
	dw $0000      ; 30
	dw $0000      ; 31
	dw $0000      ; 32
	dw $0000      ; 33
	dw $0000      ; 34
	dw $0000      ; 35
	dw $0000      ; 36
	dw $0000      ; 37
	dw $0000      ; 38
	dw $0000      ; 39
	dw $0000      ; 3A
	dw $0000      ; 3B
	dw $0000      ; 3C
	dw $0000      ; 3D
	dw $0000      ; 3E
	dw $0000      ; 3F

	; dark world
	dw $0000      ; 40
	dw $0000      ; 41
	dw $0000      ; 42
	dw .map43     ; 43
	dw $0000      ; 44
	dw $0000      ; 45
	dw $0000      ; 46
	dw $0000      ; 47
	dw $0000      ; 48
	dw $0000      ; 49
	dw $0000      ; 4A
	dw $0000      ; 4B
	dw $0000      ; 4C
	dw $0000      ; 4D
	dw $0000      ; 4E
	dw $0000      ; 4F
	dw $0000      ; 50
	dw $0000      ; 51
	dw $0000      ; 52
	dw $0000      ; 53
	dw $0000      ; 54
	dw $0000      ; 55
	dw $0000      ; 56
	dw $0000      ; 57
	dw $0000      ; 58
	dw $0000      ; 59
	dw $0000      ; 5A
	dw .map5B     ; 5B
	dw $0000      ; 5C
	dw $0000      ; 5D
	dw .map5E     ; 5E
	dw $0000      ; 5F
	dw $0000      ; 60
	dw $0000      ; 61
	dw $0000      ; 62
	dw $0000      ; 63
	dw $0000      ; 64
	dw $0000      ; 65
	dw $0000      ; 66
	dw $0000      ; 67
	dw $0000      ; 68
	dw $0000      ; 69
	dw $0000      ; 6A
	dw $0000      ; 6B
	dw $0000      ; 6C
	dw $0000      ; 6D
	dw $0000      ; 6E
	dw $0000      ; 6F
	dw $0000      ; 70
	dw $0000      ; 71
	dw $0000      ; 72
	dw $0000      ; 73
	dw $0000      ; 74
	dw $0000      ; 75
	dw $0000      ; 76
	dw $0000      ; 77
	dw $0000      ; 78
	dw $0000      ; 79
	dw .map7A     ; 7A
	dw $0000      ; 7B
	dw $0000      ; 7C
	dw $0000      ; 7D
	dw $0000      ; 7E
	dw $0000      ; 7F
	dw .map80     ; 80
	dw $0000      ; 81

;---------------------------------------------------------------------------------------------------

.map07
	dw !OWW_InvertedOnly

	; replace ladder with mountainside
	dw !OWW_SkipIfFlagSet
		dl OverworldEventDataWRAM+$07
		db $10
		dw ReliableOWWSentinel

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $0152, $2A20 ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $00E3, $2AA0 ; tile, start

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map1B
	dw !OWW_InvertedOnly

	; Bat hole
	dw !OWW_SkipIfNotFlagSet
		dl OverworldEventDataWRAM+$5B
		db $20
		dw ReliableOWWSentinel

	dw $046D, $243E
	dw $0E39, $2440

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3A, $24BC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3E, $253C ; tile, start

	dw $0490, $25BE
	dw $0491, $25C0

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map5B
	dw !OWW_InvertedOnly

	dw $0034, $3BBE  ; pre-aga portal

	dw !OWW_SkipIfNotEqual
		dl ProgressIndicator
		db $03
		dw ReliableOWWSentinel

	dw $0212, $3BBE  ; post-aga portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map15
.map1E
.map43
.map5E
.map7A
.map80
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_END

;===================================================================================================

Overworld_InvertedTRPuzzle:
{
    REP #$30
    LDA.l OWTileMapAlt+07 : AND.w #$00FF : BNE .inverted
        LDA.w #$0212 : LDX.w #$0720 : STA.l TileMapA,X ; what we wrote over
        JSL Overworld_MemorizeMap16Change : JSL Overworld_DrawPersistentMap16+4 ; what we wrote over
        RTL

    ; removes barriers from TR Peg Puzzle Ledge
    .inverted
    LDA.w #$0184 : LDX.w #$0A20 : JSL Overworld_DrawPersistentMap16
    LDA.w #$0184 : LDX.w #$0AA0 : JSL Overworld_DrawPersistentMap16
    LDA.w #$0185 : LDX.w #$0A22 : JSL Overworld_DrawPersistentMap16
    LDA.w #$0185 : LDX.w #$0AA2 : JSL Overworld_DrawPersistentMap16
    RTL
}

Overworld_OtherTileChanges:
{
	if !FEATURE_LIMITED_RUN == 2604
		PHX : PHY : PHB
		PEA.w $7E00 : PLB : PLB
			JSL Limited_OverworldPedestalTileChanges
		PLB : PLY : PLX
	endif
	RTS
}
