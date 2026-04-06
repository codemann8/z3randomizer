org $aa8000 ;150000
db $4f, $52 ;OR
OWMode:
dw 0
OWFlags:
dw 0
OWReserved:
dw 0
OWFog:
db 0 ; 0: disabled - 1: fog clears after visiting either world version of a screen - 2: fog clears after visiting the current world version of a screen
org $aa8010
OWVersionInfo:
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

;Hooks
org $82a92C
JSL OWDetectEdgeTransition ; JSL Link_CheckForEdgeScreenTransition

org $82a936
OverworldHandleTransitions_PerformEdgeTransition:

org $82a999
jsl OWEdgeTransition : nop #4 ;LDA $02A4E3,X : ORA $7EF3CA

org $82aa07
JSL OWMarkVisited : NOP

org $84e8ae
Overworld_DoSpecialOverworldTrigger:
JSL OWDetectSpecialTransition
RTL : NOP

org $82e809
JSL OWSpecialExit

org $82bfe8
JSL OWAdjustExitPosition

org $82c1a9
JSL OWEndScrollTransition

org $84E881
Overworld_LoadSpecialOverworld_RoomId:
org $84E8B4
Overworld_LoadSpecialOverworld:

org $84E96A
JSL OWSpecialReturnTriggerClear

org $82A9DA
JSL OWSkipPalettes
BCC OverworldHandleTransitions_change_palettes : NOP #4

org $87982A
Link_ResetSwimmingState:


; mirror hooks
org $8283DC ; override world check when spawning mirror portal sprite in Crossed OWR
jsl OWLightWorldOrCrossed
org $85AF75
Sprite_6C_MirrorPortal:
jsl OWMirrorSpriteDisable ; LDA $7EF3CA
org $85AF88
jsl OWMirrorSpriteSkipDraw : NOP ; LDA.w $0FC6 : CMP.b #$03
org $85AFDF
Sprite_6C_MirrorPortal_missing_mirror:
org $8ABFB6
jsl OWMirrorSpriteOnMap : NOP ; LDA.w $008A : CMP.b #$40

; whirlpool shuffle cross world change
org $82b3bd
jsl OWWhirlpoolUpdate ;JSL $02EA6C
org $82B44E
jsl OWWhirlpoolEnd ; STZ.b $11 : STZ.b $B0

; flute menu cancel
org $8ab7af ;LDA $F2 : ORA $F0 : AND #$C0
jml OWFluteCancel2 : nop
org $8ab90d ;JSL $02E99D
jsl OWFluteCancel

; allows Frog sprite to spawn in LW and also allows his friend to spawn in their house
org $868a76 ; < 30a76 - sprite_prep.asm:785 (LDA $7EF3CA : AND.w #$40)
lda.b IndoorsFlag : eor.b #1 : nop #2

; allows Frog to be accepted at Blacksmith
org $86b3ee ; < 333ee - sprite_smithy_bros.asm:347 (LDA $7EF3CC : CMP.b #$08 : BEQ .no_returning_smithy_tagalong)
jsl OWSmithAccept : nop #2
db #$b0 ; BCS to replace BEQ

; load Stumpy per screen's original world, not current world flag
org $86907f ; < 3107f - sprite_prep.asm:2170 (LDA $7EF3CA)
lda.b OverworldIndex : and.b #$40

; override Link speed with Old Man following
org $89a32e ; < bank_09.asm:7457 (LDA.b #$0C : STA.b $5E)
jsl OWOldManSpeed

; Dark Bonk Rocks Rain Sequence Guards (allowing Tile Swap on Dark Bonk Rocks)
;org $89c957 ; <- 4c957
;dw #$cb5f ; matches value on Central Bonk Rocks screen

; override world check when viewing overworld (incl. title screen portion)
org $8aba6c  ; < ? - Bank0a.asm:474 ()
jsl OWMapWorldCheck16 : nop

; Custom Overworld Map
org $8ABA52
JSL OverworldMap_InitGfx_InitScrap

org $8ABA99
WorldMap_LoadDarkWorldMap:
LDA.b GameMode : CMP.b #$14 ; attract module
BEQ .vanilla_light
    LDA.l OWFlags : AND.b #!FLAG_OW_CUSTOM_MAP : BNE .custom
        LDA.b OverworldIndex : AND.b #$40
        BEQ .vanilla_light
    .custom
    STZ.b ScrapBuffer72 ; clear tile swap flag
    JSL LoadMapDarkOrCustom_long
    NOP #2
warnpc $8ABAB5
.vanilla_light ; $0ABAB5

org $8ABD12
JSL MoveZoomedInPositionY
org $8ABD2F
JSL MoveZoomedInPositionX

org $8ABB32
JSL LoadMapOppositeWorld

org $8ABFF0
JSL MoveMirrorPortalMapSprite
; Could insert similar hooks at $8AB860 and $8AB8AC for flute spots

;(replacing -> LDA $8A : AND.b #$40)
org $80d8c4  ; < ? - Bank00.asm:4068 ()
jsl OWWorldCheck
org $82aa36  ; < ? - Bank02.asm:6559 ()
jsl OWWorldCheck
org $82aeca  ; < ? - Bank02.asm:7257 ()
jsl OWWorldCheck16 : nop
org $82b349  ; < ? - Bank02.asm:7902 ()
jsl OWWorldCheck
org $82c40a  ; < ? - Bank02.asm:10547 ()
jsl OWWorldCheck
org $85afd9  ; < ? - sprite_warp_vortex.asm:60 ()
jsl OWWorldCheck
org $87a3f0  ; < ? - Bank07.asm:5772 () ; flute activation/use
jsl OWWorldCheck
org $87a967  ; < ? - Bank07.asm:6578 ()
jsl OWWorldCheck
org $87a9a1  ; < ? - Bank07.asm:6622 ()
jsl OWWorldCheck
org $87a9ed  ; < ? - Bank07.asm:6677 ()
jsl OWWorldCheck
org $87aa34  ; < ? - Bank07.asm:6718 ()
jsl OWWorldCheck
org $88d408  ; < ? - ancilla_morph_poof.asm:48 ()
jsl OWWorldCheck
org $8bfeab  ; < ? - Bank0b.asm:36 ()
jsl OWWorldCheck16 : nop
org $8cffb6  ; < ? - ?.asm ? ()
jsl OWWorldCheck16 : nop
org $8cffe8  ; < ? - ?.asm ? ()
jsl OWWorldCheck16 : nop
org $9beca2  ; < ? - palettes.asm:556 ()
jsl OWWorldCheck16 : nop
org $9bed95  ; < ? - palettes.asm:748 ()
jsl OWWorldCheck16 : nop

org $82B16C  ; LDA $8A : AND #$3F : ORA 7EF3CA
JSL OWApplyWorld : BRA + : NOP #2 : +

org $89C3C4
jsl OWBonkDropPrepSprite : nop #2
org $89C801
jsl OWBonkDropPrepSprite : nop #2
org $86D052
jsl OWBonkDropSparkle
org $86AD49
jsl OWBonkDropsOverworld : nop
org $9EDE6A
jsl OWBonkDropSparkle : BNE GoldBee_Dormant_exit
jsl OWBonkDropsUnderworld : bra +
GoldBee_SpawnSelf_SetProperties:
phb : lda.b #$1E : pha : plb ; switch to bank 1E
    jsr GoldBee_SpawnSelf+12
plb : rtl
nop #2
+

;Code
org $aa8800
OWTransitionDirection:
dw 3, 2, 1, 0 ; $02 after $02A932
OWEdgeDataOffset:
dw OWSouthEdges, OWEastEdges, OWSouthEdges
OWCoordIndex: ; Horizontal 1st
db 2, 2, 0, 0 ; Coordinate Index $20-$23
OWOppCoordIndex: ; Horizontal 1st
db 0, 0, 2, 2 ; Coordinate Index $20-$23
OWBGIndex: ; Horizontal 1st
db 0, 0, 6, 6 ; BG Scroll Index $e0-$eb
OWOppBGIndex: ; Horizontal 1st
db 6, 6, 0, 0 ; BG Scroll Index $e0-$eb
OWCameraIndex: ; Horizontal 1st
db 4, 4, 0, 0 ; Camera Index $0618-$61f
OWOppCameraIndex: ; Horizontal 1st
db 0, 0, 4, 4 ; Camera Index $0618-$61f
OWOppSlotOffset: ; Amount to offset OW Slot
db 8, -8, 1, -1 ; OW Slot x2 $700
OWOppDirectionOffset: ; Amount to offset coord calc
db $10, $f0, $02, $fe
OWCameraRangeIndex:
db 2, 2, 0, 0 ; For OWCameraRange
OWCameraRange:
dw $011E, $0100 ; Length of the range the camera can move on small screens
OWAutoWalk:
db $04, $08, $01, $02

DivideByTwoPreserveSign:
{
    asl : php : ror : plp : ror : rtl
}

OWWorldCheck:
{
    phx
        ldx.b OverworldIndex : lda.l OWTileWorldAssoc,x
    plx : and.b #$ff : rtl
}
OWWorldCheck16:
{
    phx
        ldx.b OverworldIndex : lda.l OWTileWorldAssoc,x
    plx : and.w #$00ff : rtl
}
OWMapWorldCheck16:
{
    lda.b GameMode : cmp.w #$0014 : beq .return ; attract module, return with Z flag cleared
        jsl OWWorldCheck16
        eor.b ScrapBuffer72 ; apply tile swap flag
    .return
    rtl
}
OWApplyWorld:
{
    LDX.b OverworldIndex

    .fromScreen
    LDA.l OWTileWorldAssoc,X : CMP.l CurrentWorld : BEQ .keepWorld ; if dest screen mismatches the current world
        TXA : EOR.b #$40 : RTL

    .keepWorld
    TXA : RTL
}

OWWhirlpoolUpdate:
{
    jsl FindPartnerWhirlpoolExit ; what we wrote over
    ldx.b OverworldIndex : ldy.b #$03 : jsr OWWorldTerrainUpdate
    rtl
}

OWWhirlpoolEnd:
{
    STZ.b SubSubModule ; what we wrote over
    LDA.w RandoOverworldForceTrans : BEQ .normal
        LDA.b #$3C : STA.w SFX2 ; play error sound before forced transition
        RTL
    .normal
    STZ.b GameSubMode ; end whirlpool transition
    RTL
}

OWDestroyItemSprites:
{
    PHX : LDX.b #$0F
    .nextSprite
    LDA.w SpriteTypeTable,X
    CMP.b #$D8 : BCC .continue
    CMP.b #$EC : BCS .continue
    .killSprite ; need to kill sprites from D8 to EB on screen transition
    STZ.w SpriteAITable,X
    .continue
    DEX : BPL .nextSprite
    PLX : RTL
}

OWMirrorSpriteOnMap:
{
    JSL OWWorldCheck
    CMP.b #$40 ; part of what we wrote over
    RTL
}
OWMirrorSpriteDisable:
{
    LDA.b GameMode : CMP.b #$0F : BNE +  ; avoid rare freeze during mirror superbunny
	    PLA : PLA : PLA : JML Sprite_6C_MirrorPortal_missing_mirror
	+ 

    lda.l OWMode+1 : and.b #!FLAG_OW_CROSSED : beq .vanilla
        lda.l InvertedMode : beq +
            lda.b #$40
        + rtl
    
    .vanilla
    lda.l CurrentWorld ; what we wrote over
    rtl
}
OWMirrorSpriteSkipDraw:
{
    lda.l OWMode+1 : and.b #!FLAG_OW_CROSSED : beq .vanilla
        lda.l InvertedMode : beq +
            lda.l CurrentWorld : eor.b #$40
            bra ++
        + lda.l CurrentWorld : ++ beq .vanilla
            stz.w SpriteMovement,x ; disables collision
            sec : rtl
    
    .vanilla
    LDA.w GfxChrHalfSlotVerify : CMP.b #$03 ; what we wrote over
    RTL
}
OWLightWorldOrCrossed:
{
    lda.l OWMode+1 : and.b #!FLAG_OW_CROSSED : beq ++
        lda.l InvertedMode : beq +
            lda.b #$40
        + rtl
    ++ jsl OWWorldCheck : rtl
}

OWFluteCancel:
{
    lda.l OWFlags+1 : and.b #$01 : bne +
        jsl FluteMenu_LoadTransport : rtl
    + lda.w RandoOverworldTargetEdge : bne +
        jsl FluteMenu_LoadTransport
    + stz.w RandoOverworldTargetEdge : rtl
}
OWFluteCancel2:
{
    lda.b Joy1B_All : ora.b Joy1A_All : and.b #$c0 : bne +
        jml FluteMenu_HandleSelection_NoSelection
    + inc.w SubModuleInterface
    lda.l OWFlags+1 : and.b #$01 : beq +
    lda.b Joy1B_All : cmp.b #$40 : bne +
        lda.b #$01 : sta.w RandoOverworldTargetEdge
    + rtl 
}
OWMapFluteCancelIcon:
{
    LDA.b #$02 : STA.b Scrap0B ; what we wrote over
    LDA.l OWFlags+1 : AND.b #$01 : BEQ .return
	LDA.b GameSubMode : CMP.b #$0A : BNE .return
    LDA.b FrameCounter : AND.b #$10 : BNE .return
        LDA.b #$7E : STA.b Scrap0D
        LDA.b #$34 : STA.b Scrap0C
        STZ.b Scrap0B
        LDA.b Scrap0E : CLC : ADC.b #$04 : STA.b Scrap0E
        LDA.b Scrap0F : CLC : ADC.b #$04 : STA.b Scrap0F
    .return
    RTL
}
OWSmithAccept:
{
    lda.l FollowerIndicator : cmp.b #$07 : beq +
    cmp.b #$08 : beq +
        clc : rtl
    + sec : rtl
}
OWOldManSpeed:
{
    lda.b IndoorsFlag : beq .outdoors
        lda.b RoomIndex : and.b #$fe : cmp.b #$f0 : beq .vanilla ; if in cave where you find Old Man
        bra .normalspeed
    .outdoors
        lda.b OverworldIndex : cmp.b #$03 : beq .vanilla ; if on WDM screen

    .normalspeed
    lda.b LinkSpeed : cmp.b #$0c : rtl
        stz.b LinkSpeed : rtl

    .vanilla
    lda.b #$0c : sta.b LinkSpeed ; what we wrote over
    rtl
}
OWMarkVisited:
{
    LDX.b OverworldIndex : STZ.w $0412 ; what we wrote over
    LDA.b GameMode : CMP.b #$14 : BCS .return
        LDA.l OverworldEventDataWRAM,X
        ORA.b #$80 : STA.l OverworldEventDataWRAM,X

    .return
    RTL
}

LoadMapDarkOrCustom:
{
    CMP.b #!FLAG_OW_CUSTOM_MAP : REP #$30 : BEQ .custom
        LDX.w #$03FE ; draw vanilla Dark World (what we wrote over)
        .copy_next
            LDA.w WorldMap_DarkWorldTilemap,X : STA.w GFXStripes,X
            DEX : DEX : BPL .copy_next
        BRL .end
    .custom
        LDX.b OverworldIndex
        LDA.l OWTileWorldAssoc,X
        AND.w #$0040
        EOR.b ScrapBuffer72 ; apply tile swap flag
        BEQ .draw_lw
            LDA.w #OWMapGridDark
            BRA .draw_dw
        .draw_lw
            LDA.w #OWMapGridLight
        .draw_dw
        STA.b Scrap00
        LDA.w #OWMapGridLight>>16 ; current program bank
        STA.b Scrap02
        LDX.w #$139C
        LDY.w #$003F
        .next_cell
            PHY
            JSR GetOWMapTilemapOffsetToCopy
            .copy_cell ; more efficient to have X on the right side
            TAY
            LDA.w WorldMap_LightWorldTilemap+$00,Y : STA.b $00,X
            LDA.w WorldMap_LightWorldTilemap+$02,Y : STA.b $02,X
            LDA.w WorldMap_LightWorldTilemap+$20,Y : STA.b $20,X
            LDA.w WorldMap_LightWorldTilemap+$22,Y : STA.b $22,X
            LDA.w WorldMap_LightWorldTilemap+$40,Y : STA.b $40,X
            LDA.w WorldMap_LightWorldTilemap+$42,Y : STA.b $42,X
            LDA.w WorldMap_LightWorldTilemap+$60,Y : STA.b $60,X
            LDA.w WorldMap_LightWorldTilemap+$62,Y : STA.b $62,X
            PLY
            DEX : DEX : DEX : DEX ; move one screen left
            TYA : AND.w #$0007 : BNE .same_row
                TXA : SEC : SBC.w #$0060 : TAX ; move one screen row up
            .same_row
            DEY
        BPL .next_cell
    .end
    SEP #$30
    LDA.b #$15 : STA.b NMIINCR ; what we wrote over
    RTS
}

GetOWMapTilemapOffsetToCopy:
{
    LDA.l OWFog : AND.w #$00FF
    CMP.w #$0001 : BEQ .parallel_fog
    CMP.w #$0002 : BNE .no_fog

    LDA.b [Scrap00],Y : AND.w #$00FF
    PHX
    TAX
    BIT.w #$0040
    BEQ .light_fog
        LDA.l Overworld_ActualScreenID-$40,X : ORA.w #$0040
        BRA .dark_fog
    .light_fog
        LDA.l Overworld_ActualScreenID,X
    .dark_fog
    AND.w #$00FF
    TAX
    LDA.l OverworldEventDataWRAM,X
    .check_visited_flag
    PLX
    AND.w #$0080 : BNE .no_fog
    LDA.w #($D350-$C739)
    RTS

    .parallel_fog
    LDA.b [Scrap00],Y : AND.w #$003F
    PHX
    TAX
    LDA.l Overworld_ActualScreenID,X
    AND.w #$00FF
    TAX
    LDA.l OverworldEventDataWRAM,X
    ORA.l OverworldEventDataWRAM+$40,X
    BRA .check_visited_flag

    .no_fog
    LDA.b [Scrap00],Y : AND.w #$0038 : ASL : ASL : ASL : ASL
    STA.b Scrap03
    LDA.b [Scrap00],Y
    BIT.w #$0040
    BEQ .light
        AND.w #$0007
        ASL : ASL : ADC.w #$1000 : ADC.b Scrap03
        RTS
    .light
    PHX
    AND.w #$0024 : LSR : TAX
    LDA.b [Scrap00],Y
    AND.w #$0007
    ASL : ASL : ADC.w #$1000 : ADC.b Scrap03
    SEC : SBC.l LWQuadrantOffsets,X
    PLX
    RTS

    LWQuadrantOffsets:
    dw $1000-$0210 ; top left
    dw $0C00-$01F0 ; top right
    dw 0,0,0,0,0,0
    dw $0800+$01F0 ; bottom left
    dw $0400+$0210 ; bottom right
}

OverworldMap_InitGfx_InitScrap:
{
    STZ.b ScrapBuffer72 ; clear tile swap flag
    LDA.b #$11 : STA.b MAINDESQ ; what we wrote over
    RTL
}
LoadMapDarkOrCustom_long:
{
    PHB : LDA.b #WorldMap_DarkWorldTilemap>>16 : PHA : PLB
        LDA.l OWFlags : AND.b #!FLAG_OW_CUSTOM_MAP
        JSR LoadMapDarkOrCustom
    PLB
    RTL
}
LoadMapOppositeWorld:
{
    LDA.l OWFlags : AND.b #!FLAG_OW_ADJUST_DYNAMIC_MAP_SPRITE_POSITION : BEQ .vanilla
    LDA.b ScrapBuffer72 : BEQ +
        LDA.b Joy1B_All : AND.b #$30 : BNE .vanilla
            STZ.b ScrapBuffer72 ; clear tile swap flag
            BRA .new_tiles
    + LDA.b Joy1B_New : AND.b #$30 : BEQ .vanilla
        LDA.b #$40 : STA.b ScrapBuffer72 ; set tile swap flag
.new_tiles
    JSL OverworldMap_InitGfx+$10 ; load palette
        DEC.w SubModuleInterface
        LDA.b #$0F : STA.b INIDISPQ
    JSL LoadMapDarkOrCustom_long
    LDA.b #$24 : STA.w SFX3
    PLA : PLA : PEA.w $BBAF ; skip everything upon return
.vanilla
    LDA.b Joy1B_New : AND.b #$70 ; what we wrote over
    RTL
}
FluteMenu_MoveLinkSprite:
{
    JSR MoveMapSprite
    BRA WorldMap_SkipHandleSprites_vanilla
}
WorldMap_SkipHandleSprites:
{
    JSR MoveMapSprite : BEQ .vanilla
    LDA.b ScrapBuffer72 : BEQ .vanilla ; skip draw if no tile swap
        PLA : PLA : PEA.w $C39B ; exit without drawing sprites
    RTL 
.vanilla
    LDA.b FrameCounter : AND.b #$10 ; what we wrote over
    RTL
}

MoveMirrorPortalMapSprite:
{
    STA.l $7EC109 ; what we overwrote
    JSR MoveMapSprite
    RTL
}

MoveZoomedInPositionY:
{
    LDA.l OWFlags : AND.w #!FLAG_OW_ADJUST_DYNAMIC_MAP_SPRITE_POSITION : BEQ .vanilla
        SEP #$20
        JSR MoveMapSprite_Setup
        JSR MoveMapSprite_GetYCoordHighByte
        PHA
            REP #$20
            LDA.l $7EC108 : XBA
            SEP #$20
        PLA : XBA
        REP #$20
        RTL
.vanilla
    LDA.l $7EC108 ; what we overwrote
    RTL
}
MoveZoomedInPositionX:
{
    LDA.l OWFlags : AND.w #!FLAG_OW_ADJUST_DYNAMIC_MAP_SPRITE_POSITION : BEQ .vanilla
        SEP #$20
        JSR MoveMapSprite_Setup
        JSR MoveMapSprite_GetXCoordHighByte
        PHA
            REP #$20
            LDA.l $7EC10A : XBA
            SEP #$20
        PLA : XBA
        REP #$20
        RTL
.vanilla
    LDA.l $7EC10A ; what we overwrote
    RTL
}

MoveMapSprite:
{
    LDA.l OWFlags : AND.b #!FLAG_OW_ADJUST_DYNAMIC_MAP_SPRITE_POSITION : BEQ .return
    PHP
        JSR MoveMapSprite_Setup
        JSR MoveMapSprite_GetXCoordHighByte : STA.l $7EC10B
        JSR MoveMapSprite_GetYCoordHighByte : STA.l $7EC109
    PLP
    .return
    RTS
}
MoveMapSprite_Setup:
{
    LDA.l $7EC10B : AND.b #$0E : LSR
    STA.b Scrap00
    LDA.l $7EC109 : AND.b #$0E : ASL : ASL
    ADC.b Scrap00
    STA.b Scrap00
    LDX.b OverworldIndex
    LDA.l OWTileWorldAssoc,X
    LDX.b Scrap00
    AND.b #$40
    BEQ .light
        LDA.l OWMapGridDarkPositionByAbsolutePosition,X
        BRA .dark
    .light
        LDA.l OWMapGridLightPositionByAbsolutePosition,X
    .dark
    TAX
    AND.b #$07 : ASL
    STA.b Scrap00
    RTS
}
MoveMapSprite_GetXCoordHighByte:
{
    LDA.l $7EC10B : AND.b #$01 : ORA.b Scrap00
    RTS
}
MoveMapSprite_GetYCoordHighByte:
{
    TXA : AND.b #$38 : LSR : LSR : STA.b Scrap00
    LDA.l $7EC109 : AND.b #$01 : ORA.b Scrap00
    RTS
}

OWBonkDropPrepSprite:
{
    LDA.b IndoorsFlag : BEQ +
        LDA.w $0FB5 ; what we wrote over
        PHA
        BRA .continue
    +
    STZ.w SpriteLayer,X : STZ.w SpriteAux,X ; what we wrote over
    PHA

    .continue
    LDA.l OWFlags+1 : AND.b #!FLAG_OW_BONKDROP : BEQ .return
        + LDA.w SpriteTypeTable,X : CMP.b #$D9 : BNE +
            LDA.b #$03 : STA.w SpriteLayer,X
            BRA .prep
        + CMP.b #$B2 : BEQ .prep
        PLA : RTL
    
    .prep
    STZ.w SprRedrawFlag,X
    PHB : PHK : PLB : PHY
        TXY : JSR OWBonkDropLookup : BCC .done
            ; found match ; X = rec + 1
            INX : LDA.w OWBonkPrizeData,X : PHA
            JSR OWBonkDropCollected : PLA : BCC .done
                TYX : LDA.b #$01 : STA.w SprRedrawFlag,X
    .done
    TYX : PLY : PLB
    
    .return
    PLA : RTL
}

OWBonkDropSparkle:
{
    LDA.l OWFlags+1 : AND.b #!FLAG_OW_BONKDROP : BEQ .nosparkle
    LDA.w SpriteAuxB,X : BEQ .nosparkle
    LDA.w SprRedrawFlag,X : BNE .nosparkle
    LDA.b GameMode : CMP.b #$0E : BEQ .nosparkle
    LDA.b LinkState : CMP.b #$08 : BCC + : CMP.b #$0A+1 : BCS + : BRA .nosparkle : + ; skip if we're mid-medallion
        JSL Sprite_SpawnSparkleGarnish
        ; move sparkle down 1 tile
        PHX : TYX : PLY
        LDA.l $7FF81E,X : CLC : ADC.b #$10 : STA.l $7FF81E,X
        LDA.l $7FF85A,X : ADC.b #$00 : STA.l $7FF85A,X
        PHY : TXY : PLX

    .nosparkle
    LDA.w SpriteTypeTable,X : CMP.b #$D9 : BEQ .greenrupee
    CMP.b #$B2 : BEQ .goodbee
    RTL

    .goodbee
    LDA.w SpriteAuxB,X ; what we wrote over
    RTL

    .greenrupee
    JSL Sprite_DrawRippleIfInWater ; what we wrote over
    RTL
}

OWBonkDropsUnderworld:
{
    LDA.l OWFlags+1 : AND.b #!FLAG_OW_BONKDROP : BNE .shuffled
        .vanilla ; what we wrote over
        STZ.w SpriteAITable,X
        LDA.l BottleContentsOne : ORA.l BottleContentsTwo
            ORA.l BottleContentsThree : ORA.l BottleContentsFour
        RTL

    .shuffled
    LDA.w SpriteAITable,X : BNE +
        BRA .return+1
    + PHY : TXY
    JSL OWBonkDrops

    .return
    PLY
    LDA.b #$08 ; makes original good bee not spawn
    RTL
}

OWBonkDropsOverworld:
{
    LDA.l OWFlags+1 : AND.b #!FLAG_OW_BONKDROP : BNE .shuffled
        BRA .vanilla

    .shuffled
    LDA.w SpriteAITable,Y : BNE +
        BRA .vanilla
    + LDA.w SpriteTypeTable,Y : CMP.b #$D9 : BEQ +
        BRA .vanilla+3
    +
    LDA.b #$00 : STA.w SpriteLayer,Y ; restore proper layer
    JSL OWBonkDrops

    .vanilla
    LDA.w SpriteTypeTable,Y : CMP.b #$D8 ; what we wrote over
    RTL
}

OWBonkDrops:
{
    PHB : PHK : PLB
    LDA.b IndoorsFlag : BEQ +
        LDX.b #((UWBonkPrizeData-OWBonkPrizeData)+1)
        BRA .found_match
    +
    JSR OWBonkDropLookup : BCS .found_match
        JMP .return+2

    .found_match
    INX : LDA.w OWBonkPrizeData,X : PHX : PHA ; S = FlagBitmask, X (row + 2)
    JSR OWBonkDropCollected : PHA : BCS .load_item_and_mw ; S = Collected, FlagBitmask, X (row + 2)
        LDA.b #$1B : STA.w SFX3 ; JSL Sound_SetSfx3PanLong ; seems that when you bonk, there is a pending bonk sfx, so we clear that out and replace with reveal secret sfx
        ; JSLSpriteSFX_QueueSFX3WithPan
    
    .load_item_and_mw
    LDA.b 3,S : TAX : INX : LDA.w OWBonkPrizeData,X
    PHA : INX : LDA.w OWBonkPrizeData,X : BEQ +
        ; multiworld item
        DEX : PLA ; A = item id; X = row + 3
        JMP .spawn_item
    + DEX : PLA ; A = item id; X = row + 3

    .determine_type ; A = item id; X = row + 3; S = Collected, FlagBitmask, X (row + 2)
    CMP.b #$D0 : BNE +
        LDA.b #$79 : JMP .sprite_transform ; transform to bees
    + CMP.b #$42 : BNE +
        JSL Sprite_TransmuteToBomb ; transform a heart to bomb, vanilla behavior
        JMP .mark_collected
    + CMP.b #$34 : BNE +
        LDA.b #$D9 : JMP .sprite_transform ; transform to single rupee
    + CMP.b #$35 : BNE +
        LDA.b #$DA : JMP .sprite_transform ; transform to blue rupee
    + CMP.b #$36 : BNE +
        LDA.b #$DB : BRA .sprite_transform ; transform to red rupee
    + CMP.b #$27 : BNE +
        LDA.b #$DC : BRA .sprite_transform ; transform to 1 bomb
    + CMP.b #$28 : BNE +
        LDA.b #$DD : BRA .sprite_transform ; transform to 4 bombs
    + CMP.b #$31 : BNE +
        LDA.b #$DE : BRA .sprite_transform ; transform to 8 bombs
    + CMP.b #$45 : BNE +
        LDA.b #$DF : BRA .sprite_transform ; transform to small magic
    + CMP.b #$D4 : BNE +
        LDA.b #$E0 : BRA .sprite_transform ; transform to big magic
    + CMP.b #$D6 : BNE +
        LDA.b #$79 : JSL OWBonkSpritePrep
        JSL GoldBee_SpawnSelf_SetProperties ; transform to good bee
        BRA .mark_collected
    + CMP.b #$44 : BNE +
        LDA.b #$E2 : BRA .sprite_transform ; transform to 10 arrows
    + CMP.b #$D1 : BNE +
        LDA.b #$AC : BRA .sprite_transform ; transform to apples
    + CMP.b #$D2 : BNE +
        LDA.b #$E3 : BRA .sprite_transform ; transform to fairy
    + CMP.b #$D3 : BNE .spawn_item
        INX : INX : LDA.w OWBonkPrizeData,X ; X = row + 5
        CLC : ADC.b #$08 : PHA
        LDA.w SpritePosYLow,Y : SEC : SBC.b 1,S : STA.w SpritePosYLow,Y
            LDA.w SpritePosYHigh,Y : SBC.b #$00 : STA.w SpritePosYHigh,Y : PLX
        LDA.b #$0B ; BRA .sprite_transform ; transform to chicken
    
    .sprite_transform
    JSL OWBonkSpritePrep

    .mark_collected ; S = Collected, FlagBitmask, X (row + 2)
    PLA : BEQ + : - : JMP .return : + ; S = FlagBitmask, X (row + 2)
    TYX : JSL Sprite_IsOnscreen : BCC -
        LDA.b IndoorsFlag : BEQ +
            LDA.l RoomDataWRAM[$0120].high : ORA.b 1,S : STA.l RoomDataWRAM[$0120].high
            LDA.w $0400 : ORA.b 1,S : STA.w $0400
            BRA .increment_collection
        +
        LDA.b OverworldIndex
        BIT.b #$40 : BEQ +
            LDA.l ProgressIndicator : CMP.b #$02
            LDA.b OverworldIndex : BCS + : AND.b #$BF
        +
        TAX : LDA.l OverworldEventDataWRAM,X : ORA.b 1,S : STA.l OverworldEventDataWRAM,X
        
        .increment_collection
        REP #$20
            LDA.l TotalItemCounter : INC : STA.l TotalItemCounter
        SEP #$20
        LDA.b #$01 : STA.l UpdateHUDFlag
        BRA .return

    ; spawn itemget item
    .spawn_item ; A = item id ; Y = bonk sprite slot ; S = Collected, FlagBitmask, X (row + 2)
    PLX : BEQ + : LDA.b #$00 : STA.w SpriteAITable,Y : BRA .return ; S = FlagBitmask, X (row + 2)
        + PHA

        LDA.b #$EB
        JSL Sprite_SpawnDynamically+15 ; +15 to skip finding a new slot, use existing sprite

        PLA : STA.w SprSourceItemId, Y
        PHX : TYX : PLY
            JSL RequestStandingItemVRAMSlot
        PHY : TXY : PLX

        ; affects the rate the item moves in the Y/X direction
        LDA.b #$00 : STA.w SpriteVelocityY,Y
        LDA.b #$0A : STA.w SpriteVelocityX,Y

        LDA.b #$1A : STA.w SpriteVelocityZ,Y ; amount of force (gives height to the arch)
        LDA.b #$FF : STA.w EnemyStunTimer,Y ; stun timer
        LDA.b #$30 : STA.w SpriteTimerE,Y ; aux delay timer 4 ?? dunno what that means

        LDA.b #$00 : STA.w SpriteLayer,Y ; layer the sprite is on

        LDA.b IndoorsFlag : BEQ +
            ; sets the tile type that is underneath the sprite, water
            TYX : LDA.b #$09 : STA.l $7FF9C2,X ; TODO: Figure out how to get the game to set this
        +

        ; sets bitmask flag, uses free RAM
        PLA : STA.w SpriteSpawnStep,Y ; S = X (row + 2)

        ; sets MW player
        PLX : INX : INX
        LDA.w OWBonkPrizeData,X : STA.w SprItemMWPlayer,Y
        ; determines the initial spawn point of item
        INX
        LDA.w SpritePosYLow,Y : SEC : SBC.w OWBonkPrizeData,X : STA.w SpritePosYLow,Y
            LDA.w SpritePosYHigh,Y : SBC.b #$00 : STA.w SpritePosYHigh,Y
        
        BRA .return+2

    .return
    PLA : PLA : PLB
    RTL
}

; Y = sprite slot; returns X = row + 1
OWBonkDropLookup:
{
    ; loop thru rando bonk table to find match
    LDA.b OverworldIndex
    BIT.b #$40 : BEQ + 
            LDA.l ProgressIndicator : AND.b #$FF : CMP.b #$02
            LDA.b OverworldIndex : BCS ++ : AND.b #$BF
        ++
    +
    LDX.b #((UWBonkPrizeData-OWBonkPrizeData)-sizeof(OWBonkPrizeTable)) ; 41 bonk items, 6 bytes each
    - CMP.w OWBonkPrizeData,X : BNE +
        INX
        PHA
        LDA.w SpritePosXLow,Y : LSR A : LSR A : LSR A : LSR A
        EOR.w SpritePosYLow,Y : CMP.w OWBonkPrizeData,X : BNE ++ ; X = row + 1
            PLA : SEC : RTS
        ++ DEX : PLA
    + CPX.b #$00 : BNE +
        CLC : RTS
    + DEX : DEX : DEX : DEX : DEX : DEX : BRA -
}

; S = FlagBitmask ; returns SEC if collected
OWBonkDropCollected:
{
    ; check if collected
    LDA.b IndoorsFlag : BEQ +
        LDA.l RoomDataWRAM[$0120].high : AND.b 3,S : BEQ .return ; S = Collected, FlagBitmask, X (row + 2)
            SEC : RTS
    +
    LDA.b OverworldIndex
    BIT.b #$40 : BEQ + 
            LDA.l ProgressIndicator : CMP.b #$02
            LDA.b OverworldIndex : BCS ++ : AND.b #$BF
        ++
    +
    TAX
    LDA.l OverworldEventDataWRAM,X : AND.b 3,S : BEQ .return ; S = Collected, FlagBitmask, X (row + 2)
        SEC : RTS

    .return
    CLC : RTS
}

; A = SprItemReceipt, Y = Sprite Slot Index, X = free/overwritten
OWBonkSpritePrep:
{
    STA.w SpriteTypeTable,Y
    TYX : JSL SpritePrep_LoadProperties
    BEQ +
        ; these are sprite properties that make it fall out of the tree to the east 
        LDA.b #$30 : STA.w SpriteVelocityZ,Y ; amount of force (related to speed)
        LDA.b #$10 : STA.w SpriteVelocityX,Y ; eastward rate of speed
        LDA.b #$FF : STA.w EnemyStunTimer,Y ; expiration timer
    + RTL
}

org $aa9000
OWDetectEdgeTransition:
{
    JSL Link_CheckForEdgeScreenTransition ; what we wrote over
    BCS .return
    STZ.w RandoOverworldWalkDist
    LDA.l OWMode : ORA.l OWMode+1 : BEQ .vanilla
        PHY
        JSR OWShuffle
        PLY
        LDA.w RandoOverworldTargetEdge : BMI .specialOrDisabled
    .vanilla
    CLC ; allow transition
    RTL
    .specialOrDisabled
    CMP.b #$FF : BNE .special
    STZ.w RandoOverworldTargetEdge
    PHB
    JML Link_CheckForEdgeScreenTransition_prevent_transition
    .special
    REP #$30
    AND.w #$0003 : TAY : ASL : TAX
    LDA.w #$007F : STA.w RandoOverworldTargetEdge
    JSR OWLoadSpecialArea
    SEC
    .return
    RTL
}
OWDetectSpecialTransition:
{
    STZ.w RandoOverworldWalkDist
    LDA.l OWMode : BEQ .normal
    TXA : AND.w #$0002 : LSR
    STA.w RandoOverworldTerrain
    LDA.l OWSpecialDestIndex,X : BIT.w #$0080 : BEQ .switch_to_edge
    AND.w #$00FF : CMP.w #$00FF : BEQ .disabled
    AND.w #$0003 : TAY : ASL : TAX
    .normal
    JSR OWLoadSpecialArea
    .return
    RTL

    .disabled
    SEP #$30
    STZ.w RandoOverworldTargetEdge
    RTL

    .switch_to_edge
    STA.w RandoOverworldTargetEdge
    LDA.l OWEdgeDataOffset,X : STA.w RandoOverworldEdgeAddr
    PLA : SEP #$30 : PLA ; delete 3 bytes from stack
    JSL Link_CheckForEdgeScreenTransition : BCS .return
    LDA.l Overworld_CheckForSpecialOverworldTrigger_Direction,X : STA.b Scrap00 : CMP.b #$08 : BNE .hobo
        LSR : STA.b LinkPosY : STZ.b BG2V ; move Link and camera to edge
        LDA.b #$06 : STA.b Scrap02
        STZ.w TransitionDirection
        BRA .continue
    .hobo
        STA.b Scrap02 : STA.w TransitionDirection
        ASL : STA.b LinkPosX : STZ.b BG2H ; move Link and camera to edge
        LDA.b #$0A : STA.b LinkPosX+1 : STA.b BG2H+1
    .continue
    STZ.b Scrap03
    ; copied from DeleteCertainAncillaeStopDashing at $028A0E
    JSL Ancilla_TerminateSelectInteractives
    LDA.w LinkDashing : BEQ .not_dashing
        STZ.b LinkJumping : STZ.b LinkIncapacitatedTimer
        LDA.b #$FF : STA.b LinkRecoilZ : STA.b $C7
        STZ.b $3D : STZ.b LinkSpeed : STZ.w $032B : STZ.w LinkDashing : STZ.b LinkState
    .not_dashing
    PLA : PLA : PLA ; delete 3 bytes from stack
    JML OverworldHandleTransitions_PerformEdgeTransition
}
OWEdgeTransition:
{
    LDA.l OWMode : ORA.l OWMode+1 : BEQ .unshuffled
    LDY.w RandoOverworldTargetEdge : STZ.w RandoOverworldTargetEdge
    CPY.b #$7F : BEQ .unshuffled
        JSL OWDestroyItemSprites
        REP #$10
        LDX.w RandoOverworldEdgeAddr
        PHB : PHK : PLB
            JSR OWNewDestination
        PLB
        SEP #$30
        RTL

    .unshuffled
    LDA.l Overworld_ActualScreenID,X : ORA.l CurrentWorld ; what we wrote over
    TAX : LDA.l OWMode+1 : AND.b #!FLAG_OW_MIXED : BEQ .vanilla
        JML OWApplyWorld_fromScreen

    .vanilla
    TXA : RTL
}
OWSpecialExit:
{
    LDA.l OWMode : ORA.l OWMode+1 : BEQ .vanilla
        PHY
        LDY.b #$00
        LDA.w TransitionDirection : LSR : BNE +
            LDY.w RandoOverworldTerrain : BRA ++
        +
        LDA.w RandoOverworldTerrain : BNE ++
            LDY.b #$02
        ++
        JSR OWWorldTerrainUpdate
        PLY
    .vanilla
    LDA.l $7EFD40,X ; what we wrote over
    RTL
}
OWShuffle:
{
    ;determine direction of edge transition
    phx : lsr.w OverworldSlotPosition
    tyx : lda.l OWTransitionDirection,X : sta.w TransitionDirection

    .setOWID
    ;look up transitions in current area in table OWEdgeOffsets
    ;offset is (8bytes * OW Slot ID) + (2bytes * direction)
    asl : rep #$20 : and.w #$00ff : pha : sep #$20 ;2 bytes per direction

    ldx.b OverworldIndex : lda.l OWTileWorldAssoc,X : eor.l CurrentWorld : beq +
        ; fake world, will treat this OW area as opposite world
        txa : eor.b #$40 : tax
    + txa : and.b #$40 : !ADD.w OverworldSlotPosition : rep #$30 : and.w #$00ff : asl #3

    adc.b 1,S : tax
    asl.w OverworldSlotPosition : pla
    ;x = offset to edgeoffsets table
    
    sep #$20 : lda.l OWEdgeOffsets,x : and.b #$ff : beq .noTransition : pha ;get number of transitions
    ;s1 = number of transitions left to check
    
    inx : lda.l OWEdgeOffsets,x ;record id of first transition in table
    ;multiply ^ by 16, 16bytes per record
    sta.w CPUMULTA : lda.b #16 : sta.w CPUMULTB ;wait 8 cycles
    pla ;a = number of trans
    rep #$20
    and.w #$00ff
    ldx.w CPUPRODUCT ;x = offset to first record

    .nextTransition
    pha
        jsr OWSearchTransition_entry : bcs .newDestination
        txa : !ADD.w #$0010 : tax
    pla : dec : bne .nextTransition : bra .noTransition

    .newDestination
    pla : sep #$30 : plx : rts

    .noTransition
    sep #$30 : plx
    lda.b #$7f : sta.w RandoOverworldTargetEdge

    .return
    rts
}
OWSearchTransition:
{
    .exitloop ; moved here because of branch distance
    clc : rts

    .entry
    ;A-16 XY-16
    lda.w TransitionDirection : bne + ;north
        lda.l OWNorthEdges,x : dec
        cmp.b LinkPosX : !BGE .exitloop
        lda.l OWNorthEdges+2,x : cmp.b LinkPosX : !BLT .exitloop
            ;MATCH
            phx
            lda.l OWNorthEdges+14,x : tay ;y = record id of dest
            lda.l OWNorthEdges+12,x ;a = current terrain
            ldx.w #OWSouthEdges ;x = address of table
            bra .matchfound
    + dec : bne + ;south
        lda.l OWSouthEdges,x : dec
        cmp.b LinkPosX : !BGE .exitloop
        lda.l OWSouthEdges+2,x : cmp.b LinkPosX : !BLT .exitloop
            ;MATCH
            phx
            lda.l OWSouthEdges+14,x : tay ;y = record id of dest
            lda.l OWSouthEdges+12,x ;a = current terrain
            ldx.w #OWNorthEdges ;x = address of table
            bra .matchfound
    + dec : bne + ; west
        lda.l OWWestEdges,x : dec
        cmp.b LinkPosY : !BGE .exitloop
        lda.l OWWestEdges+2,x : cmp.b LinkPosY : !BLT .exitloop
            ;MATCH
            phx
            lda.l OWWestEdges+14,x : tay ;y = record id of dest
            lda.l OWWestEdges+12,x ;a = current terrain
            ldx.w #OWEastEdges ;x = address of table
            bra .matchfound
    + lda.l OWEastEdges,x : dec ;east
        cmp.b LinkPosY : !BGE .exitloop
        lda.l OWEastEdges+2,x : cmp.b LinkPosY : !BLT .exitloop
            ;MATCH
            phx
            lda.l OWEastEdges+14,x : tay ;y = record id of dest
            lda.l OWEastEdges+12,x ;a = current terrain
            ldx.w #OWWestEdges ;x = address of table

    .matchfound
    stx.w RandoOverworldEdgeAddr : sty.w RandoOverworldTargetEdge : sta.w RandoOverworldTerrain
    plx : jsr OWInterruptTransition
    sec : rts
}
OWInterruptTransition:
{
    if !FEATURE_LIMITED_RUN == 2604
        JSL Limited_OverworldTransitionPedestal
    endif
    RTS
}
OWNewDestination:
{
    tya : sta.w CPUMULTA : lda.b #16 : sta.w CPUMULTB ;wait 8 cycles
    rep #$20 : txa : nop : !ADD.w CPUPRODUCT : tax ;a = offset to dest record
    lda.w $0008,x : sta.b Scrap04 ;save dest OW slot/ID
    ldy.b LinkPosY : lda.w TransitionDirection : dec #2 : bpl + : ldy.b LinkPosX : + sty.b Scrap06
    
    ;;22	e0	e2	61c	61e - X
    ;;20	e6	e8	618	61a - Y
    ;keep current position if within incoming gap
    lda.w $0000,x : and.w #$01ff : pha : lda.w $0002,x : and.w #$01ff : pha
    LDA.l OWMode : AND.w #$0007 : BEQ .noLayoutShuffle ;temporary fix until VRAM issues are solved
        lda.w $0006,x : sta.b Scrap06 ;set coord
        lda.w $000a,x : sta.b OverworldMap16Buffer ;VRAM
        tya : and.w #$01ff : cmp.b 3,s : !BLT .adjustMainAxis
        dec : cmp.b 1,s : !BGE .adjustMainAxis
            inc : pha : lda.b Scrap06 : and.w #$fe00 : !ADD.b 1,s : sta.b Scrap06 : pla

            ; adjust and set other VRAM addresses
            lda.w $0006,x : pha : lda.b Scrap06 : !SUB 1,s 
            jsl DivideByTwoPreserveSign : jsl DivideByTwoPreserveSign : jsl DivideByTwoPreserveSign : jsl DivideByTwoPreserveSign : pha ; number of tiles
            lda.w TransitionDirection : dec #2 : bmi +
                pla : pea.w $0000 : bra ++ ;pla : asl #7 : pha : bra ++ ; y-axis shifts VRAM by increments of 0x80 (disabled for now)
            + pla : asl : pha ; x-axis shifts VRAM by increments of 0x02
            ++ lda.b OverworldMap16Buffer : !ADD.b 1,s : sta.b OverworldMap16Buffer : pla : pla

        .adjustMainAxis
        LDA.b OverworldMap16Buffer : SEC : SBC.w #$0400 : AND.w #$0F00 : ASL : XBA : STA.b OverworldTilemapIndexY ; vram
        LDA.b OverworldMap16Buffer : SEC : SBC.w #$0010 : AND.w #$003E : LSR : STA.b OverworldTilemapIndexX

    .noLayoutShuffle
    LDA.w $000F,X : AND.w #$00FF : STA.w RandoOverworldWalkDist ; position to walk to after transition (if non-zero)

    LDY.w #$0000
    LDA.w $000C,X : AND.w #$0001 : BEQ + ; check if going to water transition
    LDA.w RandoOverworldTerrain : AND.w #$0001 : BNE ++ ; check if coming from water transition
        INY : BRA ++
    +
    LDA.w RandoOverworldTerrain : BEQ ++ ; check if coming from water transition
        LDY.w #$0002
    ++
    STY.b Scrap08

    pla : pla : sep #$10 : ldy.w TransitionDirection
    ldx.w OWCoordIndex,y : lda.b LinkPosY,x : and.w #$fe00 : pha
        lda.b LinkPosY,x : and.w #$01ff : pha ;s1 = relative cur, s3 = ow cur
    lda.b Scrap06 : and.w #$fe00 : !SUB.b 3,s : pha ;set coord, s1 = ow diff, s3 = relative cur, s5 = ow cur
    lda.b Scrap06 : and.w #$01ff : !SUB.b 3,s : pha ;s1 = rel diff, s3 = ow diff, s5 = relative cur, s7 = ow cur
    lda.b Scrap06 : sta.b LinkPosY,x : and.w #$fe00 : sta.b Scrap06 ;set coord
    ldx.w OWBGIndex,y : lda.b BG2H,x : !ADD.b 1,s : adc.b 3,s : sta.b BG2H,x
    ldx.w OWCameraIndex,y : lda.w CameraScrollN,x : !ADD.b 1,s : adc.b 3,s : sta.w CameraScrollN,x
    ldx.w OWCameraIndex,y : lda.w CameraScrollS,x : !ADD.b 1,s : adc.b 3,s : sta.w CameraScrollS,x
    pla : jsl DivideByTwoPreserveSign : pha
    ldx.w OWBGIndex,y : lda.b BG1H,x : !ADD.b 1,s : sta.b BG1H,x : pla
    ldx.w OWBGIndex,y : lda.b BG1H,x : !ADD.b 1,s : sta.b BG1H,x : pla
    pla : pla

    ;fix camera unlock
    lda.b BG2H,x : !SUB.b Scrap06 : bpl +
        pha : lda.b Scrap06 : sta.b BG2H,x
        ldx.w OWCameraIndex,y : lda.w CameraScrollN,x : !SUB.b 1,s : sta.w CameraScrollN,x
        lda.w CameraScrollS,x : !SUB.b 1,s : sta.w CameraScrollS,x : pla
        bra .adjustOppositeAxis
    + lda.b Scrap06 : ldx.w OWCameraRangeIndex,y : !ADD.w OWCameraRange,x : sta.b Scrap06
    ldx.w OWBGIndex,y : !SUB.b BG2H,x : bcs .adjustOppositeAxis
        pha : lda.b Scrap06 : sta.b BG2H,x
        ldx.w OWCameraIndex,y : lda.w CameraScrollN,x : !ADD.b 1,s : sta.w CameraScrollN,x
        lda.w CameraScrollS,x : !ADD.b 1,s : sta.w CameraScrollS,x : pla

    .adjustOppositeAxis
    ;opposite coord stuff
    rep #$30 : lda.w OWOppDirectionOffset,y : and.w #$00ff : bit.w #$0080 : beq +
        ora.w #$ff00 ;extend 8-bit negative to 16-bit negative
    + pha : cpy.w #$0002 : lda.w OverworldSlotPosition : !BGE +
        and.w #$00f0 : pha : lda.b Scrap04 : asl : and.w #$0070 : !SUB.b 1,s : tax : pla : txa
        !ADD.b 1,s : tax : pla : txa : asl : asl : asl : asl : asl : pha : bra ++
    + and.w #$000f : pha : lda.b Scrap04 : asl : and.w #$000f : !SUB.b 1,s : !ADD.b 3,s
        sep #$10 : tax : phx : ldx.b #$0 : phx : rep #$10 : pla : plx : plx : pha
    
    ++ sep #$10 : ldx.w OWOppCoordIndex,y : lda.b LinkPosY,x : !ADD.b 1,s : sta.b LinkPosY,x ;set coord
    ldx.w OWOppBGIndex,y : lda.b BG2H,x : !ADD.b 1,s : sta.b BG2H,x
    ldx.w OWOppCameraIndex,y : lda.w CameraScrollN,x : !ADD.b 1,s : sta.w CameraScrollN,x
    ldx.w OWOppCameraIndex,y : lda.w CameraScrollS,x : !ADD.b 1,s : sta.w CameraScrollS,x
    ldx.w OWOppBGIndex,y : lda.b BG1H,x : !ADD.b 1,s : sta.b BG1H,x
    lda.w TransitionDirection : asl : tax : lda.w CameraTargetN,x : !ADD.b 1,s : sta.w CameraTargetN,x : pla

    sep #$30 : lda.b Scrap04 : and.b #$3f : !ADD.w OWOppSlotOffset,y : asl : sta.w OverworldSlotPosition
    
    ; crossed OW shuffle and terrain
    ldx.b Scrap05 : ldy.b Scrap08 : jsr OWWorldTerrainUpdate
    
    ldx.b OverworldIndex : lda.b Scrap05 : sta.b OverworldIndex : stx.b Scrap05 ; $05 is prev screen id, $8a is dest screen

    jsr OWGfxUpdate

    lda.b OverworldIndex
    rep #$30 : rts
}
OWLoadSpecialArea:
{
    LDA.l Overworld_LoadSpecialOverworld_RoomId,X : STA.b RoomIndex
    JSL Overworld_LoadSpecialOverworld ; sets M and X flags
    TYX
    LDY.b #$00
    CPX.b #$01 : BNE + ; check if going to water transition
    LDA.w RandoOverworldTerrain : BNE ++ ; check if coming from water transition
        INY : BRA ++
    +
    LDA.w RandoOverworldTerrain : BEQ ++ ; check if coming from water transition
        LDY.b #$02
    ++
    LDA.l OWSpecialDestSlot,X : TAX
    JSR OWWorldTerrainUpdate
    .return
    RTS
}
OWWorldTerrainUpdate: ; x = owid of destination screen, y = 1 for land to water, 2 for water to land, 3 for whirlpools and 0 else
{
    LDA.l OWMode+1 : AND.b #!FLAG_OW_CROSSED : BEQ .not_crossed
    LDA.l OWTileWorldAssoc,x : CMP.l CurrentWorld : BNE .crossed
    .not_crossed
        JMP .normal
    .crossed
        sta.l CurrentWorld ; change world

        ; moving mirror portal off screen when in DW
        cmp.b #0 : beq + : lda.b #1
        + cmp.l InvertedMode : bne +
            lda.w MirrorPortalPosXH : and.b #$0f : sta.w MirrorPortalPosXH : bra .playSfx ; bring portal back into position
        + lda.w MirrorPortalPosXH : ora.b #$40 : sta.w MirrorPortalPosXH ; move portal off screen
        
        .playSfx
        lda.b #$38 : sta.w SFX3 ; play sfx - #$3b is an alternative

        ; toggle bunny mode
        lda.l MoonPearlEquipment : beq + : jmp .nobunny
        + lda.l InvertedMode : bne .inverted
            lda.l CurrentWorld : bra +
            .inverted lda.l CurrentWorld : eor.b #$40
        + and.b #$40 : beq .nobunny
            LDA.w RandoOverworldForceTrans : BEQ + ; check if forced transition
                CPY.b #$03 : BEQ ++
                    LDA.b #$17 : STA.b LinkState
                    LDA.b #$01 : STA.w BunnyFlag : STA.b BunnyFlagDP
                    LDA.w RandoOverworldForceTrans : JSR OWLoadGearPalettes : BRA .end_forced_edge
                ++ JSR OWLoadGearPalettes : BRA .end_forced_whirlpool
            +
            CPY.b #$01 : BEQ .auto ; check if going from land to water
            CPY.b #$02 : BEQ .to_bunny_reset_swim ; bunny state if swimming to land
            LDA.b LinkState : CMP.b #$04 : BNE .to_bunny ; check if swimming
            .auto
                PHX
                LDA.b #$01
                LDX.b LinkState : CPX.b #$04 : BNE +
                    INC
                +
                STA.w RandoOverworldForceTrans
                CPY.b #$03 : BEQ .whirlpool
                    LDA.b #$01 : STA.w LinkDeepWater
                    LDX.w TransitionDirection
                    LDA.l OWAutoWalk,X : STA.b ForceMove
                    STZ.b LinkState
                    PLX
                    BRA .to_pseudo_bunny
                    .whirlpool
                    PLX : JMP OWLoadGearPalettes
            .to_bunny_reset_swim
            LDA.b LinkState : CMP.b #$04 : BNE .to_bunny ; check if swimming
                JSL Link_ResetSwimmingState
                STZ.w LinkDeepWater
            .to_bunny
            LDA.b #$17 : STA.b LinkState
            .to_pseudo_bunny
            LDA.b #$01 : STA.w BunnyFlag : STA.b BunnyFlagDP
            JMP OWLoadGearPalettes

        .nobunny
        lda.b LinkState : cmp.b #$17 : bne + ; retain current state unless bunny
            stz.b LinkState
        + stz.w BunnyFlag : stz.b BunnyFlagDP

    .normal
    LDA.w RandoOverworldForceTrans : BEQ .not_forced ; check if forced transition
        CPY.b #$03 : BEQ .end_forced_whirlpool
            .end_forced_edge
            STZ.b ForceMove : STZ.w LinkDeepWater
        .end_forced_whirlpool
        STZ.w RandoOverworldForceTrans
        CMP.b #$02 : BNE +
            DEC : STA.w LinkDeepWater : STZ.w LinkSwimDirection
            LDA.b FlagBY : AND.b #$7F : STA.b FlagBY
            LDA.b #$04 : BRA .set_state
        +
        CMP.b #$03 : BNE ++
            LDA.b #$17
            .set_state
            STA.b LinkState
        ++
        RTS
    .not_forced
    CPY.b #$02 : BNE + ; check if going from water to land
        LDA.b LinkState : CMP.b #$04 : BNE .return ; check if swimming
            JSL Link_ResetSwimmingState
            STZ.w LinkDeepWater
            STZ.b LinkState
    +
    CPY.b #$01 : BNE .return ; check if going from land to water
    LDA.b LinkState : CMP.b #$04 : BEQ .return ; check if swimming
        LDA.b #$01 : STA.w LinkDeepWater
        LDA.l FlippersEquipment : BEQ .no_flippers ; check if flippers obtained
        LDA.b LinkState : CMP.b #$17 : BEQ .no_flippers ; check if bunny
            LDA.b FlagBY : AND.b #$7F : STA.b FlagBY
            LDA.b #$04 : STA.b LinkState : STZ.w LinkSwimDirection : RTS
        .no_flippers
            PHX
            INC : STA.w RandoOverworldForceTrans
            LDX.w TransitionDirection
            LDA.l OWAutoWalk,X : STA.b ForceMove
            PLX
            LDA.b LinkState : CMP.b #$17 : BNE .return ; check if bunny
                LDA.b #$03 : STA.w RandoOverworldForceTrans
                STZ.b LinkState
    .return
    RTS
}
OWGfxUpdate:
{
    REP #$20 : LDA.l OWMode : AND.w #$0207 : BEQ .is_only_mixed : SEP #$20
        ;;;;PLA : AND.b #$3F : BEQ .leaving_woods
        LDA.b OverworldIndex : AND.b #$3F : BEQ .entering_woods
        ;LDA.b Scrap05 : JSL OWSkipPalettes : BCS .skip_palettes
            LDA.b OverworldIndex : JSR OWDetermineScreensPaletteSet
            CPX.w $0AB3 : BEQ .skip_palettes ; check if next screen's palette is different
                LDA.b Scrap00 : PHA
                JSL OverworldLoadScreensPaletteSet_long ; loading correct OW palette
                PLA : STA.b Scrap00
    .leaving_woods
    .entering_woods
    .is_only_mixed
    .skip_palettes
    SEP #$20
}
OWLoadGearPalettes:
{
    PHX : PHY : LDA.b Scrap00 : PHA
    LDA.w BunnyFlag : BEQ +
        JSL LoadGearPalettes_bunny
        BRA .return
    +
    JSL LoadGearPalettes_link
    .return
    PLA : STA.b Scrap00 : PLY : PLX
    RTS
}
OWDetermineScreensPaletteSet: ; A = OWID to check
{
    LDX.b #$02
    PHA : AND.b #$3F
    CMP.b #$03 : BEQ .death_mountain
    CMP.b #$05 : BEQ .death_mountain
    CMP.b #$07 : BEQ .death_mountain
        LDX.b #$00
    .death_mountain
    PLA : PHX : TAX : LDA.l OWTileWorldAssoc,X : BEQ +
        PLX : INX : RTS
    + PLX : RTS
}
OWSkipPalettes:
{
    STA.b Scrap05 ; A = previous screen, also stored in $05
    ; only skip mosaic if OWR Layout or Crossed
    PHP : REP #$20 : LDA.l OWMode : AND.w #$0207 : BEQ .vanilla : PLP
        ; checks to see if going to from any DM screens
        ;LDA.b Scrap05 : JSR OWDetermineScreensPaletteSet : TXA : AND.b #$FE : STA.b Scrap04
        ;LDA.b OverworldIndex : JSR OWDetermineScreensPaletteSet : TXA : AND.b #$FE
        ;CMP.b Scrap04 : BNE .skip_palettes
        BRA .vanilla+1

    .vanilla
    PLP
    LDA.b Scrap05 : AND.b #$3F : BEQ .skip_palettes ; what we
    LDA.b OverworldIndex : AND.b #$BF : BNE .change_palettes ; wrote over, kinda
    .skip_palettes
    SEC : RTL ; mosaic transition occurs
    .change_palettes
    CLC : RTL
}
OWAdjustExitPosition:
{
    LDA.w RandoOverworldWalkDist : CMP.b #$60 : BEQ .stone_bridge
    CMP.b #$B0 : BNE .normal
        LDA.b #$80 : STA.b LinkPosY : STZ.b LinkPosY+1
        BRA .normal
    .stone_bridge
        LDA.b #$A0 : STA.b BG2H
        LDA.b #$3D : STA.w CameraScrollW
        LDA.b #$3B : STA.w CameraScrollE
        INC.b LinkPosX+1 : INC.w CameraScrollW+1 : INC.w CameraScrollE+1
    .normal
    LDA.w RandoOverworldForceTrans : BEQ +
        LDA.b #$3C : STA.w SFX2 ; play error sound before forced transition
    +
    INC.b GameSubMode : STZ.b SubSubModule ; what we wrote over
    RTL
}
OWEndScrollTransition:
{
    LDY.w RandoOverworldWalkDist : BEQ .normal
        CMP.w RandoOverworldWalkDist
        RTL
    .normal
    CMP.l Overworld_FinalizeEntryOntoScreen_Data,X ; what we wrote over
    RTL
}
OWSpecialReturnTriggerClear:
{
    STZ.b SubSubModule : STZ.b RoomIndex ; what we wrote over
    STZ.w RandoOverworldTargetEdge
    RTL
}

;Data
org $aaa000
OWEdgeOffsets:
;2 bytes per each direction per each OW Slot, order is NSWE per value at $0418
;AABB, A = offset to the transition table, B = number of transitions
dw $0000, $0000, $0000, $0000 ;OW Slot 00, OWID 0x00 Lost Woods
dw $0000, $0000, $0000, $0001 ;OW Slot 01, OWID 0x00
dw $0000, $0001, $0001, $0000 ;OW Slot 02, OWID 0x02 Lumberjack
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0101
dw $0000, $0000, $0101, $0000
dw $0000, $0000, $0000, $0201
dw $0000, $0000, $0201, $0000

dw $0000, $0102, $0000, $0000
dw $0000, $0301, $0000, $0000
dw $0101, $0401, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0301
dw $0000, $0000, $0301, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0501, $0000, $0000 ;Zora

dw $0302, $0602, $0000, $0000
dw $0501, $0801, $0000, $0402
dw $0601, $0902, $0402, $0602
dw $0000, $0000, $0602, $0801
dw $0000, $0000, $0801, $0901
dw $0000, $0b03, $0901, $0a03
dw $0000, $0000, $0a03, $0d02
dw $0701, $0000, $0d02, $0000

dw $0802, $0000, $0000, $0000 ;OW Slot 18, OWID 0x18 Kakariko
dw $0a01, $0000, $0000, $0000
dw $0b02, $0000, $0000, $0f01
dw $0000, $0000, $0f01, $0000
dw $0000, $0000, $0000, $0000
dw $0d03, $0e01, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000

dw $0000, $0000, $0000, $0000
dw $0000, $0f01, $0000, $1001
dw $0000, $0000, $1001, $0000
dw $0000, $1001, $0000, $0000
dw $0000, $1101, $0000, $1101
dw $1001, $1201, $1101, $0000
dw $0000, $1301, $0000, $0000
dw $0000, $1401, $0000, $0000

dw $0000, $0000, $0000, $1201
dw $1101, $0000, $1201, $1301
dw $0000, $1502, $1301, $0000
dw $1201, $1701, $0000, $1403
dw $1301, $1801, $1403, $1701 ;Links
dw $1401, $1901, $1801, $1802 ;Hobo
dw $1501, $1a02, $1902, $0000
dw $1601, $0000, $0000, $0000

dw $0000, $0000, $0000, $0000 ;OW Slot 30, OWID 0x30 Desert
dw $0000, $0000, $0000, $0000
dw $1702, $0000, $0000, $1a01
dw $1901, $1c01, $1b01, $1b03
dw $1a01, $1d01, $1c03, $0000
dw $1b01, $0000, $0000, $0000
dw $1c02, $0000, $0000, $0000
dw $0000, $1e02, $0000, $0000

dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $1e02
dw $0000, $0000, $1f02, $2002
dw $1e01, $0000, $2102, $2201
dw $1f01, $0000, $2301, $2301
dw $0000, $0000, $2401, $0000
dw $0000, $0000, $0000, $2402
dw $2002, $0000, $2502, $0000

dw $0000, $0000, $0000, $0000 ;OW Slot 40, OWID 0x40 Skull Woods
dw $0000, $0000, $0000, $2601
dw $0000, $2001, $2701, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $2701
dw $0000, $0000, $2801, $0000
dw $0000, $0000, $0000, $2801
dw $0000, $0000, $2901, $0000

dw $0000, $2102, $0000, $0000
dw $0000, $2301, $0000, $0000
dw $2201, $2401, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $2901
dw $0000, $0000, $2a01, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $2501, $0000, $0000

dw $2302, $2602, $0000, $0000
dw $2501, $2801, $0000, $2a02
dw $2601, $2902, $2b02, $2c02
dw $0000, $0000, $2d02, $2e01
dw $0000, $0000, $2f01, $2f01
dw $0000, $2b03, $3001, $3003
dw $0000, $0000, $3103, $3302
dw $2701, $0000, $3402, $0000

dw $2802, $0000, $0000, $0000 ;OW Slot 58, OWID 0x58 Village of Outcasts
dw $2a01, $0000, $0000, $0000
dw $2b02, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $2d03, $2e01, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000

dw $0000, $0000, $0000, $0000
dw $0000, $2f01, $0000, $3501
dw $0000, $0000, $3601, $0000
dw $0000, $3001, $0000, $0000
dw $0000, $3101, $0000, $3601
dw $3001, $3201, $3701, $0000
dw $0000, $3301, $0000, $0000
dw $0000, $3401, $0000, $0000

dw $0000, $0000, $0000, $3702
dw $3101, $0000, $3802, $3901
dw $0000, $3502, $3a01, $0000
dw $3201, $3701, $0000, $3a03
dw $3301, $3801, $3b03, $3d01
dw $3401, $3901, $3e01, $3e02
dw $3501, $3a02, $3f02, $0000
dw $3601, $0000, $0000, $0000

dw $0000, $0000, $0000, $0000 ;OW Slot 70, OWID 0x70 Mire
dw $0000, $0000, $0000, $0000
dw $3702, $0000, $0000, $4001
dw $3901, $3c01, $4101, $4103
dw $3a01, $3d01, $4203, $0000
dw $3b01, $0000, $0000, $0000
dw $3c02, $0000, $0000, $0000
dw $0000, $3e02, $0000, $0000

dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $4402
dw $3e01, $0000, $4502, $4601
dw $3f01, $0000, $4701, $4701
dw $0000, $0000, $4801, $0000
dw $0000, $0000, $0000, $4802
dw $4002, $0000, $4902, $0000

dw $0000, $4001, $0000, $0000
dw $0000, $0000, $0000, $4a01
dw $0000, $4101, $0000, $0000

OWSpecialDestSlot:
db $80, $80, $81

org $aaa800 ;PC 152800
OWNorthEdges:
;   Min    Max   Width   Mid OW Slot/OWID VRAM Terrain Dest Index
dw $00a0, $00a0, $0000, $00a0, $0000, $0284, $0000, $B040 ;Lost Woods (exit only)
dw $0458, $0540, $00e8, $04cc, $0a0a, $180a, $0000, $0000
dw $0f38, $0f60, $0028, $0f4c, $0f0f, $009a, $0000, $2041 ;Waterfall (exit only)
dw $0058, $0058, $0000, $0058, $1010, $1800, $0000, $0001
dw $0178, $0178, $0000, $0178, $1010, $181e, $0000, $0002
dw $0388, $0388, $0000, $0388, $1111, $1820, $0000, $0003
dw $0480, $05b0, $0130, $0518, $1212, $1812, $0000, $0004
dw $0f70, $0f90, $0020, $0f80, $1717, $1820, $0000, $0005
dw $0078, $0098, $0020, $0088, $1818, $1802, $0000, $0006 ;Kakariko
dw $0138, $0158, $0020, $0148, $1818, $181a, $0000, $0007
dw $02e8, $0348, $0060, $0318, $1819, $1854, $0000, $0008
dw $0478, $04d0, $0058, $04a4, $1a1a, $1806, $0000, $0009
dw $0510, $0538, $0028, $0524, $1a1a, $1816, $0000, $000a
dw $0a48, $0af0, $00a8, $0a9c, $1d1d, $1804, $0000, $000b
dw $0b28, $0b38, $0010, $0b30, $1d1d, $1818, $0001, $000c
dw $0b70, $0ba0, $0030, $0b88, $1d1d, $1820, $0000, $000d
dw $0a40, $0b10, $00d0, $0aa8, $2525, $1806, $0000, $000e
dw $0350, $0390, $0040, $0370, $2929, $1820, $0000, $000f
dw $0670, $06a8, $0038, $068c, $2b2b, $1802, $0000, $0010
dw $0898, $09b0, $0118, $0924, $2c2c, $1814, $0000, $0011 ;Links House
dw $0a40, $0ba0, $0160, $0af0, $2d2d, $180e, $0000, $0012
dw $0c70, $0c90, $0020, $0c80, $2e2e, $1802, $0000, $0013
dw $0f70, $0f80, $0010, $0f78, $2f2f, $1820, $0000, $0014
dw $0430, $0468, $0038, $044c, $3232, $1800, $0000, $0015
dw $04d8, $04f8, $0020, $04e8, $3232, $180c, $0000, $0016
dw $0688, $06b0, $0028, $069c, $3333, $1804, $0000, $0017
dw $08d0, $08f0, $0020, $08e0, $3434, $180e, $0000, $0018
dw $0a80, $0b40, $00c0, $0ae0, $3535, $180c, $0000, $0019
dw $0d38, $0d58, $0020, $0d48, $3536, $185a, $0001, $001a
dw $0d90, $0da0, $0010, $0d98, $3536, $1860, $0000, $001b
dw $06a0, $07b0, $0110, $0728, $3b3b, $1816, $0000, $001c
dw $0830, $09b0, $0180, $08f0, $3c3c, $1810, $0000, $001d
dw $0e78, $0e88, $0010, $0e80, $3f3f, $1802, $0001, $001e
dw $0ee0, $0fc0, $00e0, $0f50, $3f3f, $181c, $0000, $001f
dw $0458, $0540, $00e8, $04cc, $4a4a, $180a, $0000, $0020
dw $0058, $0058, $0000, $0058, $5050, $181e, $0000, $0021
dw $0178, $0178, $0000, $0178, $5050, $1800, $0000, $0022
dw $0388, $0388, $0000, $0388, $5151, $1820, $0000, $0023
dw $0480, $05b0, $0130, $0518, $5252, $1812, $0000, $0024
dw $0f70, $0f90, $0020, $0f80, $5757, $1820, $0000, $0025
dw $0078, $0098, $0020, $0088, $5858, $1802, $0000, $0026 ;Village of Outcasts
dw $0138, $0158, $0020, $0148, $5858, $181a, $0000, $0027
dw $02e8, $0348, $0060, $0318, $5859, $1854, $0000, $0028
dw $0478, $04d0, $0058, $04a4, $5a5a, $1806, $0000, $0029
dw $0510, $0538, $0028, $0524, $5a5a, $1816, $0000, $002a
dw $0a48, $0af0, $00a8, $0a9c, $5d5d, $1804, $0000, $002b
dw $0b28, $0b38, $0010, $0b30, $5d5d, $1818, $0001, $002c
dw $0b70, $0ba0, $0030, $0b88, $5d5d, $1820, $0000, $002d
dw $0a40, $0b10, $00d0, $0aa8, $6565, $1806, $0000, $002e
dw $0350, $0390, $0040, $0370, $6969, $1820, $0000, $002f
dw $0670, $06a8, $0038, $068c, $6b6b, $1802, $0000, $0030
dw $0898, $09b0, $0118, $0924, $6c6c, $1814, $0000, $0031
dw $0a40, $0ba0, $0160, $0af0, $6d6d, $180e, $0000, $0032
dw $0c70, $0c90, $0020, $0c80, $6e6e, $1802, $0000, $0033
dw $0f70, $0f80, $0010, $0f78, $6f6f, $1820, $0000, $0034
dw $0430, $0468, $0038, $044c, $7272, $1800, $0000, $0035
dw $04d8, $04f8, $0020, $04e8, $7272, $180c, $0000, $0036
dw $0688, $06b0, $0028, $069c, $7373, $1804, $0000, $0037
dw $08d0, $08f0, $0020, $08e0, $7474, $180e, $0000, $0038
dw $0a80, $0b40, $00c0, $0ae0, $7575, $180c, $0000, $0039
dw $0d38, $0d58, $0020, $0d48, $7576, $185a, $0001, $003a
dw $0d90, $0da0, $0010, $0d98, $7576, $1860, $0000, $003b
dw $06a0, $07b0, $0110, $0728, $7b7b, $1816, $0000, $003c
dw $0830, $09b0, $0180, $08f0, $7c7c, $1810, $0000, $003d
dw $0e78, $0e88, $0010, $0e80, $7f7f, $1802, $0001, $003e
dw $0ee0, $0fc0, $00e0, $0f50, $7f7f, $181c, $0000, $003f
OWSouthEdges:
dw $0458, $0540, $00e8, $04cc, $0202, $100a, $0000, $0001
dw $0058, $0058, $0000, $0058, $0008, $2000, $0000, $0003
dw $0178, $0178, $0000, $0178, $0008, $2020, $0000, $0004
dw $0388, $0388, $0000, $0388, $0009, $2060, $0000, $0005
dw $0480, $05b0, $0130, $0518, $0a0a, $1012, $0000, $0006
dw $0f70, $0f90, $0020, $0f80, $0f0f, $1020, $0000, $0007
dw $0078, $0098, $0020, $0088, $1010, $1002, $0000, $0008
dw $0138, $0158, $0020, $0148, $1010, $101a, $0000, $0009
dw $02e8, $0348, $0060, $0318, $1111, $1014, $0000, $000a
dw $0478, $04d0, $0058, $04a4, $1212, $1006, $0000, $000b
dw $0510, $0538, $0028, $0524, $1212, $1016, $0000, $000c
dw $0a48, $0af0, $00a8, $0a9c, $1515, $1004, $0000, $000d
dw $0b28, $0b38, $0010, $0b30, $1515, $1018, $0001, $000e
dw $0b70, $0ba0, $0030, $0b88, $1515, $1020, $0000, $000f
dw $0a40, $0b10, $00d0, $0aa8, $1d1d, $1006, $0000, $0010
dw $0350, $0390, $0040, $0370, $1821, $2060, $0000, $0011
dw $0670, $06a8, $0038, $068c, $1b23, $2004, $0000, $0012
dw $0898, $09b0, $0118, $0924, $1b24, $2054, $0000, $0013
dw $0a40, $0ba0, $0160, $0af0, $2525, $100e, $0000, $0014
dw $0c70, $0c90, $0020, $0c80, $1e26, $2002, $0000, $0015
dw $0f70, $0f80, $0010, $0f78, $1e27, $2060, $0000, $0016
dw $0430, $0468, $0038, $044c, $2a2a, $1000, $0000, $0017
dw $04d8, $04f8, $0020, $04e8, $2a2a, $100c, $0000, $0018
dw $0688, $06b0, $0028, $069c, $2b2b, $1004, $0000, $0019
dw $08d0, $08f0, $0020, $08e0, $2c2c, $100e, $0000, $001a
dw $0a80, $0b40, $00c0, $0ae0, $2d2d, $100c, $0000, $001b
dw $0d38, $0d58, $0020, $0d48, $2e2e, $101a, $0001, $001c
dw $0d90, $0da0, $0010, $0d98, $2e2e, $1020, $0000, $001d
dw $06a0, $07b0, $0110, $0728, $3333, $1016, $0000, $001e
dw $0830, $09b0, $0180, $08f0, $3434, $1010, $0000, $001f
dw $0e78, $0e88, $0010, $0e80, $3737, $1002, $0001, $0020
dw $0ee0, $0fc0, $00e0, $0f50, $3737, $101c, $0000, $0021
dw $0458, $0540, $00e8, $04cc, $4242, $100a, $0000, $0022
dw $0058, $0058, $0000, $0058, $4048, $2000, $0000, $0023
dw $0178, $0178, $0000, $0178, $4048, $2020, $0000, $0024
dw $0388, $0388, $0000, $0388, $4049, $2060, $0000, $0025
dw $0480, $05b0, $0130, $0518, $4a4a, $1012, $0000, $0026
dw $0f70, $0f90, $0020, $0f80, $4f4f, $1020, $0000, $0027
dw $0078, $0098, $0020, $0088, $5050, $1002, $0000, $0028
dw $0138, $0158, $0020, $0148, $5050, $101a, $0000, $0029
dw $02e8, $0348, $0060, $0318, $5151, $1014, $0000, $002a
dw $0478, $04d0, $0058, $04a4, $5252, $1006, $0000, $002b
dw $0510, $0538, $0028, $0524, $5252, $1016, $0000, $002c
dw $0a48, $0af0, $00a8, $0a9c, $5555, $1004, $0000, $002d
dw $0b28, $0b38, $0010, $0b30, $5555, $1018, $0001, $002e
dw $0b70, $0ba0, $0030, $0b88, $5555, $1020, $0000, $002f
dw $0a40, $0b10, $00d0, $0aa8, $5d5d, $1006, $0000, $0030
dw $0350, $0390, $0040, $0370, $5861, $2060, $0000, $0031
dw $0670, $06a8, $0038, $068c, $5b63, $2004, $0000, $0032
dw $0898, $09b0, $0118, $0924, $5b64, $2054, $0000, $0033
dw $0a40, $0ba0, $0160, $0af0, $6565, $100e, $0000, $0034
dw $0c70, $0c90, $0020, $0c80, $5e66, $2002, $0000, $0035
dw $0f70, $0f80, $0010, $0f78, $5e67, $2060, $0000, $0036
dw $0430, $0468, $0038, $044c, $6a6a, $1000, $0000, $0037
dw $04d8, $04f8, $0020, $04e8, $6a6a, $100c, $0000, $0038
dw $0688, $06b0, $0028, $069c, $6b6b, $1004, $0000, $0039
dw $08d0, $08f0, $0020, $08e0, $6c6c, $100e, $0000, $003a
dw $0a80, $0b40, $00c0, $0ae0, $6d6d, $100c, $0000, $003b
dw $0d38, $0d58, $0020, $0d48, $6e6e, $101a, $0001, $003c
dw $0d90, $0da0, $0010, $0d98, $6e6e, $1020, $0000, $003d
dw $06a0, $07b0, $0110, $0728, $7373, $1016, $0000, $003e
dw $0830, $09b0, $0180, $08f0, $7474, $1010, $0000, $003f
dw $0e78, $0e88, $0010, $0e80, $7777, $1002, $0001, $0040
dw $0ee0, $0fc0, $00e0, $0f50, $7777, $101c, $0000, $0041
dw $0080, $0080, $0000, $0080, $8080, $0000, $0000, $0000 ;Pedestal (unused)
dw $0288, $02c0, $0038, $02a4, $8189, $1782, $0000, $0002 ;Zora (unused)
OWWestEdges:
dw $0070, $00a0, $0030, $0088, $0202, $00e0, $0000, $0000
dw $0068, $0078, $0010, $0070, $0505, $0060, $0000, $0001
dw $0068, $0088, $0020, $0078, $0707, $00e0, $0000, $0002
dw $0318, $0368, $0050, $0340, $050d, $1660, $0000, $0003
dw $0450, $0488, $0038, $046c, $1212, $00e0, $0000, $0004
dw $0560, $05a0, $0040, $0580, $1212, $08e0, $0000, $0005
dw $0488, $0500, $0078, $04c4, $1313, $0360, $0000, $0006
dw $0538, $05a8, $0070, $0570, $1313, $08e0, $0000, $0007
dw $0470, $05a8, $0138, $050c, $1414, $04e0, $0000, $0008
dw $0470, $0598, $0128, $0504, $1515, $04e0, $0000, $0009
dw $0480, $0488, $0008, $0484, $1616, $01e0, $0001, $000a
dw $04b0, $0510, $0060, $04e0, $1616, $04e0, $0000, $000b
dw $0560, $0588, $0028, $0574, $1616, $08e0, $0000, $000c
dw $0450, $0458, $0008, $0454, $1717, $00e0, $0001, $000d
dw $0480, $04a8, $0028, $0494, $1717, $01e0, $0000, $000e
dw $0718, $0738, $0020, $0728, $1b1b, $06e0, $0000, $000f
dw $0908, $0948, $0040, $0928, $2222, $05e0, $0000, $0010
dw $0878, $08a8, $0030, $0890, $2525, $01e0, $0000, $0011
dw $0bb8, $0bc8, $0010, $0bc0, $2929, $0960, $0000, $0012
dw $0b60, $0ba0, $0040, $0b80, $2a2a, $0960, $0000, $0013
dw $0ab0, $0ad0, $0020, $0ac0, $2c2c, $0360, $0000, $0014
dw $0af0, $0b40, $0050, $0b18, $2c2c, $05e0, $0000, $0015
dw $0b78, $0ba0, $0028, $0b8c, $2c2c, $08a0, $0000, $0016
dw $0b10, $0b28, $0018, $0b1c, $2d2d, $061c, $0001, $604a ;Stone Bridge (exit only)
dw $0b68, $0b98, $0030, $0b80, $2d2d, $08e0, $0000, $0017
dw $0a68, $0ab8, $0050, $0a90, $2e2e, $01e0, $0000, $0018
dw $0b00, $0b78, $0078, $0b3c, $2e2e, $0660, $0001, $0019
dw $0c50, $0db8, $0168, $0d04, $3333, $05e0, $0000, $001a
dw $0c78, $0ce3, $006b, $0cad, $3434, $02e0, $0000, $001b
dw $0ce4, $0d33, $004f, $0d0b, $3434, $05e0, $0001, $001c
dw $0d34, $0db8, $0084, $0d76, $3434, $08e0, $0000, $001d
dw $0ea8, $0f20, $0078, $0ee4, $3a3a, $03e0, $0000, $001e
dw $0f78, $0fa8, $0030, $0f90, $3a3a, $0860, $0000, $001f
dw $0f18, $0f18, $0000, $0f18, $3b3b, $0660, $0000, $0020
dw $0fc8, $0fc8, $0000, $0fc8, $3b3b, $08e0, $0000, $0021
dw $0e28, $0fb8, $0190, $0ef0, $3c3c, $04e0, $0000, $0022
dw $0f78, $0fb8, $0040, $0f98, $353d, $1860, $0000, $0023
dw $0f20, $0f40, $0020, $0f30, $3f3f, $05e0, $0001, $0024
dw $0f70, $0fb8, $0048, $0f94, $3f3f, $0860, $0000, $0025
dw $0070, $00a0, $0030, $0088, $4242, $00e0, $0000, $0026
dw $0068, $0078, $0010, $0070, $4545, $0060, $0000, $0027
dw $0068, $0088, $0020, $0078, $4747, $00e0, $0000, $0028
dw $0318, $0368, $0050, $0340, $454d, $1660, $0000, $0029
dw $0450, $0488, $0038, $046c, $5252, $00e0, $0000, $002a
dw $0560, $05a0, $0040, $0580, $5252, $08e0, $0000, $002b
dw $0488, $0500, $0078, $04c4, $5353, $0360, $0000, $002c
dw $0538, $05a8, $0070, $0570, $5353, $08e0, $0000, $002d
dw $0470, $05a8, $0138, $050c, $5454, $04e0, $0000, $002e
dw $0470, $0598, $0128, $0504, $5555, $04e0, $0000, $002f
dw $0480, $0488, $0008, $0484, $5656, $01e0, $0001, $0030
dw $04b0, $0510, $0060, $04e0, $5656, $04e0, $0000, $0031
dw $0560, $0588, $0028, $0574, $5656, $08e0, $0000, $0032
dw $0450, $0458, $0008, $0454, $5757, $00e0, $0001, $0033
dw $0480, $04a8, $0028, $0494, $5757, $01e0, $0000, $0034
dw $0908, $0948, $0040, $0928, $6262, $05e0, $0000, $0035
dw $0878, $08a8, $0030, $0890, $6565, $01e0, $0000, $0036
dw $0b60, $0b68, $0008, $0b64, $6969, $08e0, $0000, $0037
dw $0bb8, $0bc8, $0010, $0bc0, $6969, $0960, $0000, $0038
dw $0b60, $0ba0, $0040, $0b80, $6a6a, $0960, $0000, $0039
dw $0ab0, $0ad0, $0020, $0ac0, $6c6c, $0360, $0000, $003a
dw $0af0, $0b40, $0050, $0b18, $6c6c, $05e0, $0000, $003b
dw $0b78, $0ba0, $0028, $0b8c, $6c6c, $08a0, $0000, $003c
dw $0b68, $0b98, $0030, $0b80, $6d6d, $08e0, $0000, $003d
dw $0a68, $0ab8, $0050, $0a90, $6e6e, $01e0, $0000, $003e
dw $0b00, $0b78, $0078, $0b3c, $6e6e, $0660, $0001, $003f
dw $0c50, $0db8, $0168, $0d04, $7373, $05e0, $0000, $0040
dw $0c78, $0ce3, $006b, $0cad, $7474, $02e0, $0000, $0041
dw $0ce4, $0d33, $004f, $0d0b, $7474, $05e0, $0001, $0042
dw $0d34, $0db8, $0084, $0d76, $7474, $08e0, $0000, $0043
dw $0f18, $0f18, $0000, $0f18, $7b7b, $0660, $0000, $0044
dw $0fc8, $0fc8, $0000, $0fc8, $7b7b, $08e0, $0000, $0045
dw $0e28, $0fb8, $0190, $0ef0, $7c7c, $04e0, $0000, $0046
dw $0f78, $0fb8, $0040, $0f98, $757d, $1860, $0000, $0047
dw $0f20, $0f40, $0020, $0f30, $7f7f, $05e0, $0001, $0048
dw $0f70, $0fb8, $0048, $0f94, $7f7f, $0860, $0000, $0049
OWEastEdges:
dw $0070, $00a0, $0030, $0088, $0001, $0180, $0000, $0000
dw $0068, $0078, $0010, $0070, $0304, $0180, $0000, $0001
dw $0068, $0088, $0020, $0078, $0506, $0180, $0000, $0002
dw $0318, $0368, $0050, $0340, $030c, $1780, $0000, $0003
dw $0450, $0488, $0038, $046c, $1111, $00c0, $0000, $0004
dw $0560, $05a0, $0040, $0580, $1111, $08c0, $0000, $0005
dw $0488, $0500, $0078, $04c4, $1212, $0340, $0000, $0006
dw $0538, $05a8, $0070, $0570, $1212, $08c0, $0000, $0007
dw $0470, $05a8, $0138, $050c, $1313, $04c0, $0000, $0008
dw $0470, $0598, $0128, $0504, $1414, $04c0, $0000, $0009
dw $0480, $0488, $0008, $0484, $1515, $01c0, $0001, $000a
dw $04b0, $0510, $0060, $04e0, $1515, $04c0, $0000, $000b
dw $0560, $0588, $0028, $0574, $1515, $08c0, $0000, $000c
dw $0450, $0458, $0008, $0454, $1616, $00c0, $0001, $000d
dw $0480, $04a8, $0028, $0494, $1616, $01c0, $0000, $000e
dw $0718, $0738, $0020, $0728, $1a1a, $06c0, $0000, $000f
dw $0908, $0948, $0040, $0928, $1821, $1680, $0000, $0010
dw $0878, $08a8, $0030, $0890, $1b24, $1280, $0000, $0011
dw $0bb8, $0bc8, $0010, $0bc0, $2828, $0940, $0000, $0012 ;Race Game
dw $0b60, $0ba0, $0040, $0b80, $2929, $0940, $0000, $0013
dw $0ab0, $0ad0, $0020, $0ac0, $2b2b, $0340, $0000, $0014
dw $0af0, $0b40, $0050, $0b18, $2b2b, $05c0, $0000, $0015
dw $0b78, $0ba0, $0028, $0b8c, $2b2b, $08c0, $0000, $0016
dw $0b68, $0b98, $0030, $0b80, $2c2c, $08c0, $0000, $0018
dw $0a68, $0ab8, $0050, $0a90, $2d2d, $01c0, $0000, $0019
dw $0b00, $0b78, $0078, $0b3c, $2d2d, $0640, $0001, $001a
dw $0c50, $0db8, $0168, $0d04, $3232, $05c0, $0000, $001b
dw $0c78, $0ce3, $006b, $0cad, $3333, $02c0, $0000, $001c
dw $0ce4, $0d33, $004f, $0d0b, $3333, $05c0, $0001, $001d
dw $0d34, $0db8, $0084, $0d76, $3333, $08c0, $0000, $001e
dw $0ea8, $0f20, $0078, $0ee4, $3039, $1480, $0000, $001f
dw $0f78, $0fa8, $0030, $0f90, $3039, $1980, $0000, $0020
dw $0f18, $0f18, $0000, $0f18, $3a3a, $0640, $0000, $0021
dw $0fc8, $0fc8, $0000, $0fc8, $3a3a, $08c0, $0000, $0022
dw $0e28, $0fb8, $0190, $0ef0, $3b3b, $04c0, $0000, $0023
dw $0f78, $0fb8, $0040, $0f98, $3c3c, $08c0, $0000, $0024
dw $0f20, $0f40, $0020, $0f30, $353e, $1680, $0001, $0025
dw $0f70, $0fb8, $0048, $0f94, $353e, $1880, $0000, $0026
dw $0070, $00a0, $0030, $0088, $4041, $0180, $0000, $0027 ;Skull Woods
dw $0068, $0078, $0010, $0070, $4344, $0180, $0000, $0028
dw $0068, $0088, $0020, $0078, $4546, $0180, $0000, $0029
dw $0318, $0368, $0050, $0340, $434c, $1780, $0000, $002a
dw $0450, $0488, $0038, $046c, $5151, $00c0, $0000, $002b
dw $0560, $05a0, $0040, $0580, $5151, $08c0, $0000, $002c
dw $0488, $0500, $0078, $04c4, $5252, $0340, $0000, $002d
dw $0538, $05a8, $0070, $0570, $5252, $08c0, $0000, $002e
dw $0470, $05a8, $0138, $050c, $5353, $04c0, $0000, $002f
dw $0470, $0598, $0128, $0504, $5454, $04c0, $0000, $0030
dw $0480, $0488, $0008, $0484, $5555, $01c0, $0001, $0031
dw $04b0, $0510, $0060, $04e0, $5555, $04c0, $0000, $0032
dw $0560, $0588, $0028, $0574, $5555, $08c0, $0000, $0033
dw $0450, $0458, $0008, $0454, $5656, $00c0, $0001, $0034
dw $0480, $04a8, $0028, $0494, $5656, $01c0, $0000, $0035
dw $0908, $0948, $0040, $0928, $5861, $1680, $0000, $0036
dw $0878, $08a8, $0030, $0890, $5b64, $1280, $0000, $0037
dw $0b60, $0b68, $0008, $0b64, $6868, $08c0, $0000, $0038 ;Dig Game
dw $0bb8, $0bc8, $0010, $0bc0, $6868, $0940, $0000, $0039
dw $0b60, $0ba0, $0040, $0b80, $6969, $0940, $0000, $003a
dw $0ab0, $0ad0, $0020, $0ac0, $6b6b, $0340, $0000, $003b
dw $0af0, $0b40, $0050, $0b18, $6b6b, $05c0, $0000, $003c
dw $0b78, $0ba0, $0028, $0b8c, $6b6b, $08c0, $0000, $003d
dw $0b68, $0b98, $0030, $0b80, $6c6c, $08c0, $0000, $003e
dw $0a68, $0ab8, $0050, $0a90, $6d6d, $01c0, $0000, $003f
dw $0b00, $0b78, $0078, $0b3c, $6d6d, $0640, $0001, $0040
dw $0c50, $0db8, $0168, $0d04, $7272, $05c0, $0000, $0041
dw $0c78, $0ce3, $006b, $0cad, $7373, $02c0, $0000, $0042
dw $0ce4, $0d33, $004f, $0d0b, $7373, $05c0, $0001, $0043
dw $0d34, $0db8, $0084, $0d76, $7373, $08c0, $0000, $0044
dw $0f18, $0f18, $0000, $0f18, $7a7a, $0640, $0000, $0045
dw $0fc8, $0fc8, $0000, $0fc8, $7a7a, $08c0, $0000, $0046
dw $0e28, $0fb8, $0190, $0ef0, $7b7b, $04c0, $0000, $0047
dw $0f78, $0fb8, $0040, $0f98, $7c7c, $08c0, $0000, $0048
dw $0f20, $0f40, $0020, $0f30, $757e, $1680, $0001, $0049
dw $0f70, $0fb8, $0048, $0f94, $757e, $1880, $0000, $004a
dw $0058, $00c0, $0068, $008c, $8080, $0020, $0001, $0017 ;Hobo (unused)

org $aab9a0 ;PC 1539a0
OWSpecialDestIndex:
dw $0080, $0081, $0082

org $aab9b0 ;PC 1539b0
OWTileWorldAssoc:
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $40, $40, $40, $40, $40, $40, $40, $40
db $00, $00

org $aaba70 ;PC 153a70
OWTileMapAlt:
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0

db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0

db 0, 0

;================================================================================
; Bonk Prize Data ($AABB00 - $AABBFB)
;--------------------------------------------------------------------------------
; This table stores data relating to bonk locations for Bonk Drop Shuffle
; 
; Example: We can use OWBonkPrizeTable[$09].loot to read what item is in the
; east tree on the Sanctuary screen
;--------------------------------------------------------------------------------
; Search Criteria - The following two fields are used as a unique index
; .owid         = OW screen ID 
; .yx           = Y & X coordinate data *see below*
; 
; .flag         = OW event flag bitmask
; .loot         = Loot ID
; .mw_player    = Multiworld player ID
; .vert_offset  = Vertical offset, # of pixels the sprite moves up when activated
;
; .yx field is a combination of both the least significant digits of the Y and X
; coordinates of the static location of the sprite located in a bonk location.
; All sprites, when initialized, are aligned by a 16 pixel increment.
; The coordinate system in LTTP is handled by two bytes:
;        (high)             (low)
;   - - - w  w w w s   s s s s  s s s s
;   w = world absolute coords, every screen is $200 pixels in each dimension
;   s = local screen coords, coords relative to the bounds of the current screen
; Because of the 16 pixel alignment of sprites, the last four bits of the coords
; are unset. This leaves 5 bits remaining, we simply disregard the highest bit
; and then combine the Y and X coords together to be used as search criteria.
; This does open the possibility of a false positive match from 3 other coords
; on the same screen (15 on megatile screens) but there are no bonk sprites that
; have collision in this regard.
;--------------------------------------------------------------------------------
struct OWBonkPrizeTable $AABB00
    .owid: skip 1
    .yx: skip 1
    .flag: skip 1
    .loot: skip 1
    .mw_player: skip 1
    .vert_offset: skip 1
endstruct align 6

org $aabb00 ;PC 153b00
OWBonkPrizeData:
; OWID  YX  Flag  Item  MW Offset
db $00, $59, $10, $b0, $00, $20
db $05, $04, $10, $b2, $00, $00
db $0a, $4e, $10, $b0, $00, $20
db $0a, $a9, $08, $b1, $00, $20
db $10, $c7, $10, $b1, $00, $20
db $10, $f7, $08, $b4, $00, $20
db $11, $08, $10, $27, $00, $00
db $12, $a4, $10, $b2, $00, $20
db $13, $c7, $10, $31, $00, $20
db $13, $98, $08, $b1, $00, $20
db $15, $a4, $10, $b1, $00, $20
db $15, $fb, $08, $b2, $00, $20
db $18, $a8, $10, $b2, $00, $20
db $18, $36, $08, $35, $00, $20
db $1a, $8a, $10, $42, $00, $20
db $1a, $1d, $08, $b2, $00, $20
;db $1a, $77, $04, $35, $00, $20  ; pre aga ONLY ; hijacked murahdahla bonk tree
db $1b, $46, $10, $b1, $00, $10
db $1d, $6b, $10, $b1, $00, $20
db $1e, $72, $10, $b2, $00, $20
db $2a, $8f, $10, $36, $00, $20
db $2a, $45, $08, $36, $00, $20
db $2b, $d6, $10, $b2, $00, $20
db $2e, $9c, $10, $b2, $00, $20
db $2e, $b4, $08, $b0, $00, $20
db $32, $29, $10, $42, $00, $20
db $32, $9a, $08, $b2, $00, $20
;db $34, $xx, $10, $xx, $00, $1c  ; pre aga ONLY
db $42, $66, $10, $b2, $00, $20
db $51, $08, $10, $b2, $00, $04
db $51, $09, $08, $b2, $00, $04
db $54, $b5, $10, $27, $00, $14
db $54, $ef, $08, $b2, $00, $08
db $54, $b9, $04, $36, $00, $00
db $55, $aa, $10, $b0, $00, $20
db $55, $fb, $08, $35, $00, $20
db $56, $e4, $10, $b0, $00, $20
db $5b, $a7, $10, $b2, $00, $20
db $5e, $00, $10, $b2, $00, $20
db $6e, $8c, $10, $35, $00, $10
db $6e, $90, $08, $b0, $00, $10
db $6e, $a4, $04, $b1, $00, $10
db $74, $4e, $10, $b1, $00, $1c
UWBonkPrizeData:
db $ff, $00, $02, $b5, $00, $08

org $AABC80 ;PC 153C80
OWMapGridLight:
db $00, $01, $02, $03, $04, $05, $06, $07
db $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
db $10, $11, $12, $13, $14, $15, $16, $17
db $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
db $20, $21, $22, $23, $24, $25, $26, $27
db $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
db $30, $31, $32, $33, $34, $35, $36, $37
db $38, $39, $3A, $3B, $3C, $3D, $3E, $3F
OWMapGridDark:
db $40, $41, $42, $43, $44, $45, $46, $47
db $48, $49, $4A, $4B, $4C, $4D, $4E, $4F
db $50, $51, $52, $53, $54, $55, $56, $57
db $58, $59, $5A, $5B, $5C, $5D, $5E, $5F
db $60, $61, $62, $63, $64, $65, $66, $67
db $68, $69, $6A, $6B, $6C, $6D, $6E, $6F
db $70, $71, $72, $73, $74, $75, $76, $77
db $78, $79, $7A, $7B, $7C, $7D, $7E, $7F

org $AABD00 ;PC 153D00
OWMapGridLightPositionByAbsolutePosition:
db $00, $01, $02, $03, $04, $05, $06, $07
db $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
db $10, $11, $12, $13, $14, $15, $16, $17
db $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
db $20, $21, $22, $23, $24, $25, $26, $27
db $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
db $30, $31, $32, $33, $34, $35, $36, $37
db $38, $39, $3A, $3B, $3C, $3D, $3E, $3F
OWMapGridDarkPositionByAbsolutePosition:
db $00, $01, $02, $03, $04, $05, $06, $07
db $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
db $10, $11, $12, $13, $14, $15, $16, $17
db $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
db $20, $21, $22, $23, $24, $25, $26, $27
db $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
db $30, $31, $32, $33, $34, $35, $36, $37
db $38, $39, $3A, $3B, $3C, $3D, $3E, $3F
