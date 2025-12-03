;================================================================================
; Randomize Heart Pieces
;--------------------------------------------------------------------------------
HeartPieceGet:
    PHX : PHY
    LDA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    LDY.w SprSourceItemId, X
    JSL MaybeMarkDigSpotCollected
    .skipLoad
    LDA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_ITEM_PLAYER_ID
    CPY.b #$26 : BNE .not_heart ; don't add a 1/4 heart if it's not a heart piece
        CMP.b #$00 : BNE .not_heart
        LDA.l HeartPieceQuarter : INC A : AND.b #$03 : STA.l HeartPieceQuarter
    .not_heart
    JSL Player_HaltDashAttackLong
    STZ.w ItemReceiptMethod ; 0 = Receiving item from an NPC or message
    JSL Link_ReceiveItem
    JSL MaybeUnlockTabletAnimation

    PLY : PLX
RTL
;--------------------------------------------------------------------------------
HeartContainerGet:
    PHX : PHY
    JSL IncrementBossSword
    LDY.w SprSourceItemId, X
    BRA HeartPieceGet_skipLoad
;--------------------------------------------------------------------------------
DrawHeartPieceGFX:
    PHP
    JSL Sprite_IsOnscreen : BCC .offscreen
        PHA : PHY
        LDA.w SprRedrawFlag, X : BEQ .skipInit ; skip init if already ready
            JSL HeartPieceSpritePrep
            LDA.w SprRedrawFlag, X : CMP.b #$02 : BEQ .skipInit
            BRA .done ; don't draw on the init frame
        .skipInit
        LDA.w SprItemReceipt, X ; Retrieve stored item type
        .skipLoad
        PHA : PHX
        TAX
        LDA.l SpriteProperties_standing_width,X : BNE +
            PLX
            REP #$20 : LDA.b RoomIndex : CMP.w #$0120 : SEP #$20 : BNE .prepShadow
                LDA.b IndoorsFlag : BNE .draw ; skip "shadow" change in good bee room
            .prepShadow
            LDA.w SpriteControl, X : ORA.b #$20 : STA.w SpriteControl, X

            .draw
            PLA
            JSL DrawPotItem
            REP #$21
            LDA.b Scrap00 : ADC.w #$0004 : STA.b Scrap00
            SEP #$20
            JSL Sprite_DrawShadowLong
            BRA .done
        +
        PLX
        PLA
        JSL DrawPotItem
        JSL Sprite_DrawShadowLong
        .done
        PLY : PLA
    .offscreen
    PLP
RTL
;--------------------------------------------------------------------------------
DrawHeartContainerGFX:
	PHP
	JSL Sprite_IsOnscreen : BCC DrawHeartPieceGFX_offscreen
	
	PHA : PHY
	LDA.w SprRedrawFlag, X : BEQ .skipInit ; skip init if already ready
		JSL HeartContainerSpritePrep
		LDA.w SprRedrawFlag, X : CMP.b #$02 : BEQ .skipInit
		BRA DrawHeartPieceGFX_done ; don't draw on the init frame
	
	.skipInit
	LDA.w SprItemReceipt, X ; Retrieve stored item type

	BRA DrawHeartPieceGFX_skipLoad
;--------------------------------------------------------------------------------
HeartContainerSound:
    LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BNE +
    LDA.w ItemReceiptMethod : CMP.b #$03 : BEQ +
    JSL CheckIfBossRoom : BCC + ; Skip if not in a boss room
        LDA.b #$2E
        SEC
        RTL
    +
    CLC
RTL
;--------------------------------------------------------------------------------
NormalItemSkipSound:
; Out: c - skip sounds if set
    JSL CheckIfBossRoom : BCS .boss_room
    LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BNE .skip
        TDC
        CPY.b #$17 : BEQ .skip
        CLC
RTL
    .boss_room
    LDA.w ItemReceiptMethod : CMP.b #$03 : BEQ +
        .skip
        SEC
        RTL
    +
    LDA.b #$20
    .dont_skip
    CLC
RTL
;--------------------------------------------------------------------------------
HeartPieceSpritePrep:
    LDA.l ServerRequestMode : BEQ + :  : +

    INC.w SkipBeeTrapDisguise
    JSL HeartPieceGetPlayer : STA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    JSL LoadHeartPieceRoomValue
    STA.w SprSourceItemId, X
    JML RequestStandingItemVRAMSlot
;--------------------------------------------------------------------------------
HeartContainerSpritePrep:
    JSL HeartPieceGetPlayer : STA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    JSL LoadHeartContainerRoomValue ; load item type
    STA.w SprSourceItemId, X
    JML RequestStandingItemVRAMSlot
;--------------------------------------------------------------------------------
LoadHeartPieceRoomValue:
    LDA.b IndoorsFlag : BEQ .outdoors ; check if we're indoors or outdoors
    .indoors
    JSL LoadIndoorValue
    JMP .done
    .outdoors
    JSL LoadOutdoorValue
    .done
RTL
;--------------------------------------------------------------------------------
!DynamicDropGFXSlotCount_UW = (FreeUWGraphics_end-FreeUWGraphics)>>1
!DynamicDropGFXSlotCount_OW = (FreeOWGraphics_end-FreeOWGraphics)>>1
HPItemReset:
    PHA
    LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BNE .skip
        PLA
        JSL GiveRupeeGift ; thing we wrote over
        BRA .done
    .skip
    PLA
    .done
    PHA
        JSL HeartPieceSetRedraw
    PLA
RTL
;--------------------------------------------------------------------------------
MaybeMarkDigSpotCollected:
    PHA : PHP
        LDA.b IndoorsFlag : BNE +
        REP #$20 ; set 16-bit accumulator
        LDA.b OverworldIndex : CMP.w #$002A : BNE +
            LDA.l HasGroveItem : ORA.w #$0001 : STA.l HasGroveItem
        +
    PLP : PLA
RTL
;--------------------------------------------------------------------------------
HeartPieceSpawnDelayFix:
	JSL Sprite_DrawRippleIfInWater
	; Fix the delay when spawning a HeartPiece sprite
	JSL Sprite_CheckIfPlayerPreoccupied : BCS + ; what we moved from $05F037
	JSL Sprite_CheckDamageToPlayerSameLayerLong : RTL ; what we wrote over
	+ CLC : RTL
;--------------------------------------------------------------------------------
macro GetPossiblyEncryptedItem(ItemLabel,TableLabel)
    LDA.l IsEncrypted : BNE ?encrypted
        LDA.l <ItemLabel>
        BRA ?done
    ?encrypted:
    PHX : PHP
        REP #$30 ; set 16-bit accumulator & index registers
        LDA.b Scrap00 : PHA : LDA.b Scrap02 : PHA

        LDA.w #<TableLabel> : STA.b Scrap00
        LDA.w #<TableLabel>>>16 : STA.b Scrap02
        LDA.w #<ItemLabel>-<TableLabel>
        JSL RetrieveValueFromEncryptedTable

        PLX : STX.b Scrap02 : PLX : STX.b Scrap01
    PLP : PLX
    ?done:
endmacro

LoadIndoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #225 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Forest_Thieves, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #226 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lumberjack_Tree, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #234 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Spectacle_Cave, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #283 : BNE +
		LDA.b LinkPosX : XBA : AND.w #$0001 ; figure out where link is
		BNE ++
			%GetPossiblyEncryptedItem(HeartPiece_Circle_Bushes, HeartPieceIndoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Graveyard_Warp, HeartPieceIndoorValues)
			JMP .done
	+ CMP.w #288 : BNE +
		LDA.l UWBonkPrizeData+3
		JMP .done
	+ CMP.w #294 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Mire_Warp, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #295 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Smith_Pegs, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #135 : BNE +
		LDA.l StandingKey_Hera
		JMP .done
	+
	PHX
	LDX.w CurrentSpriteSlot ; If we're on a different screen ID via glitches load the sprite
	LDA.w SprItemReceipt,X        ; we can see and are interacting with
	PLX
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;225 - HeartPiece_Forest_Thieves
;226 - HeartPiece_Lumberjack_Tree
;234 - HeartPiece_Spectacle_Cave
;283 - HeartPiece_Circle_Bushes
;283 - HeartPiece_Graveyard_Warp
;294 - HeartPiece_Mire_Warp
;295 - HeartPiece_Smith_Pegs
;--------------------------------------------------------------------------------
LoadOutdoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b OverworldIndex
	; Rain state fix: In rain state DW, use LW screen ID for item lookup
	BIT.w #$0040 : BEQ +
		LDA.l ProgressIndicator : AND.w #$00FF : CMP.w #$0002
			LDA.b OverworldIndex : BCS ++ : AND.w #$00BF
		++
	+
	CMP.w #$00 : BNE +
		LDA.l OWBonkPrizeTable[$00].loot
		JMP .done
	+ CMP.w #$03 : BNE +
		LDA.b LinkPosX : CMP.w #1890 : !BLT ++
			%GetPossiblyEncryptedItem(HeartPiece_Spectacle, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(EtherItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$05 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$01].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Mountain_Warp, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$0A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$02].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$03].loot
			JMP .done
	+ CMP.w #$10 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$04].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$05].loot
			JMP .done
	+ CMP.w #$11 : BNE +
		LDA.l OWBonkPrizeTable[$06].loot
		JMP .done
	+ CMP.w #$12 : BNE +
		LDA.l OWBonkPrizeTable[$07].loot
		JMP .done
	+ CMP.w #$13 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$08].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$09].loot
			JMP .done
	+ CMP.w #$15 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0A].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0B].loot
			JMP .done
	+ CMP.w #$18 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0C].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0D].loot
			JMP .done
	+ CMP.w #$1A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0E].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0F].loot
			JMP .done
	+ CMP.w #$1B : BNE +
		LDA.l OWBonkPrizeTable[$10].loot
		JMP .done
	+ CMP.w #$1D : BNE +
		LDA.l OWBonkPrizeTable[$11].loot
		JMP .done
	+ CMP.w #$1E : BNE +
		LDA.l OWBonkPrizeTable[$12].loot
		JMP .done
	+ CMP.w #$28 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Maze, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$2A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$13].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$14].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HauntedGroveItem, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$2B : BNE +
		LDA.l OWBonkPrizeTable[$15].loot
		JMP .done
	+ CMP.w #$2E : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$16].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$17].loot
			JMP .done
	+ CMP.w #$30 : BNE +
		LDA.b LinkPosX : CMP.w #512 : !BGE ++
			%GetPossiblyEncryptedItem(HeartPiece_Desert, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(BombosItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$32 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$18].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$19].loot
			JMP .done
	+ CMP.w #$35 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lake, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$3B : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Swamp, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$42 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1A].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$4A : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$51 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1B].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$1C].loot
			JMP .done
	+ CMP.w #$54 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1D].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$1E].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$1F].loot
			JMP .done
	+ CMP.w #$55 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$20].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$21].loot
			JMP .done
	+ CMP.w #$56 : BNE +
		LDA.l OWBonkPrizeTable[$22].loot
		JMP .done
	+ CMP.w #$5B : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$23].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Pyramid, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$5E : BNE +
		LDA.l OWBonkPrizeTable[$24].loot
		JMP .done
	+ CMP.w #$68 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Digging, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$6E : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$25].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$26].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$27].loot
			JMP .done
	+ CMP.w #$74 : BNE +
		LDA.l OWBonkPrizeTable[$28].loot
		JMP .done
	+ CMP.w #$81 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Zora, HeartPieceOutdoorValues)
		JMP .done
	+
	PHX
	LDX.w CurrentSpriteSlot ; If we're on a different screen ID via glitches load the sprite
	LDA.w SprItemReceipt,X  ; we can see and are interacting with.
	PLX
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;$03 - HeartPiece_Spectacle
;$05 - HeartPiece_Mountain_Warp
;$28 - HeartPiece_Maze
;$30 - HeartPiece_Desert
;$35 - HeartPiece_Lake
;$3B - HeartPiece_Swamp
;$42 - HeartPiece_Cliffside - not really but the gfx load weird otherwise
;$4A - HeartPiece_Cliffside
;$5B - HeartPiece_Pyramid
;$68 - HeartPiece_Digging
;$81 - HeartPiece_Zora
;--------------------------------------------------------------------------------
LoadHeartContainerRoomValue:
LoadBossValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #200 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_ArmosKnights, HeartContainerBossValues)
		JMP .done
	+ CMP.w #51 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Lanmolas, HeartContainerBossValues)
		JMP .done
	+ CMP.w #7 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Moldorm, HeartContainerBossValues)
		JMP .done
	+ CMP.w #90 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_HelmasaurKing, HeartContainerBossValues)
		JMP .done
	+ CMP.w #6 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Arrghus, HeartContainerBossValues)
		JMP .done
	+ CMP.w #41 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Mothula, HeartContainerBossValues)
		JMP .done
	+ CMP.w #172 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Blind, HeartContainerBossValues)
		JMP .done
	+ CMP.w #222 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Kholdstare, HeartContainerBossValues)
		JMP .done
	+ CMP.w #144 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Vitreous, HeartContainerBossValues)
		JMP .done
	+ CMP.w #164 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Trinexx, HeartContainerBossValues)
		JMP .done
	+
	LDA.w #$003E ; default to a normal boss heart
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
CheckIfBossRoom:
;--------------------------------------------------------------------------------
; Carry set if we're in a boss room, unset otherwise.
;--------------------------------------------------------------------------------
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #200 : BEQ .done
	CMP.w #51 : BEQ .done
	CMP.w #7 : BEQ .done
	CMP.w #90 : BEQ .done
	CMP.w #6 : BEQ .done
	CMP.w #41 : BEQ .done
	CMP.w #172 : BEQ .done
	CMP.w #222 : BEQ .done
	CMP.w #144 : BEQ .done
	CMP.w #164 : BEQ .done
	CLC
	.done
+	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
;#200 - Eastern Palace - Armos Knights
;#51 - Desert Palace - Lanmolas
;#7 - Tower of Hera - Moldorm
;#32 - Agahnim's Tower - Agahnim I
;#90 - Palace of Darkness - Helmasaur King
;#6 - Swamp Palace - Arrghus
;#41 - Skull Woods - Mothula
;#172 - Thieves' Town - Blind
;#222 - Ice Palace - Kholdstare
;#144 - Misery Mire - Vitreous
;#164 - Turtle Rock - Trinexx
;#13 - Ganon's Tower - Agahnim II
;#0 - Pyramid of Power - Ganon
;--------------------------------------------------------------------------------
;JSL $86DD40 ; DashKey_Draw
;JSL $86DBF8 ; Sprite_PrepAndDrawSingleLargeLong
;JSL $86DC00 ; Sprite_PrepAndDrawSingleSmallLong ; draw first cell correctly
;JSL $80D51B ; GetAnimatedSpriteTile
;JSL $80D52D ; GetAnimatedSpriteTile.variable
;================================================================================
HeartPieceGetPlayer:
{
	PHY
	LDA.b IndoorsFlag : BNE +
		BRL .outdoors
	+

	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #135 : BNE +
		LDA.l StandingKey_Hera_Player
		BRL .done
	+ CMP.w #200 : BNE +
		LDA.l HeartContainer_ArmosKnights_Player
		BRL .done
	+ CMP.w #51 : BNE +
		LDA.l HeartContainer_Lanmolas_Player
		BRL .done
	+ CMP.w #7 : BNE +
		LDA.l HeartContainer_Moldorm_Player
		BRL .done
	+ CMP.w #90 : BNE +
		LDA.l HeartContainer_HelmasaurKing_Player
		BRL .done
	+ CMP.w #6 : BNE +
		LDA.l HeartContainer_Arrghus_Player
		BRL .done
	+ CMP.w #41 : BNE +
		LDA.l HeartContainer_Mothula_Player
		BRL .done
	+ CMP.w #172 : BNE +
		LDA.l HeartContainer_Blind_Player
		BRL .done
	+ CMP.w #222 : BNE +
		LDA.l HeartContainer_Kholdstare_Player
		BRL .done
	+ CMP.w #144 : BNE +
		LDA.l HeartContainer_Vitreous_Player
		BRL .done
	+ CMP.w #164 : BNE +
		LDA.l HeartContainer_Trinexx_Player
		BRL .done
	+ CMP.w #225 : BNE +
		LDA.l HeartPiece_Forest_Thieves_Player
		BRL .done
	+ CMP.w #226 : BNE +
		LDA.l HeartPiece_Lumberjack_Tree_Player
		BRL .done
	+ CMP.w #234 : BNE +
		LDA.l HeartPiece_Spectacle_Cave_Player
		BRL .done
	+ CMP.w #283 : BNE +
		LDA.b LinkPosX : XBA : AND.w #$0001 ; figure out where link is
		BNE ++
			LDA.l HeartPiece_Circle_Bushes_Player
			BRL .done
		++
			LDA.l HeartPiece_Graveyard_Warp_Player
			BRL .done
	+ CMP.w #288 : BNE +
		LDA.l OWBonkPrizeTable[$2A].mw_player
		BRL .done
	+ CMP.w #294 : BNE +
		LDA.l HeartPiece_Mire_Warp_Player
		BRL .done
	+ CMP.w #295 : BNE +
		LDA.l HeartPiece_Smith_Pegs_Player
		BRL .done
	LDA.w #$0000
	BRL .done

	.outdoors
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b OverworldIndex
	CMP.w #$00 : BNE +
		LDA.l OWBonkPrizeTable[$00].mw_player
		BRL .done
	+ CMP.w #$03 : BNE +
		LDA.b LinkPosX : CMP.w #1890 : !BLT ++
			LDA.l HeartPiece_Spectacle_Player
			BRL .done
		++
			LDA.l EtherItem_Player
			BRL .done
	+ CMP.w #$05 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$01].mw_player
			BRL .done
		++
			LDA.l HeartPiece_Mountain_Warp_Player
			BRL .done
	+ CMP.w #$0A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$02].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$03].mw_player
			BRL .done
	+ CMP.w #$10 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$04].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$05].mw_player
			BRL .done
	+ CMP.w #$11 : BNE +
		LDA.l OWBonkPrizeTable[$06].mw_player
		BRL .done
	+ CMP.w #$12 : BNE +
		LDA.l OWBonkPrizeTable[$07].mw_player
		BRL .done
	+ CMP.w #$13 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$08].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$09].mw_player
			BRL .done
	+ CMP.w #$15 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0A].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0B].mw_player
			BRL .done
	+ CMP.w #$18 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0C].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0D].mw_player
			BRL .done
	+ CMP.w #$1A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0E].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0F].mw_player
			BRL .done
	+ CMP.w #$1B : BNE +
		LDA.l OWBonkPrizeTable[$11].mw_player
		BRL .done
	+ CMP.w #$1D : BNE +
		LDA.l OWBonkPrizeTable[$12].mw_player
		BRL .done
	+ CMP.w #$1E : BNE +
		LDA.l OWBonkPrizeTable[$13].mw_player
		BRL .done
	+ CMP.w #$28 : BNE +
		LDA.l HeartPiece_Maze_Player
		BRL .done
	+ CMP.w #$2A : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$14].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$15].mw_player
			BRL .done
		++
			LDA.l HauntedGroveItem_Player
			BRL .done
	+ CMP.w #$2B : BNE +
		LDA.l OWBonkPrizeTable[$16].mw_player
		BRL .done
	+ CMP.w #$2E : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$17].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$18].mw_player
			BRL .done
	+ CMP.w #$30 : BNE +
		LDA.b LinkPosX : CMP.w #512 : !BGE ++
			LDA.l HeartPiece_Desert_Player
			BRL .done
		++
			LDA.l BombosItem_Player
			BRL .done
	+ CMP.w #$32 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$19].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$1A].mw_player
			BRL .done
	+ CMP.w #$35 : BNE +
		LDA.l HeartPiece_Lake_Player
		BRL .done
	+ CMP.w #$3B : BNE +
		LDA.l HeartPiece_Swamp_Player
		BRL .done
	+ CMP.w #$42 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1B].mw_player
			BRL .done
		++
			LDA.l HeartPiece_Cliffside_Player
			BRL .done
	+ CMP.w #$4A : BNE +
		LDA.l HeartPiece_Cliffside_Player
		BRL .done
	+ CMP.w #$51 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1C].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$1D].mw_player
			BRL .done
	+ CMP.w #$54 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1E].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$1F].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$20].mw_player
			BRL .done
	+ CMP.w #$55 : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$21].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$22].mw_player
			BRL .done
	+ CMP.w #$56 : BNE +
		LDA.l OWBonkPrizeTable[$23].mw_player
		BRL .done
	+ CMP.w #$5B : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$24].mw_player
			BRL .done
		++
			LDA.l HeartPiece_Pyramid_Player
			BRL .done
	+ CMP.w #$5E : BNE +
		LDA.l OWBonkPrizeTable[$25].mw_player
		BRL .done
	+ CMP.w #$68 : BNE +
		LDA.l HeartPiece_Digging_Player
		BRL .done
	+ CMP.w #$6E : BNE +
		LDA.w SpriteSpawnStep,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$26].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$27].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$28].mw_player
			BRL .done
	+ CMP.w #$74 : BNE +
		LDA.l OWBonkPrizeTable[$29].mw_player
		BRL .done
	+ CMP.w #$81 : BNE +
		LDA.l HeartPiece_Zora_Player
		BRL .done
	+
	LDA.w #$0000

	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
	PLY
RTL
}
;--------------------------------------------------------------------------------
BossPrizeGetPlayer:
{
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #200 : BNE +
		LDA.l Prize_ArmosKnights_Player
		BRA .done
	+ CMP.w #51 : BNE +
		LDA.l Prize_Lanmolas_Player
		BRA .done
	+ CMP.w #7 : BNE +
		LDA.l Prize_Moldorm_Player
		BRA .done
	+ CMP.w #90 : BNE +
		LDA.l Prize_HelmasaurKing_Player
		BRA .done
	+ CMP.w #6 : BNE +
		LDA.l Prize_Arrghus_Player
		BRA .done
	+ CMP.w #41 : BNE +
		LDA.l Prize_Mothula_Player
		BRA .done
	+ CMP.w #172 : BNE +
		LDA.l Prize_Blind_Player
		BRA .done
	+ CMP.w #222 : BNE +
		LDA.l Prize_Kholdstare_Player
		BRA .done
	+ CMP.w #144 : BNE +
		LDA.l Prize_Vitreous_Player
		BRA .done
	+ CMP.w #164 : BNE +
		LDA.l Prize_Trinexx_Player
		BRA .done
	+
	LDA.w #$0000

	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
}
;--------------------------------------------------------------------------------
HeartPieceSetRedraw:
	PHY
		LDY.b #$0F
		.next
		LDA.w SpriteAITable,Y : BEQ ++
			LDA.w SpriteTypeTable,Y : CMP.b #$EB : BEQ + ; heart piece
			CMP.b #$E4 : BEQ + ; enemy key drop
			CMP.b #$3B : BEQ + ; bonk item (book/key)
			CMP.b #$E5 : BEQ + ; enemy big key drop
			CMP.b #$E7 : BEQ + ; mushroom item
			CMP.b #$E9 : BEQ + ; powder item
			BRA ++
				+ LDA.b #$01 : STA.w SprRedrawFlag,Y
		++ DEY : BPL .next
	PLY
RTL
HeartPieceGetRedraw:
	PHY
		LDY.b #$0F
		.next
		LDA.w SpriteAITable,Y : BEQ ++
			LDA.w SpriteTypeTable,Y : CMP.b #$EB : BEQ + ; heart piece
			CMP.b #$E4 : BEQ + ; enemy key drop
			CMP.b #$3B : BEQ + ; bonk item (book/key)
			CMP.b #$E5 : BEQ + ; enemy big key drop
			CMP.b #$E7 : BEQ + ; mushroom item
			CMP.b #$E9 : BEQ + ; powder item
			BRA ++
				+ LDA.w SprRedrawFlag,Y : BEQ ++
					PLY : SEC : RTL
		++ DEY : BPL .next
	PLY
CLC : RTL
