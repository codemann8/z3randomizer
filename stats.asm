;================================================================================
; Stat Tracking
;================================================================================
; $7EF420 - $7EF468 - Stat Tracking
;
; See sram.asm for adresses and documentation of stat values
;--------------------------------------------------------------------------------
IncrementBonkCounter:
	LDA.l StatsLocked : BNE +
	LDA.l BonkCounter : INC : BEQ + ; overflow
		STA.l BonkCounter
	+
RTL
;--------------------------------------------------------------------------------
StatSaveCounter:
	PHA
		LDA.l StatsLocked : BNE +
		LDA.b GameMode : CMP.b #$17 : BNE + ; not a proper s&q, link probably died
		LDA.l SaveQuitCounter : INC
		CMP.b #100 : BEQ + ; decimal 100
			STA.l SaveQuitCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementSaveCounter:
	PHA
		LDA.l StatsLocked : BNE +
			LDA.l SaveQuitCounter : DEC : STA.l SaveQuitCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DungeonHoleWarpTransition:
	LDA.l LayerOfDestination, X
	BRA StatTransitionCounter
DungeonHoleEntranceTransition:
	JSL EnableForceBlank
	
	LDA.l SilverArrowsAutoEquip : AND.b #$02 : BEQ +
	LDA.w EntranceIndex : CMP.b #$7B : BNE + ; skip unless falling to ganon's room
	LDA.l BowTracking : AND.b #$40 : BEQ + ; skip if we don't have silvers
	LDA.l BowEquipment : BEQ + ; skip if we have no bow
	CMP.b #$03 : !BGE + ; skip if the bow is already silver
		!ADD.b #$02 : STA.l BowEquipment ; increase bow to silver
	+
	
	BRA StatTransitionCounter
DungeonStairsTransition:
	JSL Dungeon_SaveRoomQuadrantData
	BRA StatTransitionCounter
DungeonExitTransition:
	LDA.l IceModifier : BEQ + ; ice physics
		JSL Player_HaltDashAttackLong
		LDA.b #$00 : STA.w UseY1 ; stop item dashing
	+
	LDA.b #$0F : STA.b GameMode ; stop running through the transition
	JSL DynamicDropGFXClear
StatTransitionCounter:
	PHA : PHP
		LDA.l StatsLocked : BNE +
		REP #$20 ; set 16-bit accumulator
		LDA.l ScreenTransitions : INC
		CMP.w #999 : BEQ + ; decimal 999
			STA.l ScreenTransitions
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IncrementFlute:
	LDA.l StatsLocked : BNE +
		LDA.l FluteCounter : INC : STA.l FluteCounter
	+
	JSL StatTransitionCounter ; also increment transition counter
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeys:
	STA.l CurrentSmallKeys ; thing we wrote over, write small key count
	PHX
		LDA.l StatsLocked : BNE +
			LDA.l SmallKeyCounter : INC : STA.l SmallKeyCounter
		+
		JSL UpdateKeys
		PHY : LDY.b #24 : JSL AddInventory : PLY
		JSL HUD_RebuildLong
	LDA.b #$01 : STA.l UpdateHUDFlag
	PLX
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeysNoPrimary:
        STA.l CurrentSmallKeys ; thing we wrote over, write small key count
        PHX
        LDA.l StatsLocked : BNE +
                LDA.l SmallKeyCounter : INC : STA.l SmallKeyCounter
        +
        JSL UpdateKeys
        LDA.b IndoorsFlag : BEQ + ; skip room check if outdoors
                PHP : REP #$20 ; set 16-bit accumulator
                LDA.b RoomIndex : CMP.w #$0087 : BNE ++ ; hera basement
                LDA.b $A8 : AND.w #$0003 : CMP.w #$0002 : BNE ++ ; must be quadrant 2
                LDA.w SprDropsItem, X : AND.w #$00FF : BNE ++ ; must not be a standing item
                        PLP : PHY
                        LDY.b #$24
                        JSL AddInventory
                        PLY : BRA +
                ++
                PLP
        +
        LDA.b #$01 : STA.l UpdateHUDFlag
        JSL HUD_RebuildLong
        PLX
RTL
;--------------------------------------------------------------------------------
DecrementSmallKeys:
	STA.l CurrentSmallKeys ; thing we wrote over, write small key count
	JSL UpdateKeys
RTL
;--------------------------------------------------------------------------------
CountChestKeyLong:
        PHX : PHP
        SEP #$30
	JSR CountChestKey
        PLP : PLX
RTL
;--------------------------------------------------------------------------------

CountChestKey:
        PHA : PHX
        LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BNE .done
        LDA.l StatsLocked : BNE .done
                CPY.b #$24 : BEQ .this_dungeon
                        TYA
                        AND.b #$0F : CMP.b #$02 : BCC .hc_sewers
                                TAX
                                LDA.l DungeonCollectedKeys,X : INC : STA.l DungeonCollectedKeys,X
                                BRA .done
                .this_dungeon
                LDA.w DungeonID : CMP.b #$03 : BCC .hc_sewers
                        LSR : TAX
                        LDA.l DungeonCollectedKeys,X : INC : STA.l DungeonCollectedKeys,X
                        BRA .done

                .hc_sewers
                LDA.l SewerCollectedKeys : INC
                STA.l SewerCollectedKeys : STA.l HCCollectedKeys

        .done
        PLX : PLA
RTS

;--------------------------------------------------------------------------------
IncrementAgahnim2Sword:
        PHA
        JSL IncrementBossSword
        PLA
RTL
;--------------------------------------------------------------------------------
IncrementDeathCounter:
	PHA
		LDA.l StatsLocked : BNE +
		LDA.l CurrentHealth : BNE + ; link is still alive, skip
			LDA.l DeathCounter : INC : STA.l DeathCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementFairyRevivalCounter:
	STA.l BottleContents, X ; thing we wrote over
	PHA
		LDA.l StatsLocked : BNE +
			LDA.l FaerieRevivalCounter : INC : STA.l FaerieRevivalCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementChestTurnCounter:
	PHA
		LDA.l StatsLocked : BNE +
			LDA.l ChestTurnCounter : INC : STA.l ChestTurnCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementChestCounter:
	LDA.b #$01 : STA.w ItemReceiptMethod ; thing we wrote over
	PHA
		LDA.l StatsLocked : BNE +
			LDA.l ChestsOpened : INC : STA.l ChestsOpened
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementChestCounter:
	PHA
		LDA.l StatsLocked : BNE +
			LDA.l ChestsOpened : DEC : STA.l ChestsOpened
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementItemCounter:
	PHA
		LDA.l StatsLocked : BNE +
                        REP #$20
			LDA.l TotalItemCounter : DEC : STA.l TotalItemCounter
                        SEP #$20
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementBigChestCounter:
        JSL Dungeon_SaveRoomQuadrantData ; thing we wrote over
        PHA
        LDA.l StatsLocked : BNE +
                LDA.l BigKeysBigChests : INC : AND.b #$0F : TAX
                LDA.l BigKeysBigChests : AND.b #$F0 : STA.l BigKeysBigChests
                TXA : ORA.l BigKeysBigChests : STA.l BigKeysBigChests
        +
        PLA
RTL
;--------------------------------------------------------------------------------
IncrementDamageTakenCounter_Eight:
	STA.l CurrentHealth
	PHA : PHP
	LDA.l StatsLocked : BNE +
	REP #$21
	LDA.l DamageCounter
	ADC.w #$0008
	BCC ++
	LDA.w #$FFFF
++	STA.l DamageCounter
+	PLP
	PLA
	RTL

IncrementDamageTakenCounter_Arb:
	PHP
	LDA.l StatsLocked : BNE +
	REP #$21
	LDA.b Scrap00
	AND.w #$00FF
	ADC.l DamageCounter
	BCC ++
	LDA.w #$FFFF
++	STA.l DamageCounter
+	PLP

	LDA.l CurrentHealth
	RTL

IncrementMagicUseCounter:
	STA.l CurrentMagic

IncrementMagicUseCounterByrna:
	PHA : PHP
	LDA.l StatsLocked : BNE +
	REP #$21
	LDA.b Scrap00
	AND.w #$00FF
	ADC.l MagicCounter
	BCC ++
	LDA.w #$FFFF
++	STA.l MagicCounter
+	PLP : PLA

	RTL

IncrementMagicUseCounterOne:
	LDA.l StatsLocked : BNE +
	REP #$20
	LDA.l MagicCounter
	INC
	BEQ ++
	STA.l MagicCounter
++	SEP #$20
+	LDA.l CurrentMagic
	RTL

;--------------------------------------------------------------------------------
IncrementOWMirror:
        PHA
                LDA.b #$08 : STA.w RaceGameFlag ; fail race game
                LDA.l StatsLocked : BNE +
                LDA.l CurrentWorld : BEQ + ; only do this for DW->LW
                        LDA.l OverworldMirrors : INC : STA.l OverworldMirrors
                +
        PLA
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
IncrementUWMirror:
	PHA
		LDA.b #$00 : STA.l AltTextFlag ; bandaid patch bug with mirroring away from text
		LDA.l StatsLocked : BNE +
		LDA.w DungeonID : CMP.b #$FF : BEQ + ; skip if we're in a cave or house
			LDA.l UnderworldMirrors : INC : STA.l UnderworldMirrors
			JSL StatTransitionCounter
		+
	PLA
	JSL Dungeon_SaveRoomData ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
IncrementSpentRupees:
    DEC A : BPL .subtractRupees
    LDA.w #$0000 : STA.l CurrentRupees
RTL
	.subtractRupees
	PHA : PHP
	LDA.l StatsLocked : AND.w #$00FF : BNE +
		LDA.l RupeesSpent : INC
		CMP.w #9999 : BEQ + ; decimal 9999
			STA.l RupeesSpent
	+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IndoorTileTransitionCounter:
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
IndoorSubtileTransitionCounter:
    ;JSL HeartPieceSetRedraw ; set redraw flag for items
    STZ.w SomariaSwitchFlag ; stuff we wrote over
    STZ.w SpriteRoomTag
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
StatsFinalPrep:
	PHA : PHX : PHP
		SEP #$30 ; set 8-bit accumulator and index registers
		
		LDA.l StatsLocked : BNE .ramPostOnly
		INC : STA.l StatsLocked
	
		JSL IncrementFinalSword

		LDA.l HighestMail : INC : STA.l HighestMail ; add green mail to mail count
		LDA.l Aga2Duck : BEQ .ramPostOnly
		LDA.l ScreenTransitions : DEC : STA.l ScreenTransitions ; remove extra transition from exiting gtower via duck

		.ramPostOnly
		LDA.l SwordBossKills : LSR #4 : !ADD.l SwordBossKills : STA.l BossKills
		LDA.l SwordBossKills+1 : LSR #4 : !ADD.l SwordBossKills+1 : !ADD.l BossKills : AND.b #$0F : STA.l BossKills

		LDA.l NMIFrames : !SUB.l LoopFrames : STA.l LagTime
		LDA.l NMIFrames+1 : SBC.l LoopFrames+1 : STA.l LagTime+1
		LDA.l NMIFrames+2 : SBC.l LoopFrames+2 : STA.l LagTime+2
		LDA.l NMIFrames+3 : SBC.l LoopFrames+3 : STA.l LagTime+3

		LDA.l RupeesSpent : !ADD.l DisplayRupees : STA.l RupeesCollected
		LDA.l RupeesSpent+1 : ADC.l DisplayRupees+1 : STA.l RupeesCollected+1

                REP #$20
		LDA.l TotalItemCounter : !SUB.l ChestsOpened : STA.l NonChestCounter

		.done
	PLP : PLX : PLA
	LDA.b #$19 : STA.b GameMode ; thing we wrote over, load triforce room
        STZ.b GameSubMode
        STZ.b SubSubModule
RTL
