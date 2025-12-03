;================================================================================
; Dungeon & Boss Drop Fixes
;--------------------------------------------------------------------------------
SpawnDungeonPrize:
        PHX : PHB

        PHA
        ; Don't spawn prize in Cave state, Hyrule Castle, Escape, Castle Tower, or Ganon's Tower
        LDA.w DungeonID : BMI .skip_prize_drop ; Cave state
        CMP.b #$00 : BEQ .skip_prize_drop ; Escape
        CMP.b #$02 : BEQ .skip_prize_drop ; Hyrule Castle
        CMP.b #$1A : BEQ .skip_prize_drop ; Ganon's Tower
        CMP.b #$08 : BEQ .skip_prize_drop ; Agahnim's Tower (Castle Tower)
        PLA

        STA.w ItemReceiptID
        TAX
        LDA.b $06,S : STA.b ScrapBuffer72 ; Store current RoomTag index
        LDA.b #$29 : LDY.b #$06

        JSL AddAncillaLong
        BCS .failed_spawn
                LDA.w ItemReceiptID
                STA.w AncillaGet,X
                JSR AddDungeonPrizeAncilla
                LDX.b ScrapBuffer72 : STZ.b RoomTag,X
        .failed_spawn
        PLB : PLX
RTL

.skip_prize_drop:
        PLA : PLB : PLX
RTL

AddDungeonPrizeAncilla:
        LDY.w ItemReceiptID
        STZ.w AncillaVelocityY,X
        STZ.w AncillaVelocityX,X
        STZ.w AncillaGeneralF,X
        STZ.w AncillaGeneralA,X
        STZ.w AncillaGeneralN,X

        LDA.b #$D0 : STA.w AncillaVelocityZ,X
        LDA.b #$80 : STA.w AncillaZCoord,X
        LDA.b #$09 : STA.w AncillaTimer,X
        LDA.b #$00 : STA.w AncillaGeneralD,X
        LDA.w AncillaGet,X : STA.w ItemReceiptID
        LDA.w DungeonID : CMP.b #$14 : BNE .not_hera
                LDA.b LinkPosY+1 : AND.b #$FE
                INC A
                STA.b Scrap01
                STZ.b Scrap00
                LDA.b LinkPosX+1 : AND.b #$FE
                INC A
                STA.b Scrap03
                STZ.b Scrap02
                BRA .set_coords_exit
        .not_hera
        TYA : ASL : TAY
        REP #$20
        LDA.w #$0078
        CLC : ADC.b BG2V
        STA.b Scrap00
        LDA.w #$0078
        CLC : ADC.b BG2H
        STA.b Scrap02
        SEP #$20

        .set_coords_exit
        LDA.b Scrap00 : STA.w AncillaCoordYLow,X
        LDA.b Scrap01 : STA.w AncillaCoordYHigh,X
        LDA.b Scrap02 : STA.w AncillaCoordXLow,X
        LDA.b Scrap03 : STA.w AncillaCoordXHigh,X
RTS

PrepPrizeTile:
        PHA : PHX : PHY
        JSL BossPrizeGetPlayer : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
        LDA.b #$01 : STA.l SpriteSkipEOR
                LDA.w AncillaGet, X
                JSL AttemptItemSubstitution
                JSL ResolveLootIDLong
                STA.w AncillaGet, X
                JSL RequestStandingItemVRAMSlot
        LDA.b #$00 : STA.l SpriteSkipEOR
        PLY : PLX : PLA
RTL

PrizeReceiveItem:
        PHA
        JSL BossPrizeGetPlayer : STA.l !MULTIWORLD_ITEM_PLAYER_ID
        PLA
        CMP.b #$6A : BNE +
                ; TODO : This doesn't increment any item counts/stats
                JML ActivateTriforceCutscene
        +
        JSL Link_ReceiveItem
        LDA.l TextBoxDefer : BEQ +
                STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
                JSL Main_ShowTextMessage_Alt
                LDA.b #$00 : STA.l TextBoxDefer
        +
RTL

SetItemPose:
        PHA
        LDA.w DungeonID : BMI .one_handed
        LDA.w RoomItemsTaken : BIT.b #$80 : BNE +
                .one_handed
                PLA
                JML Link_ReceiveItem_not_cool_pose
        +
        JSR CrystalOrPendantBehavior : BCC .one_handed
        .two_handed
        PLA
JML Link_ReceiveItem_cool_pose

SetPrizeCoords:
        PHX : PHY
        STZ.b Scrap03
        LDA.w ItemReceiptMethod : CMP.b #$03 : BEQ +
                .regular_coords
                PLY : PLX
                LDY.w AncillaGet,X
                RTL
        +
        JSR CrystalOrPendantBehavior : BCC .regular_coords
        PLY : PLX
        LDY.b #$20 ; Treat as crystal
RTL

SetCutsceneFlag:
; Out: c - Cutscene flag $02 if set, $01 if unset.
        PHX
        LDY.b #$01 ; wrote over
        LDA.w DungeonID : BMI .no_cutscene
        LDA.w RoomItemsTaken : BIT.b #$80 : BNE .dungeon_prize
                .no_cutscene
                SEP #$30
                PLX
                CLC
                RTL
        .dungeon_prize
        LDA.w ItemReceiptMethod : CMP.b #$03 : BCC .no_cutscene
                JSR SetDungeonCompleted
                LDA.w ItemReceiptID
                REP #$30
                AND.w #$00FF : ASL : TAX
                LDA.l InventoryTable_properties,X : BIT.w #$0080 : BEQ .no_cutscene
                        SEP #$31
                        PLX
RTL

AnimatePrizeCutscene:
        LDA.w ItemReceiptMethod : CMP.b #$03 : BNE +
                JSR CrystalOrPendantBehavior : BCC +
                        LDA.w DungeonID : BMI +
                        LDA.w RoomItemsTaken : BIT.b #$80 : BEQ +
                                SEC
                                RTL
        +
        CLC
RTL

PrizeDropSparkle:
        LDA.w AncillaID,X : CMP.b #$29 : BNE .no_sparkle
                JSR CrystalOrPendantBehavior : BCC .no_sparkle
                        SEC
                        RTL
        .no_sparkle
        CLC
RTL

HandleDropSFX:
        LDA.w RoomItemsTaken : BIT.b #$80 : BEQ .no_sound
                JSR CrystalOrPendantBehavior : BCC .no_sound
                        SEC
                        RTL
        .no_sound
        CLC
RTL

HandleCrystalsField:
        TAX
        LDA.w ItemReceiptID : CMP.b #$20 : BNE .not_crystal
                TXA
                STA.l CrystalsField
                RTL
        .not_crystal
RTL

MaybeKeepLootID:
        PHA
        LDA.w DungeonID : BMI .no_prize
        LDA.w RoomItemsTaken : BIT.b #$80 : BNE .prize
                .no_prize
                STZ.w ItemReceiptID
                STZ.w ItemReceiptPose
                PLA
                RTL
        .prize
        STZ.w ItemReceiptPose
        PLA
RTL

CheckSpawnPrize:
; In: A - DungeonID
; Out: c - Spawn prize if set
        REP #$20
        LDX.w DungeonID
        LDA.l DungeonItemMasks,X : AND.l DungeonsCompleted : BEQ .spawn
                SEP #$20
                CLC
                RTL
        .spawn
        SEP #$21
RTL

CheckDungeonCompletion:
        LDX.w DungeonID
        REP #$20
        LDA.l DungeonItemMasks,X : AND.l DungeonsCompleted
        SEP #$20
RTL

PendantMusicCheck:
; In: A - Item receipt ID
        PHX
        TAY
        LDA.w ItemReceiptMethod : CMP.b #$03 : BNE .dont_wait
                TYA
                REP #$30
                AND.w #$00FF : ASL : TAX
                LDA.l InventoryTable_properties,X : BIT.w #$0080 : BNE .dont_wait
                        SEP #$31
                        PLX
                        RTL
        .dont_wait
        SEP #$30
        PLX
        CLC
RTL

PrepPrizeOAMCoordinates:
        PHX : PHY
        LDY.w AncillaLayer,X

        LDA.w $F67F,Y : STA.b $65
        STZ.b $64

        LDA.w AncillaCoordYLow,X : STA.b Scrap00
        LDA.w AncillaCoordYHigh,X : STA.b Scrap01
        LDA.w AncillaCoordXLow,X : STA.b Scrap02
        LDA.w AncillaCoordXHigh,X : STA.b Scrap03

        REP #$20
        LDA.b Scrap00
        SEC : SBC.w $0122
        STA.b Scrap00

        LDA.b Scrap02
        SEC : SBC.w $011E
        STA.b Scrap02
        STA.b Scrap04

        LDA.w AncillaZCoord,X
        AND.w #$00FF
        STA.b ScrapBuffer72

        LDA.b Scrap00
        STA.b Scrap06
        SEC
        SBC.b ScrapBuffer72
        STA.b Scrap00

        JSL PrepAncillaAnimation
        TXY
        LDA.w AncillaGet,Y : AND.w #$00FF : PHA
        REP #$10
                ASL : TAX
                LDA.l VRAMAddressOffset,X : STA.b Scrap0C
                CLC : ADC.w #$0010 : STA.b Scrap0D
        PLX
        SEP #$10
        PHX
                ; special animation handling
                CPX.b #$D2 : BNE + ; fairy
                        LDX.w AncillaDirection,Y : BEQ ++ : CPX.b #$03 : BEQ ++ ; use other fairy GFX
                                LDA.b Scrap0C : CLC : ADC.w #$0002 : STA.b Scrap0C
                                CLC : ADC.w #$0010 : STA.b Scrap0D
                        ++ CPX.b #$02 : BCC .check_width ; move fairy up 2 pixels
                                LDA.b Scrap00 : SEC : SBC.w #$0002 : STA.b Scrap00
                                BRA .check_width
                + CPX.b #$D6 : BNE + ; good bee
                        LDA.b Scrap0C : AND.w #$FF00 : ORA.w #$007C : STA.b Scrap0C ; use blank GFX for high VRAM
                        LDX.w AncillaDirection,Y : BEQ ++ : CPX.b #$03 : BEQ ++ ; use other bee GFX
                                LDA.b Scrap0D : SEC : SBC.w #$0010 : STA.b Scrap0D
                        ++ CPX.b #$02 : BCC + ; move bee up 2 pixels
                                LDA.b Scrap00 : SEC : SBC.w #$0002 : STA.b Scrap00
                +
        
        .check_width
        PLX
        SEP #$20
        LDA.l SpriteProperties_chest_width,X : BNE .wide
                TYX
                LDA.w AncillaID,X : CMP.b #$3E : BEQ .rising_crystal
                        REP #$20
                        LDA.b Scrap00
                        CLC : ADC.w #$0008
                        STA.b Scrap08
                        LDA.b Scrap02
                        CLC : ADC.w #$0004
                        STA.b Scrap02 : STA.b Scrap0A
                        BRA .wide
                .rising_crystal
                REP #$20
                LDA.b Scrap00
                CLC : ADC.w #$0008 : STA.b Scrap08
                LDA.b Scrap02 : STA.b Scrap0A
        .wide
        SEP #$20
        PLY : PLX
RTL

PrepPrizeVRAMHigh:
        PHX
                LDX.b #$00
                JSL PrepPrizeVRAM : BCS .store
                        LDA.b #$24
                .store
                STA.b ($90),Y
        PLX
RTL

PrepPrizeVRAMLow:
        PHX
                LDX.b #$01
                JSL PrepPrizeVRAM : BCS .store
                        LDA.b #$34
                .store
                STA.b ($90),Y
        PLX
RTL

PrepPrizeVRAM:
        PHY
                LDA.b 9,S : TAY
                LDA.w AncillaID,Y : CMP.b #$29 : BEQ +
                        PLY : CLC : RTL  ; not a prize drop ancilla
                + LDA.b Scrap0C,X : CMP.b #$24 : BEQ + : CMP.b #$34 : BEQ +
                        PLY : SEC : RTL  ; in vanilla VRAM
                +
                ; use dynamic VRAM slot
                PHX
                        LDA.w SprItemGFXSlot,Y : ASL : TAX
                        REP #$20
                        LDA.l FreeUWGraphics,X : LSR #4
                PLX
                CPX.b #$01 : BNE +
                        CLC : ADC.w #$0010
                +
                SEP #$20
        PLY : SEC
RTL

PrepPrizeShadow:
        PHX
        LDA.b 5,S : TAX : LDA.w AncillaGet,X : TAX
        LDA.l SpriteProperties_standing_width,X : BNE .wide
                LDA.b Scrap02
                SEC : SBC.b #$04
                STA.b Scrap02
                PLX : LDX.b #$02
                BRA .wide+1
        .wide
        PLX
        LDA.b #$20 : STA.b Scrap04 ; What we wrote over
RTL

CheckPoseItemCoordinates:
        PHX
        LDA.w SprRedrawFlag,X : BEQ +
                JSL BossPrizeGetPlayer : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
                LDA.b #$01 : STA.l SpriteSkipEOR
                LDA.w AncillaGet,X
                JSL RequestStandingItemVRAMSlot
                LDA.b #$00 : STA.l SpriteSkipEOR
        +
        LDA.w ItemReceiptPose : BEQ .done
                   BIT.b #$02 : BEQ .done
                LDA.w AncillaGet,X : TAX
                LDA.l SpriteProperties_chest_width,X : BNE .done
                        LDA.b Scrap02
                        CLC : ADC.b #$04
                        STA.b Scrap02
        .done
        PLX
        LDA.w AncillaGet,X
        TAX
RTL

CrystalOrPendantBehavior:
; Out: c - Crystal Behavior if set, pendant if unset
        PHA : PHX
        LDA.w AncillaGet,X
        REP #$31
        AND.w #$00FF : ASL : TAX
        LDA.l InventoryTable_properties,X : BIT.w #$0080 : BNE .crystal_behavior
                SEP #$30
                LDA.w ItemReceiptPose : BEQ +
                        LDA.b #$02 : STA.b LinkDirection
                +
                PLX : PLA
                RTS
        .crystal_behavior
        SEP #$31
        PLX : PLA
RTS

CheckDungeonWorld:
; Maintain vanilla door opening behavior with dungeon prizes
        TXA : CMP.b #$05 : BCS .dark_world
                REP #$02
                RTL
        .dark_world
        SEP #$02
RTL

SetDungeonCompleted:
        LDX.w DungeonID : BMI +
                REP #$20
                LDA.l DungeonItemMasks, X : ORA.l DungeonsCompleted : STA.l DungeonsCompleted
                SEP #$20
        +
RTS

MaybeSkipHeartRefill:
        LDA.w CurrentControlRequest : CMP.b #$13 : BNE .vanilla
        LDA.l HeartPieceQuarter : BNE +
                ; increase health
                LDA.l MaximumHealth : CMP.b #$A0 : BEQ .reset_skip
                CLC : ADC.b #$08 : STA.l MaximumHealth
        +
        .reset_skip
        LDA.b #$00 ; just to ensure the MaximumHealth doesn't flow outside
        BRA .skip

        .vanilla
        LDA.l HeartPieceQuarter : BEQ .do ; what we wrote over
.skip
CLC
RTL
.do
SEC
RTL

ClearMultiworldText:
        PHP : PHX 
                SEP #$30
                LDA.l !MULTIWORLD_HUD_TIMER : BEQ +
                        LDA.b #$01 : STA.l !MULTIWORLD_HUD_TIMER
                        JSL GetMultiworldItem
                +
        PLX : PLP
RTL 

MaybeSkipCrystalCutsceneFollowerReset:
PHA
        LDA.l FollowerTravelAllowed : CMP.b #$02 : BEQ .skip
        ; skip if prizes are shuffled outside of normal boss drops
        LDA.l InventoryTable_properties+($37*2) : AND.b #$01 : BEQ .continue
.skip
PLA : PLA : PLA : PLA
JML CrystalCutscene_SpawnMaiden_PostFollowerGfx
.continue
PLA
STA.l FollowerIndicator ; what we wrote over
RTL
