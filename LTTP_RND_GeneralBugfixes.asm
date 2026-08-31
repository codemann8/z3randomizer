;================================================================================
; The Legend of Zelda, A Link to the Past - Randomizer General Development & Bugfixes
;================================================================================
lorom

;===================================================================================================

; THIS NEEDS TO BE THE FIRST INCLUDE BECAUSE IT CHANGES THINGS EVERYWHERE
; If this were to be included later, it would almost certainly overwrite other changes
incsrc "fastrom.asm"

;================================================================================

;org $80FFC0 ; <- 7FC0 - Bank00.asm : 9173 (db "THE LEGEND OF ZELDA  " ; 21 bytes)
;db $23, $4E

org $80FFD5 ; <- 7FD5 - Bank00.asm : 9175 (db $20   ; rom layout)
db $30 ; set fast lorom

;org $80FFD6 ; <- 7FD6 - Bank00.asm : 9176 (db $02   ; cartridge type)
;db $55 ; enable S-RTC

org $80FFD7 ; <- 7FD7 - Bank00.asm : 9177 (db $0A   ; rom size)
db $0B ; mark rom as 16mbit

org $80FFD8 ; <- 7FD8 - Bank00.asm : 9178 (db $03   ; ram size (sram size))
db $05 ; mark sram as 32k

org $BFFFFF ; <- 1FFFFF
db $00 ; expand file to 2mb

org $9FFFF8 ; <- FFFF8 timestamp rom
db $20, $19, $08, $31 ; year/month/day

;================================================================================
!ROM_VERSION_LOW ?= 1  ; ROM version (two 16-bit integers)
!ROM_VERSION_HIGH ?= 5 ;

org $80FFE0 ; Unused hardware vector
RomVersion:
dw !ROM_VERSION_LOW
dw !ROM_VERSION_HIGH

;================================================================================
!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

function hexto555(h) = ((((h&$FF)/8)<<10)|(((h>>8&$FF)/8)<<5)|(((h>>16&$FF)/8)<<0))

; Feature flags, run asar with -DFEATURE_X=1 to enable

;================================================================================

!MULTIWORLD_ITEM = "$7EF4D2"
!MULTIWORLD_ITEM_FROM = "$7EF4D3"
!MULTIWORLD_ROOMID = "$7EF4D4"
!MULTIWORLD_ROOMDATA = "$7EF4D6"
!MULTIWORLD_SCOUT_LOCATION = "$7EF4D7"
!MULTIWORLD_SCOUTREPLY_LOCATION = "$7EF4D8"
!MULTIWORLD_SCOUTREPLY_ITEM = "$7EF4D9"
!MULTIWORLD_SCOUTREPLY_PLAYER = "$7EF4DA"
!MULTIWORLD_RECEIVING_ITEM = "$7EC057" ; 0 = default | 1 = receiving
!MULTIWORLD_HUD_CHARACTER_DATA = "$7EC058" ; 0x40 bytes
!MULTIWORLD_ITEM_PLAYER_ID = "$7EC098" ; 0 = disabled
!MULTIWORLD_SPRITEITEM_PLAYER_ID = "$7EC099"
!MULTIWORLD_HUD_TIMER = "$7EC09A"
!MULTIWORLD_HUD_DELAY = "#120"
!MULTIWORLD_ITEM_ID = "$7EC09B" ; for lua scripts?
!Dungeon_ChestData = "$01E96C"

!FEATURE_LIMITED_RUN ?= 0

!FLAG_OW_MIXED = $04
!FLAG_OW_CROSSED = $02
!FLAG_OW_BONKDROP = $02
!FLAG_OW_CUSTOM_MAP = $02
!FLAG_OW_ADJUST_DYNAMIC_MAP_SPRITE_POSITION = $04

incsrc hooks.asm
incsrc spriteswap.asm
incsrc hashalphabethooks.asm
incsrc sharedplayerpalettefix.asm
incsrc ram.asm
incsrc sram.asm
incsrc registers.asm
incsrc vanillalabels.asm

org $A08000 ; bank $20
incsrc itemdowngrade.asm
incsrc bugfixes.asm
incsrc darkworldspawn.asm
incsrc lampmantlecone.asm
incsrc floodgatesoftlock.asm
incsrc heartpieces.asm
incsrc npcitems.asm
incsrc flipperkill.asm
incsrc pendantcrystalhud.asm
incsrc potions.asm
incsrc shopkeeper.asm
incsrc bookofmudora.asm
incsrc crypto.asm
incsrc tablets.asm
incsrc fairyfixes.asm
incsrc rngfixes.asm
incsrc medallions.asm
incsrc zelda.asm
incsrc maidencrystals.asm
incsrc flute.asm
incsrc dungeondrops.asm
incsrc halfmagicbat.asm
incsrc swordswap.asm
incsrc stats.asm
incsrc dialog.asm
incsrc entrances.asm
incsrc accessibility.asm
incsrc heartbeep.asm
incsrc capacityupgrades.asm
incsrc timer.asm
incsrc doorframefixes.asm
incsrc music.asm
incsrc roomloading.asm
incsrc icepalacegraphics.asm
incsrc follower.asm
warnpc $A18000

org $9C8000 ; text tables for translation
incbin "data/i18n_en.bin"
warnpc $9CF356

org $A18000 ; static mapping area
incsrc framehook.asm
warnpc $A186B0

org $A186B0 ; static mapping area, do not move
incsrc hud.asm
warnpc $A18800

org $A18800 ; static mapping area

warnpc $A19000

org $A1A000 ; static mapping area. Referenced by front end. Do not move.
incsrc invertedstatic.asm
warnpc $A1A100

org $A1B000
incsrc failure.asm
warnpc $A1FF00


org $A1FF00 ; static mapping area
incsrc init.asm

org $A48000 ; code bank - PUT NEW CODE HERE
incsrc glitched.asm
incsrc hardmode.asm
incsrc goalitem.asm
incsrc quickswap.asm
incsrc cuccostorm.asm
incsrc retro.asm
incsrc controllerjank.asm
incsrc boots.asm
incsrc events.asm
incsrc fileselect.asm
incsrc playername.asm
incsrc decryption.asm
incsrc hashalphabet.asm
incsrc inverted.asm
incsrc invertedmaps.asm
incsrc bonktreemaps.asm
incsrc newhud.asm
incsrc save.asm
incsrc password.asm
incsrc enemy_adjustments.asm
;incsrc hudtext.asm
incsrc servicerequest.asm
incsrc elder.asm
incsrc toast.asm
incsrc fastcredits.asm
incsrc msu.asm
incsrc menu/overworldmap.asm ; Overwrites some code in bank $8A
incsrc dungeonmap.asm
incsrc hextodec.asm
incsrc multiworld.asm
incsrc textrenderer.asm
warnpc $A58000

org $A28000
ItemReceiptGraphicsROM:
; we need some empty space here so that 0000 can mean nothing
fillbyte $00 : fill 32
incbin "data/customitems.4bpp"
PreloadedGraphicsROM:
incbin "data/preloadedgfx.4bpp"
if !FEATURE_LIMITED_RUN == 2604
    incbin "data/limited/limited2604.4bpp"
endif
warnpc $A2B000
org $A2B000
incsrc itemdatatables.asm ; Statically mapped
incsrc decompresseditemgraphics.asm
incsrc newitems.asm
incsrc utilities.asm
incsrc inventory.asm
incsrc menu/hudalpha.asm
warnpc $A38000

org $A38000
incsrc stats/credits.asm ; Statically mapped
org $A39800
incsrc stats/main.asm
incsrc stats/statConfig.asm
FontTable:
incsrc stats/fonttable.asm

incsrc doorrando/doorrando.asm ; bank 27/A7
;bank 28/A8 for keydropshuffle / standing items
incsrc keydrop/standing_items.asm ; bank 28/A8
incsrc owrando.asm ; bank 2A/AA
incsrc limited/limited_hooks.asm ; bank 2D/AD
incsrc enemizer/main.asm ; bank 36/B6

org $B08000 ; bank #$30
incsrc tables.asm
warnpc $B18000

org $B48000
incsrc spc.asm

org $B18000 ; bank $31
GFX_Mire_Bombos:
incbin "data/99ff1_bombos.gfx"
warnpc $B18800

org $B18800
GFX_Mire_Quake:
incbin "data/99ff1_quake.gfx"
warnpc $B19000

org $B19000
GFX_TRock_Bombos:
incbin "data/a6fc4_bombos.gfx"
warnpc $B19800

org $B19800
GFX_TRock_Ether:
incbin "data/a6fc4_ether.gfx"
warnpc $B1A000

org $B1A000
GFX_HUD_Items:
incbin "menu/drsheetdc.2bppc"
warnpc $B1A800

org $B1A800

warnpc $B1B000

org $B1B000
GFX_HUD_Main:
incbin "data/c2e3e.gfx"
warnpc $B1B800

org $B1C000
IcePalaceFloorGfx:
incbin "data/ice_palace_floor.bin"
warnpc $B1C801

org $B1C800
Damage_Table:
incbin "data/damage_table.bin"
warnpc $B1D001

org $B1D000
FileSelectNewGraphics:
incbin "data/fileselectgfx.2bpp"
warnpc $B1E001

org $B1E000
InvertedCastleHole: ;address used by front end. DO NOT MOVE!
incbin "data/sheet73.gfx"
warnpc $B1E501

org $B38000
GFX_HUD_Palette:
incbin "data/hudpalette.pal"
warnpc $B38041

org $B39000
ExpandedTrinexx:
incbin "data/sheet178.gfx"
warnpc $B39600

org $B39600
BossMapIconGFX:
incbin "data/bossicons.4bpp"

org $B39C00
NewFont:
incbin "data/newfont.bin"
NewFontInverted:
incbin "data/newfont_inverted.bin"
SmallCharacters:
incbin "data/smallchars.2bpp"
org $8CD7DF
incsrc data/playernamecharmap.asm
org $8CE73D
incbin data/playernamestripes_1.bin
org $8CE911
incbin data/playernamestripes_2.bin
incsrc data/kanjireplacements.asm ; Overwrites text gfx data and masks in bank $8E

org $B28000
Extra_Text_Table:
incsrc itemtext.asm
warnpc $B2E000

org $B2DFD0	; PC 0x195FD0
incsrc multiworldplayernames.asm
warnpc $B30000

incsrc externalhooks.asm
;================================================================================
org $919100 ; PC 0x89100
incbin "data/map_icons.gfx"
warnpc $919401
;================================================================================
org $9BB1E0
incsrc custompalettes.asm
warnpc $9BB880
;================================================================================
org $AF8000 ; PC 0x178000
Static_RNG: ; each line below is 512 bytes of rng
incsrc staticrng.asm
warnpc $AF8401
;================================================================================
org $AF8400
incsrc tournament.asm
incsrc eventdata.asm
warnpc $B08000
;================================================================================
;Bank Map
;$20 Code Bank
;$21 Reserved (Frame Hook & Init)
;$22 Unused
;$23 Stats & Credits
;$24 Code Bank
;$25 GFX/SFX Overrides
;$26 Multiworld data
;$27 DR Code Bank
;$28 Keydrop / Standing Items Code bank
;$29 External hooks (rest of bank not used)
;$2A Reserved for OWR
;$2B Reserved for "outlet data" ~5.8k
;$2D Reserved for Limited-Run/Seasonal Features
;$2E Reserved for Tournament Use
;$2F Static RNG (rest is reserved for tournament use)
;$30 Main Configuration Table
;$31 Graphics Bank
;$32 Text Bank
;$33 Graphics Bank
;$36 reserved for Enemizer
;$37 Room data if needed for DR/Pottery/Enemizer
;$3A reserved for downstream use
;$3B reserved for downstream use
;$3F reserved for internal debugging
;================================================================================
;RAM
;See ram.asm for label assignments
;$7EC900[0x1F00]: BigRAM buffer
;$7EF000[0x500]: SRAM mirror First 0x500 bytes of SRAM
;   See sram.asm for labels and assignments
;$7F5000[0x800]: Rando's main free ram region
;   See ram.asm for specific assignments
;$7F6000[0x1000]: SRAM buffer mapped to vanilla save slots 1 and 2
;   See sram.asm for labels and assignments
;$7F7667[0x6719] - free ram
;================================================================================
;SRAM Map
;See sram.asm for label assignments and documentation
;$70:0000 (5K) Game state
;  0000-04FF Vanilla Slot 1 (mirrored at $7EF000)
;  0500-14FF Ext Slot 1 (mirrored at $7F6000)
;$70:2000 (0x25) ROM Name and version number
;$70:3000 (0x16) Password
;$70:6000 (8K) Scratch buffers
;================================================================================

org $80D09C ; 0x509C - HUD Items H
db GFX_HUD_Items>>16
org $80D17B ; 0x517B - HUD Items M
db GFX_HUD_Items>>8
org $80D25A ; 0x525A - HUD Items L
db GFX_HUD_Items

org $80D09D ; 0x509D - HUD Main H
db GFX_HUD_Main>>16
org $80D17C ; 0x517C - HUD Main M
db GFX_HUD_Main>>8
org $80D25B ; 0x525B - HUD Main L
db GFX_HUD_Main

;================================================================================
