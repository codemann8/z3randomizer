OnPrepFileSelect:
        LDA.b GameSubMode : CMP.b #$03 : BNE +
                LDA.b #$06 : STA.b NMISTRIPES ; thing we wrote over
                RTL
        +
        PHA : PHX
        REP #$10
        JSL LoadAlphabetTilemap
        JSL LoadFullItemTiles
        SEP #$10
        PLX : PLA
RTL
;--------------------------------------------------------------------------------
OnDrawHud:
	JSL DrawChallengeTimer ; this has to come before NewDrawHud because the timer overwrites the compass counter
	JSL NewDrawHud
	JSL DrHudOverride
	JSL SwapSpriteIfNecessary
	JSL CuccoStorm
	JSL PollService
JML ReturnFromOnDrawHud
;--------------------------------------------------------------------------------
OnDungeonEntrance:
	STA.l PegColor ; thing we wrote over
        JSL MaybeFlagDungeonTotalsEntrance
        LDA.w #$0001 : STA.l UpdateHUDFlag
        SEP #$30
        JSL DynamicDropGFXClear
        REP #$30
RTL
;--------------------------------------------------------------------------------
OnDungeonBossExit:
        JSL StatTransitionCounter
        JSL ClearMultiworldText
        JSL DynamicDropGFXClear
RTL
;--------------------------------------------------------------------------------
OnPlayerDead:
	PHA
		JSL SetDeathWorldChecked
                JSL DynamicDropGFXClear
		JSL SetSilverBowMode
		JSL RefreshRainAmmo
	PLA
RTL
;--------------------------------------------------------------------------------
OnDungeonExit:
        PHA : PHP
        SEP #$20 ; set 8-bit accumulator
        JSL SQEGFix
        JSL DynamicDropGFXClear
        PLP : PLA

        STA.w DungeonID : STZ.w Map16ChangeIndex ; thing we wrote over

        PHA : PHP
        LDA.w #$0001 : STA.l UpdateHUDFlag
        JSL HUD_RebuildLong
        JSL FloodGateResetInner
        JSL SetSilverBowMode
        PLP : PLA
RTL
;--------------------------------------------------------------------------------
OnQuit:
	JSL SQEGFix
        JSL MSUResumeReset
	LDA.b #$00 : STA.l AltTextFlag ; bandaid patch bug with mirroring away from text
	LDA.b #$10 : STA.b MAINDESQ ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnUncleItemGet:
	PHA

	LDA.l EscapeAssist
	BIT.b #$04 : BEQ + : STA.l InfiniteMagic : +
	BIT.b #$02 : BEQ + : STA.l InfiniteBombs : +
	BIT.b #$01 : BEQ + : STA.l InfiniteArrows : +

	LDA.l UncleItem_Player : STA.l !MULTIWORLD_ITEM_PLAYER_ID
	PLA
	JSL Link_ReceiveItem

	LDA.l UncleRefill : BIT.b #$04 : BEQ + : LDA.b #$80 : STA.l MagicFiller : + ; refill magic
	LDA.l UncleRefill : BIT.b #$02 : BEQ + : LDA.b #50 : STA.l BombsFiller : + ; refill bombs
	LDA.l UncleRefill : BIT.b #$01 : BEQ + ; refill arrows
		LDA.b #70 : STA.l ArrowsFiller

		LDA.l ArrowMode : BEQ +
			LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking ; enable bow toggle
			REP #$20 ; set 16-bit accumulator
			LDA.l CurrentRupees : !ADD.l FreeUncleItemAmount : STA.l CurrentRupees ; rupee arrows, so also give the player some money to start
			SEP #$20 ; set 8-bit accumulator
	+
        LDA.l ProgressIndicator : BNE +
                LDA.b #$01 : STA.l ProgressIndicator ; handle rain state
        +
RTL
;--------------------------------------------------------------------------------
OnAga1Defeated:
        STA.l ProgressIndicator ; vanilla game state stuff we overwrote
        LDA.l GanonVulnerableMode
        CMP.b #$06 : BNE +
                .light_speed
                REP #$20
                LDA.w #$0019 : STA.b GameMode
                SEP #$20
        +
        LDA.b #$08 : CMP.w DungeonID : BNE +
                ORA.l DungeonsCompleted+1 : STA.l DungeonsCompleted+1
        +
.exit
RTL
;--------------------------------------------------------------------------------
OnAga2Defeated:
        JSL Dungeon_SaveRoomData_justKeys ; thing we wrote over, make sure this is first
        LDA.b #$01 : STA.l Aga2Duck
        LDA.w DungeonID : CMP.b #$1A : BNE +
                LDA.l DungeonsCompleted : ORA.b #$04 : STA.l DungeonsCompleted
        +
        LDA.b #$FF : STA.w DungeonID
        JML IncrementAgahnim2Sword
;--------------------------------------------------------------------------------
OnFileCreation:
        PHB
        LDA.w #$03D7
        LDX.w #$B000
        LDY.w #$0000
        MVN CartridgeSRAM>>16, InitSRAMTable>>16
        ; Skip file name and validity value
        LDA.w #$010C
        LDX.w #$B3E3
        LDY.w #$03E3
        MVN CartridgeSRAM>>16, InitSRAMTable>>16
        PLB

        ; Resolve instant post-aga if standard
        SEP #$20
        LDA.l InitProgressIndicator : BIT #$80 : BEQ +
                LDA.b #$00 : STA.l ProgressIndicatorSRAM  ; set post-aga after zelda rescue
                LDA.b #$00 : STA.l OverworldEventDataSRAM+$02 ; keep rain state vanilla
        +
        REP #$20

        ; Set validity value and do some cleanup. Jump to checksum done.
        LDA.w #$55AA : STA.l FileValiditySRAM
        JSL WriteSaveChecksumAndBackup
        STZ.b Scrap00
        STZ.b Scrap01

JML InitializeSaveFile_checksum_done
;--------------------------------------------------------------------------------
OnFileLoad:
	REP #$10 ; set 16 bit index registers
	JSL EnableForceBlank ; what we wrote over
	REP #$20 : LDA.l TotalItemCount : STA.l MultiClientFlagsWRAM+1 : SEP #$20
	LDA.l MultiClientFlagsROM : STA.l MultiClientFlagsWRAM

	LDA.b #$07 : STA.w BG34NBA ; Restore screen 3 to normal tile area

	LDA.l FileMarker : BNE +
		JSL OnNewFile
		LDA.b #$FF : STA.l FileMarker
	+
	LDA.w DeathReloadFlag : BNE + ; don't adjust the worlds for "continue" or "save-continue"
	LDA.l MosaicLevel : BNE + ; don't adjust worlds if mosiac is enabled (Read: mirroring in dungeon)
		JSL DoWorldFix
	+
	JSL MasterSwordFollowerClear
	LDA.b #$FF : STA.l RNGLockIn ; reset rng item lock-in
	LDA.l GenericKeys : BEQ +
		LDA.l CurrentGenericKeys : STA.l CurrentSmallKeys ; copy generic keys to key counter
	+

	JSL SetSilverBowMode
	JSL RefreshRainAmmo
	JSL SetEscapeAssist

	LDA.l IsEncrypted : CMP.b #01 : BNE +
		JSL LoadStaticDecryptionKey
	+
	SEP #$10 ; restore 8 bit index registers
	JSL DynamicDropGFXClear
RTL
;--------------------------------------------------------------------------------
OnNewFile:
	PHX : PHP
		; reset some values on new file that are otherwise only reset on hard reset
		SEP #$20 ; set 8-bit accumulator
		STZ.w AncillaSearch
		STZ.w LayerAdjustment ; EG
		STZ.w ArcVariable : STZ.w ArcVariable+1
		STZ.w TreePullKills
		STZ.w TreePullHits
		STZ.w PrizePackIndexes
                STZ.w PrizePackIndexes+1
                STZ.w PrizePackIndexes+2
                STZ.w PrizePackIndexes+3
                STZ.w PrizePackIndexes+4
                STZ.w PrizePackIndexes+5
                STZ.w PrizePackIndexes+6
		LDA.b #$00 : STA.l MosaicLevel
		JSL InitRNGPointerTable
	PLP : PLX
RTL
;--------------------------------------------------------------------------------
OnInitFileSelect:
	LDA.b #$51 : STA.w $0AA2 ;<-- Line missing from JP1.0, needed to ensure "extra" copy of naming screen graphics are loaded.
	JSL EnableForceBlank
RTL
;--------------------------------------------------------------------------------
OnLinkDamaged:
	JSL IncrementDamageTakenCounter_Arb
	JML OHKOTimer
;--------------------------------------------------------------------------------
;OnEnterWater:
;       JSL UnequipCapeQuiet ; what we wrote over
;RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPit:
	JSL OHKOTimer

	LDA.l AllowAccidentalMajorGlitch
	BEQ ++
--	LDA.b #$14 : STA.b GameSubMode ; thing we wrote over

	RTL

++	LDA.b GameMode : CMP.b #$12 : BNE --

	STZ.b GameSubMode
	RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPitOutdoors:
	JML OHKOTimer ; make sure this is last
;--------------------------------------------------------------------------------
OnOWTransition:
        JSL FloodGateReset
        JSL StatTransitionCounter
        PHP
        SEP #$20 ; set 8-bit accumulator
        LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
        LDA.b #$01 : STA.l UpdateHUDFlag
        PLP
RTL
;--------------------------------------------------------------------------------
OnLoadDuckMap:
	LDA.l DuckMapFlag
	BNE +
		INC : STA.l DuckMapFlag
		JSL OverworldMap_InitGfx : DEC.w SubModuleInterface
		RTL
	+
	LDA.b #$00 : STA.l DuckMapFlag
	JML OverworldMap_DarkWorldTilemap
;--------------------------------------------------------------------------------
PreItemGet:
	LDA.b #$01 : STA.l BusyItem ; mark item as busy
RTL
;--------------------------------------------------------------------------------
PostItemGet:
        STZ.w ProgressiveFlag
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ +
                LDX.w CurrentSpriteSlot
                STZ.w SpriteMetaData,X
        +
RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
        PHB
        LDA.b #$00 : STA.l BusyItem ; mark item as finished
        LDA.l TextBoxDefer : BEQ +
                STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
                JSL Main_ShowTextMessage_Alt
                LDA.b #$00 : STA.l TextBoxDefer
        +

        LDA.w ItemReceiptMethod : CMP.b #$01 : BNE +
            LDA.b LinkDirection : BEQ +
                JSL IncrementChestTurnCounter
        +

        LDA.b IndoorsFlag : BEQ +
        		REP #$20 : LDA.b RoomIndex : STA.l !MULTIWORLD_ROOMID : SEP #$20
        		LDA.w RoomItemsTaken : STA.l !MULTIWORLD_ROOMDATA
        +

        LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BEQ +
        		STZ.w ItemReceiptMethod
        		LDA.b #$00 : STA.l !MULTIWORLD_ITEM_PLAYER_ID
        		PLB
        		JML Ancilla_ReceiveItem_objectFinished
	+

        STZ.w ItemReceiptMethod : LDA.w AncillaGet, X ; thing we wrote over to get here
        PLB
JML Ancilla_ReceiveItem_optimus+6
;--------------------------------------------------------------------------------
