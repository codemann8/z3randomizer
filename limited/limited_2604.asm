!LoadedPedestalNumber = LimitedRunStore
!PedestalCollectedFlags = LimitedRunStore+1
!KickedOutMessage = LimitedRunStore+2
;!FortuneRead = LimitedRunStore+3
!ScreenSequenceIndex = LimitedRunStore+4 ; 16-bit, screen temporary
!BananaFlags = LimitedRunStore+4 ; 16-bit, screen temporary
!StatueGFXLoaded = LimitedRunStore+4 ; 16-bit, screen temporary
!GFXLoadFlag = LimitedRunStore+$20
!UnderworldPuzzlesSolved = LimitedRunStore+$21 ; equals how many puzzle items link's collected
!BlinkTimer = LimitedRunStore+$22 ; Blink timer - must be zero to activate
!SecretItemFlags = LimitedRunStore+$23 ; - - - - - - k m (bit field)
                                       ; k = book reward | m = boomerang reward
!NewTagTimer = $7E0AB9 ; Timer for new room tag effects
!NewTagIndex = $7E0ABA ; Index for new room tag effects
!NewTagFlag  = $7E0ABB ; Flag for new room tag effects

!BookPortalActive   = $7E0270   ; 1 byte  - Portal state (0=none, 1=placed)
!BookPortalPosX     = $7E0271   ; 2 bytes - Portal X position
!BookPortalPosY     = $7E0273   ; 2 bytes - Portal Y position
!BookPortalBG2H     = $7E0275   ; 2 bytes - Camera H scroll
!BookPortalBG2V     = $7E0277   ; 2 bytes - Camera V scroll
!BookPortalLinkLayer = $7E0279  ; 1 byte  - Link layer (BG1/BG2)
!BookPortalBG1H     = $7E027A   ; 2 bytes - BG1 H scroll
!BookPortalBG1V     = $7E027C   ; 2 bytes - BG1 V scroll
!BookPortalCamBounds = $7E04E0  ; 16 bytes - Camera bounds snapshot ($0600-$060F)

!BananaXPos = LimitedRunData
!BananaYPos = LimitedRunData+10
!LostWoodsMessage = LimitedRunData+20

; --------------------------------------------------------------------------------

Limited_LoadEggGoalHUDGfx:
    LDA.b #.gfx>>16 : STA.b Scrap02
    REP #$30
    LDA.w #.gfx : STA.b Scrap00
    LDA.w #$E0E0>>1 : STA.w VMADDR
    LDX.w #$0007
    - LDA.b [Scrap00] : STA.w VMDATA
    INC.b Scrap00 : INC.b Scrap00
    DEX : BPL -
    LDA.w #$7C00 : STA.w VMADDR ; restore VMADDR
    SEP #$30
    RTL
.gfx
db $00, $00, $04, $1C, $02, $3E, $02, $3E, $02, $3E, $02, $3E, $24, $3C, $18, $18

Limited_OverworldPedestalTileChanges:
    LDA.b OverworldIndex : CMP.w #$0015 : BNE +
        LDA.w #$02C3 : STA.w $20A8
	    LDA.w #$02CA : STA.w $2128
        RTL
    + CMP.w #$001E : BNE +
        LDA.w #$0000 : STA.l !StatueGFXLoaded
        LDA.l OverworldEventDataWRAM+$1E : AND.w #$0040 : BEQ ++
		LDA.w #$0912 : STA.w $3318
            INC : STA.w $331A
            INC : STA.w $3398
            INC : STA.w $339A
        ++ RTL
    + CMP.w #$0043 : BNE +
        LDA.l OverworldEventDataWRAM+$43 : AND.w #$0040 : BEQ ++
		LDA.w #$0912 : STA.w $2310
            INC : STA.w $2312
            INC : STA.w $2390
            INC : STA.w $2392
        ++ RTL
    + CMP.w #$005E : BNE +
        LDA.l OverworldEventDataWRAM+$5E : AND.w #$0040 : BEQ ++
		LDA.w #$0912 : STA.w $2B74
            INC : STA.w $2B76
            INC : STA.w $2BF4
            INC : STA.w $2BF6
        ++ RTL
    + CMP.w #$007A : BNE +
        LDA.l OverworldEventDataWRAM+$7A : AND.w #$0020 : BEQ ++
		LDA.w #$0912 : STA.w $2A1E
            INC : STA.w $2A20
            INC : STA.w $2A9E
            INC : STA.w $2AA0
        ++ RTL
    + CMP.w #$0080 : BEQ + : RTL : +
        LDA.w #$0034 : STA.w $2A14 : STA.w $2A96
        LDA.l !LoadedPedestalNumber : AND.w #$00FF : BNE + : RTL
        + CMP.w #$0001 : BNE +
            LDA.w #$00DA : STA.w $2794 : STA.w $2814 : STA.w $2894
                STA.w $2914 : STA.w $2992 : STA.w $2994 : STA.w $2996
            LDA.w #$010D : STA.w $2792
            RTL
        + CMP.w #$0002 : BNE +
            LDA.w #$010D : STA.w $2792 : STA.w $2894 : STA.w $2912
                INC : STA.w $2896 : STA.w $2914
                INC : STA.w $2796
            LDA.w #$0071 : STA.w $2812
            LDA.w #$00DA : STA.w $2794 : STA.w $2816 : STA.w $2992 : STA.w $2994 : STA.w $2996
            LDA.w #$0034 : STA.w $2814
            RTL
        + CMP.w #$0003 : BNE +
            LDA.w #$010D : STA.w $2792
            INC : STA.w $2996
            INC : STA.w $2796 : STA.w $2896
            LDA.w #$0071 : STA.w $2812
            LDA.w #$0034 : STA.w $2814
            INC : STA.w $2912
            LDA.w #$00F8 : STA.w $2992
            LDA.w #$00DA : STA.w $2794 : STA.w $2816 : STA.w $2894 : STA.w $2916 : STA.w $2994
            RTL
        + CMP.w #$0004 : BNE +
            LDA.w #$00DA : STA.w $2792 : STA.w $2796 : STA.w $2812 : STA.w $2816
                STA.w $2894 : STA.w $2896 : STA.w $2916 : STA.w $2996
            LDA.w #$00F8 : STA.w $2892
            LDA.w #$0034 : STA.w $2814
            RTL
        + CMP.w #$0005 : BNE +
            LDA.w #$00DA : STA.w $2792 : STA.w $2794 : STA.w $2796
                STA.w $2812 : STA.w $2894 : STA.w $2916 : STA.w $2994
            LDA.w #$0034 : STA.w $2814
                INC : STA.w $2912
            LDA.w #$00F8 : STA.w $2892 : STA.w $2992
            LDA.w #$010E : STA.w $2996
                INC : STA.w $2896
            RTL
        + CMP.w #$0006 : BNE +
            LDA.w #$010D : STA.w $2792
                INC : STA.w $2996
                INC : STA.w $2796 : STA.w $2896
            LDA.w #$00DA : STA.w $2794 : STA.w $2812 : STA.w $2892
                STA.w $2894 : STA.w $2912 : STA.w $2916 : STA.w $2994
            LDA.w #$00F8 : STA.w $2992
            LDA.w #$0034 : STA.w $2814
            LDA.w #$0071 : STA.w $2816
            RTL
        + CMP.w #$0007 : BNE +
            LDA.w #$00DA : STA.w $2792 : STA.w $2794
                STA.w $2796 : STA.w $2816 : STA.w $2992
            LDA.w #$0034 : STA.w $2814
            LDA.w #$010D : STA.w $2894 : STA.w $2912
                INC : STA.w $2896 : STA.w $2914
            RTL
        + CMP.w #$0008 : BNE ++
            LDA.w #$010D : STA.w $2792 : STA.w $2892
                INC : STA.w $2996
                INC : STA.w $2796 : STA.w $2896
            LDA.w #$00DA : STA.w $2794 : STA.w $2812 : STA.w $2816
                STA.w $2894 : STA.w $2912 : STA.w $2916 : STA.w $2994
            LDA.w #$0034 : STA.w $2814
            LDA.w #$00F8 : STA.w $2992
        ++ RTL

Limited_PedestalBeeSecrets_noreveal:
    CLC
    RTL
Limited_PedestalBeeSecrets:
    LDA.b IndoorsFlag : BNE .noreveal
    LDA.b OverworldIndex : CMP.b #$15 : BNE +
        LDA.b #$04 : BRA .set_secret
    + CMP.b #$6A : BNE +
        LDA.b #$06 : BRA .set_secret
    + CMP.b #$1E : BNE +
        LDA.b #$00 : BRA .set_secret
    + CMP.b #$43 : BNE +
        LDA.b #$08 : BRA .set_secret
    + CMP.b #$12 : BNE +
        LDA.b #$0A : BRA .set_secret
    + CMP.b #$7A : BNE +
        LDA.b #$0C : BRA .set_secret
    + CMP.b #$5B : BNE +
        PHX : TAX : LDA.l OWTileMapAlt, X : PLX : AND.b #$01 : BNE .noreveal
        LDA.b #$0E : BRA .set_secret
    + CMP.b #$1B : BNE +
        PHX : TAX : LDA.l OWTileMapAlt, X : PLX : AND.b #$01 : BEQ .noreveal
        LDA.b #$12 : BRA .set_secret
    + CMP.b #$5E : BNE +
        LDA.b #$02 : BRA .set_secret
    + CMP.b #$00 : BNE +
        LDA.b #$10 : BRA .set_secret
    +
    BRA .noreveal
.set_secret
    STA.b Scrap02
    PHX
        JSL GetRandomInt : AND.b #$03 : PHA
        JSL GetRandomInt : AND.b #$03 : PHA
        REP #$20
        LDX.b Scrap02
        LDA.l .secret_xpos,X
        STA.b Scrap00
        PLX
        LDA.l Bee_BounceBoundaries, X : AND.w #$00FF
        CLC : ADC.b Scrap00
        STA.b Scrap04
        LDX.b Scrap02
        LDA.l .secret_ypos,X
        STA.b Scrap02
        PLX
        LDA.l Bee_BounceBoundaries, X : AND.w #$00FF
        CLC : ADC.b Scrap02
        STA.b Scrap06
        SEP #$20
    PLX
    SEC
    RTL

.secret_xpos
dw $0CC8, $0FA8, $0B40, $04E8, $0688, $04A0, $0460, $06E8 ; pedestals
dw $0280, $06E8, $0000, $0000

.secret_ypos
dw $0870, $0770, $0418, $0AF0, $0068, $05F0, $0F10, $07C8 ; pedestals
dw $0060, $0630, $0000, $0000

pushpc
org $82AE8E
JSL MasterSword_ConditionalLoadOverlay
org $9EE08F
JSL MasterSwordPedestal_AlternateDialogue : NOP
pullpc

; return Z = 0 if vanilla, 1 if limited
; return C = 0 if not pulled, 1 if pulled, irrelevant if Z=0
MasterSword_LimitedCheckIfPulled:
    LDA.l !LoadedPedestalNumber : BEQ .vanilla
    PHX
        XBA : LDA.b #$00 : XBA
        TAX
        SEC : LDA.b #$00
        - ROL : DEX : BNE -
        AND.l !PedestalCollectedFlags : CMP.b #$01
    PLX
    INC
    RTL
.vanilla
    LDA.b #$00
    RTL

MasterSword_LimitedActivateCutscene:
    JSL MasterSword_LimitedCheckIfPulled : BEQ .exit
        REP #$30
        LDA.w #$1020
        LDX.w ItemStackPtr : STA.l ItemGFXStack, X
        LDA.w #$BCE0>>1 : STA.l ItemTargetStack, X
        TXA : INC #2 : STA.w ItemStackPtr
        SEC : RTL
.exit
    CLC : RTL

MasterSword_LimitedHandleReceipt:
    JSL MasterSword_LimitedCheckIfPulled : BEQ .exit
    LDY.b #$6B
    PHX
        LDA.l !LoadedPedestalNumber : TAX
        SEC : LDA.b #$00
        - ROL : DEX : BNE -
        ORA.l !PedestalCollectedFlags
        STA.l !PedestalCollectedFlags
        LDA.b #$01 : STA.l !MULTIWORLD_RECEIVING_ITEM
    PLX
.exit
    RTL

MasterSword_ConditionalLoadOverlay:
    SEP #$20
    JSL MasterSword_LimitedCheckIfPulled
    REP #$20
    BEQ .vanilla : BCC +
        LDA.w #$0040 : RTL
    + LDA.w #$0000 : RTL
.vanilla
    LDA.l OverworldEventDataWRAM, X ; what we wrote over
    RTL

MasterSwordPedestal_AlternateDialogue:
    LDA.l !LoadedPedestalNumber : BEQ .vanilla
        LDA.b #$59 : LDY.b #$01
    RTL
.vanilla
    LDA.w $9EE038, Y : TAY : XBA ; what we wrote over
    RTL

Limited_ResetOnOWTransition:
    LDA.b #$00 : STA.l !LoadedPedestalNumber
.exit
    RTL

Limited_HammerPegSwampNook:
    LDA.b OverworldIndex : CMP.w #$007A : BNE .exit
    INC.w HammerPegCounter
    LDA.w HammerPegCounter : CMP.w #$0007 : BNE .exit
    PHX
        SEP #$20
        LDA.l OverworldEventDataWRAM+$7A : ORA.b #$20
        STA.l OverworldEventDataWRAM+$7A
        LDA.b #$1B : STA.w SFX3
        REP #$20
        LDA.w #$0050 : STA.w TileMapUpdateId
        LDA.w #$0A1E : STA.w TileMapTile32
        JSL Overworld_DoMapUpdate32x32_long
        REP #$30
    PLX
.exit
    RTL


Limited_HandlePedestalEntrances_exit:
    RTL
Limited_HandlePedestalEntrances:
    LDA.w OverworldIndexMirror : CMP.w #$0015 : BNE +
        LDA.b LinkPosX : AND.w #$FFF8 : CMP.w #$0B40 : BNE .exit
        LDA.w #$0003 : JMP .load_pedestal
    + CMP.w #$001E : BNE +
        LDA.b LinkPosX : AND.w #$FFF8 : CMP.w #$0CC8 : BNE .exit
        LDA.w #$0000 : STA.l !StatueGFXLoaded
        LDA.w #$0001 : BRA .load_pedestal
    + CMP.w #$0043 : BNE +
        LDA.b LinkPosX : AND.w #$FFF8 : CMP.w #$0688 : BNE .exit
        LDA.w #$0005 : BRA .load_pedestal
    + CMP.w #$001B : BNE +
        PHX : TAX : LDA.l OWTileMapAlt, X : PLX : AND.w #$0001 : BEQ .exit
        BRA ++
    + CMP.w #$005B : BNE +
        PHX : TAX : LDA.l OWTileMapAlt, X : PLX : AND.w #$0001 : BNE .exit
        ++ LDA.b LinkPosX : AND.w #$FFF8 : CMP.w #$06E8 : BNE .exit
        LDA.b LinkPosY : AND.w #$0780 : CMP.w #$0780 : BNE .exit
        LDA.l !PedestalCollectedFlags : AND.w #$0080 : BNE .exit2
        LDA.w #$0008 : BRA .load_pedestal
    + CMP.w #$005E : BNE +
        LDA.b LinkPosX : AND.w #$FFF8 : CMP.w #$0FA8 : BNE .exit2
        LDA.w #$0002 : BRA .load_pedestal
    + CMP.w #$007A : BNE .exit2
        LDA.w #$0007
.load_pedestal
    SEP #$20
    STA.l !LoadedPedestalNumber
    PLA : REP #$20 : PLX ; discard return address
    LDX.w #$0000
    JML Overworld_DoSpecialOverworldTrigger
.exit2
    RTL

pushpc
org $9BC8BE
JSL Overworld_OverrideSecrets : NOP

org $9BC0C6
JSL Overworld_OverrideSecretFlag : NOP #2
pullpc

; if bushdrop shuffle is ever implemented, this would need to be
;   removed and entries would need to be added thru the generator
Overworld_OverrideSecrets:
    CPX.w #$0043<<1 : BNE .vanilla
    LDA.w #OverworldData_HiddenItems_Screen_43 : STA.b Scrap00
    LDA.w #OverworldData_HiddenItems_Screen_43>>16 : STA.b Scrap02
    RTL
.vanilla
    LDA.w #$009B : STA.b Scrap02 ; what we wrote over
    RTL

Overworld_OverrideSecretFlag:
    CPX.w #$0043 : BNE .vanilla
        LDA.l OverworldEventDataWRAM, X : ORA.b #$40
        RTL
.vanilla
    LDA.l OverworldEventDataWRAM, X : ORA.b #$20
    RTL

OverworldData_HiddenItems_Screen_43:
    db $10, $03, $84 ; Staircase    xy:{ 0x080, 0x060 }
    db $60, $0A, $04 ; Random pack  xy:{ 0x300, 0x140 }
    db $DA, $0B, $04 ; Random pack  xy:{ 0x2D0, 0x160 }
    db $E6, $0B, $04 ; Random pack  xy:{ 0x330, 0x160 }
    db $60, $0D, $04 ; Random pack  xy:{ 0x300, 0x1A0 }
    db $20, $19, $01 ; Green rupee  xy:{ 0x100, 0x320 }
    db $04, $1A, $04 ; Random pack  xy:{ 0x020, 0x340 }
    db $EE, $17, $06 ; Heart        xy:{ 0x370, 0x2E0 }
    db $68, $19, $06 ; Heart        xy:{ 0x340, 0x320 }
    db $74, $19, $06 ; Heart        xy:{ 0x3A0, 0x320 }
    db $EE, $1A, $06 ; Heart        xy:{ 0x370, 0x340 }
    dw $FFFF

Limited_OverworldTransitionPedestal:
    TXY : LDA.l !ScreenSequenceIndex : TAX
    TYA : CMP.l .lookupid, X : BNE .reset
    LDA.w TransitionDirection : CMP.l .direction, X : BNE .reset
        LDA.l .override, X : STA.w RandoOverworldTargetEdge
        CPX.w #$000A : BNE +
            SEP #$20
            LDA.b #$06 : STA.l !LoadedPedestalNumber
            LDA.b #$00 : STA.l !ScreenSequenceIndex
            REP #$20
            LDA.w #$1B00 : STA.w SFX2
            RTL
        +
        LDA.w #$2D00 : STA.w SFX2
        INX : INX : TXA
        BRA .increment
.reset
    LDA.w #$0000
.increment
    STA.l !ScreenSequenceIndex
    RTL

.lookupid
dw $0090, $0050, $00A0, $0070, $0040, $0060
.direction
dw $0001, $0002, $0001, $0003, $0002, $0000
.override
dw $0006, $0007, $0006, $0005, $0006, $B080

Limited_FluteMenu_PedestalDestination:
    LDA.l NpcFlags : AND.b #$40 : BEQ .exit
    LDA.w FluteSelection : CMP.b #($04-1)<<1 : BNE .exit
        LDA.b #$04 : STA.l !LoadedPedestalNumber
        STZ.w CutsceneFlag
        STZ.b LinkVisible
        STZ.w ItemReceiptPose
        PLA : REP #$30 : PLX ; discard return address
        LDX.w #$0000 : JML Overworld_DoSpecialOverworldTrigger
.exit
    RTL

pushpc
org $86908D ; overwrites previous hook
JSL ItemCheck_TreeKid_IsTree : CMP.b #$08 : BEQ $0A
org $86B0CE
INC.w SpriteActivity, X
org $86B0D2
JSL Stumpy_WaitForMusic_FinalWish : NOP
org $86B0FD
JSL Stumpy_BecomeTree_FinalGoodbye : NOP #2
org $86B131
JSL ItemSet_TreeKid_TurnToTree
org $88DE0C
JSL Ancilla27_Duck_MaybeSkip : NOP #3
pullpc

ItemCheck_TreeKid_IsTree:
		;LDA.l NpcFlags : BIT.b #$40 : BNE .is_tree ; restore this line if we want him to stay as tree
		LDA.l NpcFlags : AND.b #$08 : BEQ .not_given
		LDA.b #$03 : STA.w SpriteActivity, X
		LDA.b #$00
.not_given:
RTL
.is_tree:
		LDA.b #$08
RTL

ItemSet_TreeKid_TurnToTree:
		STA.l NpcFlagsVanilla ; what we wrote over
		PHA
			  LDA.l NpcFlags : ORA.b #$40 : STA.l NpcFlags
		PLA
RTL

Stumpy_WaitForMusic_FinalWish:
    LDA.b #$E6 : LDY.b #$00 : JSL Sprite_ShowSolicitedMessageIfPlayerFacing
    LDA.w ItemCursor : CMP.b #$0D ; what we wrote over
RTL 

Stumpy_BecomeTree_FinalGoodbye:
    CMP.b #$03 : BNE .return
    PHY
        LDA.b #$E7 : LDY.b #$00 : JSL Sprite_ShowMessageUnconditional
    PLY
.return
    LDA.b #$33 : JSL Sound_SetSfx2PanLong ; what we wrote over
RTL

Ancilla27_Duck_MaybeSkip:
    LDA.w LastSFX1 : CMP.b #$17 : BNE .continue
    LDA.w CurrentControlRequest : CMP.b #$F2 : BNE .continue
        ; conditions during Stumpy cutscene, despawn duck
        STZ.w AncillaID, X
        PLA : PLA : PEA.w $88DE3F ; return directly to RTS
.return:
RTL
.continue:
    LDA.b GameSubMode : BEQ .return ; what we wrote over
    PLA : PLA : PLA
    JML $88DF75 ; kinda what we wrote over

; Lost Woods Fake Master Sword Gimmick
pushpc
org $86E091
JSL ThrownSprite_FakeMasterSwordDeath : NOP
pullpc

Limited_InitializeWallmasterTileset:
    LDA.w EntranceIndex : CMP.l Overworld_GetPitDestination_screen+$2D : BNE .exit
    LDA.b LinkFallPose : BEQ .exit
    LDA.b IndoorsFlag : BEQ .exit
    LDA.w OverworldIndexMirror : BNE .exit ; came in from lost woods
    LDA.w OWTransitionFlag : BEQ .exit
        LDA.b #$23 : STA.l LastSpriteSet+2 : STA.b Scrap07 ; wallmaster gfx
.exit
    RTL

Limited_UnderworldPrepWallmasterKickOut:
    LDA.w EntranceIndex : CMP.l Overworld_GetPitDestination_screen+$2D : BNE .vanilla
    LDA.b LinkFallPose : BEQ .vanilla
    LDA.b IndoorsFlag : BEQ .vanilla
    LDA.w OverworldIndexMirror : BNE .vanilla ; came in from lost woods
    LDA.w OWTransitionFlag : BEQ .vanilla
        LDA.b #$90 : LDY.b #$09 : JSL Sprite_SpawnDynamically_arbitrary
        LDA.b LinkPosX : STA.w SpritePosXLow, Y
        LDA.b LinkPosX+1 : STA.w SpritePosXHigh, Y
        LDA.b LinkTargetPosY : STA.w SpritePosYLow, Y
        LDA.b LinkTargetPosY+1 : STA.w SpritePosYHigh, Y
        LDA.b LinkLayer : STA.w SpriteLayer, Y
        LDA.b #$80 : STA.w SpriteZCoord, Y
        LDA.b #$01 : STA.w SpriteAuxTable, Y
            STA.w CutsceneFlag
            STA.l !KickedOutMessage
        LDA.b #$20 : STA.w SFX2
        LDA.b #$00
        RTL
.vanilla
    LDA.b #$01
    RTL

Limited_LoadOverworldFromUnderworld:
    LDA.l !KickedOutMessage : BEQ .exit
    PLA : PLA : PLA : PLA : PLA : PLA
    LDA.b #$08 : STA.b GameMode
    STZ.b SubSubModule
    REP #$20
    LDA.w #$0100 : STA.b RoomIndex
    LDA.w #$0208 : STA.l EN_POSY
    LDA.w #$0320 : STA.l EN_POSX
    SEP #$20
    JML $82E337 ; some RTS in bank 02
.exit
    RTL

Limited_ShowAwaitingMessage:
    LDA.l !KickedOutMessage : BEQ .exit
        LDA.l !LostWoodsMessage+1 : TAY : LDA.l !LostWoodsMessage
        JSL Sprite_ShowMessageUnconditional
        LDA.b #$00 : STA.l !KickedOutMessage
.exit
    RTL

Limited_ModifyFakeSwordOverPit:
    LDA.w OWTransitionFlag : BEQ .exit
    CPY.b #$20 : BNE .exit ; over pit
    LDA.w SpriteTypeTable, X : CMP.b #$E8 : BNE .exit
        LDA.w SpriteVelocityY, X : JSL DivideByTwoPreserveSign : STA.w SpriteVelocityY, X
        LDA.w SpriteVelocityX, X : JSL DivideByTwoPreserveSign : STA.w SpriteVelocityX, X
        LDA.w SpriteVelocityZ, X : SEC : SBC.b #$02 : STA.w SpriteVelocityZ, X
.exit
    RTL

ThrownSprite_FakeMasterSwordDeath:
    LDA.b #$06 : STA.w SpriteAITable, X ; what we wrote over
    LDA.w CurrentSpriteTile : CMP.b #$20 : BNE .exit ; over pit
    LDA.l OWTransitionFlag : BEQ .exit
        STZ.w OWTransitionFlag
        LDA.b #$09 : STA.w SFX3
.exit
    RTL

; Snitch Cucco Storm Gimmick
pushpc

org $9DC9CD
JSL Thief_Chasing_CuccoStorm : NOP #2
db $B0, $05 ; BCS to skip over following JSR

org $9DCCC2
JSL SpriteDraw_Thief_SnitchVariant

pullpc

SpriteDraw_Thief_SnitchVariant:
    TAX ; part of what we wrote over
    LDA.b IndoorsFlag : BNE .vanilla
    LDA.b OverworldIndex : CMP.b #$18 : BNE .vanilla
        LDY.b #$06
        LDA.l .oam_body,X : STA.b ($90),Y
        LDA.l .oam_head,X
        RTL
.vanilla
    LDA.l $9DCC96,X ; part of what we wrote over
    RTL

.oam_head
    db $E2, $E2, $C0, $E0
.oam_body
    db $E4, $E4, $C2, $E8

Thief_Chasing_CuccoStorm:
    INC.w SpriteActivity, X : LDA.b #$20 : STA.w SpriteTimer, X ; what we wrote over
    LDA.b IndoorsFlag : BNE .exit
    LDA.b OverworldIndex : CMP.b #$18 : BNE .exit
        PHX
            JSL CuccoStorm_activate
        PLX
        SEC
        RTL
.exit
    CLC
    RTL

; Flying Floor Tiles
pushpc
org $89BA8A
JSL SpawnFlyingTile_FollowLink : NOP
pullpc

SpawnFlyingTile_FollowLink:
    LDA.b #$04 : STA.w SpriteHitPoints,Y ; what we wrote over
    LDA.b LinkPosX : JSR .within_range
    CMP.b #$C0 : BCC +
        LDA.b #$C0
    + STA.w SpritePosXLow,Y
    LDA.b LinkPosY : JSR .within_range
    CMP.b #$B0 : BCC +
        LDA.b #$B0 : CLC
    + ADC.b #$08 : STA.w SpritePosYLow,Y
.exit
    RTL
.within_range
    CLC : ADC.b #$08 : AND.b #$F0
        CMP.b #$10 : BCS .return
            LDA.b #$10
.return
    RTS

; Mirror Wallmaster Gimmick
; pushpc
; org $82A0AF
; STZ.w SpriteAITable+$C
; LDA.b #$90 : LDY.b #$0C : JSL Sprite_SpawnDynamically_arbitrary
; JSL Limited_MirrorWallmaster
; pullpc

; Limited_MirrorWallmaster:
;     BPL +
;         ; if clearing $0C slot wasn't enough, kill all sprites
;         LDY.b #$0E
;         - LDA.b #$00 : STA.w SpriteAITable, Y : DEY : BPL -
;         LDA.b #$90 : LDY.b #$0C : JSL Sprite_SpawnDynamically_arbitrary
;     +
;     LDA.b LinkPosX : STA.w SpritePosXLow, Y
;     LDA.b LinkPosX+1 : STA.w SpritePosXHigh, Y
;     LDA.b LinkPosY : STA.w SpritePosYLow, Y
;     LDA.b LinkPosY+1 : STA.w SpritePosYHigh, Y
;     LDA.b LinkLayer : STA.w SpriteLayer, Y
;     LDA.b #$A0 : STA.w SpriteZCoord, Y
;     INC.w CutsceneFlag
;     LDA.b #$40 : STA.w LinkIFrames
;     LDA.b #$20 : STA.w SFX2
;     REP #$30
;         LDA.w #BigDecompressionBuffer+$4000
;         LDX.w ItemStackPtr : STA.l ItemGFXStack, X
;         LDA.w #$B4C0>>1 : STA.l ItemTargetStack, X
        
;         LDA.w #BigDecompressionBuffer+$4040
;         INX #2 : STA.l ItemGFXStack, X
;         LDA.w #$B500>>1 : STA.l ItemTargetStack, X
        
;         LDA.w #BigDecompressionBuffer+$4080
;         INX #2 : STA.l ItemGFXStack, X
;         LDA.w #$B540>>1 : STA.l ItemTargetStack, X

;         LDA.w #BigDecompressionBuffer+$40C0
;         INX #2 : STA.l ItemGFXStack, X
;         LDA.w #$B580>>1 : STA.l ItemTargetStack, X

;         LDA.w #BigDecompressionBuffer+$4100
;         INX #2 : STA.l ItemGFXStack, X
;         LDA.w #$B5C0>>1 : STA.l ItemTargetStack, X

;         INX #2 : STX.w ItemStackPtr
;     SEP #$30
; RTL

; Desert Statue Gimmick
pushpc
org $8595DA : NOP #5
org $8595E6 : db #$03
org $8595F3
JSL DesertStatue_Moving_Finish : NOP
STZ.w $02F0
pullpc

DesertStatue_Moving_Finish:
    STZ.w SpriteActivity, X
    STZ.w SpriteSpawnStep, X
    RTL

; Z1 Armos Gimmick
pushpc
org $87C0F7
JSL CheckForGravePush_Conditional

org $87CB2E
JSL CheckForZ1StatuePush : NOP

org $8999E0
JSL AncillaAdd_Z1ArmosStatue

org $85A072
JSL ArmosKnight_KnightDead

org $85B800
JSL SpriteDraw_Z1ArmosStatue_Alternate : NOP
org $85B758
JSL ArmosStatue_InactivePalette : NOP

org $85A288
JSL SpriteDraw_Z1ArmosKnight_Alternate
org $9DEF7E
JSL ArmosKnight_RedCrusherPalette : NOP

org $8FFE97 : db $42 : skip 5 : db $42 : skip 8 : db $42, $42 : skip 5 : db $42 ; make statues pushable
pullpc

CheckForGravePush_Conditional:
    BEQ .reset_push_timer ; what we
    LDA.b LinkLastDirection : BEQ .continue ; wrote over
    LDA.b OverworldIndex : CMP.b #$1E : BEQ .continue
.reset_push_timer
    LDA.b #$01
.continue
    RTL

; most of this code is copied from CheckForGravePush
CheckForZ1StatuePush:
    STZ.b $6B ; part of what we wrote over
    LDA.b OverworldIndex : CMP.b #$1E : BNE .reset_push_timer
    LDA.w $02E7 : AND.b #$0F : BEQ .reset_push_timer
    LDA.b LinkLastDirection : AND.b #$02 : BEQ .reset_push_timer
    DEC.b $61 : BPL .return
.dashing
    LDA.b Scrap0E : PHA
        LDY.b #$04 : LDA.b #$24 ; ANCILLA 24
        JSL AncillaAdd_GraveStone
    PLA : STA.b Scrap0E
.reset_push_timer
    LDA.b #$34 : STA.b $61
.return
    LDA.w $02E8 ; part of what we wrote over
    RTL

AncillaAdd_Z1ArmosStatue_gravestone:
    REP #$30 : LDY.b LinkPosY ; what we wrote over
    RTL
AncillaAdd_Z1ArmosStatue:
    LDA.b OverworldIndex : CMP.b #$1E : BNE .gravestone
    PLA : PLA : PLA ; discard return address
    LDA.b #AncillaAdd_Z1ArmosStatue>>16 : STA.b Scrap06 : PHA : PLB
    STZ.w AncillaID, X

    REP #$30
    LDA.b LinkLastDirection : AND.w #$0002 : BNE +
        ; up/down, set X
        LDA.b LinkPosX : CLC : ADC.w #$0008 : AND.w #$FFF0 : STA.b Scrap02
        BRA .determine_xy
    + ; left/right, set Y
    LDA.b LinkPosY : AND.w #$FFF0 : CLC : ADC.w #$0008 : STA.b Scrap00
.determine_xy
    LDA.b LinkLastDirection : AND.w #$00FF : BNE + ; up
        LDA.b LinkPosY : SEC : SBC.w #$001C : AND.w #$FFF8 : STA.b Scrap00
        BRA .search
    + DEC : BNE + ; down
        LDA.b LinkPosY : CLC : ADC.w #$0010 : AND.w #$FFF8 : STA.b Scrap00
        BRA .search
    + DEC : BNE + ; left
        LDA.b LinkPosX : SEC : SBC.w #$001C : AND.w #$FFF0 : STA.b Scrap02
        BRA .search
    + LDA.b LinkPosX : CLC : ADC.w #$0010 : AND.w #$FFF0 : STA.b Scrap02 ;right
.search
    LDA.b LinkLastDirection : AND.w #$00FF : ASL : TAX
    LDA.w .direction, X : STA.b Scrap04
    LDY.w #((.position_x-.position_y)+2)
.next_statue
    JMP.w [Scrap04]
.direction
    dw .check_up, .check_down, .check_left, .check_right

.check_up
    LDA.w .position_y, Y : CMP.b Scrap00 : BNE .continue
    LDA.w .position_x, Y : DEC : CMP.b Scrap02 : BCS .continue
    CLC : ADC.w #$0020 : CMP.b Scrap02 : BCC .continue
    BRA .found_statue
.check_down
    LDA.w .position_y, Y : CMP.b Scrap00 : BNE .continue
    LDA.w .position_x, Y : DEC : CMP.b Scrap02 : BCS .continue
    CLC : ADC.w #$0020 : CMP.b Scrap02 : BCC .continue
    BRA .found_statue
.check_left
    LDA.w .position_x, Y : CMP.b Scrap02 : BNE .continue
    LDA.w .position_y, Y : DEC : CMP.b Scrap00 : BCS .continue
    CLC : ADC.w #$0020 : CMP.b Scrap00 : BCC .continue
    BRA .found_statue
.check_right
    LDA.w .position_x, Y : CMP.b Scrap02 : BNE .continue
    LDA.w .position_y, Y : DEC : CMP.b Scrap00 : BCS .continue
    CLC : ADC.w #$0020 : CMP.b Scrap00 : BCC .continue
    BRA .found_statue

.continue
    DEY #2 : BMI + : JMP.w [Scrap04] : +
    SEP #$30
    BRL .exit

.found_statue
    LDX.w .tilemap_offset, Y

    PHY
        LDA.w #$02E5 : JSL Overworld_MemorizeMap16Change : JSL Overworld_DrawPersistentMap16
        INX #2
        LDA.w #$02E5 : JSL Overworld_MemorizeMap16Change : JSL Overworld_DrawPersistentMap16
        TXA : CLC : ADC.w #$007E : TAX
        LDA.w #$02E5 : JSL Overworld_MemorizeMap16Change : JSL Overworld_DrawPersistentMap16
        INX #2
        LDA.w #$02E5 : JSL Overworld_MemorizeMap16Change : JSL Overworld_DrawPersistentMap16
    PLX
    SEP #$30
    LDA.b #$01 : STA.b NMISTRIPES

    PHX
        TXA : LSR : TAX
        LDA.w .sprite_id,X
        PHA
            JSL Sprite_SpawnDynamically
            BMI +
                JSL SpritePrep_LoadProperties
            +
        PLA
    PLX
    CPY.b #$00 : BMI .exit

    CMP.b #$53 : BNE +
        LDA.b #$01 : STA.w $0FF8 ; Red Armos Knight
        BRA .set_position
    +
    LDA.b #$02 : STA.w SpriteSpawnStep, Y
    LDA.b #$0D : STA.w SpriteOAMProp, Y
.set_position
    REP #$20
    LDA.w .position_x, X : CLC : ADC.w #$0008 : STA.b Scrap00
    LDA.w .position_y, X : CLC : ADC.w #$0010 : STA.b Scrap02
    SEP #$20

    LDA.b Scrap02 : STA.w SpritePosYLow, Y
    LDA.b Scrap03 : STA.w SpritePosYHigh, Y

    LDA.b Scrap00 : STA.w SpritePosXLow, Y
    LDA.b Scrap01 : STA.w SpritePosXHigh, Y

    LDA.l !StatueGFXLoaded : BNE +
        LDA.b #$01 : STA.l !StatueGFXLoaded : STA.l !GFXLoadFlag
    +
.exit
    PLB : RTL

.position_y
    ;dw $06B0
    ;dw $06B0
    dw $0818
    dw $0828
    dw $0828
    dw $0828
    dw $0858
    dw $0858
    dw $0888
    dw $0888
    dw $0888
    dw $0938
    dw $0938
.position_x
    ;dw $0EE0
    ;dw $0FB0
    dw $0E20
    dw $0C60
    dw $0CC0
    dw $0D20
    dw $0CC0
    dw $0EC0
    dw $0C60
    dw $0CC0
    dw $0D20
    dw $0D20
    dw $0D80
.tilemap_offset
    ;dw $05DC
    ;dw $05F6
    dw $1144
    dw $118C
    dw $1198
    dw $11A4
    dw $1318
    dw $1358
    dw $148C
    dw $1498
    dw $14A4
    dw $1A24
    dw $1A30
.sprite_id
    ;db $51
    ;db $51
    db $51
    db $51
    db $51
    db $51
    db $53
    db $51
    db $51
    db $51
    db $51
    db $51
    db $51

ArmosKnight_KnightDead_vanilla:
    JML $89AF32 ; CheckIfScreenIsClear - what we wrote over
ArmosKnight_KnightDead:
    LDA.b IndoorsFlag : BNE .vanilla
        ; reveal entrance
        LDA.b #$1A : STA.w SFX3
        LDA.l OverworldEventDataWRAM+$1E : ORA.b #$40
        STA.l OverworldEventDataWRAM+$1E
        REP #$30
            LDA.w #$0912 : LDX.w #$1318 : JSL Overworld_DrawPersistentMap16
            LDA.w #$0913 : LDX.w #$131A : JSL Overworld_DrawPersistentMap16
            LDA.w #$0914 : LDX.w #$1398 : JSL Overworld_DrawPersistentMap16
            LDA.w #$0915 : LDX.w #$139A : JSL Overworld_DrawPersistentMap16
        SEP #$30
        LDA.b #$01 : STA.b NMISTRIPES
        CLC
.exit
    RTL

ArmosStatue_InactivePalette:
    LDA.b #$0B ; what we
    CLC : ADC.w SpriteSpawnStep, X
    STA.w SpriteOAMProp, X ; wrote over
    RTL

ArmosKnight_RedCrusherPalette:
    LDA.b IndoorsFlag : BNE .vanilla
        LDA.b #$03
        BRA .set_palette
.vanilla
    LDA.b #$07 ; what we
.set_palette
    STA.w SpriteOAMProp, X ; wrote over
    RTL

SpriteDraw_Z1ArmosStatue_Alternate:
    LDA.w SpriteSpawnStep, X : BEQ .vanilla
        PHB : PHK : PLB
            JSL OAM_AllocateFromRegionC
            REP #$20
            LDA.w #.oam_groups : STA.b Scrap08
            SEP #$20
            LDA.b #$04 : JSL Sprite_DrawMultiple
            JSL OAM_AllocateFromRegionF
        PLB
    RTL
.vanilla
    LDA.b #$02 : JML Sprite_DrawMultiple ; what we wrote over
.oam_groups
dw  -8, -12 : db $CE, $00, $00, $02
dw   8, -12 : db $CE, $40, $00, $02
dw  -8,   4 : db $EE, $00, $00, $02
dw   8,   4 : db $EE, $40, $00, $02

SpriteDraw_Z1ArmosKnight_Alternate:
    LDA.b IndoorsFlag : BNE .vanilla
        PLA : PLA : PEA.w $A2E7 ; discard return address
        PHB : PHK : PLB
            JSL OAM_AllocateFromRegionC
            REP #$20
            LDA.w #.oam_groups : STA.b Scrap08
            SEP #$20
            LDA.b #$04 : JSL Sprite_DrawMultiple
            JSL OAM_AllocateFromRegionF
            JSL Sprite_DrawShadowLong
        PLB
.vanilla
    LDA.w SpriteGFXControl, X : ASL ; what we wrote over
    RTL
.oam_groups
dw  -8, -12 : db $CE, $00, $00, $02
dw   8, -12 : db $CE, $40, $00, $02
dw  -8,   4 : db $EE, $00, $00, $02
dw   8,   4 : db $EE, $40, $00, $02

Limited_TransferGFX_exit:
    RTL
Limited_TransferGFX:
    LDA.l !GFXLoadFlag : BEQ .exit
        PHP
            REP #$10
            SEP #$20
            LDA.b #$80 : STA.w VMAIN
            LDA.b #$01 : STA.w DMA0MODE
            DEC : STA.l !GFXLoadFlag
            LDA.b #$18 : STA.w DMA0PORT
            LDA.b #$A2 : STA.w DMA0ADDRB

            REP #$20
            ; row 0 (tiles 0-1)
            LDA.w #$B9C0>>1 : STA.w VMADDR
            LDA.w #$9C20 : STA.w DMA0ADDR
            LDA.w #$0040 : STA.w DMA0SIZE
            SEP #$20 : LDA.b #$01 : STA.w DMAENABLE : REP #$20
            ; row 1 (tiles 2-3)
            LDA.w #$BBC0>>1 : STA.w VMADDR
            LDA.w #$9E20 : STA.w DMA0ADDR
            LDA.w #$0040 : STA.w DMA0SIZE
            SEP #$20 : LDA.b #$01 : STA.w DMAENABLE : REP #$20
            ; row 2 (tiles 4-5)
            LDA.w #$BDC0>>1 : STA.w VMADDR
            LDA.w #$A020 : STA.w DMA0ADDR
            LDA.w #$0040 : STA.w DMA0SIZE
            SEP #$20 : LDA.b #$01 : STA.w DMAENABLE : REP #$20
            ; row 3 (tiles 6-7)
            LDA.w #$BFC0>>1 : STA.w VMADDR
            LDA.w #$A220 : STA.w DMA0ADDR
            LDA.w #$0040 : STA.w DMA0SIZE
            SEP #$20 : LDA.b #$01 : STA.w DMAENABLE : REP #$20
        PLP
    RTL

; Kiki Banana Fetch Game
pushpc
org $9EE516
JSL Kiki_VerifyPurchaseCheckBanana
pullpc

SpritePrep_KikiBanana:
    LDA.l OverworldEventDataWRAM+$5E : AND.b #$60 : CMP.b #$60 : BEQ .despawn
    ; despawn if one exists already
    LDY.b #$0F
    STX.b Scrap00
    - CPY.b Scrap00 : BEQ +
        LDA.w SpriteTypeTable, Y : CMP.b #$03 : BNE +
            .despawn
            STZ.w SpriteAITable, X
            RTL
    + DEY : BPL -

    LDA.b #$00 : STA.l !BananaFlags : STA.l !BananaFlags+1
    STA.w SpriteAux, X : STA.w SpriteSpawnStep, X : STA.w SpriteTimer, X

    PHX
        REP #$20
        LDA.w #$1160 ; banana gfx
        LDX.w ItemStackPtr : STA.l ItemGFXStack, X
        LDA.w #$B840>>1 : STA.l ItemTargetStack, X
        TXA : INC #2 : STA.w ItemStackPtr
        SEP #$20
    PLX
    RTL

Sprite_03_KikiBanana:
    STZ.w SpriteAux, X : STZ.w SpriteDirectionTable, X
    LDY.b #$00
.next_instance
    PHY
        REP #$20
        INY : LDA.l !BananaFlags
        - ROR : DEY : BNE -
        SEP #$20
    PLY
    BCS .collected
    JSL KikiBanana_SetCoords
    JSL Sprite_Get16BitCoords_long
    PHY
        JSL Sprite_PrepOAMCoordLong
    PLY
    LDA.w SpriteDirectionTable, X : BNE +
        TYA : INC : STA.w SpriteDirectionTable, X
    + BCS .skip_instance ; offscreen
        ; check if link is close to banana
        LDA.w SpriteTimer, X : BNE ++
            REP #$20
            LDA.w SpriteCoordCacheX : SEC : SBC.w LinkPosX : BPL +
                EOR.w #$FFFF : INC
            + CMP.w #$0018 : BCS ++
                LDA.w SpriteCoordCacheY : SEC : SBC.w LinkPosY : BPL +
                    EOR.w #$FFFF : INC
                + CMP.w #$0018 : BCS ++
                    SEP #$20
                    TYA : INC : ASL #4
                    ORA.w SpriteAux, X : STA.w SpriteAux, X ; set sprite coords to this index later
        ++
    SEP #$20
    PHY
        JSL SpriteDraw_KikiBanana
    PLY
.skip_instance
    INC.w SpriteAux, X
.collected
    INY : CPY.b #(!BananaYPos-!BananaXPos) : BCC .next_instance
    LDA.w SpriteTimer, X : DEC : BNE +
        LDA.b #$FF : STA.w HUDTimer
    +
    LDA.w SpriteAux, X : LSR #4 : BEQ .exit
    TAY : DEY
    JSL KikiBanana_SetCoords
    JSL Sprite_CheckDamageToPlayerSameLayerLong : BCC .exit
        JML KikiBanana_Collect
.exit
    RTL

; X = sprite index
; Y = banana index
KikiBanana_Collect:
    INC.w SpriteSpawnStep, X
    LDA.b #$0A : STA.w SFX3
    TYA : INC : CMP.w SpriteDirectionTable, X : BNE +
        INC.w SpriteSpawnStep, X
        LDA.b #$2D : STA.w SFX3
    +
    REP #$20
        SEC : INY : LDA.w #$0000
        - ROL : DEY : BNE -
        ORA.l !BananaFlags : STA.l !BananaFlags
    SEP #$20
    LDA.b #$10 : STA.w SpriteTimer, X
    LDA.b #$FF : STA.w HUDTimerDelay
    LDA.w SpriteSpawnStep, X : STA.w HUDTimer
    CMP.b #((!BananaYPos-!BananaXPos)<<1) : BNE .return
        ; reveal entrance
        LDA.b #$1A : STA.w SFX3
        LDA.l OverworldEventDataWRAM+$5E : ORA.b #$40
        STA.l OverworldEventDataWRAM+$5E
        LDA.w OverworldSlotPosition : CMP.b #$3E : REP #$30 : BNE +
            LDA.w #$0912 : LDX.w #$0B74 : JSL Overworld_DrawPersistentMap16
            LDA.w #$0914 : LDX.w #$0BF4 : JSL Overworld_DrawPersistentMap16
            LDA.w #$0913 : LDX.w #$0B76 : JSL Overworld_DrawPersistentMap16
            LDA.w #$0915 : LDX.w #$0BF6 : JSL Overworld_DrawPersistentMap16
            SEP #$30
            LDA.b #$01 : STA.b NMISTRIPES
            BRA .return
        +
        LDA.w #$0912 : STA.l $7E2B74
        INC : STA.l $7E2B76
        INC : STA.l $7E2BF4
        INC : STA.l $7E2BF6
        SEP #$30
.return
    RTL

; X = sprite index
; Y = banana index
SpriteDraw_KikiBanana:
    PHY
        LDA.b #$08 : JSL OAM_AllocateFromRegionA
        JSL Sprite_PrepAndDrawSingleLargeLong  ; draws gfx at current coord
    PLY
    TYA : INC : CMP.w SpriteDirectionTable, X : BNE .exit
        LDA.w SpritePosYLow, X : CLC : ADC.b #$10 : STA.w SpritePosYLow, X
        LDA.w SpritePosYHigh, X : ADC.b #$00 : STA.w SpritePosYHigh, X
        JSL Sprite_SpawnSparkleGarnish
.exit
    RTL

KikiBanana_SetCoords:
    PHX : TYX : PLY
        REP #$20
            LDA.l !BananaXPos, X : AND.w #$007F
            ASL #4 : CLC : ADC.w $0604
        SEP #$20
        STA.w SpritePosXLow, Y : XBA : STA.w SpritePosXHigh, Y
        REP #$20
            LDA.l !BananaYPos, X : AND.w #$007F
            ASL #4 : CLC : ADC.w $0600
        SEP #$20
        STA.w SpritePosYLow, Y : XBA : STA.w SpritePosYHigh, Y
    PHX : TYX : PLY
    RTL

Kiki_VerifyPurchaseCheckBanana:
    LDY.b #$0F
    - LDA.w SpriteTypeTable, Y : CMP.b #$03 : BNE +
        LDA.w SpriteSpawnStep, Y : CMP.b #(!BananaYPos-!BananaXPos) : BCS .checkrupees
        BRA .fail
    + DEY : BPL -
.fail
    CLC : PLA : LDA.b #$1C : PHA ; overwrite return address to fail rupee check
    RTL
.checkrupees
    LDA.b #$64 : LDY.b #$00 ; what we wrote over
    RTL

; Ganon Gimmick
pushpc
org $9D8FCC
JML Ganon_MaybeWarpOnLink
org $9D8F58
JSL Sprite_Ganon_skip_damage : NOP #2
org $9D8EEA
JSL Ganon_MaybeEnableVulnerabilty : NOP
org $9DF00F
JSL RedArmosCrusher_Jump_adjust_proximity : NOP #2
org $89EE44
JSL Ganon_FakeVictory : NOP
org $81C78A
JSL RoomTag_GanonDoor_victory
pullpc

macro JSRLongCall_Bank1D(call, return)
    PHK : PEA.w (<return>)-1 ; address to return back to
    PEA.w $88BB-1 ; some RTL in bank 1D
    JML <call>
endmacro

; $0D80 - SpriteActivity - this determines which routine runs on the next frame, the added routines are $14-$1B
; $0C9A - SpriteScreenOwner - prevents vanilla torch-based invulnerability check from activating
;                             *allows our code to properly let Ganon be set up for this newly added phase
; $0BA0 - SpriteAncillaInteract - this is used to skip the collision/damage check
;                                 *sometimes is ineffective under certain conditions
; $0CAA - SpriteDeflection - this is used to bypass activating an invulnerability timer* during the $0A carry state
;                            *this timer caused routine code to be skipped for a period after throwing Ganon
; $0E40 - SpriteOAMProperties - toggles 'harmless' bit to selectively avoid collision/damage in stunned phase

; $0E90/$0DA0/$0DB0 - SpriteAuxB/SpriteAuxTable/SpriteAuxTableB - Armos code uses these to temp store Link's coords

; $0EB0 - SpriteDirectionTable - this is used to change the direction Ganon faces
;                                *Armos code also uses this to temp store part of Link's coords
; $0DC0 - SpriteGFXControl - this determines which body gfx Ganon uses
; $0DE0 - SpriteMoveDirection - this determines which head gfx Ganon uses
; $0ED0 - SpriteSpawnStep - controls gfx for Ganon's trident
;                           *Armos code increments this to determine if ready for the next routine
; $0F50 - SpriteOAMProp - controls the palette for Ganon gfx

; $0EC0 - SpriteAuxC - used to count how many times Ganon was hit since last reset
; $0D90 - SpriteMovement - used to count how many times Ganon has smashed the floor since last reset

; $0E70 - SpriteTileCollision - this is zeroed when we want Ganon to clip thru tiles
;                               *helps let him clip into walls slightly to allow pit fall
; $0B68 - SpriteTileDeath - this allows Ganon to fall into pits

; $0DF0 - SpriteTimer - this is the primary routine countdown timer
; $0E00 - SpriteTimerB - while active, this skips damage checks, but also exits Ganon code early
; $0F10 - SpriteTimerE - this timer allows the current routine to pause and let recoil take visual effect
; $0EE0 - SpriteTimerD - controls duration of floor shake

Ganon_MaybeWarpOnLink:
    ; Ganon in phase 4 has a chance to warp on Link's position
    JSL RNG_Ganon : AND.b #$03 : BNE .vanilla
        LDA.b LinkPosX : STA.l $7FFD5C
        LDA.b LinkPosY : STA.l $7FFD68
        LDA.b #$12 : JML Ganon_SelectWarpLocation_custom
.vanilla
    LDA.b #$12 : JML Ganon_SelectWarpLocation ; what we wrote over

Ganon_FakeVictory:
    LDA.b #$13 : STA.w MusicControlRequest ; what we wrote over
    LDA.b #$09 : STA.w SpriteAITable, X
    LDA.b #$01 : STA.w CutsceneFlag : STA.w ForceSwordUp
    LDA.b #$14 : STA.w SpriteActivity, X
    LDA.b #$04 : STA.w SpriteHitPoints, X
    LDA.b #$80 : STA.w SpriteTimer, X
    PHX
      LDX.b #$00
      LDA.w $04F0 : BEQ +
          INX
      + LDA.w $04F0+1 : BEQ +
          INX
      + TXA : CMP.w $04C5 : BEQ +
          LDA.b #$40 : STA.w $04F0+1 ; puts out glitched torch
    + PLX
    LDA.b #$FF : STA.w SpriteGFXControl, X
    LDA.w SpriteDeflection, X : ORA.b #$80 : STA.w SpriteDeflection, X
    STZ.w SpriteTimerB, X
.exit
    RTL

RoomTag_GanonDoor_victory:
    STA.b $11 : STZ.b $B0 ; what we wrote over
    LDA.b #$13 : STA.w MusicControlRequest
    RTL

Sprite_Ganon_skip_damage_return:
    RTL
Sprite_Ganon_skip_damage:
    STZ.w SpriteAncillaInteract, X : LDA.w SpriteActivity, X ; what we wrote over
    CMP.b #$14 : BCC .return
    TAY
    PLA : PLA : PEA.w $8FAD-1 ; some RTS in bank 1D
    TYA
    SEC : SBC.b #$14
    JSL JumpTableLocal
    dw Ganon_Phase5_WaitForFanfare  ; 0x14
    dw Ganon_Phase5_SpawnBats       ; 0x15
    dw Ganon_Phase5_RelightTorches  ; 0x16
    dw Ganon_Phase5_TargetLink      ; 0x17
    dw Ganon_Phase5_Jump            ; 0x18
    dw Ganon_Phase5_Hover           ; 0x19
    dw Ganon_Phase5_PrepSlam        ; 0x1A
    dw Ganon_Phase5_Stunned         ; 0x1B

Ganon_Phase5_WaitForFanfare:
    LDA.w SpriteTimer, X : BNE .exit
    LDA.b #$A0 : STA.w SpriteTimer, X
    LDA.w SpriteHitPoints, X : DEC : STA.w SpriteHitPoints, X : BNE .exit
        INC.w SpriteActivity, X
        LDA.b #$12 : STA.w SFX1
        LDA.b #$FF : STA.w SpriteTimer, X
        LDA.b #$02 : STA.w SpriteHitPoints, X
        STZ.w SpriteMoveDirection, X
.exit
    RTL

Ganon_Phase5_SpawnBats_advance:
    INC.w SpriteActivity, X
    LDA.b #$10 : STA.w SpriteTimer, X
    LDA.b #$02 : STA.w SpriteHitPoints, X
    STZ.w SpriteLayer, X
Ganon_Phase5_SpawnBats_exit:
    RTL
Ganon_Phase5_SpawnBats:
    LDA.w SpriteTimer, X : BNE .exit
    LDA.w SpriteHitPoints, X : BEQ .advance
        LDA.b #$20 : STA.w SpriteTimer, X
        STZ.w CutsceneFlag : STZ.w ForceSwordUp
        %JSRLongCall_Bank1D(Ganon_SpawnFireBat_trailing, +) : +
        LDA.b LinkPosX : STA.l $7EC10A
        LDA.b LinkPosY : STA.l $7EC108
        LDA.b #$B8 : STA.b LinkPosY
        LDA.b #$20 : STA.w SpritePosYLow, Y
        LDA.w SpriteHitPoints, X : DEC : STA.w SpriteHitPoints, X
        AND.b #$01 : BEQ +
            ; bat 1
            LDA.b #$28 : STA.w SpritePosXLow, Y
            LDA.b #$C8 : STA.b LinkPosX
            BRA .bat_move
        + ; bat 2
        LDA.b #$C8 : STA.w SpritePosXLow, Y
        LDA.b #$28 : STA.b LinkPosX
.bat_move
    PHX : TYX
    LDA.b #$20 : JSL Sprite_ApplySpeedTowardsPlayerLong
    PLX
    LDA.l $7EC10A : STA.b LinkPosX
    LDA.l $7EC108 : STA.b LinkPosY
    RTL

Ganon_Phase5_RelightTorches_advance:
    INC.w SpriteActivity, X
    LDA.b #$FF : STA.w SpriteHitPoints, X
    LDA.b #$1F : STA.w MusicControlRequest
    STZ.w SpriteAuxC, X
    STZ.w SpriteTimerB, X
    LDA.b #$20 : STA.w SpriteTimer, X
    LDA.b #$01 : STA.w SpriteOAMProp, X
    LDA.b #$D6 : STA.w SpriteTypeTable, X
Ganon_Phase5_RelightTorches_exit:
    RTL
Ganon_Phase5_RelightTorches:
    LDA.w SpriteTimer, X : BNE .exit
    LDA.w SpriteHitPoints, X : BEQ .advance
        LDA.w SpriteHitPoints, X : DEC : STA.w SpriteHitPoints, X
        AND.b #$01 : CLC : BEQ + : SEC : +
        LDA.b #$C0 : BCC + : INC : + : STA.w $0333
        PHP : PHX
            JSL LightTorch
        PLX : PLP
        LDA.w $04C5 : INC : STA.w SpriteScreenOwner, X
        LDY.b #$00 : TYA : BCC + : INY : + : STA.w $04F0, Y
        LDA.b #$20 : STA.w SpriteTimer, X
    RTL

Ganon_Phase5_HandleShake:
    STZ.w BG1ShakeH : STZ.w BG1ShakeH+1
    LDA.w SpriteTimerD, X : BEQ +
        AND.b #$01 : TAY
        LDA.w $9D8000, Y : STA.w BG1ShakeH
        LDA.w $9D8002, Y : STA.w BG1ShakeH+1
    +
    RTS

Ganon_Phase5_CheckDamage:
    LDA.w SpriteHitPoints, X : CMP.b #$FF : BEQ .exit
        LDA.b #$FF : STA.w SpriteHitPoints, X
        LDA.w SpriteAuxC, X : INC : CMP.b #$03 : BCS Ganon_Phase5_TargetLink_stun
            STA.w SpriteAuxC, X
            LDA.b #$10 : STA.w SpriteTimerE, X
            CMP.w SpriteTimer, X : BCS .exit
                STA.w SpriteTimer, X
.exit
    RTL

Ganon_Phase5_TargetLink_stun:
    LDA.b #$1B : STA.w SpriteActivity, X
    LDA.b #$FF : STA.w SpriteTimer, X
    STZ.w SpriteAuxC, X : STZ.w SpriteMovement, X
    STZ.w SpriteVelocityZ, X : STZ.w SpriteVelocityX, X : STZ.w SpriteVelocityY, X
Ganon_Phase5_TargetLink_exit:
    RTL
Ganon_Phase5_TargetLink:
    JSR Ganon_Phase5_HandleShake
    JSL Ganon_Phase5_CheckDamage
    %JSRLongCall_Bank1D(MoveSpriteZ_bank1D, +) : +
    LDA.w SpriteZCoord, X : BPL +
        LDA.b #$00 : STA.w SpriteZCoord, X
    +
    CMP.b #$10 : BCC +
        INC.w SpriteAncillaInteract, X
    +
    ORA.w SpriteTimer, X : BNE .exit
        LDA.b #$20 : STA.w SpriteVelocityZ, X
        JSL Sprite_ApplySpeedTowardsPlayerLong
        INC.w SpriteActivity, X
        LDA.w SpriteMovement, X : INC : STA.w SpriteMovement, X
        CMP.b #$05 : BCC +
            STZ.w SpriteAuxC, X : STZ.w SpriteMovement, X
            LDA.b #$6E : STA.w TextID
            LDA.b #$01 : STA.w TextID+1
            JSL Sprite_ShowMessageMinimal
        +
        LDA.b LinkPosX : STA.w SpriteAuxTable, X
        LDA.b LinkPosX+1 : STA.w SpriteAuxTableB, X
        LDA.b LinkPosY : STA.w SpriteAuxB, X
        LDA.b #$20 : JSL Sound_SetSfx2PanLong
    RTL

Ganon_Phase5_Jump_exit:
    RTL
Ganon_Phase5_Jump:
    JSL Ganon_Phase5_CheckDamage
    LDA.w SpriteTimerE, X : BNE .exit
        LDA.b LinkPosY+1 : STA.w SpriteDirectionTable, X
        LDA.w SpriteSpawnStep, X : PHA : STZ.w SpriteSpawnStep, X
            %JSRLongCall_Bank1D($9DEFE0, +) : + ; RedArmosCrusher_Jump
        PLA : XBA : LDA.w SpriteSpawnStep, X : PHP
            XBA : STA.w SpriteSpawnStep, X
        PLP : BEQ +
        LDA.w SpriteZCoord, X : CMP.b #$20 : BCC +
            INC.w SpriteActivity, X
        +
        %JSRLongCall_Bank1D(MoveSpriteXYZ_bank1D, +) : +
        LDA.w SpriteZCoord, X : CMP.b #$40 : BCC +
            LDA.b #$40 : STA.w SpriteZCoord, X
            STZ.w SpriteVelocityZ, X
        +
        STZ.w SpriteDirectionTable, X
        LDA.b #$06 : STA.w SpriteGFXControl, X
        INC.w SpriteAncillaInteract, X
    RTL

RedArmosCrusher_Jump_adjust_proximity:
    PHA
        LDA.b RoomIndex : BNE .vanilla
            ; makes Ganon go closer to target
            PLA : ADC.w #$0004 : CMP.w #$0008
        RTL
.vanilla
    PLA
    ADC.w #$0010 : CMP.w #$0020 ; what we wrote over
    RTL

Ganon_Phase5_Hover:
    STZ.w SpriteVelocityZ, X
    STZ.w SpriteVelocityY, X
    STZ.w SpriteVelocityX, X
    INC.w SpriteAncillaInteract, X
    %JSRLongCall_Bank1D(MoveSpriteXYZ_bank1D, +) : +
    LDA.w SpriteTimer, X : BNE .exit
        INC.w SpriteActivity, X
.exit
    RTL

Ganon_Phase5_PrepSlam:
    LDA.b #$98 : STA.w SpriteVelocityZ, X
    LDA.b #$07 : STA.w SpriteGFXControl, X
    INC.w SpriteAncillaInteract, X
    %JSRLongCall_Bank1D(MoveSpriteZ_bank1D, +) : +
    LDA.w SpriteZCoord, X : BMI .exit
        LDA.b #$0C : JSL Sound_SetSfx2PanLong
        LDA.b #$20 : STA.w SpriteTimerD, X
#Ganon_Phase5_Reset:
        LDA.b #$20 : STA.w SpriteTimer, X
        LDA.b #$17 : STA.w SpriteActivity, X
        LDA.w SpriteOAMProperties, X : AND.b #$7F : STA.w SpriteOAMProperties, X
.exit
    RTL

Ganon_Phase5_Stunned:
    LDA.w SpriteOAMProperties, X : ORA.b #$80 : STA.w SpriteOAMProperties, X
    LDA.b #$02 : STA.w SpriteTileDeath, X
    LDA.b #$01 : STA.w SpriteDirectionTable, X
    %JSRLongCall_Bank1D(MoveSpriteXYZ_bank1D, +) : +
    LDA.w SpriteVelocityZ, X : ORA.w SpriteVelocityX, X : ORA.w SpriteVelocityY, X : BEQ .skip_throw
        LDA.b #$02 : STA.w SpriteTimer, X
        JSL Sprite_CheckTileCollisionLong
        LDA.w $0FA5 : CMP.b #$20 : BNE +
            STZ.w SpriteTileCollision, X
        +
        JSL ThrownSprite_TileAndSpriteInteraction_long
.skip_throw
    LDA.w SpriteTimer, X : BNE .exit
        LDA.b #$01 : STA.w SpriteOAMProp, X
        LDA.b #$07 : STA.w SpriteGFXControl, X
        BRA Ganon_Phase5_Reset
.exit
    JSL Sprite_CheckIfLifted_permissive_long
    LDA.b #$05 : STA.w SpriteOAMProp, X
    RTL

Ganon_MaybeEnableVulnerabilty:
    LDA.w SpriteActivity, X : CMP.b #$1B : BEQ .skip
        LDA.b #$40 : STA.w SpriteTimerB, X ; what we wrote over
.exit
    RTL
.skip
    ; change Ganon GFX based on Link direction if carried
    LDA.w SpriteAITable, X : CMP.b #$0A : BNE .exit
    PHB : PHK : PLB
        LDA.b LinkDirection : LSR : TAY
        LDA.w .stun_gfx, Y : STA.w SpriteGFXControl, X
    PLB
    RTL
.stun_gfx
db $0A, $05, $0F, $05

; ----- BEGIN AERINON SECTION -----
pushpc
; hooks
org $819907
  NOP #2
  JSL HideChestForNewTags

org $819925
  NOP #2
  JSL HideChestForNewTags

org $81BCC4
  NOP #2 : JSL PreventCollisionForNewTags

org $81BCE2
  NOP #2 : JSL PreventCollisionForNewTags

org $81BE07
  Underworld_SetChestAttributes_ToNext:

 org $81BDE0
    JSL CheckSkipChestCollision
    BCS Underworld_SetChestAttributes_ToNext
    NOP

org $81C307
  JSL HandleNewTags1
  BCS Underworld_HandleRoomTags_AfterTag1

org $81C312
  JSL HandleNewTags2
  BCS Underworld_HandleRoomTags_AfterTag2

org $818786
  NOP : JSL ClearNewTagMem

org $868859
  NOP : JSL SpritePrep_SwitchExtended

org $85D908
  NOP : JSL PullSwitch_GoodSound

org $81C893
  JSL OperateChestRevealModForPullSwitchTag

org $8794AB
  JSL ExtendRoomsWithPitDamage

; NOTE: this overrides the chest encryption function - won't work with IsEncrypted flag
org $81EBEB
  NOP : JML GetChestDataExtended

org $81D961
  NOP #2
  JSL PushBlock_TileTypeMod

org $81D7D0  ; PushBlock_Main floor tile restoration
  JSL PushBlock_FloorTileCheck
  NOP #2

org $82D894  ; After vanilla SRAM pushblock init
  JSL InitExtendedPushBlocks
  NOP

org $81889A  ; After vanilla room loading loop
  JSL LoadExtendedPushBlocks
  NOP

org $87A0B8  ; see LinkItem_Boomerang, bank07
  JSL SecretBoomerang
  BCS LinkItem_Boomerang_exit ; only if boomerang is already out
  NOP

org $878102
  JSL HandleBlinkTimer

org $87A470
  JSL SecretBook

org $85AF7F
db $80

org $86ECC5
  JSL SliverBoomDamageUpgrade

; Push block overrides:

org $84EED2 ; Room CA Push blocks (unused)
dw $0120, $09E0 ; for good bee room
dw $00D5, $1AE0 ; for map room

pullpc

Limited_InitializeSnitchStatueTileset:
    LDA.b IndoorsFlag : BEQ .exit
    LDA.b RoomIndex+1 : BEQ .exit
    LDA.b RoomIndex : DEC : BNE .exit ; check if snitch house
        LDA.b #$52 : STA.l LastSpriteSet+3 : STA.b Scrap06 ; statue gfx
.exit
    RTL

;--------------------------------------------------------------------------------
;  New Tag Code
;--------------------------------------------------------------------------------

; Check the new tags that have chests hidden
HideChestForNewTags:
  STA.b Scrap00
  CMP.w #$0040 : BEQ .exit ; new tag - 40, if equal then hide chest
  ; didn't need to add one for 42 because room already qualified
  ; chests for tag 43 only hides one chest. - How to do that?
  CMP.w #$0043 : BNE .continue ; next tag
  LDA.w $0496
  CMP.w #$000A : BNE .continue ; only hide if chest index 4 (new chest 5)
  LDX.w #$0008 ; need to set X to check for this particular chest
  TDC : RTL ; set zero flag and leave
.continue
  LDA.b Scrap00
  CMP.w #$0044 : BEQ .exit ; new tag - 44, if equal then hide chest
  CMP.w #$0045 : BEQ .exit ; new tag - 45, if equal then hide chest
  CMP.w #$0046 : BEQ .exit ; new tag - 46, if equal then hide chest
  CMP.w #$0047 : BEQ .exit ; new tag - 47, if equal then hide chest
  AND.w #$00FF
  CMP.w #$0027
.exit
  RTL ; if zero flag set, the chest will be hidden, otherwise not

PreventCollisionForNewTags:
  AND.w #$00FF
  CMP.w #$0027 : BEQ .exit
  CMP.w #$0040 : BEQ .exit ; don't check for $43 here as this check isn't chest specific
  CMP.w #$0042 : BEQ .exit ; pull switch room - puzzle chest collision hidden until switches pulled
  CMP.w #$0044 : BEQ .exit
  CMP.w #$0045 : BEQ .exit
  CMP.w #$0046 : BEQ .exit
  CMP.w #$0047
.exit
  RTL ; if zero flag set, collision will be prevented, otherwise not

CheckSkipChestCollision:
  AND.w #$7FFF : LSR : TAX ; What we wrote over

  ; Check if this is chest 5 (Y=$0008) AND tag $43 is active
  CPY.w #$0008 : BNE .write_collision

  PHA
  LDA.b RoomTag : AND.w #$00FF
  CMP.w #$0043
  BNE .not_tag43   ; Branch before PLA!
  ; Tag $43 active, skip writing collision
  PLA              ; Clean up stack
  SEC              ; Set carry = skip
  RTL

.not_tag43
  PLA              ; Restore A
.write_collision
  LDA.b Scrap00        ; Original instruction (load collision value)
  CLC              ; Clear carry = write collision
  RTL

HandleNewTags1:
  STZ.b Scrap0E
  LDA.b RoomTag
  ASL A
  TAX
  CMP.b #$80
  BCC .done
  JSR HandleNewTag
  SEC
.done
  RTL

HandleNewTags2:
  STA.b Scrap0E
  LDA.b $AF
  ASL A
  TAX
  CMP.b #$80
  BCC .done
  JSR HandleNewTag
  SEC
.done
  RTL

NewTagPool:
 dw HandleTunicTag ; $40 (index 0), tunic code
 dw HandleQuantumChestTag ; $41 (index 1), quantum chest code
 dw HandlePullSwitchChestTag ; $42 (index 2), pull switch chest code
 dw HandleMapRoomTag ; $43 (index 3), map room code
 dw HandleTilePuzzleTag ; $44 (index 4), tile stepping puzzle code
 dw HandleSokobanTag ; $45 (index 5), sokoban puzzle code
 dw HandlePortalRoomTag ; $46 (index 6), portal room code
 dw HandleFinalPuzzleTag ; $47 (index 7), final puzzle code

HandleNewTag:
  AND.b #$7F : TAX
  JSR (NewTagPool, X)
  RTS

ClearNewTagMem:
  STZ.b $FC  ; hook code
  STZ.w $045C
  STZ.w !NewTagIndex
  STZ.w !NewTagTimer
  STZ.w !NewTagFlag
  STZ.w !BookPortalActive
  RTL

;--------------------------------------------------------------------------------
;  Tunic Tag Code
;--------------------------------------------------------------------------------

PatternTarget:
  db $04, $01, $08, $01, $01, $04, $02 ; d,r,u,r,r,d,l (forward, udlr encoding)
PatternTargetReverse:
  db $01, $08, $02, $02, $04, $02, $08 ; r,u,l,l,d,l,u (reverse)

HandleTunicTag:
  LDA.w !NewTagIndex
  AND.b #$7F             ; strip direction bit for completion check
  CMP.b #$07
  BNE .continue
  RTS
.continue
  LDA.w !NewTagTimer
  BEQ .reset_pattern
  DEC.w !NewTagTimer

  LDA.b LinkQuadrantV    ; only count d-pad inputs in the top half of the room
  BNE .exit

  LDA.b Joy1A_New
  AND.b #$0F
  BEQ .release_input
  LDX.w !NewTagFlag
  BNE .exit

  LDX.w !NewTagIndex
  BNE .not_step0

  ; Step 0: direction not yet determined; try forward then reverse
  TAY                                ; save buttons (AND will destroy A)
  AND.l PatternTarget, X             ; check forward: PatternTarget[0]
  BNE .step0_forward
  TYA                                ; restore buttons
  AND.l PatternTargetReverse, X     ; check reverse: PatternTargetReverse[0]
  BEQ .reset_pattern
  LDA.w !NewTagIndex : ORA.b #$80 : STA.w !NewTagIndex  ; tag as reverse
.step0_forward
  LDX.w !NewTagIndex
  BRA .check_complete

.not_step0
  BMI .do_reverse
  AND.l PatternTarget, X             ; forward: X = step (no direction bit)
  BEQ .reset_pattern
  BRA .check_complete

.do_reverse
  ; X = $80|step; preserve buttons in Y while computing index
  TAY                                ; save buttons
  TXA : AND.b #$7F : TAX             ; X = step (strip direction bit)
  TYA                                ; restore buttons
  AND.l PatternTargetReverse, X     ; check match
  LDX.w !NewTagIndex                 ; restore X = $80|step
  BEQ .reset_pattern

.check_complete
  INX
  TXA : AND.b #$7F : CMP.b #$07     ; test step (masked) for completion
  BEQ .pattern_complete
  INC.w !NewTagFlag
  LDX.b #$B4
  STX.w !NewTagTimer
  RTS

.pattern_complete
  STX.w !NewTagIndex                 ; stores $07 (forward) or $87 (reverse)
  PHK : PEA.w .jslrtsreturn-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML RoomTag_OperateChestReveal ; _01C7D8
.jslrtsreturn
  RTS

.release_input
  LDA.w !NewTagFlag
  BEQ .exit
  LDA.w !NewTagIndex
  INC                                ; preserves direction bit ($80+N stays $80+N+1)
  STA.w !NewTagIndex
  STZ.w !NewTagFlag
  RTS

.reset_pattern
  STZ.w !NewTagIndex                 ; clears direction bit automatically
  LDA.b #$B4
  STA.w !NewTagTimer
  STZ.w !NewTagFlag
.exit
  RTS

;--------------------------------------------------------------------------------
;  Quantum Chest Tag Code
;--------------------------------------------------------------------------------

; needed data for quantum chest tag, the 3 location that the chest could be at
; These are pixel locations. Tile locations would be divided by 8.
ChestXPositions:
  dw $0030, $0058, $0098  ; x positions (6*8, 11*8, 19*8)

ChestYPositions:
  dw $00D8, $0040, $01B8  ; y positions (27*8, 8*8, 55*8)

HandleQuantumChestTag:
  LDA.b LinkQuadrantH
  BEQ .continue ; only runs if on left side of room
.early_exit
  RTS
.continue
  LDA.l RoomDataWRAM[$6A].low : AND.b #$40 : BNE .early_exit

  LDA.w !NewTagFlag
  CMP.b #$02 : BNE .not_revealing_new_chest

  REP #$30
  LDA.w #$0004 : STA.w SubModuleInterface
  LDA.w #$5A5A : STA.b Scrap0C
;  STZ.w $1000
  LDA.w #$0006 : STA.w $0496
  ; need to set X appropriately
  PHK : PEA.w .jslrtsreturn-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML $81C7EB ; _01C7DE - RoomTag_OperateChestReveal_DontClearTag
.jslrtsreturn
  STZ.w !NewTagFlag ; all done
  RTS

.not_revealing_new_chest
  JSL Underworld_ExtinguishTorch
  ; determine if chest is in sight line using AABB collision
  JSR CalculateTrapezoidBounds
  LDA.w !NewTagIndex ; which position the chest is at
  ASL : TAX  ; position tables are words
  JSR CheckNearRectangle
  BCS .collision
  JSR CheckFarRectangle
  BCS .collision
.no_collision
  ; was it last seen?
  SEP #$20
  LDA.w !NewTagFlag
  BEQ .exit ; no change
  JSR MoveChestToNewPosition
  INC.w !NewTagFlag ; next step, show new chest
  RTS
.collision
  SEP #$20
  LDA.w !NewTagFlag
  BNE .exit ; already marked as seen
  INC.w !NewTagFlag ; mark as seen
.exit
  RTS

MoveChestToNewPosition:
  ; move cheset to new location
  ; Pick new "random" position (cycle through positions)
  LDX.w !NewTagIndex
  INX
  LDA.b FrameCounter : LSR : BCC .noSkip
  INX
.noSkip
  CPX.b #$03 : BCC .storeNewIndex
  TXA : SBC.b #$03 : TAX
.storeNewIndex
  STX.w !NewTagIndex

  ; Clear old chest tiles (graphics and collision)
  LDY.b #$04 ; hardcoded chest number (2nd chest - index 4)
  REP #$30
  LDA.w $06E0, Y ; get old tilemap offset
  TAX
  LDA.w #$1CC6 ; Carpet tile
  STA.l TileMapA, X ; clear top-left
  STA.l TileMapA+2, X ; clear top-right
  STA.l TileMapA+$80, X ; clear bottom-left
  STA.l TileMapA+$82, X ; clear bottom-right
  STA.b Scrap02 : STA.b Scrap04 : STA.b Scrap06 : STA.b Scrap08

  TXA : LSR : TAX ; divided by two since collision map is byte per tile
  LDA.w #$0000 ; empty collision
  STA.l $7F2000, X
  STA.l $7F2040, X

  STZ.w GFXStripes
  STZ.w SubModuleInterface
  LDA.w #$0002
  STA.w $0496
  PHK : PEA.w .jslrtsreturn-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML $81C837 ; _01C837 - RoomTag_OperateChestReveal_BuildNMIStripes ; doesn't alter y, depends on it
.jslrtsreturn
  REP #$30
  ; Calculate new tilemap offset from X/Y positions
  LDA.w !NewTagIndex : AND.w #$00FF : ASL : TAX
  LDA.l ChestYPositions, X
  ASL #3 ; multiply Y by 8 (account for width of tilemap)
  STA.b Scrap00
  LDA.l ChestXPositions, X
  LSR #3 ; divide X by 8 (convert to tile offset)
  CLC : ADC.b Scrap00
  ASL A ; word offset
  STA.w $06E0, Y ; store new position

  SEP #$30
  RTS

CONE_FORWARD = $44        ; 68 pixels forward
CONE_BACK = $20           ; 32 pixels backward
CONE_NEAR_WIDTH = $46     ; 70 pixels wide at near
CONE_FAR_WIDTH = $5E      ; 94 pixels wide at far
CONE_NEAR_RANGE = $10     ; 16 pixels ahead (near portion)

; Near rectangle bounds
ConeNearLeft  = $00
ConeNearRight = $02
ConeNearTop   = $04
ConeNearBottom = $06

; Far rectangle bounds
ConeFarLeft   = $08
ConeFarRight  = $0A
ConeFarTop    = $0C
ConeFarBottom = $0E

DirectionRoutine:
dw TrapezoidUp
dw TrapezoidDown
dw TrapezoidLeft
dw TrapezoidRight


CalculateTrapezoidBounds:
    LDA.b LinkDirection : TAX
    REP #$20
    JMP (DirectionRoutine, X)

TrapezoidRight:
    ; Near rectangle: behind Link to near range
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #CONE_BACK
    STA.b ConeNearLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #CONE_NEAR_RANGE
    STA.b ConeNearRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearBottom

    ; Far rectangle: near range to full forward
    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #CONE_NEAR_RANGE
    STA.b ConeFarLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #CONE_FORWARD
    STA.b ConeFarRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarBottom
    RTS

TrapezoidLeft:
    ; Near rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #CONE_NEAR_RANGE
    STA.b ConeNearLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #CONE_BACK
    STA.b ConeNearRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearBottom

    ; Far rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #CONE_FORWARD
    STA.b ConeFarLeft

    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #CONE_NEAR_RANGE
    STA.b ConeFarRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarBottom
    RTS

TrapezoidUp:
    ; Near rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #CONE_NEAR_RANGE
    STA.b ConeNearTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #CONE_BACK
    STA.b ConeNearBottom

    ; Far rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #CONE_FORWARD
    STA.b ConeFarTop

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #CONE_NEAR_RANGE
    STA.b ConeFarBottom
    RTS

TrapezoidDown:
    ; Near rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #(CONE_NEAR_WIDTH/2)
    STA.b ConeNearRight

    LDA.b LinkPosY : AND.w #$01FF
    SEC : SBC.w #CONE_BACK
    STA.b ConeNearTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #CONE_NEAR_RANGE
    STA.b ConeNearBottom

    ; Far rectangle
    LDA.b LinkPosX : AND.w #$01FF
    SEC : SBC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarLeft

    LDA.b LinkPosX : AND.w #$01FF
    CLC : ADC.w #(CONE_FAR_WIDTH/2)
    STA.b ConeFarRight

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #CONE_NEAR_RANGE
    STA.b ConeFarTop

    LDA.b LinkPosY : AND.w #$01FF
    CLC : ADC.w #CONE_FORWARD
    STA.b ConeFarBottom
    RTS


CheckNearRectangle:
    ; AABB: if (rect1.right > rect2.left AND rect1.left < rect2.right
    ;       AND rect1.bottom > rect2.top AND rect1.top < rect2.bottom)

    ; Check: chest.left < cone.right
    LDA.l ChestXPositions, X    ; chest.left
    CMP.b ConeNearRight
    BCS .no_hit                 ; if chest.left >= cone.right, no collision

    ; Check: chest.right > cone.left
    CLC : ADC.w #$0008   ; chest.right = chest.left + 8
    CMP.b ConeNearLeft
    BCC .no_hit                 ; if chest.right <= cone.left, no collision

    ; Check: chest.top < cone.bottom
    LDA.l ChestYPositions, X    ; chest.top
    CMP.b ConeNearBottom
    BCS .no_hit

    ; Check: chest.bottom > cone.top
    CLC : ADC.w #$0008              ; chest.bottom = chest.top + 8
    CMP.b ConeNearTop
    BCC .no_hit

    SEC                         ; Collision!
    RTS

.no_hit:
    CLC : RTS

CheckFarRectangle:
    ; AABB: if (rect1.right > rect2.left AND rect1.left < rect2.right
    ;       AND rect1.bottom > rect2.top AND rect1.top < rect2.bottom)

    ; Check: chest.left < cone.right
    LDA.l ChestXPositions, X    ; chest.left
    CMP.b ConeFarRight
    BCS .no_hit                 ; if chest.left >= cone.right, no collision

    ; Check: chest.right > cone.left
    CLC : ADC.w #$0008              ; chest.right = chest.left + 8
    CMP.b ConeFarLeft
    BCC .no_hit                 ; if chest.right <= cone.left, no collision

    ; Check: chest.top < cone.bottom
    LDA.l ChestYPositions, X    ; chest.top
    CMP.b ConeFarBottom
    BCS .no_hit

    ; Check: chest.bottom > cone.top
    CLC : ADC.w #$0008              ; chest.bottom = chest.top + 8
    CMP.b ConeFarTop
    BCC .no_hit

    SEC                         ; Collision!
    RTS

.no_hit:
    CLC : RTS


;--------------------------------------------------------------------------------
;  Pull Switch Tag Code
;--------------------------------------------------------------------------------

SpritePrep_SwitchExtended:
  LDA.w RoomIndexMirror
  CMP.b #$CE
  BEQ .done
  CMP.b #$5F
.done
  RTL

SwitchOrder:
;db $07, $03, $05, $04, $02, $01, $06 ; order to pull switches in
db $09, $05, $07, $06, $04, $03, $08 ; sprite index of switches

PullSwitch_GoodSound:
  LDA.b RoomIndex : CMP.b #$5F : BNE .normal
  STX.b Scrap00
  LDX.w !NewTagIndex : LDA.l SwitchOrder, X
  CMP.b Scrap00 : BNE .noMatch
  INC.w !NewTagIndex
  BRA .exit
.noMatch
  STZ.w !NewTagIndex
  BRA .exit
.normal
  LDA.b #$1B ; good switch sound
  STA.w SFX3
.exit
  RTL


HandlePullSwitchChestTag:
  LDA.w !NewTagIndex : CMP.b #$07 : BCC .exit
  ; operate chest reveal
  STZ.b $AF ; clear tag
  REP #$30
  STZ.w GFXStripes
  LDA.w #$0002 : STA.w SubModuleInterface ; start at chest 2
  LDA.w #$5959 : STA.b Scrap0C ; chest 2
  LDA.w #$0004 : STA.w $0496 ; 2 chest in room
  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML $81C7EB ; _01C7DE - RoomTag_OperateChestReveal_DontClearTag
.exit
  RTS

OperateChestRevealModForPullSwitchTag:
  INC : STA.w SubModuleInterface
  LDA.b $AF : CMP.w #$0042 : BNE .normal
  LDA.w SubModuleInterface : INC #2 : STA.w SubModuleInterface ; skips a chest
.normal
  LDA.w SubModuleInterface
  RTL

;--------------------------------------------------------------------------------
;  Map Room Tag Code
;--------------------------------------------------------------------------------

; Memory locations you'll need:
; Link: $20/$21 (Y), $22/$23 (X)
; Ancillas: $029E,X (type), $2A,X/$2B,X (Y), $2C,X/$2D,X (X) - 10 slots (0-9)
; Push blocks: $0292-$02A1 (16 blocks), positions in room data
; Sprites: $0E20,X (type), $0D00,X (Y low), $0D20,X (Y high), $0D10,X (X low), $0D30,X (X high)

HandleMapRoomTag:
  LDA.b LinkQuadrantH : BEQ .exit ; only right side of room
  ; Check Link's position first (cheapest check)
  LDA.b LinkPosY : CMP.b #$7C : BCC .exit
  CMP.b #$8C : BCS .exit
  LDA.b LinkPosX : CMP.b #$48 : BCC .exit
  CMP.b #$58 : BCS .exit

  ; Check for somaria block (ancilla type $0C)
  JSR CheckSomariaBlock
  BCC .exit

  ; Check for push block in position
  JSR CheckPushBlock
  BCC .exit

  ; Check for statue (sprite type $??)
  JSR CheckStatue
  BCC .exit

  ; Check for chicken (sprite type $D5)
  JSR CheckChicken
  BCC .exit

  ; All conditions met - reveal chest
  STZ.b RoomTag ; clear tag (or $AF depending on which tag slot)
  REP #$30
  STZ.w GFXStripes
  LDA.w #$0008 : STA.w SubModuleInterface ; chest index * 2, 5th chest
  LDA.w #$5C5C : STA.b Scrap0C ; chest data, 5th chest (58, 0th chest etc)
  LDA.w #$000A : STA.w $0496 ; number of chests * 2
  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML $81C7EB ; _01C7DE - RoomTag_OperateChestReveal_DontClearTag
.exit
  RTS

CheckSomariaBlock:
  LDX.b #$09 ; 10 ancilla slots (0-9)
.loop
  LDA.w AncillaID, X : CMP.b #$2C : BEQ .found ; $2C = somaria block
  DEX : BPL .loop
  CLC : RTS ; not found
.found
  ; Check position
  LDA.w AncillaCoordYLow, X : CMP.b #$50 : BCC .fail
  CMP.b #$60 : BCS .fail
  LDA.w AncillaCoordXLow, X : CMP.b #$98 : BCC .fail
  CMP.b #$A8 : BCS .fail
  SEC : RTS ; found and in position
.fail
  CLC : RTS

CheckPushBlock:
  ; Assume push block is the only manipulable block in the room
  LDY.b #$00

  ; Get tilemap offset from $0540,Y
  LDA.w ManipTileMapX, Y ; load tilemap offset (low byte) x or y?
  CMP.b #$EC : BNE .fail ; check bounds

  LDA.w ManipTileMapX+1, Y ; load tilemap offset (high byte) x or y?
  CMP.b #$1A : BNE .fail ; check bounds
  SEC : RTS

.fail
  SEP #$20
  CLC : RTS

CheckStatue:
  LDX.b #$06
  LDA.w SpritePosYLow, X : CMP.b #$6C : BCC .fail
  CMP.b #$7C : BCS .fail
  LDA.w SpritePosXLow, X : CMP.b #$3C : BCC .fail
  CMP.b #$4C : BCS .fail
  SEC : RTS
.fail
  CLC : RTS

CheckChicken:
  LDX.b #$05
  LDA.w SpritePosYLow, X : CMP.b #$70 : BCC .fail
  CMP.b #$80 : BCS .fail
  LDA.w SpritePosXLow, X : CMP.b #$70 : BCC .fail
  CMP.b #$80 : BCS .fail
  SEC : RTS
.fail
  CLC : RTS

;--------------------------------------------------------------------------------
;  Tile Puzzle Tag Code
;--------------------------------------------------------------------------------

; Constants
CARPET_TILE = $1CC6 ; Carpet tile ID

; Green floor tile IDs (hardcoded in IsFloorTile)
; $18DB = top-left of 16x16, $18DA = top-right of 16x16

; Tiles that SHOULD be carpet when puzzle is solved
; Format: X coordinate, Y coordinate (both 8-bit, in 16x16 tile coords)
ShouldBeCarpetTiles:
; $12, $18 is ambiguous, can be floor or carpet depending on pattern
; $12, $17 is also ambiguous, but likely can't be avoided
  db $12, $17, $12, $16, $13, $16
  db $14, $16, $14, $15, $14, $14, $15, $14
  db $16, $14, $16, $15, $16, $16, $17, $16
  db $18, $16, $18, $17, $18, $18, $18, $19
  db $18, $1A, $17, $1A, $16, $1A, $15, $1A
  db $14, $1A, $14, $1B, $14, $1C, $15, $1C
  db $16, $1C, $17, $1C, $18, $1C, $19, $1C
  db $1A, $1C, $1A, $1B, $1A, $1A, $1A, $19
  db $1A, $18, $1A, $17, $1A, $16, $1B, $16
  db $1C, $16, $1C, $15, $1C, $14
SHOULD_BE_CARPET_COUNT = $26

; Tiles that SHOULD be floor when puzzle is solved
; Format: X coordinate, Y coordinate (both 8-bit, in 16x16 tile coords)
ShouldBeFloorTiles:
  db $12, $14, $13, $14, $17, $14, $18, $14
  db $19, $14, $1A, $14, $1B, $14, $12, $15
  db $18, $15, $1A, $15, $15, $16, $19, $16
  db $14, $17, $16, $17, $1C, $17, $13, $18
  db $14, $18, $15, $18, $16, $18, $17, $18
  db $19, $18, $1B, $18, $1C, $18, $12, $19
  db $14, $19, $16, $19, $1C, $19, $12, $1A
  db $13, $1A, $19, $1A, $1B, $1A, $1C, $1A
  db $12, $1B, $16, $1B, $18, $1B, $1C, $1B
  db $12, $1C, $13, $1C, $1B, $1C, $1C, $1C
SHOULD_BE_FLOOR_COUNT = $28

HandleTilePuzzleTag:

  LDA.b LinkQuadrantH : BEQ .early_exit ; Only activate on right side of room
  LDA.l RoomDataWRAM[$AB].low : AND.b #$10 : BEQ .continue ; Check if we already opened the chest
.early_exit
  RTS

.continue
  ; Get Link's position in tile coordinates (16x16)
  ; Link coordinates are 9-bit (0x000-0x1FF)
  REP #$30  ; 16-bit A and X/Y
  ; Calculate full room 8x8 coordinates for VRAM (0-63)
  ; Add 4 pixels before dividing to shift tile boundaries to ...4 and ...C
  LDA.b LinkPosX : AND.w #$01FF : CLC : ADC.w #$0004 : LSR #3 : STA.b Scrap00  ; X (0-63)
  LDA.b LinkPosY : AND.w #$01FF : CLC : ADC.w #$0004 : LSR #3 : INC : STA.b Scrap02  ; Y (0-63) +4px, +1 for visual

  ; Calculate VRAM tilemap offset: ((Y × 64) + X) × 2
  LDA.b Scrap02 : XBA : LSR #2 : CLC : ADC.b Scrap00 : ASL : STA.b Scrap0E

  ; Ensure coordinates are within 0-63 range for 64-wide tilemap
  LDA.b Scrap00 : AND.w #$003F : STA.b Scrap04  ; X (0-63)
  LDA.b Scrap02 : AND.w #$003F : STA.b Scrap06  ; Y (0-63)

  ; Calculate tilemap offset for 64-wide layout: (Y8 * 128) + (X8 * 2)
  LDA.b Scrap06 : XBA : LSR #2 : CLC : ADC.b Scrap04 : ASL : TAX

  ; Check if it's any valid floor tile (checks TL and TR)
  JSR IsFloorTile
  BCC .not_floor  ; Not a floor tile

  ; Change to carpet
  LDA.w #CARPET_TILE
  STA.l TileMapA, X      ; Top-left
  STA.l TileMapA+2, X    ; Top-right
  STA.l TileMapA+$80, X  ; Bottom-left
  STA.l TileMapA+$82, X  ; Bottom-right
  STA.b Scrap02          ; Save tile value once

  ; Build NMI stripe to update VRAM ($0E already contains VRAM offset)
  JSR BuildTileStripe

.not_floor
  ; Check if pattern is complete
  JSR CheckCompletePattern
  BCC .exit

  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML RoomTag_OperateChestReveal ; _01C7D8

.exit
  SEP #$30
  RTS

; Check if all tiles match the expected pattern
CheckCompletePattern:
  ; First check all tiles that should be carpet
  LDX.w #$0000
.loop_carpet
  CPX.w #SHOULD_BE_CARPET_COUNT*2 : BCS .check_floor

  ; Convert 16x16 tile coords to 8x8 top-left position (X=odd, Y=odd)
  LDA.l ShouldBeCarpetTiles, X : AND.w #$00FF : ASL : INC : STA.b Scrap00  ; X8 = (X16 * 2) + 1 (odd)
  INX
  LDA.l ShouldBeCarpetTiles, X : AND.w #$00FF : ASL : INC : STA.b Scrap02  ; Y8 = (Y16 * 2) + 1 (odd)
  INX
  PHX  ; Save loop counter

  ; Calculate offset for 64-wide layout: (Y8 * 128) + (X8 * 2)
  LDA.b Scrap02 : XBA : LSR #2 : CLC : ADC.b Scrap00 : ASL : TAX

  ; Check if tile is carpet
  LDA.l TileMapA, X
  PLX  ; Restore loop counter before comparison
  CMP.w #CARPET_TILE
  BNE .fail

  BRA .loop_carpet

.check_floor
  ; Now check all tiles that should still be floor
  LDX.w #$0000
.loop_floor
  CPX.w #SHOULD_BE_FLOOR_COUNT*2 : BCS .success

  ; Convert 16x16 tile coords to 8x8 top-left position (X=odd, Y=odd)
  LDA.l ShouldBeFloorTiles, X : AND.w #$00FF : ASL : INC : STA.b Scrap00  ; X8 = (X16 * 2) + 1 (odd)
  INX
  LDA.l ShouldBeFloorTiles, X : AND.w #$00FF : ASL : INC : STA.b Scrap02  ; Y8 = (Y16 * 2) + 1 (odd)
  INX
  PHX  ; Save loop counter

  ; Calculate offset for 64-wide layout: (Y8 * 128) + (X8 * 2)
  LDA.b Scrap02 : XBA : LSR #2 : CLC : ADC.b Scrap00 : ASL : TAX

  ; Check if tile is floor (checks TL and TR)
  JSR IsFloorTile
  PLX  ; Restore loop counter
  BCC .fail  ; Not a floor tile

  BRA .loop_floor

.success
  SEC
  RTS

.fail
  CLC
  RTS

; Check if tiles match a valid floor pattern
; Input: X = tilemap offset to current tile position
; Output: Carry set if valid floor pattern found, clear otherwise
; Preserves: X
; Modifies: A
IsFloorTile:
  ; REP #$20 assumed
  PHX  ; Save X

  ; Check if TL=18DB (left half of green floor)
  LDA.l TileMapA, X
  CMP.w #$18DB
  BEQ .valid

  ; Check if TR=18DA (right half of green floor)
  LDA.l TileMapA+2, X
  CMP.w #$18DA
  BEQ .valid

  ; Neither matches
  PLX
  CLC
  RTS

.valid:
  PLX
  SEC
  RTS

; Build VRAM stripe for a single 16x16 tile
; Input: $0E = tilemap offset (word offset into $7E2000)
;        $02, $04, $06, $08 = tile data for 4 8x8 tiles
BuildTileStripe:
  LDX.w GFXStripes  ; Get current stripe buffer position

  ; Build stripe for top-left 8x8 tile (offset +$0000)
  LDA.b Scrap0E
  JSR TilemapOffsetToVRAM
  STA.w GFXStripes+2, X

  ; Build stripe for top-right 8x8 tile (offset +$0002)
  LDA.b Scrap0E : CLC : ADC.w #$0002
  JSR TilemapOffsetToVRAM
  STA.w GFXStripes+8, X

  ; Build stripe for bottom-left 8x8 tile (offset +$0080)
  LDA.b Scrap0E : CLC : ADC.w #$0080
  JSR TilemapOffsetToVRAM
  STA.w GFXStripes+$E, X

  ; Build stripe for bottom-right 8x8 tile (offset +$0082)
  LDA.b Scrap0E : CLC : ADC.w #$0082
  JSR TilemapOffsetToVRAM
  STA.w GFXStripes+$14, X

  ; Store tile data (reuse same value)
  LDA.b Scrap02
  STA.w GFXStripes+$06, X
  STA.w GFXStripes+$0C, X
  STA.w GFXStripes+$12, X
  STA.w GFXStripes+$18, X

  ; Set stripe size (1 tile = $0100)
  LDA.w #$0100
  STA.w GFXStripes+$04, X
  STA.w GFXStripes+$0A, X
  STA.w GFXStripes+$10, X
  STA.w GFXStripes+$16, X

  ; Terminate stripe list
  LDA.w #$FFFF
  STA.w GFXStripes+$1A, X

  ; Update stripe buffer position
  TXA
  CLC : ADC.w #$001A
  STA.w GFXStripes

  ; Set NMI flag to upload stripes
  SEP #$20
  LDA.b #$01
  STA.b NMISTRIPES
  REP #$20

  RTS

; Convert tilemap offset to VRAM address
; Input: A = tilemap offset
; Output: A = VRAM address (byte-swapped for stripe format)
; Based on RoomTag_BuildChestStripes at $01EF0D
TilemapOffsetToVRAM:
  STA.b Scrap04

  AND.w #$0040
  LSR #4
  XBA
  STA.b Scrap06

  LDA.b Scrap04
  AND.w #$303F
  LSR
  ORA.b Scrap06
  STA.b Scrap06

  LDA.b Scrap04
  AND.w #$0F80
  LSR #2
  ORA.b Scrap06
  XBA

  RTS

;--------------------------------------------------------------------------------
;  Sokoban Tag Code
;--------------------------------------------------------------------------------

; Pressure plate positions in room $0038 (tilemap indices)
PressurePlatePositions:
  dw $0452  ; (X=$29, Y=$08)
  dw $0652  ; (X=$29, Y=$0C)
  dw $0852  ; (X=$29, Y=$10)
  dw $0556  ; (X=$2B, Y=$0A)
  dw $0756  ; (X=$2B, Y=$0E)
  dw $065A  ; (X=$2D, Y=$0C)

!PRESSURE_PLATE_COUNT = 6

HandleSokobanTag:
  ; Check if chest already opened
  SEP #$20

  LDA.l RoomDataWRAM[$38].low : AND.b #$10 : BNE .exit ; Check if chest already opened

  ; Check all 6 pressure plates - each must have a pushblock on it
  REP #$30
  LDX.w #$0000  ; Pressure plate index

.check_plate_loop
  CPX.w #!PRESSURE_PLATE_COUNT*2 : BCS .all_plates_covered

  ; Load pressure plate position
  LDA.l PressurePlatePositions, X
  STA.b Scrap00  ; Store plate position in Scrap00
  PHX            ; Save plate index

  ; Search all pushblocks (slots 0-15) for a match
  LDY.w #$0000
.check_block_loop
  CPY.w #$0020 : BCS .no_block_found  ; 16 blocks * 2 bytes = $20

  ; Load pushblock position and mask off flags
  LDA.w ManipTileMapX, Y
  AND.w #$3FFF

  ; Compare with plate position
  CMP.b Scrap00
  BEQ .block_found

  INY : INY
  BRA .check_block_loop

.no_block_found
  ; This plate doesn't have a block - puzzle incomplete
  PLX
  BRA .exit

.block_found
  ; This plate has a block - continue to next plate
  PLX
  INX : INX
  BRA .check_plate_loop

.all_plates_covered
  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML RoomTag_OperateChestReveal ; _01C7D8

.exit
  SEP #$30
  RTS

;--------------------------------------------------------------------------------
;  Portal Room Tag Code
;--------------------------------------------------------------------------------

HandlePortalRoomTag:
  LDA.b NMISTRIPES
  BNE .exit

  LDA.w $0B2E       ; FallingBridge tile counter (overlord slot 1, counts backward)
  CMP.b #$2A
  BNE .exit

  LDA.w $0641       ; block pushed flag
  BEQ .exit

  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML RoomTag_OperateChestReveal ; _01C7D8

.exit
RTS

ExtendRoomsWithPitDamage:
  LDA.b IndoorsFlag
  AND.w #$00FF
  BEQ .not_custom
  LDA.b RoomIndex
  CMP.w #$0091
  BNE .not_custom
  SEP #$30
  PLA : PLA : PLA
  JML UnderworldPitDoDamage
.not_custom:
  SEP #$20
  LDA.b RoomIndex
RTL



;--------------------------------------------------------------------------------
;  Final Puzzle Tag Code
;--------------------------------------------------------------------------------

HandleFinalPuzzleTag:
  LDA.b NMISTRIPES
  BNE .exit

  LDA.b LinkQuadrantH : BNE .exit
  LDA.b LinkQuadrantV : BEQ .exit

  ; todo
  LDA.l !UnderworldPuzzlesSolved : CMP.b #$07 : BCC .exit

  PHK : PEA.w .exit-1
  PEA.w $81CF8C ; an rtl address - 1 in Bank01
  JML RoomTag_OperateChestReveal ; _01C7D8
.exit
RTS


;--------------------------------------------------------------------------------
;  New Chest Code
;--------------------------------------------------------------------------------

ExtendedRoomData_ChestItems:
; room id, chest number; item id
dw $0039 : db $00 : db $B8  ; red boom puzzle item
dw $006A : db $02 : db $B8  ; red boom puzzle item
dw $005F : db $01 : db $B8  ; red boom puzzle item
dw $00D5 : db $04 : db $B8  ; red boom puzzle item
dw $00AB : db $00 : db $B8  ; red boom puzzle item
dw $0038 : db $00 : db $B8  ; red boom puzzle item
dw $0091 : db $00 : db $B9  ; altered puzzle item
dw $005C : db $00 : db $BA  ; final reward
; SEE HARDCODE TABLE SIZE below currently $0020 (32 bytes, 8 entries)

GetChestDataExtended:
  if !FEATURE_LIMITED_RUN == 2604
    BRA .checkExtended
  endif

.couldntFindChest
  INC.b Scrap0E : LDX.w #$FFFD ; what we wrote over
  JML Dungeon_OpenKeyedObject_nextChest

.checkExtended
  LDX.w #$FFFC

.nextChest
  ; HARDCODE TABLE SIZE here - change if you add more entries
  INX #4 : CPX.w #$0020 : BEQ .couldntFindChest
  LDA.l ExtendedRoomData_ChestItems, X : AND.w #$7FFF : CMP.b RoomIndex : BNE .nextChest
  SEP #$20
  LDA.l ExtendedRoomData_ChestItems+2, X : CMP.b Scrap0E
  REP #$20
  BNE .nextChest

;.foundChest
  LDA.l ExtendedRoomData_ChestItems+3, X : STA.b Scrap0C
  LDA.l ExtendedRoomData_ChestItems,X : ASL A : BCC .smallChest
  JML Dungeon_OpenKeyedObject_bigChest

.smallChest
  JML Dungeon_OpenKeyedObject_smallChest

;--------------------------------------------------------------------------------
;  Push Block Manip
;--------------------------------------------------------------------------------
PushBlock_TileTypeMod:
  STA.w $0500,Y
  LDA.b RoomIndex
  CMP.w #$0038 : BEQ .multipush
  CMP.w #$00D5 : BEQ .multipush
  CMP.w #$0120 : BNE .normal
.multipush
; ;figure out manipulable index
  TYA : LSR : ORA.w #$0070 : STA.b Scrap00 : XBA : ORA.b Scrap00
  RTL
.normal
  LDA.w #$2727 : RTL

;--------------------------------------------------------------------------------
;  Pressure Plate Preservation System
;--------------------------------------------------------------------------------

; Pressure plate tile values (2x2 16x16 tile = 4 tiles)
; PLACEHOLDER: Fill in actual tile values after testing in-game
PressurePlateTiles:
  dw $0CD2  ; Top-left
  dw $0CEB  ; Bottom-left
  dw $0CD3  ; Top-right
  dw $0CFB  ; Bottom-right

NormalTiles:
  dw $0CEF
  dw $0CFF
  dw $0CEE
  dw $0CFE

; Hook function: Check if block is moving off pressure plate, preserve tiles
; Called in 16-bit mode (REP #$20 already active)
PushBlock_FloorTileCheck:
  ; Check if room $0038
  LDA.b RoomIndex       ; Room index is 16-bit
  CMP.w #$0038
  BNE .execute_original

  ; Check if tag $45 active
  LDA.b RoomTag
  AND.w #$00FF          ; Mask to 8-bit value (tag is 8-bit)
  CMP.w #$0045
  BNE .execute_original

  ; Check if block is at pressure plate position
  LDA.w ManipTileMapX,Y ; Load tilemap position
  AND.w #$3FFF          ; Mask off flags

  LDX.w #$0000
.check_loop
  CMP.l PressurePlatePositions,X
  BEQ .found_match
  INX : INX
  CPX.w #!PRESSURE_PLATE_COUNT*2
  BNE .check_loop

  LDA.l NormalTiles+0
  STA.w ManipTileMapX+$20,Y
  LDA.l NormalTiles+2
  STA.w ManipTileMapX+$40,Y
  LDA.l NormalTiles+4
  STA.w ManipTileMapX+$60,Y
  LDA.l NormalTiles+6
  STA.w ManipTileMapX+$80,Y
  BRA .execute_original

.found_match
  ; Override stored floor tiles with pressure plate tiles
  LDA.l PressurePlateTiles+0
  STA.w ManipTileMapX+$20,Y
  LDA.l PressurePlateTiles+2
  STA.w ManipTileMapX+$40,Y
  LDA.l PressurePlateTiles+4
  STA.w ManipTileMapX+$60,Y
  LDA.l PressurePlateTiles+6
  STA.w ManipTileMapX+$80,Y

.execute_original
  ; Call original drawing function using jslrts (stays in 16-bit mode)
  PHK : PEA.w .return-1
  PEA.w $81CF8C       ; RTL address - 1 in Bank01
  JML RoomDraw_16x16Single
.return
  LDX.w $0474  ; overriden instruction - must be executed
  RTL

;--------------------------------------------------------------------------------
;  Extended Pushblock System
;--------------------------------------------------------------------------------

; Configuration: Change this to add more blocks (max 8 because of memory address usage)
!EXTENDED_PUSHBLOCK_COUNT = 7

; Data table: Add pushblock entries here
; Format: dw RoomID, TilemapIndex
ExtendedPushBlocks:
  dw $0038, $0752  ; Slot 99  - (X=$29, Y=$0E)
  dw $0038, $0552  ; Slot 100 - (X=$29, Y=$0A)
  dw $0038, $075A  ; Slot 101 - (X=$2D, Y=$0E)
  dw $0038, $066A  ; Slot 102 - (X=$35, Y=$0C)
  dw $0038, $066E  ; Slot 103 - (X=$37, Y=$0C)
  dw $0038, $056E  ; Slot 104 - (X=$37, Y=$0A)
  dw $0091, $0A0A  ; Slot 105 - (X=$05, Y=$14)
  ; Add up to 1 more entries here
  ; Maximum capacity: 8 entries due to using 250-26F space

;--------------------------------------------------------------------------------
; InitExtendedPushBlocks
; Called once at game start to copy extended pushblocks to SRAM
; Replaces: LDX.b #$3E : LDA.w #$0000
;--------------------------------------------------------------------------------
InitExtendedPushBlocks:
  ; Copy extended pushblocks from ROM to RAM
  ; Can't use Y-indexed with long addressing, so use absolute addressing
  LDX.b #$00             ; ROM table offset
.loop
  LDA.l ExtendedPushBlocks,X
  STA.w $0250, X        ; $0250 (slot 99 start)
  INX : INX
  CPX.b #!EXTENDED_PUSHBLOCK_COUNT*4  ; Count × 4 bytes per entry
  BNE .loop

  ; Execute replaced instructions
  LDX.b #$3E             ; Original instruction
  LDA.w #$0000           ; Original instruction
  RTL

;--------------------------------------------------------------------------------
; LoadExtendedPushBlocks
; Called every room entry to check for extended pushblocks in current room
; Replaces: REP #$20 : LDA.w $042C
;--------------------------------------------------------------------------------
LoadExtendedPushBlocks:
  REP #$30               ; Need 16-bit A and X/Y for our code

  ; Loop through extended RAM slots (99+)
  TDC                  ; Start index (slot 99)
  STA.b ObjPtrOffset

.loop
  LDX.b ObjPtrOffset

  ; Check if room ID matches current room
  LDA.w $0250,X        ; Load room ID from RAM
  CMP.b RoomIndex      ; Compare with current room
  BNE .next

  ; Match found - load and draw pushblock
  LDA.w $0252,X        ; Load tilemap index
  STA.b Scrap08
  TAY

  ; Call vanilla draw function using jslrts technique
  PHK : PEA.w .jslrtsreturn-1
  PEA.w $81CF8C          ; RTL address - 1 in Bank01
  JML RoomDraw_PushableBlock
.jslrtsreturn
  REP #$30               ; Restore 16-bit A and X/Y mode after draw function

.next
  LDA.b ObjPtrOffset
  CLC
  ADC.w #$0004           ; Next entry (+4 bytes)
  STA.b ObjPtrOffset
  CMP.w #!EXTENDED_PUSHBLOCK_COUNT*4  ; End index
  BCC .loop              ; Continue if less than limit

    ; Execute replaced instruction
  LDA.w ManipIndex       ; Original instruction (already in 16-bit mode)
  RTL

;--------------------------------------------------------------------------------
;  Reward Item
;--------------------------------------------------------------------------------

LimitedRun_ReceiveBookItem:
  LDA.l !SecretItemFlags : ORA.w #$0002 : STA.l !SecretItemFlags
  ; fall through
LimitedRun_ReceiveRewardItem:
  LDA.l !UnderworldPuzzlesSolved : INC : STA.l !UnderworldPuzzlesSolved
  TYA
  RTL

LimitedRun_ReceiveBoomItem:
  LDA.l !SecretItemFlags : ORA.w #$0001 : STA.l !SecretItemFlags
  TYA
  RTL

SecretBoomerang:
  LDA.w $035F : BEQ .clear_exit
  LDA.l !UnderworldPuzzlesSolved : BEQ .set_exit
  LDA.l !BlinkTimer : BNE .set_exit

  LDX.b #$05
.find_boom_ancilla ; $0385,X where X is 4 and the value should be 5? Search for 5 in this array?
  DEX
  LDA.w AncillaGeneralA, X
  CMP.b #$04 : BEQ .found_boom
  BRA .find_boom_ancilla
.found_boom
  ; is it the red one?
  LDA.w AncillaGeneralD, X : BEQ .set_exit  ; $0394,X is eiher 0 or 1 (blue or red)

  ; switch boomerange coords and links coords (Link teleports 8 pixels higher than boomerang)
  LDA.w AncillaCoordYHigh, X : STA.b Scrap01
  LDA.w AncillaCoordYLow, X : SEC : SBC.b #$08 : STA.b Scrap00
  BCS +                                   ; If carry set, no borrow needed
  DEC.b Scrap01                           ; Else decrement high byte for borrow
+
  LDA.w AncillaCoordXHigh, X : STA.b Scrap03 : LDA.w AncillaCoordXLow, X : STA.b Scrap02
  LDA.b LinkPosY : STA.w AncillaCoordYLow, X : LDA.b LinkPosY+1 : STA.w AncillaCoordYHigh, X
  LDA.b LinkPosX : STA.w AncillaCoordXLow, X : LDA.b LinkPosX+1 : STA.w AncillaCoordXHigh, X
  LDA.b IndoorsFlag : BEQ .overworld_teleport
  JSR TeleportLink_Underworld : BCS .set_exit : BRA .after_teleport
.overworld_teleport
  JSR TeleportLink_Overworld

.after_teleport
  LDA.b #$0D : JSL Sound_SetSfx2PanLong ; powder sfx
  LDA.l !UnderworldPuzzlesSolved : DEC : TAX
  LDA.l CooldownTable, X
  STA.l !BlinkTimer

.set_exit ; boomerang is out; go to normal exit
  SEC
  RTL
.clear_exit ; boomerang is not out, proceed normally
  CLC
  RTL

CooldownTable:
; simpler lookup if we finish 7 puzzles
  db $FF, $7D, $33, $1D, $0C, $07, $00

;===================================================================================================
; Teleport Link to Absolute Position with Camera Clamping
;===================================================================================================
; Input:
;   $00-$01 = New Y position (absolute) - DESTROYED
;   $02-$03 = New X position (absolute) - DESTROYED
; Scratch:
;   $04-$05 = Temporary storage for old camera position
;===================================================================================================

TeleportLink_Underworld:
  ; Determine layer from tile collision at boomerang's current position
  ; $00/$01=Y, $02/$03=X set by caller; GetTileType_long clobbers $04/$05, preserves X
  ; Upper floor: COLMAPA=$00; Lower floor: COLMAPA=$1C (non-zero); Wall: COLMAPA=$01/$04
  ; Note: PLB in GetTileType_long corrupts flags on return; AND.b #$FF re-establishes N/Z from A
  LDA.b #$00 : JSL GetTileType_long  ; A = COLMAPA tile type
  AND.b #$FF
  BNE .check_lower           ; COLMAPA non-zero -> not upper floor, check lower
  STZ.b LinkLayer            ; COLMAPA=$00 -> upper layer ($00 = BG2)
  BRA .ee_set
.check_lower
  LDA.b #$01 : JSL GetTileType_long  ; A = COLMAPB tile type
  AND.b #$FF
  BNE .wall_abort            ; both non-zero -> wall, abort teleport
  LDA.b #$01 : STA.b LinkLayer  ; COLMAPB=$00 -> lower layer ($01 = BG1)
  BRA .ee_set
.wall_abort
  SEC : RTS                  ; signal failure; caller skips cooldown
.ee_set
  REP #$20

  ;-----------------------------------------------------------------------------------------------
  ; Process X (horizontal) position and camera
  ;-----------------------------------------------------------------------------------------------

  ; Save old camera X
  LDA.w BG2H : STA.b Scrap04 ; Temp: old camera X

  ; Calculate X delta
  LDA.b Scrap02 : SEC : SBC.w LinkPosX
  PHA                  ; Save delta on stack

  ; Update Link X position
  LDA.b Scrap02  : STA.w LinkPosX

  ; Apply delta to camera
  PLA                  ; Restore X delta
  CLC : ADC.w BG2H     ; Add to camera X

  ; Clamp camera X to boundaries
  LDX.b CameraBoundH ; Horizontal boundary set index ($A6)

  CMP.w $0608,X    ; Check west boundary
  BCS +
  LDA.w $0608,X
+ CMP.w $060C,X    ; Check east boundary
  BCC +
  BEQ +
  LDA.w $060C,X
+ STA.w BG2H : STA.w BG1H   ; Store clamped camera X

  SEC : SBC.b Scrap04       ; Actual delta = new camera - old camera

  ; Update horizontal scroll triggers
  CLC : ADC.w CameraScrollW : STA.w CameraScrollW
  INC #2        ; East = West + 2
  STA.w CameraScrollE

  ;-----------------------------------------------------------------------------------------------
  ; Process Y (vertical) position and camera
  ;-----------------------------------------------------------------------------------------------

  ; Save old camera Y
  LDA.w BG2V : STA.b Scrap04  ; Temp: old camera Y

  ; Calculate Y delta
  LDA.b Scrap00 : SEC : SBC.w LinkPosY
  PHA                 ; Save delta on stack

  ; Update Link Y position
  LDA.b Scrap00 : STA.w LinkPosY

  ; Apply delta to camera
  PLA                 ; Restore Y delta
  CLC : ADC.w BG2V    ; Add to camera Y

  ; Clamp camera Y to boundaries
  LDX.b CameraBoundV  ; Vertical boundary set index ($A7)

  CMP.w $0600,X    ; Check north boundary
  BCS +
  LDA.w $0600,X
+ CMP.w $0604,X    ; Check south boundary
  BCC +
  BEQ +
  LDA.w $0604,X
+ STA.w BG2V : STA.w BG1V  ; Store clamped camera Y

  SEC : SBC.b Scrap04     ; Actual delta = new camera - old camera

  ; Update vertical scroll triggers
  CLC : ADC.w CameraScrollN : STA.w CameraScrollN
  INC #2        ; South = North + 2
  STA.w CameraScrollS

  ; Save old quadrant values before recalculation (LinkQuadrantH/V not yet updated)
  LDA.b LinkQuadrantH : STA.b Scrap02        ; old H quadrant: 0 or 1
  LDA.b LinkQuadrantV : LSR : STA.b Scrap00  ; old V quadrant: 0 or 2 -> 0 or 1
  JSR Teleport_RecalcQuadrantsAndBounds
  RTS

;===================================================================================================
; Recalculate quadrants and adjust camera bounds after teleport
; Input: Scrap00 = old V quadrant (0 or 1; LinkQuadrantV >> 1 before teleport)
;        Scrap02 = old H quadrant (0 or 1; LinkQuadrantH before teleport)
;        LinkPosX/Y already updated to new position
;        Called after camera clamping (BG2H/V updated)
;        Must be called with REP #$20 (16-bit accumulator) active
; Clobbers: A, X, Scrap04, $0600-$060F, $0620-$0622
; Returns: C=0
;===================================================================================================
Teleport_RecalcQuadrantsAndBounds:
    ; Adjust small-room camera bounds by quadrant delta, mirroring AdjustCameraBoundaries logic.
    ; Uses Teleport_Underworld canonical implementation.
    ; Must be called with REP #$20 (16-bit accumulator) active.
    LDA.b CameraBoundH : AND.w #$00FF
    BEQ .no_hfix
    LDA.b Scrap02 : AND.w #$0001 : XBA : AND.w #$0100  ; old H offset: $0000 or $0100
    STA.b Scrap04
    LDA.w LinkPosX : AND.w #$0100                    ; new H offset
    SEC : SBC.b Scrap04 : BEQ .no_hfix
    PHA
    CLC : ADC.w $0608 : STA.w $0608
    PLA
    CLC : ADC.w $060C : STA.w $060C
.no_hfix
    LDA.b CameraBoundV : AND.w #$FF00
    BEQ .no_vfix
    LDA.b Scrap00 : AND.w #$0001 : XBA : AND.w #$0100  ; old V offset: $0000 or $0100
    STA.b Scrap04
    LDA.w LinkPosY : AND.w #$0100                        ; new V offset
    SEC : SBC.b Scrap04 : BEQ .no_vfix
    PHA
    CLC : ADC.w $0600 : STA.w $0600
    PLA
    CLC : ADC.w $0604 : STA.w $0604
.no_vfix
    ; Reset BG1 parallax sub-pixel accumulators ($0620/$0622).
    STZ.w $0620
    STZ.w $0622
    ; Recalculate quadrants.
    SEP #$20
    LDA.b LinkPosX+1 : AND.b #$01 : STA.b LinkQuadrantH  ; 0 or 1
    LDA.b LinkPosY+1 : AND.b #$01 : ASL : STA.b LinkQuadrantV  ; 0 or 2
    ORA.b LinkQuadrantH                                   ; bit1=QUADV/2, bit0=QUADH
    STA.b Scrap00
    LDA.b $A8 : AND.b #$FC : ORA.b Scrap00 : STA.b $A8   ; update ROOMLAYOUT ($A8) low 2 bits
    CLC
    RTS

;===================================================================================================
; Teleport Link - Overworld
;===================================================================================================

TeleportLink_Overworld:
  REP #$20

  ; Clear BG1 sub-pixel accumulators to prevent parallax drift
;  STZ.w $0620                   ; OWBG1SUBPX (X sub-pixel accumulator)
;  STZ.w $0622                   ; OWBG1SUBPY (Y sub-pixel accumulator)

  ;-----------------------------------------------------------------------------------------------
  ; Process X (horizontal) position and camera
  ;-----------------------------------------------------------------------------------------------

  LDA.w BG2H : STA.b Scrap04     ; $04 = old FULL camera X (absolute coords)

  LDA.b Scrap02 : SEC : SBC.w LinkPosX
  PHA                            ; Save X delta

  LDA.b Scrap02 : STA.w LinkPosX ; Update Link X

  PLA                            ; Restore X delta
  CLC : ADC.b Scrap04            ; Apply delta to FULL camera value
  STA.b Scrap08                  ; $08 = new camera X (full pixels, before clamping)

  ; X boundaries are in /8 space, need to scale coordinates
  LSR A : LSR A : LSR A          ; Divide by 8 (discard low 3 bits)
  STA.b Scrap0A                  ; $0A = camera X in /8 space

  ; Clamp camera X to overworld boundaries (/8 space)
  ; Check min X (west edge)
  CMP.w $070C
  BCS +
  LDA.w $070C                    ; Clamp to min boundary
  STA.b Scrap0A

+ ; Check max X (east edge)
  LDA.w $070C : CLC : ADC.w $070E
  STA.b Scrap0C                  ; $0C = max X boundary

  LDA.b Scrap0A                  ; Reload camera X (/8 space)
  CMP.b Scrap0C
  BCC +
  BEQ +
  LDA.b Scrap0C                  ; Clamp to max boundary
  STA.b Scrap0A

+ ; Convert back to full pixel space
  LDA.b Scrap0A
  ASL A : ASL A : ASL A          ; Multiply by 8
  STA.b Scrap0A                  ; $0A = clamped camera X (full pixels, but low 3 bits = 0)

  ; Preserve low 3 bits from original unclamped camera
  LDA.b Scrap08 : AND.w #$0007   ; Get low 3 bits
  ORA.b Scrap0A                  ; Combine with clamped value
  STA.w BG2H                     ; Store final camera X

  SEC : SBC.b Scrap04            ; Calculate actual X delta
  STA.b Scrap06                  ; Save delta

  ; Apply scaled delta to BG1H for parallax effect
  ; Check if we're on Death Mountain screens (quarter rate) or normal (half rate)
  SEP #$20
  LDA.b OverlayID                ; Check overlay screen number
  CMP.b #$95                     ; OW 95 (Death Mountain)
  BEQ .quarter_rate_x
  CMP.b #$9E                     ; OW 9E (Death Mountain)
  BEQ .quarter_rate_x

  ; Standard parallax: BG1 moves at half rate
  REP #$20
  LDA.b Scrap06 : LSR A          ; Divide by 2 (unsigned)
  CMP.w #$7000 : BCC +           ; Check if needs sign extension
  ORA.w #$F000                   ; Restore sign bits
+ CLC : ADC.w BG1H : STA.w BG1H
  BRA .done_bg1h

.quarter_rate_x
  ; Death Mountain parallax: BG1 moves at quarter rate
  REP #$20
  LDA.b Scrap06 : LSR A : LSR A  ; Divide by 4 (unsigned)
  CMP.w #$3000 : BCC +           ; Check if needs sign extension
  ORA.w #$F000                   ; Restore sign bits
+ CLC : ADC.w BG1H : STA.w BG1H

.done_bg1h

  ; Update horizontal scroll triggers (OVERWORLD: inverted)
  LDA.b Scrap06                  ; Reload actual X delta
  CLC : ADC.w CameraScrollW : STA.w CameraScrollW
  DEC #2              ; East = West - 2 (inverted!)
  STA.w CameraScrollE

  ;-----------------------------------------------------------------------------------------------
  ; Process Y (vertical) position and camera
  ;-----------------------------------------------------------------------------------------------

  LDA.w BG2V : STA.b Scrap04     ; $04 = old FULL camera Y (absolute coords)

  LDA.b Scrap00 : SEC : SBC.w LinkPosY
  PHA                            ; Save Y delta

  LDA.b Scrap00 : STA.w LinkPosY ; Update Link Y

  PLA                            ; Restore Y delta
  CLC : ADC.b Scrap04            ; Apply delta to FULL camera value
  STA.b Scrap08                  ; $08 = new camera Y (before clamping)

  ; Clamp camera Y to overworld boundaries (absolute coordinate space)
  ; Check min Y (north edge)
  CMP.w $0708
  BCS +
  LDA.w $0708                    ; Clamp to min boundary
  STA.b Scrap08

+ ; Check max Y (south edge = boundary + size)
  LDA.w $0708 : CLC : ADC.w $070A
  STA.b Scrap0A                  ; $0A = max Y boundary

  LDA.b Scrap08                  ; Reload camera Y
  CMP.b Scrap0A
  BCC +
  BEQ +
  LDA.b Scrap0A                  ; Clamp to max boundary
  STA.b Scrap08

+ LDA.b Scrap08                  ; Final clamped camera Y
  STA.w BG2V                     ; Store final camera Y

  SEC : SBC.b Scrap04            ; Calculate actual Y delta (full coords)
  STA.b Scrap06                  ; Save actual Y delta in $06

  ; Apply scaled delta to BG1V for parallax effect
  SEP #$20
  LDA.b OverlayID                ; Check overlay screen number
  CMP.b #$97                     ; OW 97 (no parallax)
  BEQ .no_parallax_y
  CMP.b #$9D                     ; OW 9D (no parallax)
  BEQ .no_parallax_y
  CMP.b #$B5                     ; OW B5 (quarter rate)
  BEQ .quarter_rate_y
  CMP.b #$BE                     ; OW BE (quarter rate)
  BEQ .quarter_rate_y

  ; Standard parallax: BG1 moves at half rate
  REP #$20
  LDA.b Scrap06 : LSR A          ; Divide by 2 (unsigned)
  CMP.w #$7000 : BCC +           ; Check if needs sign extension
  ORA.w #$F000                   ; Restore sign bits
+ CLC : ADC.w BG1V : STA.w BG1V
  BRA .done_bg1v

.quarter_rate_y
  ; Quarter rate parallax
  REP #$20
  LDA.b Scrap06 : LSR A : LSR A ; Divide by 4 (unsigned)
  CMP.w #$3000 : BCC +          ; Check if needs sign extension
  ORA.w #$F000                  ; Restore sign bits
+ CLC : ADC.w BG1V : STA.w BG1V
  BRA .done_bg1v

.no_parallax_y
  ; No parallax - don't update BG1V
  REP #$20

.done_bg1v

  ; Update vertical scroll triggers (OVERWORLD: inverted)
  LDA.b Scrap06                  ; Reload actual Y delta
  CLC : ADC.w CameraScrollN : STA.w CameraScrollN
  DEC #2              ; South = North - 2 (inverted!)
  STA.w CameraScrollS

; Optimized method: 16-pixel tiles with base offset 0x18

  ; Save Y delta for reuse
  LDA.w BG2V
  SEC : SBC.w $0708
  STA.b Scrap0C         ; Save Y delta

  ; Y component for $84: (delta_Y & $FFF0) * 8
  AND.w #$FFF0
  ASL #3
  STA.b Scrap06         ; Temporary Y component

  ; Calculate and save screen_left in pixels
  LDA.w $070C : ASL #3 : STA.b Scrap0E

  ; Save X delta for reuse
  LDA.w BG2H
  SEC : SBC.b Scrap0E
  STA.b Scrap08            ; Save X delta

  ; X component for $84: (delta_X & $FFF0) / 8
  AND.w #$FFF0
  LSR #3
  CLC : ADC.b Scrap06  ; Add Y component
  STA.b OverworldMap16Buffer  ; Final $84

  ; $86 = (X_delta / 16 + 0x18) & 0x1F
  LDA.b Scrap08        ; Reuse saved X delta
  LSR #4
  CLC : ADC.w #$0018
  AND.w #$001F
  STA.b OverworldTilemapIndexX

  ; $88 = (Y_delta / 16 + 0x18) & 0x1F
  LDA.b Scrap0C        ; Reuse saved Y delta
  LSR #4
  CLC : ADC.w #$0018
  AND.w #$001F
  STA.b OverworldTilemapIndexY

  ;-----------------------------------------------------------------------------------------------
  ; Rebuild VRAM tilemap if on a big screen (fixes off-screen corruption)
  ;-----------------------------------------------------------------------------------------------

  SEP #$20

  ; Check if big screen: OverworldScreenSize[$8A] == 0
  LDX.b OverworldIndex
  LDA.l OverworldScreenSize,X      ; OverworldScreenSize table
  BNE .skip_rebuild    ; Non-zero = small screen, skip rebuild

  ; Big screen detected - rebuild entire tilemap without blackout
  REP #$20

  ; Save current $84/$86/$88 values (same as Module09_21 does)
  LDA.b OverworldMap16Buffer : PHA
  LDA.b OverworldTilemapIndexX : PHA
  LDA.b OverworldTilemapIndexY : PHA

  ; Set up parameters for BuildOverworldMapFromMap16
  LDA.w #$FFFF : STA.b $C8  ; Mark all quadrants for rebuild
  STZ.b $CA                 ; Clear horizontal offset
  STZ.b $CC                 ; Clear vertical offset

  SEP #$20

  ; Call long wrapper for BuildOverworldMapFromMap16
  PHK : PEA.w .jslrtsreturn-1
  PEA.w $828020            ; RTL address-1 in Bank02
  JML $82FA9B              ; BuildOverworldMapFromMap16
.jslrtsreturn:

  ; Set NMI dispatch to upload stripe data to VRAM
  LDA.b #$04               ; NMI_UpdateSubscreenOverlay
  STA.b NMIINCR            ; NMI dispatch index
  STA.w $0710              ; Backup/frame counter

  ; Restore original $84/$86/$88 values
  REP #$20
  PLA : STA.b OverworldTilemapIndexY
  PLA : STA.b OverworldTilemapIndexX
  PLA : STA.b OverworldMap16Buffer

  SEP #$20
.skip_rebuild

  RTS

;===================================================================================================
; Blink Timer
;===================================================================================================

HandleBlinkTimer:

  LDA.b FrameCounter : AND.b #$3F : BNE .exit
  LDA.l !BlinkTimer : BEQ .exit
  DEC : STA.l !BlinkTimer
.exit
  JSL GetMultiworldItem ; overwriting someone elses hook
  RTL

LimitedRun_BlinkTimer:
    LDA.l !BlinkTimer : AND.w #$00FF : BEQ .normal_exit
        ASL #3 : TAX ; X = !BlinkTimer * 8

        ; Y register holds magic level for tilemap offset
        ; Strategy: Load all 4 masks onto stack, then process with magic level

        ; Load all 4 masks from table (X = table index)
        LDA.l BlinkMeterColorTable+6,X : PHA  ; Portion 4 (bottom)
        LDA.l BlinkMeterColorTable+4,X : PHA  ; Portion 3
        LDA.l BlinkMeterColorTable+2,X : PHA  ; Portion 2
        LDA.l BlinkMeterColorTable+0,X : PHA  ; Portion 1 (top)

        TYX  ; X = magic level offset into tilemap
        ; Apply masks (pop in reverse order)
        PLA : AND.l DrawMagicMeter_mp_tilemap+0,X : STA.w HUDTileMapBuffer+$046
        PLA : AND.l DrawMagicMeter_mp_tilemap+2,X : STA.w HUDTileMapBuffer+$086
        PLA : AND.l DrawMagicMeter_mp_tilemap+4,X : STA.w HUDTileMapBuffer+$0C6
        PLA : AND.l DrawMagicMeter_mp_tilemap+6,X : STA.w HUDTileMapBuffer+$106
        SEC : RTL
.normal_exit
    CLC : RTL

;================================================================================
; Cascade Meter Color Table - Reheat Cascade
; 256 entries (one per !BlinkTimer value)
; Each entry is 8 bytes: 4 words for [Portion1, Portion2, Portion3, Portion4]
;
; Heat order: Red(4) > Orange(3) > Yellow(2) > Blue(1) > Green(0)
;
; Rules:
;   - P1 ≤ P2 ≤ P3 ≤ P4 (top never hotter than bottom)
;   - Top portion (P1) cools first through all values ≤ P2
;   - When P1 reaches 0, P2 decrements and P1 reheats to match P2
;   - This creates a 'sawtooth' cooling pattern
;
; Progression example:
;   RRRR → ORRR → YRRR → BRRR → GRRR → OORR (P1 reheats!) → YORR → ...
;
; 70 unique states mapped across 256 timer values
;
; Index calculation:
;   Base = (BlinkTimer << 3)
;================================================================================
BlinkMeterColorTable:
; Total valid states: 70

    dw $FFFF, $FFFF, $FFFF, $FFFF ; $00 [Grn][Grn][Grn][Grn] ← READY
    dw $FFFF, $FFFF, $FFFF, $EFFF ; $01 [Grn][Grn][Grn][Blu]
    dw $FFFF, $FFFF, $FFFF, $EFFF ; $02 [Grn][Grn][Grn][Blu]
    dw $FFFF, $FFFF, $FFFF, $EFFF ; $03 [Grn][Grn][Grn][Blu] < All puzzles
    dw $FFFF, $FFFF, $EFFF, $EFFF ; $04 [Grn][Grn][Blu][Blu]
    dw $FFFF, $FFFF, $EFFF, $EFFF ; $05 [Grn][Grn][Blu][Blu]
    dw $FFFF, $FFFF, $EFFF, $EFFF ; $06 [Grn][Grn][Blu][Blu]
    dw $FFFF, $FFFF, $EFFF, $EFFF ; $07 [Grn][Grn][Blu][Blu] <- Missing 1
    dw $FFFF, $EFFF, $EFFF, $EFFF ; $08 [Grn][Blu][Blu][Blu]
    dw $FFFF, $EFFF, $EFFF, $EFFF ; $09 [Grn][Blu][Blu][Blu]
    dw $FFFF, $EFFF, $EFFF, $EFFF ; $0A [Grn][Blu][Blu][Blu]
    dw $FFFF, $EFFF, $EFFF, $EFFF ; $0B [Grn][Blu][Blu][Blu]
    dw $EFFF, $EFFF, $EFFF, $EFFF ; $0C [Blu][Blu][Blu][Blu] ← Missing 2
    dw $EFFF, $EFFF, $EFFF, $EFFF ; $0D [Blu][Blu][Blu][Blu]
    dw $EFFF, $EFFF, $EFFF, $EFFF ; $0E [Blu][Blu][Blu][Blu]
    dw $FFFF, $FFFF, $FFFF, $EBFF ; $0F [Grn][Grn][Grn][Yel]
    dw $FFFF, $FFFF, $FFFF, $EBFF ; $10 [Grn][Grn][Grn][Yel]
    dw $FFFF, $FFFF, $FFFF, $EBFF ; $11 [Grn][Grn][Grn][Yel]
    dw $FFFF, $FFFF, $FFFF, $EBFF ; $12 [Grn][Grn][Grn][Yel]
    dw $FFFF, $FFFF, $EFFF, $EBFF ; $13 [Grn][Grn][Blu][Yel]
    dw $FFFF, $FFFF, $EFFF, $EBFF ; $14 [Grn][Grn][Blu][Yel]
    dw $FFFF, $FFFF, $EFFF, $EBFF ; $15 [Grn][Grn][Blu][Yel]
    dw $FFFF, $FFFF, $EFFF, $EBFF ; $16 [Grn][Grn][Blu][Yel]
    dw $FFFF, $EFFF, $EFFF, $EBFF ; $17 [Grn][Blu][Blu][Yel]
    dw $FFFF, $EFFF, $EFFF, $EBFF ; $18 [Grn][Blu][Blu][Yel]
    dw $FFFF, $EFFF, $EFFF, $EBFF ; $19 [Grn][Blu][Blu][Yel]
    dw $EFFF, $EFFF, $EFFF, $EBFF ; $1A [Blu][Blu][Blu][Yel] ← REHEAT!
    dw $EFFF, $EFFF, $EFFF, $EBFF ; $1B [Blu][Blu][Blu][Yel]
    dw $EFFF, $EFFF, $EFFF, $EBFF ; $1C [Blu][Blu][Blu][Yel]
    dw $EFFF, $EFFF, $EFFF, $EBFF ; $1D [Blu][Blu][Blu][Yel] <-Missing 3
    dw $FFFF, $FFFF, $EBFF, $EBFF ; $1E [Grn][Grn][Yel][Yel]
    dw $FFFF, $FFFF, $EBFF, $EBFF ; $1F [Grn][Grn][Yel][Yel]
    dw $FFFF, $FFFF, $EBFF, $EBFF ; $20 [Grn][Grn][Yel][Yel]
    dw $FFFF, $FFFF, $EBFF, $EBFF ; $21 [Grn][Grn][Yel][Yel]
    dw $FFFF, $EFFF, $EBFF, $EBFF ; $22 [Grn][Blu][Yel][Yel]
    dw $FFFF, $EFFF, $EBFF, $EBFF ; $23 [Grn][Blu][Yel][Yel]
    dw $FFFF, $EFFF, $EBFF, $EBFF ; $24 [Grn][Blu][Yel][Yel]
    dw $EFFF, $EFFF, $EBFF, $EBFF ; $25 [Blu][Blu][Yel][Yel] ← REHEAT!
    dw $EFFF, $EFFF, $EBFF, $EBFF ; $26 [Blu][Blu][Yel][Yel]
    dw $EFFF, $EFFF, $EBFF, $EBFF ; $27 [Blu][Blu][Yel][Yel]
    dw $EFFF, $EFFF, $EBFF, $EBFF ; $28 [Blu][Blu][Yel][Yel]
    dw $FFFF, $EBFF, $EBFF, $EBFF ; $29 [Grn][Yel][Yel][Yel]
    dw $FFFF, $EBFF, $EBFF, $EBFF ; $2A [Grn][Yel][Yel][Yel]
    dw $FFFF, $EBFF, $EBFF, $EBFF ; $2B [Grn][Yel][Yel][Yel]
    dw $FFFF, $EBFF, $EBFF, $EBFF ; $2C [Grn][Yel][Yel][Yel]
    dw $EFFF, $EBFF, $EBFF, $EBFF ; $2D [Blu][Yel][Yel][Yel] ← REHEAT!
    dw $EFFF, $EBFF, $EBFF, $EBFF ; $2E [Blu][Yel][Yel][Yel]
    dw $EFFF, $EBFF, $EBFF, $EBFF ; $2F [Blu][Yel][Yel][Yel]
    dw $EFFF, $EBFF, $EBFF, $EBFF ; $30 [Blu][Yel][Yel][Yel]
    dw $EBFF, $EBFF, $EBFF, $EBFF ; $31 [Yel][Yel][Yel][Yel] ← REHEAT!
    dw $EBFF, $EBFF, $EBFF, $EBFF ; $32 [Yel][Yel][Yel][Yel]
    dw $EBFF, $EBFF, $EBFF, $EBFF ; $33 [Yel][Yel][Yel][Yel] <- Missing 4
    dw $FFFF, $FFFF, $FFFF, $E3FF ; $34 [Grn][Grn][Grn][Org]
    dw $FFFF, $FFFF, $FFFF, $E3FF ; $35 [Grn][Grn][Grn][Org]
    dw $FFFF, $FFFF, $FFFF, $E3FF ; $36 [Grn][Grn][Grn][Org]
    dw $FFFF, $FFFF, $FFFF, $E3FF ; $37 [Grn][Grn][Grn][Org]
    dw $FFFF, $FFFF, $EFFF, $E3FF ; $38 [Grn][Grn][Blu][Org]
    dw $FFFF, $FFFF, $EFFF, $E3FF ; $39 [Grn][Grn][Blu][Org]
    dw $FFFF, $FFFF, $EFFF, $E3FF ; $3A [Grn][Grn][Blu][Org]
    dw $FFFF, $FFFF, $EFFF, $E3FF ; $3B [Grn][Grn][Blu][Org]
    dw $FFFF, $EFFF, $EFFF, $E3FF ; $3C [Grn][Blu][Blu][Org]
    dw $FFFF, $EFFF, $EFFF, $E3FF ; $3D [Grn][Blu][Blu][Org]
    dw $FFFF, $EFFF, $EFFF, $E3FF ; $3E [Grn][Blu][Blu][Org]
    dw $EFFF, $EFFF, $EFFF, $E3FF ; $3F [Blu][Blu][Blu][Org] ← REHEAT!
    dw $EFFF, $EFFF, $EFFF, $E3FF ; $40 [Blu][Blu][Blu][Org]
    dw $EFFF, $EFFF, $EFFF, $E3FF ; $41 [Blu][Blu][Blu][Org]
    dw $EFFF, $EFFF, $EFFF, $E3FF ; $42 [Blu][Blu][Blu][Org]
    dw $FFFF, $FFFF, $EBFF, $E3FF ; $43 [Grn][Grn][Yel][Org]
    dw $FFFF, $FFFF, $EBFF, $E3FF ; $44 [Grn][Grn][Yel][Org]
    dw $FFFF, $FFFF, $EBFF, $E3FF ; $45 [Grn][Grn][Yel][Org]
    dw $FFFF, $FFFF, $EBFF, $E3FF ; $46 [Grn][Grn][Yel][Org]
    dw $FFFF, $EFFF, $EBFF, $E3FF ; $47 [Grn][Blu][Yel][Org]
    dw $FFFF, $EFFF, $EBFF, $E3FF ; $48 [Grn][Blu][Yel][Org]
    dw $FFFF, $EFFF, $EBFF, $E3FF ; $49 [Grn][Blu][Yel][Org]
    dw $EFFF, $EFFF, $EBFF, $E3FF ; $4A [Blu][Blu][Yel][Org] ← REHEAT!
    dw $EFFF, $EFFF, $EBFF, $E3FF ; $4B [Blu][Blu][Yel][Org]
    dw $EFFF, $EFFF, $EBFF, $E3FF ; $4C [Blu][Blu][Yel][Org]
    dw $EFFF, $EFFF, $EBFF, $E3FF ; $4D [Blu][Blu][Yel][Org]
    dw $FFFF, $EBFF, $EBFF, $E3FF ; $4E [Grn][Yel][Yel][Org]
    dw $FFFF, $EBFF, $EBFF, $E3FF ; $4F [Grn][Yel][Yel][Org]
    dw $FFFF, $EBFF, $EBFF, $E3FF ; $50 [Grn][Yel][Yel][Org]
    dw $FFFF, $EBFF, $EBFF, $E3FF ; $51 [Grn][Yel][Yel][Org]
    dw $EFFF, $EBFF, $EBFF, $E3FF ; $52 [Blu][Yel][Yel][Org] ← REHEAT!
    dw $EFFF, $EBFF, $EBFF, $E3FF ; $53 [Blu][Yel][Yel][Org]
    dw $EFFF, $EBFF, $EBFF, $E3FF ; $54 [Blu][Yel][Yel][Org]
    dw $EFFF, $EBFF, $EBFF, $E3FF ; $55 [Blu][Yel][Yel][Org]
    dw $EBFF, $EBFF, $EBFF, $E3FF ; $56 [Yel][Yel][Yel][Org] ← REHEAT!
    dw $EBFF, $EBFF, $EBFF, $E3FF ; $57 [Yel][Yel][Yel][Org]
    dw $EBFF, $EBFF, $EBFF, $E3FF ; $58 [Yel][Yel][Yel][Org]
    dw $FFFF, $FFFF, $E3FF, $E3FF ; $59 [Grn][Grn][Org][Org]
    dw $FFFF, $FFFF, $E3FF, $E3FF ; $5A [Grn][Grn][Org][Org]
    dw $FFFF, $FFFF, $E3FF, $E3FF ; $5B [Grn][Grn][Org][Org]
    dw $FFFF, $FFFF, $E3FF, $E3FF ; $5C [Grn][Grn][Org][Org]
    dw $FFFF, $EFFF, $E3FF, $E3FF ; $5D [Grn][Blu][Org][Org]
    dw $FFFF, $EFFF, $E3FF, $E3FF ; $5E [Grn][Blu][Org][Org]
    dw $FFFF, $EFFF, $E3FF, $E3FF ; $5F [Grn][Blu][Org][Org]
    dw $FFFF, $EFFF, $E3FF, $E3FF ; $60 [Grn][Blu][Org][Org]
    dw $EFFF, $EFFF, $E3FF, $E3FF ; $61 [Blu][Blu][Org][Org] ← REHEAT!
    dw $EFFF, $EFFF, $E3FF, $E3FF ; $62 [Blu][Blu][Org][Org]
    dw $EFFF, $EFFF, $E3FF, $E3FF ; $63 [Blu][Blu][Org][Org]
    dw $FFFF, $EBFF, $E3FF, $E3FF ; $64 [Grn][Yel][Org][Org]
    dw $FFFF, $EBFF, $E3FF, $E3FF ; $65 [Grn][Yel][Org][Org]
    dw $FFFF, $EBFF, $E3FF, $E3FF ; $66 [Grn][Yel][Org][Org]
    dw $FFFF, $EBFF, $E3FF, $E3FF ; $67 [Grn][Yel][Org][Org]
    dw $EFFF, $EBFF, $E3FF, $E3FF ; $68 [Blu][Yel][Org][Org] ← REHEAT!
    dw $EFFF, $EBFF, $E3FF, $E3FF ; $69 [Blu][Yel][Org][Org]
    dw $EFFF, $EBFF, $E3FF, $E3FF ; $6A [Blu][Yel][Org][Org]
    dw $EFFF, $EBFF, $E3FF, $E3FF ; $6B [Blu][Yel][Org][Org]
    dw $EBFF, $EBFF, $E3FF, $E3FF ; $6C [Yel][Yel][Org][Org] ← REHEAT!
    dw $EBFF, $EBFF, $E3FF, $E3FF ; $6D [Yel][Yel][Org][Org]
    dw $EBFF, $EBFF, $E3FF, $E3FF ; $6E [Yel][Yel][Org][Org]
    dw $FFFF, $E3FF, $E3FF, $E3FF ; $6F [Grn][Org][Org][Org]
    dw $FFFF, $E3FF, $E3FF, $E3FF ; $70 [Grn][Org][Org][Org]
    dw $FFFF, $E3FF, $E3FF, $E3FF ; $71 [Grn][Org][Org][Org]
    dw $FFFF, $E3FF, $E3FF, $E3FF ; $72 [Grn][Org][Org][Org]
    dw $EFFF, $E3FF, $E3FF, $E3FF ; $73 [Blu][Org][Org][Org] ← REHEAT!
    dw $EFFF, $E3FF, $E3FF, $E3FF ; $74 [Blu][Org][Org][Org]
    dw $EFFF, $E3FF, $E3FF, $E3FF ; $75 [Blu][Org][Org][Org]
    dw $EFFF, $E3FF, $E3FF, $E3FF ; $76 [Blu][Org][Org][Org]
    dw $EBFF, $E3FF, $E3FF, $E3FF ; $77 [Yel][Org][Org][Org] ← REHEAT!
    dw $EBFF, $E3FF, $E3FF, $E3FF ; $78 [Yel][Org][Org][Org]
    dw $EBFF, $E3FF, $E3FF, $E3FF ; $79 [Yel][Org][Org][Org]
    dw $E3FF, $E3FF, $E3FF, $E3FF ; $7A [Org][Org][Org][Org] ← REHEAT!
    dw $E3FF, $E3FF, $E3FF, $E3FF ; $7B [Org][Org][Org][Org]
    dw $E3FF, $E3FF, $E3FF, $E3FF ; $7C [Org][Org][Org][Org]
    dw $E3FF, $E3FF, $E3FF, $E3FF ; $7D [Org][Org][Org][Org] <- Missing 5
    dw $FFFF, $FFFF, $FFFF, $E7FF ; $7E [Grn][Grn][Grn][Red]
    dw $FFFF, $FFFF, $FFFF, $E7FF ; $7F [Grn][Grn][Grn][Red]
    dw $FFFF, $FFFF, $FFFF, $E7FF ; $80 [Grn][Grn][Grn][Red]
    dw $FFFF, $FFFF, $FFFF, $E7FF ; $81 [Grn][Grn][Grn][Red]
    dw $FFFF, $FFFF, $EFFF, $E7FF ; $82 [Grn][Grn][Blu][Red]
    dw $FFFF, $FFFF, $EFFF, $E7FF ; $83 [Grn][Grn][Blu][Red]
    dw $FFFF, $FFFF, $EFFF, $E7FF ; $84 [Grn][Grn][Blu][Red]
    dw $FFFF, $FFFF, $EFFF, $E7FF ; $85 [Grn][Grn][Blu][Red]
    dw $FFFF, $EFFF, $EFFF, $E7FF ; $86 [Grn][Blu][Blu][Red]
    dw $FFFF, $EFFF, $EFFF, $E7FF ; $87 [Grn][Blu][Blu][Red]
    dw $FFFF, $EFFF, $EFFF, $E7FF ; $88 [Grn][Blu][Blu][Red]
    dw $EFFF, $EFFF, $EFFF, $E7FF ; $89 [Blu][Blu][Blu][Red] ← REHEAT!
    dw $EFFF, $EFFF, $EFFF, $E7FF ; $8A [Blu][Blu][Blu][Red]
    dw $EFFF, $EFFF, $EFFF, $E7FF ; $8B [Blu][Blu][Blu][Red]
    dw $EFFF, $EFFF, $EFFF, $E7FF ; $8C [Blu][Blu][Blu][Red]
    dw $FFFF, $FFFF, $EBFF, $E7FF ; $8D [Grn][Grn][Yel][Red]
    dw $FFFF, $FFFF, $EBFF, $E7FF ; $8E [Grn][Grn][Yel][Red]
    dw $FFFF, $FFFF, $EBFF, $E7FF ; $8F [Grn][Grn][Yel][Red]
    dw $FFFF, $FFFF, $EBFF, $E7FF ; $90 [Grn][Grn][Yel][Red]
    dw $FFFF, $EFFF, $EBFF, $E7FF ; $91 [Grn][Blu][Yel][Red]
    dw $FFFF, $EFFF, $EBFF, $E7FF ; $92 [Grn][Blu][Yel][Red]
    dw $FFFF, $EFFF, $EBFF, $E7FF ; $93 [Grn][Blu][Yel][Red]
    dw $EFFF, $EFFF, $EBFF, $E7FF ; $94 [Blu][Blu][Yel][Red] ← REHEAT!
    dw $EFFF, $EFFF, $EBFF, $E7FF ; $95 [Blu][Blu][Yel][Red]
    dw $EFFF, $EFFF, $EBFF, $E7FF ; $96 [Blu][Blu][Yel][Red]
    dw $EFFF, $EFFF, $EBFF, $E7FF ; $97 [Blu][Blu][Yel][Red]
    dw $FFFF, $EBFF, $EBFF, $E7FF ; $98 [Grn][Yel][Yel][Red]
    dw $FFFF, $EBFF, $EBFF, $E7FF ; $99 [Grn][Yel][Yel][Red]
    dw $FFFF, $EBFF, $EBFF, $E7FF ; $9A [Grn][Yel][Yel][Red]
    dw $FFFF, $EBFF, $EBFF, $E7FF ; $9B [Grn][Yel][Yel][Red]
    dw $EFFF, $EBFF, $EBFF, $E7FF ; $9C [Blu][Yel][Yel][Red] ← REHEAT!
    dw $EFFF, $EBFF, $EBFF, $E7FF ; $9D [Blu][Yel][Yel][Red]
    dw $EFFF, $EBFF, $EBFF, $E7FF ; $9E [Blu][Yel][Yel][Red]
    dw $EBFF, $EBFF, $EBFF, $E7FF ; $9F [Yel][Yel][Yel][Red] ← REHEAT!
    dw $EBFF, $EBFF, $EBFF, $E7FF ; $A0 [Yel][Yel][Yel][Red]
    dw $EBFF, $EBFF, $EBFF, $E7FF ; $A1 [Yel][Yel][Yel][Red]
    dw $EBFF, $EBFF, $EBFF, $E7FF ; $A2 [Yel][Yel][Yel][Red]
    dw $FFFF, $FFFF, $E3FF, $E7FF ; $A3 [Grn][Grn][Org][Red]
    dw $FFFF, $FFFF, $E3FF, $E7FF ; $A4 [Grn][Grn][Org][Red]
    dw $FFFF, $FFFF, $E3FF, $E7FF ; $A5 [Grn][Grn][Org][Red]
    dw $FFFF, $FFFF, $E3FF, $E7FF ; $A6 [Grn][Grn][Org][Red]
    dw $FFFF, $EFFF, $E3FF, $E7FF ; $A7 [Grn][Blu][Org][Red]
    dw $FFFF, $EFFF, $E3FF, $E7FF ; $A8 [Grn][Blu][Org][Red]
    dw $FFFF, $EFFF, $E3FF, $E7FF ; $A9 [Grn][Blu][Org][Red]
    dw $FFFF, $EFFF, $E3FF, $E7FF ; $AA [Grn][Blu][Org][Red]
    dw $EFFF, $EFFF, $E3FF, $E7FF ; $AB [Blu][Blu][Org][Red] ← REHEAT!
    dw $EFFF, $EFFF, $E3FF, $E7FF ; $AC [Blu][Blu][Org][Red]
    dw $EFFF, $EFFF, $E3FF, $E7FF ; $AD [Blu][Blu][Org][Red]
    dw $FFFF, $EBFF, $E3FF, $E7FF ; $AE [Grn][Yel][Org][Red]
    dw $FFFF, $EBFF, $E3FF, $E7FF ; $AF [Grn][Yel][Org][Red]
    dw $FFFF, $EBFF, $E3FF, $E7FF ; $B0 [Grn][Yel][Org][Red]
    dw $FFFF, $EBFF, $E3FF, $E7FF ; $B1 [Grn][Yel][Org][Red]
    dw $EFFF, $EBFF, $E3FF, $E7FF ; $B2 [Blu][Yel][Org][Red] ← REHEAT!
    dw $EFFF, $EBFF, $E3FF, $E7FF ; $B3 [Blu][Yel][Org][Red]
    dw $EFFF, $EBFF, $E3FF, $E7FF ; $B4 [Blu][Yel][Org][Red]
    dw $EFFF, $EBFF, $E3FF, $E7FF ; $B5 [Blu][Yel][Org][Red]
    dw $EBFF, $EBFF, $E3FF, $E7FF ; $B6 [Yel][Yel][Org][Red] ← REHEAT!
    dw $EBFF, $EBFF, $E3FF, $E7FF ; $B7 [Yel][Yel][Org][Red]
    dw $EBFF, $EBFF, $E3FF, $E7FF ; $B8 [Yel][Yel][Org][Red]
    dw $FFFF, $E3FF, $E3FF, $E7FF ; $B9 [Grn][Org][Org][Red]
    dw $FFFF, $E3FF, $E3FF, $E7FF ; $BA [Grn][Org][Org][Red]
    dw $FFFF, $E3FF, $E3FF, $E7FF ; $BB [Grn][Org][Org][Red]
    dw $FFFF, $E3FF, $E3FF, $E7FF ; $BC [Grn][Org][Org][Red]
    dw $EFFF, $E3FF, $E3FF, $E7FF ; $BD [Blu][Org][Org][Red] ← REHEAT!
    dw $EFFF, $E3FF, $E3FF, $E7FF ; $BE [Blu][Org][Org][Red]
    dw $EFFF, $E3FF, $E3FF, $E7FF ; $BF [Blu][Org][Org][Red]
    dw $EFFF, $E3FF, $E3FF, $E7FF ; $C0 [Blu][Org][Org][Red]
    dw $EBFF, $E3FF, $E3FF, $E7FF ; $C1 [Yel][Org][Org][Red] ← REHEAT!
    dw $EBFF, $E3FF, $E3FF, $E7FF ; $C2 [Yel][Org][Org][Red]
    dw $EBFF, $E3FF, $E3FF, $E7FF ; $C3 [Yel][Org][Org][Red]
    dw $E3FF, $E3FF, $E3FF, $E7FF ; $C4 [Org][Org][Org][Red] ← REHEAT!
    dw $E3FF, $E3FF, $E3FF, $E7FF ; $C5 [Org][Org][Org][Red]
    dw $E3FF, $E3FF, $E3FF, $E7FF ; $C6 [Org][Org][Org][Red]
    dw $E3FF, $E3FF, $E3FF, $E7FF ; $C7 [Org][Org][Org][Red]
    dw $FFFF, $FFFF, $E7FF, $E7FF ; $C8 [Grn][Grn][Red][Red]
    dw $FFFF, $FFFF, $E7FF, $E7FF ; $C9 [Grn][Grn][Red][Red]
    dw $FFFF, $FFFF, $E7FF, $E7FF ; $CA [Grn][Grn][Red][Red]
    dw $FFFF, $FFFF, $E7FF, $E7FF ; $CB [Grn][Grn][Red][Red]
    dw $FFFF, $EFFF, $E7FF, $E7FF ; $CC [Grn][Blu][Red][Red]
    dw $FFFF, $EFFF, $E7FF, $E7FF ; $CD [Grn][Blu][Red][Red]
    dw $FFFF, $EFFF, $E7FF, $E7FF ; $CE [Grn][Blu][Red][Red]
    dw $EFFF, $EFFF, $E7FF, $E7FF ; $CF [Blu][Blu][Red][Red] ← REHEAT!
    dw $EFFF, $EFFF, $E7FF, $E7FF ; $D0 [Blu][Blu][Red][Red]
    dw $EFFF, $EFFF, $E7FF, $E7FF ; $D1 [Blu][Blu][Red][Red]
    dw $EFFF, $EFFF, $E7FF, $E7FF ; $D2 [Blu][Blu][Red][Red]
    dw $FFFF, $EBFF, $E7FF, $E7FF ; $D3 [Grn][Yel][Red][Red]
    dw $FFFF, $EBFF, $E7FF, $E7FF ; $D4 [Grn][Yel][Red][Red]
    dw $FFFF, $EBFF, $E7FF, $E7FF ; $D5 [Grn][Yel][Red][Red]
    dw $FFFF, $EBFF, $E7FF, $E7FF ; $D6 [Grn][Yel][Red][Red]
    dw $EFFF, $EBFF, $E7FF, $E7FF ; $D7 [Blu][Yel][Red][Red] ← REHEAT!
    dw $EFFF, $EBFF, $E7FF, $E7FF ; $D8 [Blu][Yel][Red][Red]
    dw $EFFF, $EBFF, $E7FF, $E7FF ; $D9 [Blu][Yel][Red][Red]
    dw $EFFF, $EBFF, $E7FF, $E7FF ; $DA [Blu][Yel][Red][Red]
    dw $EBFF, $EBFF, $E7FF, $E7FF ; $DB [Yel][Yel][Red][Red] ← REHEAT!
    dw $EBFF, $EBFF, $E7FF, $E7FF ; $DC [Yel][Yel][Red][Red]
    dw $EBFF, $EBFF, $E7FF, $E7FF ; $DD [Yel][Yel][Red][Red]
    dw $FFFF, $E3FF, $E7FF, $E7FF ; $DE [Grn][Org][Red][Red]
    dw $FFFF, $E3FF, $E7FF, $E7FF ; $DF [Grn][Org][Red][Red]
    dw $FFFF, $E3FF, $E7FF, $E7FF ; $E0 [Grn][Org][Red][Red]
    dw $FFFF, $E3FF, $E7FF, $E7FF ; $E1 [Grn][Org][Red][Red]
    dw $EFFF, $E3FF, $E7FF, $E7FF ; $E2 [Blu][Org][Red][Red] ← REHEAT!
    dw $EFFF, $E3FF, $E7FF, $E7FF ; $E3 [Blu][Org][Red][Red]
    dw $EFFF, $E3FF, $E7FF, $E7FF ; $E4 [Blu][Org][Red][Red]
    dw $EFFF, $E3FF, $E7FF, $E7FF ; $E5 [Blu][Org][Red][Red]
    dw $EBFF, $E3FF, $E7FF, $E7FF ; $E6 [Yel][Org][Red][Red] ← REHEAT!
    dw $EBFF, $E3FF, $E7FF, $E7FF ; $E7 [Yel][Org][Red][Red]
    dw $EBFF, $E3FF, $E7FF, $E7FF ; $E8 [Yel][Org][Red][Red]
    dw $E3FF, $E3FF, $E7FF, $E7FF ; $E9 [Org][Org][Red][Red] ← REHEAT!
    dw $E3FF, $E3FF, $E7FF, $E7FF ; $EA [Org][Org][Red][Red]
    dw $E3FF, $E3FF, $E7FF, $E7FF ; $EB [Org][Org][Red][Red]
    dw $E3FF, $E3FF, $E7FF, $E7FF ; $EC [Org][Org][Red][Red]
    dw $FFFF, $E7FF, $E7FF, $E7FF ; $ED [Grn][Red][Red][Red]
    dw $FFFF, $E7FF, $E7FF, $E7FF ; $EE [Grn][Red][Red][Red]
    dw $FFFF, $E7FF, $E7FF, $E7FF ; $EF [Grn][Red][Red][Red]
    dw $FFFF, $E7FF, $E7FF, $E7FF ; $F0 [Grn][Red][Red][Red]
    dw $EFFF, $E7FF, $E7FF, $E7FF ; $F1 [Blu][Red][Red][Red] ← REHEAT!
    dw $EFFF, $E7FF, $E7FF, $E7FF ; $F2 [Blu][Red][Red][Red]
    dw $EFFF, $E7FF, $E7FF, $E7FF ; $F3 [Blu][Red][Red][Red]
    dw $EBFF, $E7FF, $E7FF, $E7FF ; $F4 [Yel][Red][Red][Red] ← REHEAT!
    dw $EBFF, $E7FF, $E7FF, $E7FF ; $F5 [Yel][Red][Red][Red]
    dw $EBFF, $E7FF, $E7FF, $E7FF ; $F6 [Yel][Red][Red][Red]
    dw $EBFF, $E7FF, $E7FF, $E7FF ; $F7 [Yel][Red][Red][Red]
    dw $E3FF, $E7FF, $E7FF, $E7FF ; $F8 [Org][Red][Red][Red] ← REHEAT!
    dw $E3FF, $E7FF, $E7FF, $E7FF ; $F9 [Org][Red][Red][Red]
    dw $E3FF, $E7FF, $E7FF, $E7FF ; $FA [Org][Red][Red][Red]
    dw $E3FF, $E7FF, $E7FF, $E7FF ; $FB [Org][Red][Red][Red]
    dw $E7FF, $E7FF, $E7FF, $E7FF ; $FC [Red][Red][Red][Red] ← REHEAT!
    dw $E7FF, $E7FF, $E7FF, $E7FF ; $FD [Red][Red][Red][Red]
    dw $E7FF, $E7FF, $E7FF, $E7FF ; $FE [Red][Red][Red][Red]
    dw $E7FF, $E7FF, $E7FF, $E7FF ; $FF [Red][Red][Red][Red] <- Missing 6

; Table size: 256 entries × 8 bytes = 2048 bytes (2KB)
; Table spans $0800 bytes

; =========================================================================
; Book of Mudora Portal System
; =========================================================================

SecretBook_exit:
RTL
SecretBook:
  AND.b #$BF : STA.b FlagBY ; code we wrote over and A is free

  LDA.b IndoorsFlag : BEQ .exit
  LDA.b RoomIndex : CMP.b #$91 : BEQ .can_portal  ; special exception for room were mechanic is introduced
  LDA.l !SecretItemFlags : AND.b #$02 : BEQ .exit

.can_portal
  ; Y button pressed indoors - check portal state
  LDA.w !BookPortalActive
  BNE .restore_to_portal ; If portal exists, teleport to it

  ; No portal exists - place one - Save current position and camera
.place_portal
  LDA.b #$03 : JSL Sprite_SpawnDynamically ; custom sprite
  BMI .exit

  REP #$20 ; we are currently in 8-bit mode , I think
  ; Save Link's position
  LDA.b LinkPosY : STA.w !BookPortalPosY
  LDA.b LinkPosX : STA.w !BookPortalPosX
  LDA.b BG2H : STA.w !BookPortalBG2H
  LDA.b BG2V : STA.w !BookPortalBG2V
  LDA.b LinkLayer : STA.w !BookPortalLinkLayer
  LDA.b BG1H : STA.w !BookPortalBG1H
  LDA.b BG1V : STA.w !BookPortalBG1V
  LDX.b #$0E
  - LDA.w $0600,X : STA.l !BookPortalCamBounds,X
    DEX : DEX : BPL -
  SEP #$20

  LDA.b LinkPosY   : STA.w SpritePosYLow,Y
  LDA.b LinkPosY+1 : STA.w SpritePosYHigh,Y
  LDA.b LinkPosX   : STA.w SpritePosXLow,Y
  LDA.b LinkPosX+1 : STA.w SpritePosXHigh,Y

  ; Mark portal as active
  INC.w !BookPortalActive
  LDA.b #$37 : JSL Sound_SetSfx2PanLong ; sword charged sfx
  BRL .skip_vanilla_sfx

.restore_to_portal
  ; Restore Link's position and camera
  REP #$20 ; we are currently in 8-bit mode , I think
  LDA.w !BookPortalPosY : STA.b LinkPosY
  LDA.w !BookPortalPosX : STA.b LinkPosX
  ; Update camera scroll triggers by the delta between portal and current camera position
  LDA.w !BookPortalBG2H : SEC : SBC.b BG2H  ; delta X = portal BG2H - current BG2H
  STA.b Scrap04
  LDA.w !BookPortalBG2V : SEC : SBC.b BG2V  ; delta Y = portal BG2V - current BG2V
  CLC : ADC.w CameraScrollN : STA.w CameraScrollN
  INC #2 : STA.w CameraScrollS              ; South = North + 2
  LDA.b Scrap04
  CLC : ADC.w CameraScrollW : STA.w CameraScrollW
  INC #2 : STA.w CameraScrollE              ; East = West + 2
  ; Restore camera positions
  LDA.w !BookPortalBG2H : STA.b BG2H
  LDA.w !BookPortalBG2V : STA.b BG2V
  LDA.w !BookPortalLinkLayer : STA.b LinkLayer
  LDA.w !BookPortalBG1H : STA.b BG1H
  LDA.w !BookPortalBG1V : STA.b BG1V
  ; Save old quadrant values before recalculation (LinkQuadrantH/V not yet updated)
  LDA.b LinkQuadrantH : STA.b Scrap02        ; old H quadrant: 0 or 1
  LDA.b LinkQuadrantV : LSR : STA.b Scrap00  ; old V quadrant: 0 or 2 -> 0 or 1
  JSR Teleport_RecalcQuadrantsAndBounds
  ; Restore camera bounds snapshot - overrides RecalcQuadrantsAndBounds adjustments
  REP #$20
  LDX.b #$0E
  - LDA.l !BookPortalCamBounds,X : STA.w $0600,X
    DEX : DEX : BPL -
  SEP #$30

  LDA.b #$0D : JSL Sound_SetSfx2PanLong ; powder sfx
  STZ.w !BookPortalActive
  LDY.b #$0F
  - LDA.w SpriteTypeTable, Y : CMP.b #$03 : BEQ .kill_portal
  DEY : BPL -
  BRA .skip_vanilla_sfx
.kill_portal
  LDA.b #$00 : STA.w SpriteAITable, Y
.skip_vanilla_sfx
  PLA : PLA : PEA.w $A482 ; skip vanilla SFX on return
RTL

SpritePrep_BookPortal:
RTL

Sprite_03_BookPortal:
LDA.w GfxChrHalfSlotVerify : CMP.b #$03 : BCS .skip_draw
  PHB : PHK : PLB
    LDA.b #$01 : STA.b Scrap06 : STZ.b Scrap07 ; number of gfx
    LDA.b FrameCounter : AND.b #$0C : ASL
    ADC.b #.oam_groups : STA.b Scrap08
    LDA.b #.oam_groups>>8 : ADC.b #$00 : STA.b Scrap09
    JSL Sprite_DrawMultiple_player_deferred
  PLB
.skip_draw
RTL
.oam_groups
dw   4,  10 : db $A6, $03, $00, $00
dw   4,  10 : db $B7, $43, $00, $00
dw   4,  10 : db $B6, $C3, $00, $00
dw   4,  10 : db $C7, $83, $00, $00

; =========================================================================
; Boomerang Damage Upgrade
; =========================================================================

SliverBoomDamageUpgrade:
  CPX.b #$05 : BNE .not_blue_boom
  LDA.l BoomerangEquipment  ; Load boomerang type
  CMP.b #$01 : BNE .not_blue_boom
  LDA.l !SecretItemFlags : AND.b #$01 : BEQ .not_blue_boom ; not yet enabled
  LDA.b $04, S : TAX
  LDA.w SpriteTypeTable, X : CMP.b #$D7 : BNE .not_ganon
  LDA.b #$20 : STA.w SpriteTimerE, X
.not_ganon
  LDA.b #$09
RTL
.not_blue_boom
  LDA.l AncillaDamageClasses, X ; original code, this function needs to exit with damage class in A
RTL

warnpc $AE8000
