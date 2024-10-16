;================================================================================
; Utility Functions
;================================================================================
; GetSpriteTile
; in:	A - Loot ID
; out:	A - Sprite GFX ID
;--------------------------------------------------------------------------------
GetSpriteID:
	JSL AttemptItemSubstitution
	JSR ResolveLootID
        CMP.b #$6D : BEQ .server_F0 ; Server Request F0
        CMP.b #$6E : BEQ .server_F1 ; Server Request F1
        CMP.b #$6F : BEQ .server_F2 ; Server Request F2
	BRA .normal
                .server_F0
                JSL ItemVisualServiceRequest_F0
                BRA .normal
                .server_F1
                JSL ItemVisualServiceRequest_F1
		BRA .normal
		.server_F2
		JSL ItemVisualServiceRequest_F2
	.normal
	PHX
	TAX : LDA.l ItemReceipts_graphics, X ; look up item gfx
	PLX
RTL

;--------------------------------------------------------------------------------
; GetSpritePalette
; in:	A - Loot ID
; out:	A - Palette
;--------------------------------------------------------------------------------
GetSpritePalette:
        JSL AttemptItemSubstitution
        JSR ResolveLootID
        .resolved
        TAX
        LDA.l SpriteProperties_standing_palette, X : BIT #$80 : BNE .load_palette
        ASL
RTL
        .load_palette
        JSL LoadItemPalette
        ASL
RTL

;--------------------------------------------------------------------------------
; PrepDynamicTile
;-------------------------------------------------------------------------------- 20/8477
PrepDynamicTile:
	PHX : PHY : PHB
	LDA.l RemoteItems : BEQ .notRemote
		LDA.w SprItemReceipt, X : CMP.l !MULTIWORLD_SCOUTREPLY_LOCATION : BNE ++
			LDA.l !MULTIWORLD_SCOUTREPLY_PLAYER : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
			LDA.l !MULTIWORLD_SCOUTREPLY_ITEM
			STA.w SprItemReceipt, X
			BRA .notRemote
		++
		STA.l !MULTIWORLD_SCOUT_LOCATION
		LDA.b #$00 : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
		LDA.b #$6B : STA.w SprItemReceipt, X ; make it a power star, I guess
	.notRemote
	JSR ResolveLootID
        -
	JSR ResolveBeeTrap
	JSR LoadDynamicTileOAMTable
	CMP.b #$34 : BCC + : CMP.b #$36+1 : BCS + : BRA ++ ; if rupees, don't draw to OAM
		+ JSL TransferItemReceiptToBuffer_using_ReceiptID
			SEP #$30
    ++ LDA.b #$00 : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID  ; clear player id
	PLB : PLY : PLX
RTL
        .loot_resolved
	PHX : PHY : PHB
        BRA -
;--------------------------------------------------------------------------------
; ResolveBeeTrap
; In: A - Loot ID
; Out: A - Resolved Loot ID
;--------------------------------------------------------------------------------
ResolveBeeTrap:
	PHA
		LDA.b #$00 : STA.l BeeTrapDisguise ; clear it
		LDA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID : BNE .skip
		LDA.w SkipBeeTrapDisguise : BEQ +
			.skip
			STZ.w SkipBeeTrapDisguise
			PLA : RTS
	+ PLA
	CMP.b #$D0 : BNE +
		JSL GetRandomInt : AND.b #$3F
		BNE ++ : LDA.b #$49 : ++ CMP.b #$26 : BNE ++ : LDA.b #$6A : ++
		STA.l BeeTrapDisguise
+ RTS

ResolveBeeTrapLong:
	JSR ResolveBeeTrap
RTL


;--------------------------------------------------------------------------------
; LoadDynamicTileOAMTable
; in: SprItemReceipt,X - Loot ID
; out: A - Loot ID
;-------------------------------------------------------------------------------- 20/847B
LoadDynamicTileOAMTable:
        PHP
        REP #$30
        LDA.w #$0000 : STA.l SpriteOAM : STA.l SpriteOAM+2
        LDA.w #$0200 : STA.l SpriteOAM+6
        LDA.l BeeTrapDisguise : AND.w #$00FF : BNE +
        	LDA.w SprItemReceipt,X : AND.w #$00FF
        + LDY.w #$0024
        PHX : ASL : TAX
        LDA.l InventoryTable_properties, X : BIT.w #$8000 : BEQ +
        	LDA.l VRAMAddressOffset, X : TAY
        + TYA : STA.l SpriteOAM+4
        PLX
        SEP #$30

		LDA.l BeeTrapDisguise : BNE +
			LDA.w SprItemReceipt,X
        + JSL GetSpritePalette_resolved
        STA.l SpriteOAM+5 : STA.l SpriteOAM+13
        PHX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow
        BRA .done

        .narrow
        REP #$20
        LDA.w #$0400 : STA.l SpriteOAM+7 : STA.l SpriteOAM+14
        LDA.w #$0000 : STA.l SpriteOAM+14
        LDA.w #$0800 : STA.l SpriteOAM+9
        TYA : XBA : AND.w #$FF00 : ADC.w #$1000 : STA.l SpriteOAM+11

        SEP #$20
        LDA.b #$04 : STA.l SpriteOAM

        .done
        TXA
        PLX
        PLP
RTS
;--------------------------------------------------------------------------------
; DrawDynamicTile
; in:	A - Loot ID
; out:  A - OAM Slots Taken
;--------------------------------------------------------------------------------
; This wastes two OAM slots if you don't want a shadow - fix later - I wrote "fix later" over a year ago and it's still not fixed (Aug 6, 2017) - lol (May 25th, 2019)
;-------------------------------------------------------------------------------- 2084B8
DrawDynamicTile:
		JSR PrepDrawRemoteItemSprite
        PHX
        TAX
        LDA.l BeeTrapDisguise : BEQ +
        	TAX
        + LDA.l SpriteProperties_standing_width,X : BEQ .narrow

        .full
        PLX
        LDA.b #$01 : STA.b Scrap06
        LDA.b #$0C : JSL OAM_AllocateFromRegionC
        LDA.b #$02 : PHA
        BRA .draw

        .narrow
        PLX
        LDA.b #$02 : STA.b Scrap06
        LDA.b #$10 : JSL OAM_AllocateFromRegionC
        LDA.b #$03 : PHA

        .draw
        LDA.b #SpriteOAM>>0 : STA.b Scrap08
        LDA.b #SpriteOAM>>8 : STA.b Scrap09
        STZ.b Scrap07
        LDA.b #$7E : PHB : PHA : PLB
        LDA.b #$01 : STA.l SpriteSkipEOR
        JSL Sprite_DrawMultiple_quantity_preset
        LDA.b #$00 : STA.l SpriteSkipEOR
        PLB

        LDA.b OAMPtr : !ADD.b #$08 : STA.b OAMPtr ; leave the pointer in the right spot to draw the shadow, if desired
        LDA.b OAMPtr+2 : INC #2 : STA.b OAMPtr+2
        PLA
RTL
;--------------------------------------------------------------------------------
DrawDynamicTileNoShadow:
		JSR PrepDrawRemoteItemSprite
        PHX
        TAX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow

        .full
        PLX
        LDA.b #$01 : STA.b Scrap06
        LDA.b #$04 : JSL OAM_AllocateFromRegionC
        BRA .draw

        .narrow
        PLX
        LDA.b #$02 : STA.b Scrap06
        LDA.b #$08 : JSL OAM_AllocateFromRegionC

        .draw
        LDA.b #SpriteOAM>>0 : STA.b Scrap08
        LDA.b #SpriteOAM>>8 : STA.b Scrap09
        STZ.b Scrap07
        LDA.b #$7E : PHB : PHA : PLB
        LDA.b #$01 : STA.l SpriteSkipEOR
        JSL Sprite_DrawMultiple_quantity_preset
        LDA.l Bob : BNE + : LDA.b #$00 : STA.l SpriteSkipEOR : + ; Bob fix is conditional
        PLB

        LDA.b OAMPtr : !ADD.b #$08 : STA.b OAMPtr
        LDA.b OAMPtr+2 : INC #2 : STA.b OAMPtr+2
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
PrepDrawRemoteItemSprite:
	PHA
	LDA.l RemoteItems : BEQ +
		PLA
		CMP.l !MULTIWORLD_SCOUTREPLY_LOCATION : BNE ++
			LDA.l !MULTIWORLD_SCOUT_LOCATION : BEQ +++
				LDA.l !MULTIWORLD_SCOUTREPLY_LOCATION
				STA.l SprItemReceipt, X
				JSL PrepDynamicTile
				LDA.b #$00
				BRA ++
			+++
			LDA.l !MULTIWORLD_SCOUTREPLY_PLAYER : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
			LDA.l !MULTIWORLD_SCOUTREPLY_ITEM
			RTS
		++
		STA.l !MULTIWORLD_SCOUT_LOCATION
		LDA.b #$00 : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
		LDA.b #$6B
		RTS
	+
	PLA
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
LoadModifiedTileBufferAddress:
	PHA
	LDA.l TileUploadOffsetOverride : BEQ +
		TAX
    	LDY.w #$0002
		LDA.w #$0000 : STA.l TileUploadOffsetOverride
		BRA .done
	+
    LDX.w #$2D40
    LDY.w #$0002
	.done
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Sprite_IsOnscreen
; in:	X - Sprite Slot
; out:	Carry - 1 = On Screen, 0 = Off Screen
;--------------------------------------------------------------------------------
Sprite_IsOnscreen:
        JSR .check_sprite
        BCS +
                REP #$20
                LDA.b BG2H : PHA : !SUB.w #$0F : STA.b BG2H
                LDA.b BG2V : PHA : !SUB.w #$0F : STA.b BG2V
                SEP #$20
                JSR .check_sprite
                REP #$20
                PLA : STA.b BG2V
                PLA : STA.b BG2H
                SEP #$20
        +
RTL

.check_sprite
        LDA.w SpritePosXLow, X : CMP.b BG2H
        LDA.w SpritePosXHigh, X : SBC.b BG2H+1 : BNE .offscreen

        LDA.w SpritePosYLow, X : CMP.b BG2V
        LDA.w SpritePosYHigh, X : SBC.b BG2V+1 : BNE .offscreen
        SEC
RTS
        .offscreen
        CLC
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Sprite_GetScreenRelativeCoords:
; out:	$00.w Sprite Y
; out:	$02.w Sprite X
; out:	$06.b Sprite Y Relative
; out:	$07.b Sprite X Relative
;--------------------------------------------------------------------------------
; Copied from bank $06
;--------------------------------------------------------------------------------
Sprite_GetScreenRelativeCoords:
	STY.b Scrap0B

	STA.b Scrap08

	LDA.w SpritePosYLow, X : STA.b Scrap00
	!SUB.b BG2V       : STA.b Scrap06
	LDA.w SpritePosYHigh, X : STA.b Scrap01

	LDA.w SpritePosXLow, X : STA.b Scrap02
	!SUB.b BG2H       : STA.b Scrap07
	LDA.w SpritePosXHigh, X : STA.b Scrap03
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SkipDrawEOR - Shims in Bank05.asm : 2499
;--------------------------------------------------------------------------------
SkipDrawEOR:
	LDA.l SpriteSkipEOR : BEQ .normal
	LDA.w #$0000 : STA.l SpriteSkipEOR
	LDA.w #$0F00 : TRB.b Scrap04
	.normal
	LDA.b (Scrap08), Y : EOR.w Scrap04 ; thing we wrote over
RTL

;--------------------------------------------------------------------------------
; WriteVRAMStripe
; in:	A(w) - VRAM Destination
; in:	X(w) - Length in Tiles
; in:	Y(w) - Word to Write
;--------------------------------------------------------------------------------
WriteVRAMStripe:
	PHX
		LDX.w GFXStripes ; get pointer
		AND.w #$7F : STA.w GFXStripes+2, X : INX #2 ; set destination
	PLA : ASL : AND.w #$7FFF : ORA.w #$7000 : STA.w GFXStripes+2, X : INX #2 ; set length and enable RLE
	TYA : STA.w GFXStripes+2, X : INX #2 ; set tile
	SEP #$20 ; set 8-bit accumulator
		LDA.b #$FF : STA.w GFXStripes+2, X
		STX.w GFXStripes
		LDA.b #01 : STA.b NMISTRIPES
	REP #$20 ; set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; WriteVRAMBlock
; in:	A(w) - VRAM Destination
; in:	X(w) - Length in Tiles
; in:	Y(w) - Address of Data to Copy
;--------------------------------------------------------------------------------
WriteVRAMBlock:
        PHX
        LDX.w GFXStripes ; get pointer
        AND.w #$7F : STA.w GFXStripes+2, X : INX #2 ; set destination
        PLA : ASL : AND.w #$3FFF : STA.w GFXStripes+2, X : INX #2 ; set length

        PHX
                TYX ; set X to source
                PHA
                        TXA : !ADD.w #$1002 : TAY ; set Y to dest
                PLA
                ;A is already the value we need for mvn
                MVN $7F7E ; currently we transfer from our buffers in 7F to the vram buffer in 7E

                !ADD 1, s ; add the length in A to the stack pointer on the top of the stack
        PLX : TAX ; pull and promptly ignore, copying the value we just got over it

        SEP #$20 ; set 8-bit accumulator
                LDA.b #$FF : STA.w GFXStripes+$02, X
                STX.w GFXStripes
                LDA.b #01 : STA.w NMISTRIPES
        REP #$20 ; set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------
;Byte 1   byte 2  Byte 3   byte 4
;Evvvvvvv vvvvvvv DRllllll llllllll
;
;E if set indicates that this is not a header, but instead is the terminator byte. Only the topmost bit matters in that case.
;The v's form a vram address.
;if D is set, the dma will increment the vram address by a row per word, instead of incrementing by a column (1).
;R if set enables a run length encoding feature
;the l's are the number of bytes to upload minus 1 (don't forget this -1, it is important)
;
;This is then followed by the bytes to upload, in normal format.

;RLE feature:
;This feature makes it easy to draw the same tile repeatedly. If this bit is set, the length bits should be set to 2 times the number of copies of the tile to upload. (Without subtracting 1!)
;It is followed by a single tile (word).  Combining this this with the D bit makes it easy to draw large horizontal or vertical runs of a tile without using much space. Geat for erasing or drawing horizontal or verical box edges.
;================================================================================

DynamicDrawCleanup:
        PHA
        REP #$20
        LDA.w #$F000
        STA.w OAMBuffer
        STA.w OAMBuffer+$04
        STA.w OAMBuffer+$08
        STA.w OAMBuffer+$0C
        STZ.w OAMBuffer+$02
        STZ.w OAMBuffer+$06
        STZ.w OAMBuffer+$0A
        STZ.w OAMBuffer+$0E
        SEP #$20
        PLA
RTL

;------------------------------------------------------------------------------
CheckReceivedItemPropertiesBeforeLoad:
        PHX
        LDX.w CurrentSpriteSlot
        LDA.w AncillaID,X : CMP.b #$29 : BEQ .falling_sprite
                PLX
                LDA.b RoomIndex : BEQ .normalCode
                LDA.w DungeonID : BMI .normalCode
                LDA.l RoomFade : BNE .load_palette
                        .normalCode
                        LDA.l SpriteProperties_chest_palette,X : BIT #$80 : BNE .load_palette
                        RTL
                        .load_palette
                        JSL LoadItemPalette
                        RTL
        .falling_sprite
        PLX
        LDA.l SpriteProperties_standing_palette,X : BIT #$80 : BNE .load_palette
RTL

;------------------------------------------------------------------------------
LoadItemPalette:
; In: X - Loot ID
; Out: A - Sprite palette index
        PHX : PHY : PHB
        LDA.b #PalettesVanillaBank>>16 : STA.b Scrap0C
        PEA $7E00
        PLB : PLB
        REP #$30

        TXA : ASL : TAX
        LDA.l SpriteProperties_palette_addr,X : STA.b Scrap0A
        LDY.w #$000E
        JSR AuxPaletteCheck : BCS .aux
                LDA.w TransparencyFlag : BNE .SP05
                        -
                                LDA.b [Scrap0A], Y
                                STA.w PaletteBuffer+$0170,Y
                                DEY #2
                        BPL -
                        LDA.w #$0003
                        BRA .done
                .SP05
                -
                        LDA.b [Scrap0A], Y
                        STA.w PaletteBuffer+$01B0,Y
                        DEY #2
                BPL -
                LDA.w #$0005
        .done
        SEP #$30
        PLB : PLY : PLX
        INC.b NMICGRAM
RTL
        .aux
        LDA.w TransparencyFlag : BNE .SP05_aux
                -
                        LDA.b [Scrap0A], Y
                        STA.w PaletteBufferAux+$0170,Y
                        DEY #2
                BPL -
                LDA.w #$0003
                BRA .done
        .SP05_aux
        -
                LDA.b [Scrap0A], Y
                STA.w PaletteBufferAux+$01B0,Y
                DEY #2
        BPL -
        LDA.w #$0005
        BRA .done

TransferVRAMStripes:
        JSL TransferNewNameStripes
        JSL DoDungeonMapBossIcon
        LDA.b NMISTRIPES : CMP.b #$01 ; What we wrote over
RTL


ItemReceiptWidthCheck:
        PHX
        LDX.w CurrentSpriteSlot
        LDA.w AncillaID,X : CMP.b #$29 : BEQ .falling_sprite
                PLX
                LDA.l SpriteProperties_chest_width, X
                RTL
        .falling_sprite
        PLX
        LDA.l SpriteProperties_standing_width, X
RTL

AuxPaletteCheck:
; Out: c - write to aux palette buffer if set, main buffer if unset.
;
; We have to put an item's palette in the aux buffer in rooms where standing
; item gfx are loaded in the middle of a fade-in/out such as the spiral staircase
; fade for GT torch room and the Hera cage.
        PHX
        SEP #$30
        LDA.w ItemReceiptMethod : BNE .main_buffer     ; Never use aux if we're actually receiving an item
        LDA.b RoomIndex : CMP.b #$8C : BEQ .aux_buffer ; GT torch/Hope room
        CMP.b #$87 : BEQ .aux_buffer ; Hera cage/basement
                .main_buffer
                REP #$31
                PLX
                RTS
        .aux_buffer
        SEC
        REP #$30
        PLX
RTS
