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
	JSL Overworld_LoadBonkTiles
	
	LDA.b OverworldIndex
	CMP.w #$0082
	BCS .exit

	ASL
	TAX

	LDA.l OverworldMapChangePointers,X
	BNE .do_overlay

.exit
	LDX.w #$001E
	LDA.w #$0DBE

	RTL

.end
	PLB
	BRA .exit

.do_overlay
	PHB
	PHK
	PLB

	; give Y the pointer to our data
	TAY

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
	BEQ .end

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
	dw .map03     ; 03
	dw $0000      ; 04
	dw .map05     ; 05
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
	dw .map10     ; 10
	dw $0000      ; 11
	dw $0000      ; 12
	dw $0000      ; 13
	dw .map14     ; 14
	dw .map15     ; 15
	dw $0000      ; 16
	dw $0000      ; 17
	dw $0000      ; 18
	dw $0000      ; 19
	dw .map1A     ; 1A
	dw .map1B     ; 1B
	dw $0000      ; 1C
	dw $0000      ; 1D
	dw .map1E     ; 1E
	dw $0000      ; 1F
	dw $0000      ; 20
	dw $0000      ; 21
	dw .map22     ; 22
	dw $0000      ; 23
	dw $0000      ; 24
	dw $0000      ; 25
	dw $0000      ; 26
	dw $0000      ; 27
	dw $0000      ; 28
	dw .map29     ; 29
	dw $0000      ; 2A
	dw $0000      ; 2B
	dw $0000      ; 2C
	dw $0000      ; 2D
	dw $0000      ; 2E
	;dw .map2F     ; 2F
	dw $0000      ; 2F
	dw .map30     ; 30
	dw $0000      ; 31
	dw .map32     ; 32
	;dw .map33     ; 33
	dw $0000      ; 33
	dw $0000      ; 34
	dw .map35     ; 35
	dw $0000      ; 36
	dw $0000      ; 37
	dw $0000      ; 38
	dw $0000      ; 39
	dw .map3A     ; 3A
	dw $0000      ; 3B
	dw $0000      ; 3C
	dw $0000      ; 3D
	dw $0000      ; 3E
	dw .map3F     ; 3F

	; dark world
	dw $0000      ; 40
	dw $0000      ; 41
	dw $0000      ; 42
	dw .map43     ; 43
	dw $0000      ; 44
	dw .map45     ; 45
	dw $0000      ; 46
	dw .map47     ; 47
	dw $0000      ; 48
	dw $0000      ; 49
	dw $0000      ; 4A
	dw $0000      ; 4B
	dw $0000      ; 4C
	dw $0000      ; 4D
	dw $0000      ; 4E
	dw $0000      ; 4F
	dw .map50     ; 50
	dw $0000      ; 51
	dw $0000      ; 52
	dw $0000      ; 53
	dw $0000      ; 54
	dw $0000      ; 55
	dw $0000      ; 56
	dw $0000      ; 57
	dw $0000      ; 58
	dw $0000      ; 59
	dw .map5A     ; 5A
	dw .map5B     ; 5B
	dw $0000      ; 5C
	dw $0000      ; 5D
	dw .map5E     ; 5E
	dw $0000      ; 5F
	dw $0000      ; 60
	dw $0000      ; 61
	dw .map62     ; 62
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
	dw .map6F     ; 6F
	dw .map70     ; 70
	dw $0000      ; 71
	dw $0000      ; 72
	dw .map73     ; 73
	dw $0000      ; 74
	dw .map75     ; 75
	dw $0000      ; 76
	dw $0000      ; 77
	dw $0000      ; 78
	dw $0000      ; 79
	dw .map7A     ; 7A
	dw $0000      ; 7B
	dw $0000      ; 7C
	dw $0000      ; 7D
	dw $0000      ; 7E
	dw .map7F     ; 7F
	dw .map80     ; 80
	dw $0000      ; 81

;---------------------------------------------------------------------------------------------------

.map03
	dw !OWW_InvertedOnly

	; singles
	dw $0034, $2BE0 ; portal

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	dw !OWW_Stripe|!OWW_Horizontal
	dw $29B6 ; address
	dw $021A, $01F3, $00A0, $0104|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00C6 ; tile
	dw $2A34, $2A38, $2A3A|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map05
	dw $0101, $2E18 ; OWG sign

	dw !OWW_InvertedOnly

	dw $0034, $3D4A ; portal

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw .map05_spiral_mimic_ledge

	; singles
	dw $0034, $21F2
	dw $0116, $216E
	dw $0126, $21F4

	dw $0139, $2C6C
	dw $014B, $2C6E
	dw $016B, $29F0
	dw $016B, $2CEC
	dw $0182, $29F2
	dw $0182, $2CEE

	dw !OWW_Stripe|!OWW_Horizontal
	dw $206E ; address
	dw $0111, $0113, $0113, $0112|!OWW_STOP

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0111, $20EC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(3)
	dw $0116, $20F0 ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $216C ; address
	dw $0112, $0116, $011C, $011D, $011E|!OWW_STOP

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(3)
	dw $011C, $2170 ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0123, $21EC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0144, $2364 ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $01B3, $236C ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2970 ; address
	dw $0139, $014B|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0130 ; tile
	dw $21E2, $21F0, $22E2, $22F0|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0135 ; tile
	dw $2262, $2270, $2362, $2370|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0136 ; tile
	dw $2264, $2266, $226C, $226E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0137 ; tile
	dw $2268, $226A|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $22E4 ; start
	dw $013C, $013C, $013D, $013D, $013C, $013C|!OWW_STOP

.map05_spiral_mimic_ledge
	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $00E3, $2BDC ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $014E, $2C5C ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $014E, $2C64 ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2C60 ; start
	dw $0139, $014B|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $0152, $2CDC ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0152, $2CE4 ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2CE0 ; start
	dw $016B, $0182|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $022E, $2D5C ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(3)
	dw $0230, $2DDC ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(3)
	dw $0230, $2DE6 ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $02A6, $2DE2 ; tile, start

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map07
	dw !OWW_InvertedOnly

	; ledge barrier
	dw !OWW_Stripe|!OWW_Horizontal
	dw $251C ; start
	dw $0163, $0152, $0152, $0152, $0152, $01F2|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $259A ; start
	dw $0163, $011C, $011D, $011D, $011D, $011D, $011E, $01F2|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2618 ; start
	dw $0163, $0124, $0124, $0124, $0124, $0124, $0140|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $262A ; start
	dw $01F2, $0127, $0127, $0127, $0127, $0127, $0150|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $299A ; start
	dw $0161, $0141, $014E, $014E, $014E, $014E, $014F, $0150|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0125 ; tile
	dw $261C, $269A|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0126 ; tile
	dw $2626, $26A8|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0139 ; tile
	dw $289A, $291C|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $014B ; tile
	dw $28A8, $2926|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0152 ; tile
	dw $2A1E, $2A24|!OWW_STOP

	dw $011C, $261A
	dw $011E, $2628
	dw $00CE, $2896
	dw $016A, $28AC
	dw $0141, $291A
	dw $014F, $2928
	dw $0161, $2A1C
	dw $0150, $2A26
	dw $021B, $2620 ; moved peg

	dw !OWW_SkipIfFlagSet
		dl OverworldEventDataWRAM+$07
		db $10
		dw ReliableOWWSentinel

	; replace ladder with mountainside
	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $0152, $2A20 ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $00E3, $2AA0 ; tile, start

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map10
	dw !OWW_InvertedOnly

	dw $0034, $2B2E

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map14
	dw !OWW_InvertedOnly

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	dw !OWW_Stripe|!OWW_Vertical
	dw $2422
	dw $02F1, $0184, $0184|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2424
	dw $02F2, $0185, $0185|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map15
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map1A
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$1A
		db $02
		dw ReliableOWWSentinel

	; rocks for hardlock protection
	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $02F8, $2FBC ; tile, start

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map1B
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$1B
		db $02
		dw .map1B_inverted

	; rocks for hardlock protection
	dw !OWW_Stripe|!OWW_Vertical
	dw $2FFE ; start
	dw $039A, $039B|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2F80 ; start
	dw $02FA, $030A, $030D|!OWW_STOP

.map1B_inverted
	dw !OWW_InvertedOnly

	; Eye removed
	dw !OWW_ArbTileCopy
	dw $046D ; tile
	dw $243E, $24BC, $24BE, $253E
	dw $2440, $24C0, $24C2, $2540|!OWW_STOP

	; New trees
	dw !OWW_Stripe|!OWW_Vertical
	dw $2DAA ; address
	dw $0034, $04BA, $04BB, $0034|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2DB0 ; address
	dw $0034, $04BA, $04BB, $0034|!OWW_STOP

	; New HC door
	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $044F, $201C ; tile, start

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $0455, $209C ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $045A, $211A ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0463, $219A ; tile, start

	; Bat hole
	dw !OWW_SkipIfNotFlagSet
		dl OverworldEventDataWRAM+$5B
		db $20
		dw .map1B_no_hole

	dw $046D, $243E
	dw $0E39, $2440

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3A, $24BC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3E, $253C ; tile, start

	dw $0490, $25BE
	dw $0491, $25C0

.map1B_no_hole
	dw $0101, $2252 ; goal sign

	dw !OWW_SkipIfNotFlagSet
		dl SwapAgaGanonsTower
		db $01
		dw #ReliableOWWSentinel

	dw $0101, $222C ; tower entry sign

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map1E
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map22
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$22
		db $02
		dw ReliableOWWSentinel

	; rocks for hardlock protection
	dw $02B9, $203C
	dw $0309, $203E
	dw $030E, $20BE

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map29
	dw !OWW_InvertedOnly

	; singles
	dw $0034, $248A ; remove bush
	dw $0036, $2386 ; add bush

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

; .map2F
; 	dw !OWW_InvertedOnly

; 	dw $0034, $2BB2 ; add portal

; 	dw !OWW_END

;---------------------------------------------------------------------------------------------------
.map30
	dw !OWW_InvertedOnly

	dw $0034, $3D94 ; remove portal

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	; Checkerboard cave mods
	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00D1, $2052

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00C9, $20D2

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00DC, $2152

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00D1, $2266

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $0721, $22E6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00CC, $2366

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0384, $25E6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $06B4, $2662

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(9)
	dw $0165, $26E0

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2460 ; address
	dw $00A3, $00D5, $00C5, $063D, $0384, $00AB, $0384|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2552 ; address
	dw $06E5, $063D, $06AB, $0109, $06AA, $06AA, $06AA
	dw $010C, $0106, $0107, $06AB, $0384|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $25D2 ; address
	dw $06E5, $06AB, $0109, $010C, $06A7, $06A7
	dw $06A7, $0106, $0107, $06AB|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2652 ; address
	dw $06E5, $06AB, $010C, $0105, $0106, $0165, $0166, $0766|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $24E0 ; address
	dw $0109, $00D5, $00C5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $224C ; address
	dw $00DC, $00C9, $0386, $0759|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $21CE ; address
	dw $0153, $0153, $0153, $0256, $0757, $0759|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2150 ; address
	dw $0153, $0178, $0153, $0256, $06AB, $06AB, $0757, $0759|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $26D2 ; address
	dw $06E5, $06E5, $06E5, $0759|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $26D6 ; address
	dw $00D5, $00D5, $00D5, $00D5, $01E9|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $26D8 ; address
	dw $00C4, $00CF, $0302, $00C5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $20DE ; address
	dw $00D0, $00C8, $00CA, $00C8, $00DB|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2160 ; address
	dw $00D0, $00C8, $00CA, $00C8, $00DB, $009E|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $21E2 ; address
	dw $00D0, $00C8, $00CA, $00D3, $00CE|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2264 ; address
	dw $00D0, $00C8, $0302, $00C5|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $06AB
	dw $23D2, $23E6, $2452, $2454, $24D4
	dw $24E6, $26D4, $2754, $27D4|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00D2
	dw $205E, $20E0, $2162, $21E4, $275C|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $017E
	dw $2050, $20CE|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0183
	dw $20D0, $214E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0384
	dw $24D8, $24EA|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0757
	dw $24D2, $2854|!OWW_STOP

	dw $00AB, $2352
	dw $0171, $26DE
	dw $0759, $28D4

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map32
	dw !OWW_InvertedOnly

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	; Cave 45 mods
	dw $01D5, $2486
	dw $0165, $2506
	dw $0166, $2508
	dw $0220, $278C
	dw $075E, $299A
	dw $00AB, $299C
	dw $0BDB, $2C0A

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2586
	dw $00C6, $0171, $0166|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A1A
	dw $075F, $00C6, $01E5, $077E|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A9A
	dw $0775, $01E5, $077E, $0106, $0165|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B1A
	dw $075F, $077E, $0106, $0107, $00C6|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B9C
	dw $00D5, $00C5, $00C6|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $009F, $2812

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $06E1, $2890

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0034, $29A2

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $00C6, $2608

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $021C, $260A

	dw !OWW_ArbTileCopy
	dw $0167
	dw $2488, $250A, $258C, $2A28, $2AAA, $2B2C, $2BAE|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0160
	dw $248A, $250C, $2A2A, $2AAC, $2B2E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $017C
	dw $270E, $2790, $281A, $289C, $291E, $29A0|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $01FF
	dw $278E, $2810, $289A, $291C, $299E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0757
	dw $280E, $2898, $291A|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0034
	dw $281C, $289E, $2920|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0759
	dw $288E, $2918, $2B9A|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EC
	dw $2A8A, $2A8E, $2A92, $2A94, $2A96, $2C0C|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0789
	dw $2B0A, $2B0E, $2B14, $2B94|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EB
	dw $2B12, $2B16, $2C8C, $2C94|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0BDC
	dw $2B8A, $2B8E, $2C0E, $2C14|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

; .map33
; 	dw !OWW_InvertedOnly

; 	dw $0034, $22A8 ; remove portal

; 	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map35
	dw !OWW_InvertedOnly

	dw $0034, $2F56 ; remove portal

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	dw !OWW_Stripe|!OWW_Vertical
	dw $2BB0
	dw $02F1, $0184, $0392, $0394|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2BB2
	dw $02F2, $0185, $0393, $0395|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map3A
	dw !OWW_InvertedOnly

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	dw $0964, $2984
	dw $017E, $2986

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $0184, $2A04

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $0185, $2A06

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map3F
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$3F
		db $02
		dw ReliableOWWSentinel

	dw !OWW_SkipIfFlagSet
		dl OWTileWorldAssoc+$3F
		db $40
		dw ReliableOWWSentinel

	dw !OWW_StripeRLEINC|!OWW_Vertical|OWW_RLESize(2)
	dw $075C, $2A9A ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A22
	dw $0752, $0753, $02E5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A9E
	dw $0774, $06E1, $0757, $06E3, $02E5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B1E
	dw $076E, $02E5, $0759, $0779|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B9E
	dw $076C, $02EC, $06F5, $0705|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2C1E
	dw $0704, $06F6, $06F7, $06E3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2CA2
	dw $0762, $0773|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EC ; tile
	dw $29A4, $2C16|!OWW_STOP

	dw $075E, $2B9A
	dw $076F, $2C1A

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map43
	dw !OWW_SkipIfFlagSet
		dl SwapAgaGanonsTower
		db $01
		dw .map43_atgt_swapped

	dw $0101, $2550 ; GT sign
	dw !OWW_SkipAhead, .map43_inverted

.map43_atgt_swapped
	; GT entrance auto-opened
	dw !OWW_Stripe|!OWW_Vertical
	dw $235E ; start
	dw $08D5, $08E3, $0E90, $0E96, $0E96, $0E94|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2360 ; start
	dw $08D6, $08E4, $0E91, $0E97, $0E97, $0E95|!OWW_STOP

.map43_inverted
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_InvertedOnly

	dw $0212, $2BE0 ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map45
	dw !OWW_InvertedOnly

	dw $0239, $3D4A ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map47
	dw !OWW_InvertedOnly

	; portals
	dw $0239, $269E
	dw $0239, $26A4

	dw !OWW_SkipIfFlagSet
		dl WarningFlags
		db $20
		dw ReliableOWWSentinel

	; Turtle tail hop
	dw $0398, $25A0
	dw $0522, $25A2
	dw $0125, $2620
	dw $0126, $2622

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map50
	dw !OWW_InvertedOnly

	dw $020F, $2B2E ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map5A
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$5A
		db $02
		dw ReliableOWWSentinel

	; rocks for hardlock protection
	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $02F8, $2FBC ; tile, start

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

; Pyramid
.map5B
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$5B
		db $02
		dw .map5B_continue

	; rocks for hardlock protection
	dw !OWW_Stripe|!OWW_Vertical
	dw $2F80 ; start
	dw $02FA, $030A, $030D|!OWW_STOP

	dw !OWW_StripeRLEINC|!OWW_Vertical|OWW_RLESize(2)
	dw $039A, $2FFE ; tile, start

.map5B_continue
	dw !OWW_SkipIfInverted, .map5B_inverted

	dw $0101, $27B6 ; sign to statue
	dw $05C2, $27B4 ; peg left of sign

	dw !OWW_InvertedOnly

.map5B_inverted
	; Seal pyramid entrance
	dw !OWW_Stripe|!OWW_Horizontal
	dw $2E1C
	dw $0A06, $0A0E|!OWW_STOP

	; South pyramid terrain 
	dw $0323, $39B6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0324, $39B8

	dw $02FE, $3A34
	dw $02FF, $3A36
	dw $0235, $3BB4

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0326, $3A38

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3AB2
	dw $039D, $0303, $0232
	dw $0233, $0233, $0233, $0233|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3B32
	dw $03A2, $0232, $0235, $046A
	dw $0333, $0333, $0333|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $3BB6, $3BBA, $3BBC, $3C3A
	dw $3C3C, $3C3E|!OWW_STOP

	dw $00F2, $3BB8
	dw $0108, $3C38

	dw !OWW_Stripe|!OWW_Horizontal
	dw $39C0 ; start
	dw $0324, $0324, $0324, $0325, $02D5
	dw !OWW_SKIP, $02CC|!OWW_STOP

	dw $02CC, $39D4

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3A40 ; start
	dw $0326, $0326, $0326
	dw $0327, $02F7, !OWW_SKIP
	dw $02E3, $02E3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3AC0 ; start
	dw $0233, $0233, $0233, $0234
	dw $02F6, $0396|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3B40
	dw $0333, $0333, $03AA, $03A3
	dw $0234, $0397|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3BC0 ; start
	dw $0034, $0034, $029C, $0034
	dw $03A3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3C40 ; start
	dw $0034, $0034, $010A|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(17)
	dw $010B, $3C46

	dw !OWW_CustomCommand, .map5B_pick_warp_tile

	dw !OWW_END

.map5B_pick_warp_tile
	LDA.l ProgressIndicator
	AND.w #$00FF
	CMP.w #$0003

	LDA.w #$0034
	BCC ++

	LDA.w #$0212

++	STA.l $7E3BBE

	RTS

;---------------------------------------------------------------------------------------------------

.map5E
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map62
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$62
		db $02
		dw ReliableOWWSentinel

	; rocks for hardlock protection
	dw $02B9, $203C
	dw $0309, $203E
	dw $030E, $20BE

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map6F
	dw !OWW_InvertedOnly

	dw $020F, $2BB2 ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map70
	dw !OWW_InvertedOnly

	dw $0239, $3D94 ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map73
	dw !OWW_InvertedOnly

	dw $020F, $22A8 ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map75
	dw !OWW_InvertedOnly

	dw $0239, $3352 ; add portal

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map7A
	dw !OWW_CustomCommand, Overworld_OtherTileChanges

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map7F
	dw !OWW_SkipIfNotFlagSet
		dl OWTileMapAlt+$7F
		db $02
		dw ReliableOWWSentinel

	dw !OWW_SkipIfFlagSet
		dl OWTileWorldAssoc+$7F
		db $40
		dw ReliableOWWSentinel

	dw !OWW_StripeRLEINC|!OWW_Vertical|OWW_RLESize(2)
	dw $075C, $2A9A ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A22
	dw $0752, $0753, $02E5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2A9E
	dw $0774, $06E1, $0757, $06E3, $02E5|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B1E
	dw $076E, $02E5, $0759, $0779|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2B9E
	dw $076C, $02EC, $06F5, $0705|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2C1E
	dw $0704, $06F6, $06F7, $06E3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2CA2
	dw $0762, $0773|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EC ; tile
	dw $29A4, $2C16|!OWW_STOP

	dw $075E, $2B9A
	dw $076F, $2C1A

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

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
