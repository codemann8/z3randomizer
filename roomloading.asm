LoadRoomHook:
    JSL IndoorTileTransitionCounter

    .noStats
    JSL Dungeon_LoadRoom
    REP #$10 ; 16 bit XY
        LDX.b RoomIndex ; Room ID
        LDA.l RoomCallbackTable, X
    SEP #$10 ; 8 bit XY
    JSL JumpTableLong
; Callback routines:
    dl NoCallback ; 00
    dl IcePalaceBombosSE ; 01
    dl IcePalaceBombosSW ; 02
    dl IcePalaceBombosNE ; 03
    dl CastleEastEntrance ; 04
    dl CastleWestEntrance ; 05

NoCallback:
    RTL

macro setTilePointer(roomX, roomY, quadX, quadY)
    ; Left-to-right math. Should be equivalent to 0x7e2000+(roomX*2)+(roomY*128)+(quadX*64)+(quadY*4096)
    LDX.w #<quadY>*32+<roomY>*2+<quadX>*32+<roomX>*2
endmacro

macro writeTile()
    STA.l TileMapA,x
    INX #2
endmacro

macro writeTileAt(roomX, roomY, quadX, quadY)
    STA.l <quadY>*32+<roomY>*2+<quadX>*32+<roomX>*2+TileMapA
endmacro

!BOMBOS_BORDER = $08D0
!BOMBOS_ICON_1 = $0CCA
!BOMBOS_ICON_2 = $0CCB
!BOMBOS_ICON_3 = $0CDA
!BOMBOS_ICON_4 = $0CDB
macro DrawBombosPlatform(roomX, roomY, quadX, quadY)
    REP #$30 ; 16 AXY
    %setTilePointer(<roomX>, <roomY>, <quadX>, <quadY>)
    LDA.w #!BOMBOS_BORDER
    %writeTile()
    %writeTile()
    %writeTile()
    %writeTile()

    %setTilePointer(<roomX>, <roomY>+1, <quadX>, <quadY>)
    %writeTile()
    LDA.w #!BOMBOS_ICON_1 : %writeTile()
    LDA.w #!BOMBOS_ICON_2 : %writeTile()
    LDA.w #!BOMBOS_BORDER : %writeTile()

    %setTilePointer(<roomX>, <roomY>+2, <quadX>, <quadY>)
    %writeTile()
    LDA.w #!BOMBOS_ICON_3 : %writeTile()
    LDA.w #!BOMBOS_ICON_4 : %writeTile()
    LDA.w #!BOMBOS_BORDER : %writeTile()

    %setTilePointer(<roomX>, <roomY>+3, <quadX>, <quadY>)
    %writeTile()
    %writeTile()
    %writeTile()
    %writeTile()
    SEP #$30 ; 8 AXY
endMacro

IcePalaceBombosSE:
    LDA.l AllowSwordlessMedallionUse : CMP.b #$01 : BEQ + : RTL : +
    %DrawBombosPlatform(14, 18, 1, 1)
    RTL
IcePalaceBombosSW:
    LDA.l AllowSwordlessMedallionUse : CMP.b #$01 : BEQ + : RTL : +
    %DrawBombosPlatform(14, 18, 0, 1)
    RTL
IcePalaceBombosNE:
    LDA.l AllowSwordlessMedallionUse : CMP.b #$01 : BEQ + : RTL : +
    %DrawBombosPlatform(14, 18, 1, 0)
    RTL

CastleEastEntrance: ; new solution (see Rain Prevention)
    RTL

CastleWestEntrance: ; new solution (see Rain Prevention)
    RTL

RoomCallbackTable:
    ;    0    1    2    3	 4    5    6    7    8    9    A    B    C    D    E    F
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00 ; 00x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 01x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 02x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 03x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 04x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 05x
    db $05, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 06x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $00 ; 07x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 08x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 09x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Ax
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Bx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Cx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00 ; 0Dx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Ex
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Fx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Fx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 10x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 11x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 12x
