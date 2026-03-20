;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
; This module is primarily concerned with labeling WRAM addresses used by the
; randomizer and documenting their usage. We use a combination of base $[address]
; and WRAMLabel = $[address] here, favoring the former when we have larger blocks
; of contiguous ram labeled. A line is skipped when the next address is non-cotiguous,
; but comments will go in the empty space if multi-line. In some cases the label
; name can be descriptive enough without documentation. Or I just didn't know what it was.
;
; See the JP 1.0 disassembly for reference, specifically symbols_wram.asm
; (https://github.com/spannerisms/jpdasm/ - 19/11/2022)
;--------------------------------------------------------------------------------
pushpc
org 0

;================================================================================
; Bank 7E
;--------------------------------------------------------------------------------
;================================================================================
; Direct Page
;--------------------------------------------------------------------------------
base $7E0000
Scrap:
Scrap00: skip 1                   ; Used as short-term scratch space. If you need some short-term
Scrap01: skip 1                   ; RAM, you can often use these. Double check that the next use
Scrap02: skip 1                   ; of the addresses you want to use is a write.
Scrap03: skip 1                   ;
Scrap04: skip 1                   ;
Scrap05: skip 1                   ;
Scrap06: skip 1                   ;
Scrap07: skip 1                   ;
Scrap08: skip 1                   ;
Scrap09: skip 1                   ;
Scrap0A: skip 1                   ;
Scrap0B: skip 1                   ;
Scrap0C: skip 1                   ;
Scrap0D: skip 1                   ;
Scrap0E: skip 1                   ;
Scrap0F: skip 1                   ;
GameMode = $7E0010                ; Game mode & submode. Refer to disassembly.
GameSubMode = $7E0011             ;
NMIDoneFlag = $7E0012             ; $00 = Main loop done | $01 = Not done (lag)
INIDISPQ = $7E0013                ; Queue for INIDISP updates. Written during NMI.
NMISTRIPES = $7E0014              ; NMI update flags.
NMICGRAM = $7E0015                ; When non-zero, will trigger a specific gfx update
NMIHUD = $7E0016                  ; during NMI.
NMIINCR = $7E0017                 ;
NMIUP1100 = $7E0018               ;
UPINCVH = $7E0019                 ; Incremental upload VRAM high byte
FrameCounter = $7E001A            ; Increments every frame that the game isn't lagging
IndoorsFlag = $7E001B             ; $00 = Outdoors | $01 = Indoors
MAINDESQ = $7E001C                ; PPU register queues written during NMI
SUBDESQ = $7E001D                 ;
TMWQ = $7E001E                    ;
TSWQ = $7E001F                    ;
LinkPosY = $7E0020                ; Link's absolute x/y coordinates. Both are word length.
LinkPosX = $7E0022                ;
LinkPosZ = $7E0024                ; $FFFF when on ground
LinkPushDirection = $7E0026       ; - - - - u d l r
LinkRecoilY = $7E0027             ;
LinkRecoilX = $7E0028             ;
LinkRecoilZ = $7E0029             ;
LinkSubPixelVelocty = $7E002A     ; Word length
LinkAnimationStep = $7E002E       ;
LinkDirection = $7E002F           ; $00 = Up | $02 = Down | $04 = Left | $06 = Right
                                  ;
FlagBY = $7E003A                  ; Bitfield for B and Y buttons.
                                  ;
OAMOffsetY = $7E0044              ;
OAMOffsetX = $7E0045              ;
LinkIncapacitatedTimer = $7E0046  ; Countdown when Link takes damage, not same as I-frames
                                  ;
ForceMove = $7E0049               ; Forces D-Pad inputs when written to
                                  ;
LinkVisible = $7E004B             ; When 0x0C, Link is invisible
CapeTimer = $7E004C               ; Countdown for cape sapping magic Countdown for cape sapping magic..
LinkJumping = $7E004D             ; $00 = None | $01 = Bonk/damage/water | $02 = Ledge
                                  ;
LinkStrafe = $7E0050              ; ???
LinkTargetPosY = $7E0051          ; Target Y coordinate Link should fall to
LinkTargetPosX = $7E0053          ; Target X coordinate Link
                                  ;
CapeOn = $7E0055                  ; Link invisible and untouchable when set.
BunnyFlagDP = $7E0056             ; $00 = Link | $01 = Bunny
                                  ;
PitTileActField = $7E0059         ; Tile action bitfield used by pits
LinkFallPose = $7E005A            ; Pose when falling
LinkSlipping = $7E005B            ; $00 = None | $01 = Near pit
                                  ; $02 = Falling | $03 = Falling "more"
FallTimer = $7E005C               ; Timer for falling animation
LinkState = $7E005D               ; Main Link state handler
LinkSpeed = $7E005E               ; Main Link speed handler
ManipTileField = $7E005F          ; Bitfield used by manipulable tiles
                                  ;
LinkLastDirection = $7E0066       ; Last direction Link moved: $00=up $01=down $02=left $03=right
LinkWalkDirection = $7E0067       ; - - - - u d l r
                                  ;
ScrapBuffer72 = $7E0072           ; Volatile scrap buffer. 5 bytes.
                                  ;
WorldCache = $7E007B              ; $00 = Light world | $40 bit set for dark world.
                                  ;
OverworldMap16Buffer = $7E0084    ; Buffer used to load new GFX when scrolling. Word length.
OverworldTilemapIndexX = $7E0086  ; Used to index $500 and tilemap. Word length.
OverworldTilemapIndexY = $7E0088  ; Used to index $500 and tilemap. Word length.
OverworldIndex = $7E008A          ; Overworld screen index. Word length. Dark world is OR $40 of
                                  ; light world screen in same position. Zeroed on UW entry.
OverlayID = $7E008C               ; Overworld overlay ID. One Byte.
                                  ;
OAMPtr = $7E0090                  ; Pointer used to indirectly address OAM buffer. 4 bytes.
BGMODEQ = $7E0094                 ; Various PPU queues handled during NMI
MOSAICQ = $7E0095                 ;
W12SELQ = $7E0096                 ;
W34SELQ = $7E0097                 ;
WOBJSELQ = $7E0098                ;
CGWSELQ = $7E0099                 ;
CGADSUBQ = $7E009A                ;
HDMAENABLEQ = $7E009B             ; HDMA enable flags
                                  ;
RoomIndex = $7E00A0               ; Underworld room index. Word length. High byte: $00 = EG1 | $01 = EG2
                                  ; Not zeroed on exit to overworld.
PreviousRoom = $7E00A2            ; Stores previous value of RoomIndex
                                  ;
CameraBoundH = $7E00A6            ; Which set of camera boundaries to use.
CameraBoundV = $7E00A7            ;
                                  ;
LinkQuadrantH = $7E00A9           ; Which quadrant Link is in. 0 = left, 1 = right
LinkQuadrantV = $7E00AA           ; 0 = top, 2 = bottom
                                  ;
RoomTag = $7E00AE                 ; Room effects; e.g. kill room, shutter switch, etc. Word length.
                                  ;
SubSubModule = $7E00B0            ; Often used as a submodule, such as for transitions
                                  ;
ObjPtr = $7E00B7                  ; Pointer for drawing room objects. Three bytes.
ObjPtrOffset = $7E00BA            ; Used as an offset for ObjPointer. Word Length.
PlayerSpriteBank = $7E00BC        ;
ScrapBufferBD = $7E00BD           ; Another scrap buffer. $23 bytes.
FileSelectPosition = $7E00C8      ;
PasswordCodePosition = $7E00C8    ;
PasswordSelectPosition = $7E00C9  ;
                                  ;
BG1H = $7E00E0                    ; Background scroll registers
BG2H = $7E00E2                    ; For BG1 and BG2, these registers are used for calculations later for different writes to PPU.
BG3HOFSQL = $7E00E4               ; For BG3, the values are written directly to the PPU during NMI
BG1V = $7E00E6                    ; Since BG1 and BG2 are not written directly to PPU they are given different names from BG3.
BG2V = $7E00E8                    ;
BG3VOFSQL = $7E00EA               ;
                                  ;
LinkLayer = $7E00EE               ; Layer that Link is on. $00 = BG2 (upper) | $01 = BG1 (lower)
                                  ;
Joy1A_All = $7E00F0               ; Joypad input
Joy2A_All = $7E00F1               ; All = Current & previous frame
Joy1B_All = $7E00F2               ; New = Current frame
Joy2B_All = $7E00F3               ; Old = Previous frame
Joy1A_New = $7E00F4               ;
Joy2A_New = $7E00F5               ;
Joy1B_New = $7E00F6               ;
Joy2B_New = $7E00F7               ;
Joy1A_Old = $7E00F8               ;
Joy2A_Old = $7E00F9               ;
Joy1B_Old = $7E00FA               ;
Joy2B_Old = $7E00FB               ;

;================================================================================
; Mirrored WRAM
;--------------------------------------------------------------------------------
; Pages 0x00–0x1F of Bank7E are mirrored to every program bank ALTTP uses.
;--------------------------------------------------------------------------------

DeathReloadFlag = $7E010A         ; Flag set on death for dungeon reload
CurrentMSUTrack = $7E010B         ;
GameModeCache = $7E010C           ;
GameSubModeCache = $7E010D        ;
EntranceIndex = $7E010E           ; Entrance ID into underworld. Word length.
                                  ;
MedallionFlag = $7E0112           ; Medallion cutscene flag. $01 = Cutscene active.
                                  ;
VRAMTileMapIndex = $7E0116        ; Index for high bytes for VRAM tile map uploads
VRAMUploadAddress = $7E0118       ; Incremental VRAM upload address. Low byte always 0. Word length.
                                  ;
BG1ShakeV = $7E011A               ; Applied to BG Scroll. Word Length.
BG1ShakeH = $7E011C               ;
                                  ;
CurrentVolume = $7E0127           ;
TargetVolume = $7E0129            ;
MusicControl = $7E012B            ;
MusicControlRequest = $7E012C     ;
SFX1 = $7E012D                    ;
SFX2 = $7E012E                    ;
SFX3 = $7E012F                    ;
LastAPUCommand = $7E0130          ; Last non-zero command given to SPC.
LastSFX1 = $7E0131                ; Last non-zero SFX1
MusicControlQueue = $7E0132       ; Used to queue up writes to MusicControlRequest
CurrentControlRequest = $7E0133   ; Last thing written to MusicControlRequest
LastAPU = $7E0134                 ; Stores last anything written to MusicControlRequest
                                  ;
SubModuleInterface = $7E0200      ; Word length. High byte expected to be $00.
ItemCursor = $7E0202              ; Current location of the item menu cursor.
                                  ;
BottleMenuCounter = $7E0205       ; Step counter for opening bottle menu
MenuFrameCounter = $7E0206        ; Incremented every menu frame. Never read.
MenuBlink = $7E0207               ; Incremented every frame and masked with $10 to blink cursor
                                  ;
RaceGameFlag = $7E021B            ;
                                  ;
MessageJunk = $7E0223             ; Zeroed but never used (?)
                                  ;
ProgressiveFlag = $7E0224         ; unused
;CoolScratch = $7E0224            ; 0x5C bytes of free ram
ItemStackPtr = $7E0226            ; Pointer into Item GFX and VRAM target queues. Word length.
                                  ; If not zero, pointer should always be left pointing at the
                                  ; next available slot in the stack during the frame.
SprSourceItemId = $7E0230         ; 0x10 bytes. Receipt ID without item substitutions.
SpriteMetaData = $7E0240          ; 0x10 bytes. Sprite metadata. Used for prog bow tracking.
AncillaVelocityZ = $7E0294        ; 0x0A bytes
AncillaZCoord = $7E029E           ; 0x0A bytes
                                  ;
ItemReceiptID = $7E02D8           ;
ItemReceiptPose = $7E02DA         ; $00 = No pose | $01 = One hand up | $02 = Two hands up
                                  ;
BunnyFlag = $7E02E0               ; $00 = Link | $01 = Bunny
Poofing = $7E02E1                 ; Flags cape and bunny poof.
PoofTimer = $7E02E2               ; Countdown timer for poofing.
SwordCooldown = $7E02E3           ; Cooldown for sword after dashing through an enemy.
CutsceneFlag = $7E02E4            ; Flags various cutscenes.
                                  ;
ItemReceiptMethod = $7E02E9       ;
                                  ;
TileActBE = $7E02EF               ; Bitfield used by breakables and entrances. b b b b d d d d
                                  ; b = Breakables | d = Entrances
LinkThud = $7E02F8                ; When set, guarantees a thud on landing
FollowerNoDraw = $7E02F9          ; When set, prevents follower from drawing and forces a game mode check
UseY1 = $7E0301                   ; Bitfield for Y-item usage: b p - a x z h r
                                  ; b = Boomerang                | p = Powder | a = Bow  | x = Hammer (tested, never set)
                                  ; z = Rods (tested, never set) | h = Hammer | r = Rods
CurrentYItem = $7E0303            ;
                                  ;
AButtonAct = $7E0308              ; Bitfield for A-actions. $80 = Carry/toss | $02 Prayer | $01 = Tree pull
CarryAct = $7E0309                ; Bitfield for carrying. $02 = Tossing | $01 = Lifting
                                  ;
LinkIFrames = $7E031F             ; Countdown for Link's invincibility frames after taking damage.
                                  ;
LinkSwimDirection = $7E0340       ; Bitfield for swim direction. (.... udlr)
                                  ;
LinkDeepWater = $7E0345           ; Set when Link is in deep water.
                                  ;
TileActIce = $7E0348              ; Bitfield used by ice. Word length.
                                  ;
TileActDig = $7E035B              ; Bitfield used by diggable ground. Word length. High byte unused.
                                  ;
LinkZap = $7E0360                 ; When set, recoil zaps Link.
                                  ;
LinkDashing = $7E0372             ; Flags when Link is dashing, also spinspeed
DamageReceived = $7E0373          ; Damage to deal to Link.
                                  ;
UseY2 = $7E037A                   ; - - b n c h - s
                                  ; b = Book | n = Net | c = Canes | h = Hookshot | s = Shovel
NoDamage = $7E037B                ; Prevents Link from receiving damage.
                                  ;
AncillaGeneralA = $7E0385         ; General use buffer for front slot ancillae. $05 bytes.
                                  ;
AncillaGeneralD = $7E0394         ; General use buffer for front slot ancillae. $05 bytes.
                                  ;
AncillaGeneralF = $7E039F         ; General use buffer for front slot ancillae. $0F bytes.
                                  ;
AncillaTimer = $7E03B1            ; Used as a timer for ancilla.
                                  ;
AncillaSearch = $7E03C4           ; Used to search through ancilla when every front slot is occupied.
                                  ;
ForceSwordUp = $7E03EF            ; $01 = Force sword up pose.
FluteTimer = $7E03F0              ; Countdown timer for being able to use the flute
                                  ;
YButtonOverride = $7E03FC         ; Y override for minigames. $00 = Selected item | $01 = Shovel | $02 = Bow
                                  ;
RoomItemsTaken = $7E0403          ; Items taken in a room: b k u t s e h c
                                  ; b = boss kill/item         | k = key/heart piece (prevents crystals)
                                  ; u = 2nd key/heart piece    | t = chest 4/rupees/swamp drain/bomb floor/mire wall
                                  ; s = chest 3/pod or dp wall | e, h, c = chest 2, 1, 0
OverworldIndexMirror = $7E040A    ; Overworld Area Index. Mirrors $8A
DungeonID = $7E040C               ; High byte mostly unused but sometimes read. Word length.
                                  ;
TransitionDirection = $7E0418     ; OW: 0=N 1=S 2=W 3=E  UW: 0=S 1=N 2=E 3=W
                                  ;
ManipIndex = $7E042C              ; Index of manipulable tile. Word length.
                                  ;
TrapDoorFlag = $7E0468            ; Flag that is set when trap doors are down. 2 bytes
                                  ;
LayerAdjustment = $7E047A         ; Flags layer adjustments. Arms EG.
                                  ;
RoomIndexMirror = $7E048E         ; Mirrors RoomIndex
                                  ;
RespawnFlag = $7E04AA             ; If set, entrance loading is treated as a respawn. Word length.
Map16ChangeIndex = $7E04AC        ; Word length.
                                  ;
HUDTimer = $7E04B4                ; General purpose timer for HUD
HUDTimerDelay = $7E04B5           ; Countdown until next HUD timer decrement
                                  ;
OWEntranceCutscene = $7E04C6      ;
                                  ;
HammerPegCounter = $7E04C8        ; Counts pegs hammered in overworld
HeartBeepTimer = $7E04CA          ;
                                  ;
ManipTileMapX = $7E0540           ; Tilemap X position of manipulable tile. $10 x 2 bytes
                                  ;
CameraTargetN = $7E0610           ; Camera scroll target for directions NSEW
CameraTargetS = $7E0612           ;
CameraTargetW = $7E0614           ;
CameraTargetE = $7E0616           ;
CameraScrollN = $7E0618           ; Camera scroll trigger areas for directions NSEW
CameraScrollS = $7E061A           ; The higher boundary should always be +2 from the lower in
CameraScrollW = $7E061C           ; underworld and -2 in overworld.
CameraScrollE = $7E061E           ;
                                  ;
NMIAux = $7E0632                  ; Stores long address of NMI jump. Currently only used by shops.
                                  ;
SpriteRoomTag = $7E0642           ; Set high by sprites triggering room tags.
                                  ;
SomariaSwitchFlag = $7E0646       ; Set by Somaria when on a switch.
                                  ;
TileMapDoorPos = $7E068E          ; (Dungeon) ???? related to trap doors and if they are open ; possibly bomb doors too? Update: module 0x07.0x4 probably uses this to know whether it's a key door or big key door to open. Word length.
DoorTimer = $7E0690               ; Timer for animating doors, like Sanc or HC overworld doors
TileMapUpdateId = $7E0692         ; Used as an index for updating doors in the underworld or tile32 on the overworld
                                  ;
TileMapEntranceDoors = $7E0696    ; Tilemap location of entrance doors. Word length.
TileMapTile32 = $7E0698           ; Tilemap location of new tile32 objects, such as from graves/rocks. Word length.
                                  ;
RandoOverworldEdgeAddr = $7E06F8  ; Used to store OWR edge table addresses
RandoOverworldTargetEdge = $7E06FA; Used to store target edge IDs
RandoOverworldWalkDist = $7E06FC  ; Used for custom walk destination after transitions
                                  ;
OverworldSlotPosition = $7E0700   ; Used to show which OW slot/square Link is in. Useful for "quadrants" on larger screens.
                                  ;
RandoOverworldForceTrans = $7E0703; Used to flag forced transitions
RandoOverworldTerrain = $7E0704   ; Used to store terrain type at the start of a transition
                                  ;
SkipOAM = $7E0710                 ; Set to skip OAM updates. High byte written $FF with exploding walls
OWScreenSize = $7E0712            ; Flags overworld screen size.

SpawnedItemID = $7E0720           ; ID of the Item Spawning. Word
SpawnedItemIndex = $7E0722        ; Sprite/Pot Index of Item Spawning. Word
SpawnedItemIsMultiWorld = $7E0724 ; Multiworld World Flag. Word
SpawnedItemFlag = $7E0726         ; 0x02 - one for pot, 2 for sprite drop
                                  ; (flag used as a bitmask in conjunction with StandingItemCounterMask)
SpawnedItemMWPlayer = $7E0728     ; Player Id for spawned item if Multiworld item 0x02
                                  ;
EnemyDropIndicator = $7E072A      ; Used by HUD to indicate enemy drops remaining
SkipBeeTrapDisguise = $7E072D     ; Flag to skip bee trap disguise during draw routine

SprDropsItem = $7E0730            ; Array for whether a sprite drops an item 0x16
SprItemReceipt = $7E0740          ; Array for item id for each sprite 0x16
SprItemIndex = $7E0750            ; Array for item index (see code)
SprItemMWPlayer = $7E0760         ; Player id for each sprite drop 0x16
SprItemFlags = $7E0770            ; Array 0x16 (used for both pots and drops) (combine with SprDropsItem?)
SprItemGFXSlot = $7E0780          ; this will keep track of the DynamicDropGFXIndex for each item
SprRedrawFlag = $7E0790           ; this is a flag indicating the gfx for a sprite should be reloaded and redrawn
                                  ;
DynamicDropGFXIndex = $7E07F0     ; this will just count from 0 to 6 to determine which slot we're using
                                  ; we're expecting 5 items max per room, and order is irrelevant
                                  ; we just need to keep track of where they go
DynamicDropGFXSlots = $7E07F1     ; Assume future use of this up to $0E bytes, these will store
                                  ; which item gfx is currently occupying each slot
OAMBuffer = $7E0800               ; Main OAM buffer sent to OAM. $200 bytes.
OAMBuffer2 = $7E0A00              ;
                                  ;
; $7E0AB9-0ABC                    ; Reserved for limited run use
TransparencyFlag = $7E0ABD        ; Flags transparency effects e.g. in Thieves Town Hellway
                                  ;
OWTransitionFlag = $7E0ABF        ; Used for certain transitions like smith, witch, etc.
                                  ;
DuckPose = $7E0AF4                ; Used for duck gfx (2 bytes), zero value stops duck drawing in gfx slot
                                  ;
ItemGFXPtr = $7E0AFA              ; Pointer for item receipt graphics transfers
                                  ; $0000       - no transfer, do nothing
                                  ; bit 7 reset - offset into ROM table
                                  ; bit 7 set   - explicit bank7 address
ItemGFXTarget = $7E0AFC           ; target VRAM address
                                  ;
ArcVariable = $7E0B08             ; Arc variable. Word length.
OverlordXLow = $7E0B08            ; $08 bytes.
OverlordXHigh = $7E0B10           ; $08 bytes.
PlayerNameCursor = $7E0B12        ; Player name screen.
OverlordYLow = $7E0B18            ; $08 bytes.
OverlordYHigh = $7E0B20           ; $08 bytes.
                                  ;
EnemyStunTimer = $7E0B58          ; Auto-decrementing timer for stunned enemies. $10 bytes.
SpriteTileDeath = $7E0B68         ; Contains properties involving a sprite's ability to die during tile interaction. $10 bytes.
                                  ;
BowDryFire = $7E0B9A              ; If set, arrows are deleted immediately
                                  ;
SecretId = $7E0B9C                ; Controls the secret spawned from bushes, pots, rocks, etc.
SaveFileIndex = $7E0B9D           ;
                                  ;
SpriteAncillaInteract = $7E0BA0   ; If nonzero, ancillae do not interact with the sprite. $10 bytes.
SpriteAncillaInteractID = $7E0BB0 ; This contains the ID of the ancilla that hit the sprite. $10 bytes.
                                  ;
SpritePrizeProps = $7E0BE0        ; Various properties, including prize pack info. $10 bytes.
AncillaGeneralM = $7E0BF0         ; General use buffer for ancillae. $10 bytes.
AncillaCoordYLow = $7E0BFA        ;
AncillaCoordXLow = $7E0C04        ;
AncillaCoordYHigh = $7E0C0E       ;
AncillaCoordXHigh = $7E0C18       ;
AncillaVelocityY = $7E0C22        ; $0A bytes.
AncillaVelocityX = $7E0C2C        ; $0A bytes.
AncillaSubPixelY = $7E0C36        ; $0A bytes.
AncillaSubPixelX = $7E0C40        ; $0A bytes.
AncillaID = $7E0C4A               ; $0A bytes.
AncillaGeneralN = $7E0C54         ; General use buffer for ancillae. $0A bytes.
AncillaGet = $7E0C5E              ; Used by various ancilla in various ways. $0A bytes.
AncillaTimerA = $7E0C68           ; Used as a timer for ancilla. $0A bytes.
AncillaDirection = $7E0C72        ; Used by various ancilla to track its direction. $0A bytes
AncillaLayer = $7E0C7C            ;
AncillaOAMOffset = $7E0C86        ; OAM region offset of ancilla. $0A bytes.
AncillaOAMAlloc = $7E0C90         ; OAM allocation for ancilla. $0A bytes.
SpriteScreenOwner = $7E0C9A       ; Used during screen transitions to handle sprite death. $10 bytes.
SpriteDeflection = $7E0CAA        ; Various flags relating to death and deflection. $10 bytes.
SpriteForceDrop = $7E0CBA         ; Forces drops on sprite death. $10 bytes.
                                  ;
SpriteBump = $7E0CD2              ; See symbols_wram.asm. $10 bytes.
SpriteDamageIncurred = $7E0CE2    ; Stores damage being done to a sprite. $10 bytes.
                                  ;
BossSpecialAction = $7E0CF3       ; Indicates special action required for some bosses
TreePullKills = $7E0CFB           ; Kills for tree pulls.
TreePullHits = $7E0CFC            ; Hits taken for tree pulls.
                                  ;
SpritePosYLow = $7E0D00           ; Sprite slot data. Each label has $10 bytes unless otherwise
SpritePosXLow = $7E0D10           ; specified. Some of these I'm not sure what they are. May
SpritePosYHigh = $7E0D20          ; have taken a guess or just made something up.
SpritePosXHigh = $7E0D30          ;
SpriteVelocityY = $7E0D40         ;
SpriteVelocityX = $7E0D50         ;
SpriteSubPixelY = $7E0D60         ;
SpriteSubPixelX = $7E0D70         ;
SpriteActivity = $7E0D80          ; Not sure what this is.
SpriteMovement = $7E0D90          ; Not sure what this is.
SpriteAuxTable = $7E0DA0          ; $10 bytes.
SpriteAuxTableB = $7E0DB0         ; $10 bytes.
SpriteGFXControl = $7E0DC0        ;
SpriteAITable = $7E0DD0           ; AI state of sprites. $10 bytes.
SpriteMoveDirection = $7E0DE0     ; $00 = Right | $01 = Left | $02 = Down | $03 = Up
SpriteTimer = $7E0DF0             ;
SpriteTimerB = $7E0E00            ;
SpriteTimerC = $7E0E10            ;
SpriteTypeTable = $7E0E20         ; Which sprite occupies this slot. $10 bytes.
SpriteAux = $7E0E30               ;
SpriteOAMProperties = $7E0E40     ; h m w o o o o o | h = Harmless       | m = master sword? | w = walls?
                                  ;                 | o = OAM allocation
SpriteHitPoints = $7E0E50         ; Set from $0DB173
SpriteControl = $7E0E60           ; n i o s p p p t | n = Death animation? | i = Immune to attack/collion?
                                  ; o = Shadow      | p = OAM prop palette | t = OAM prop name table
SpriteTileCollision = $7E0E70     ; Used for tile collision. $10 bytes.
SpriteJumpIndex = $7E0E80         ; Sprite jump table local. $10 bytes.
SpriteAuxB = $7E0E90              ; Sprite, general use. $10 bytes.
SpriteRecoilTimer = $7E0EA0       ; Sprite recoil timer. $10 bytes.
SpriteDirectionTable = $7E0EB0    ; Sprite direction. $10 bytes.
SpriteAuxC = $7E0EC0              ; Sprite, general use. $10 bytes.
SpriteSpawnStep = $7E0ED0         ; Related to enemies spawning other sprites (eg pikit, zirro)
SpriteTimerD = $7E0EE0            ;
SpriteInvulnerableTimer = $7E0EF0 ; Sprite invulnerability timer after damage. $10 bytes.
SpriteHalt = $7E0F00              ;
SpriteTimerE = $7E0F10            ; ?
SpriteLayer = $7E0F20             ;
SpriteKnockbackY = $7E0F30        ;
SpriteKnockbackX = $7E0F40        ;
SpriteOAMProp = $7E0F50           ;
SpriteCollision = $7E0F60         ;
SpriteZCoord = $7E0F70            ;
SpriteVelocityZ = $7E0F80         ;
SpriteSubPixelZ = $7E0F90         ;
CurrentSpriteSlot = $7E0FA0       ; Holds the current sprite/ancilla's index
                                  ;
CurrentSpriteTile = $7E0FA5       ; Holds the current sprite/ancilla's tile type
                                  ;
FreezeSprites = $7E0FC1           ; "Seems to freeze sprites"
LinkPosXCache = $7E0FC2           ; Cache of Link's coordinates
LinkPosYCache = $7E0FC4           ;   - Done at the beginning of Link_Main every frame
GfxChrHalfSlotVerify = $7E0FC6    ; Mirrors $0AAA, set to >= $03 when VRAM has temp graphics loaded
PrizePackIndexes = $7E0FC7        ; $07 bytes. One for each prize pack.
                                  ;
SpriteCoordCacheX = $7E0FD8       ;
SpriteCoordCacheY = $7E0FDA       ;
                                  ;
NoMenu = $7E0FFC                  ; When set prevents menu, mirror, medallions
                                  ;
;===================================================================================================
;===================================================================================================
; DO NOT ADD ANY RANDOMIZER VARIABLES TO THE SPACE FROM $1100 to $1FFF
;---------------------------------------------------------------------------------------------------
; It causes isses with major glitches
;===================================================================================================
;===================================================================================================
GFXStripes = $7E1000              ; Used by stripes for arbitrary VRAM transfers. $100 bytes.
RoomStripes = $7E1100             ; Used for room drawing.
                                  ;
MirrorPortalPosXH = $7E1ACF       ; Mirror portal position. (High byte of X coordinate)
                                  ;
FluteSelection = $7E1AF0          ; Flute menu selection, zero based, shifted left by 1
                                  ;
IrisPtr = $7E1B00                 ; Spotlight pointers for HDMA. $1C0 bytes (?).
                                  ;
MessageSubModule = $7E1CD8        ;
                                  ;
MessageCursor = $7E1CE8           ; Chosen option in message.
DelayTimer = $7E1CE9              ;
                                  ;
TextID = $7E1CF0                  ; Message ID and page. Word length.
                                  ;


TileMapA = $7E2000
TileMapB = $7E4000
;================================================================================
; UNMIRRORED WRAM
; Addresses from here on can only be accessed with long addressing
; or absolute addressing with the appropriate data bank set
;--------------------------------------------------------------------------------

TileUploadBuffer = $7EA180        ; 0x300 bytes
                                  ;
ItemGetGFX = $7EBD40              ; Item receipt graphics location
                                  ;
UpdateHUDFlag = $7EBE00           ; Flag used to mark HUD updates and avoid heavy code segments.
                                  ;
ToastBuffer = $7EBE02             ; Multiworld buffer. Word length.
                                  ;

MSUResumeTime = $7EBE6B           ; Mirrored MSU block
MSUResumeControl = $7EBE6F        ;
MSUFallbackTable = $7EBE70        ;
MSUDelayedCommand = $7EBE79       ;
MSUPackCount = $7EBE7A            ;
MSUPackCurrent = $7EBE7B          ;
MSUPackRequest = $7EBE7C          ;
MSULoadedTrack = $7EBE7D          ;
MSUResumeTrack = $7EBE7F          ;

ClockHours = $7EBE90              ; Clock Hours
ClockMinutes = $7EBE94            ; Clock Minutes
ClockSeconds = $7EBE98            ; Clock Seconds
ClockBuffer = $7EBE9C             ; Clock Temporary
ScratchBufferNV = $7EBEA0         ; Non-volatile scratch buffer. Must preserve values through return.
ScratchBufferV = $7EBEB0          ; Volatile scratch buffer. Can clobber at will.

RoomFade = $7EC005                ; Flags fade to black on room transitions. Word length.
FadeTimer = $7EC007               ; Timer for transition fading and mosaics. Word length.
FadeDirection = $7EC009           ; Word length
FadeLevel = $7EC00B               ; Target fade level. Word length.
                                  ;
                                  ;
MosaicLevel = $7EC011             ; Word length. High byte unused
                                  ;
RoomDarkness = $7EC017            ; Darkness level of a room. High byte unused. Word length.
                                  ;
SpriteOAM = $7EC025               ;
SpriteDynamicOAM = $7EC035        ;
                                  ;
EN_OWSCR2 = $7EC140               ; $7EC140-$7EC171 Used for caching with entrances.
EN_MAINDESQ = $7EC142             ; Copied from the JP disassembly.
EN_SUBDESQ = $7EC143              ;
EN_BG2VERT = $7EC144              ;
EN_BG2HORZ = $7EC146              ;
EN_POSY = $7EC148                 ;
EN_POSX = $7EC14A                 ;
EN_OWSCR = $7EC14C                ;
EN_OWTMAPI = $7EC14E              ;
EN_SCROLLATN = $7EC150            ;
EN_SCROLLATW = $7EC152            ;
EN_SCROLLAN = $7EC154             ;
EN_SCROLLBN = $7EC156             ;
EN_SCROLLAS = $7EC158             ;
EN_SCROLLBS = $7EC15A             ;
EN_OWTARGN = $7EC15C              ;
EN_OWTARGS = $7EC15E              ;
EN_OWTARGW = $7EC160              ;
EN_OWTARGE = $7EC162              ;
EN_AA0 = $7EC164                  ;
EN_BGSET1 = $7EC165               ;
EN_BGSET2 = $7EC166               ;
EN_SPRSET1 = $7EC167              ;
                                  ; 2 bytes free RAM.
EN_SCRMODYA = $7EC16A             ;
EN_SCRMODYB = $7EC16C             ;
EN_SCRMODXA = $7EC16E             ;
EN_SCRMODXB = $7EC170             ;
PegColor = $7EC172                ;
                                  ;
GameOverSongCache = $7EC227       ;
                                  ;
LastBGSet = $7EC2F8               ; Lists loaded sheets to check for decompression. 4 bytes.
LastSpriteSet = $7EC2FC           ; Lists loaded sprite sheets to check for decompression. 4 bytes.
PaletteBufferAux = $7EC300        ; Secondary and main palette buffer. See symbols_wram.asm
PaletteBuffer = $7EC500           ; in the disassembly.
HUDTileMapBuffer = $7EC700        ; HUD tile map buffer. $100 bytes (?)
HUDCurrentDungeonWorld = $7EC702  ;
HUDKeyIcon = $7EC726              ;
HUDGoalIndicator = $7EC72A        ;
HUDPrizeIcon = $7EC742            ;
HUDRupees = $7EC750               ;
HUDBombCount = $7EC75A            ;
HUDArrowCount = $7EC760           ;
HUDKeyDigits = $7EC764            ;
HUDMultiIndicator = $7EC790       ;
HUDKeysObtained = $7EC7A2         ;
HUDKeysSlash = $7EC7A4            ;
HUDKeysTotal = $7EC7A6            ;
                                  ;
BigRAM = $7EC900                  ; Big buffer of free ram (0x1F00)
ItemGFXStack = $7ECB00            ; Pointers to source of decompressed item tiles deferred to NMI loading.
ItemGFXSBankStack = $7ECB20       ; Source bank byte for above. (not used yet)
ItemTargetStack = $7ECB40         ; Pointers to VRAM targets for ItemGFXStack.
TotalItemCountTiles = $7ECF00     ; Cached total item count tiles for HUD. Four words high to low.

;================================================================================
; Bank 7F
;--------------------------------------------------------------------------------
DecompressionBuffer = $7F0000      ; Decompression Buffer. $2000 bytes.

DecompBuffer2 = $7F4000            ; Another buffer

base $7F5000
skip 3                             ; Unused
HexToDecDigit1: skip 1             ; Space for storing the result of hex to decimal conversion.
HexToDecDigit2: skip 1             ; Digits are stored from high to low.
HexToDecDigit3: skip 1             ;
HexToDecDigit4: skip 1             ;
HexToDecDigit5: skip 1             ;
SpriteSkipEOR: skip 2              ; Used in utilities.asm to determine when to skip drawing sprites. Zero-padded
skip $2B                           ; Unused
AltTextFlag: skip 2                ; dialog.asm: Determines whether to load from vanilla decompression buffer
                                   ; or from a secondary buffer (used for things like free dungeon item text)
BossKills: skip 1                  ;
LagTime: skip 4                    ; Computed during stats preparation for display
RupeesCollected: skip 2            ; Computed during stats preparation for display
NonChestCounter: skip 2            ; Computed during stats preparation for display
BowTrackingFlags: skip 2           ; Stores tracking bits for progressive bows before resolution to concrete item.
TileUploadOffsetOverride: skip 2   ; Offset override for loading sprite gfx
skip 3                             ;
skip 8                             ;
                                   ; Shop Block $7F504F - $7F506F
ShopEnableCount: skip 1            ; Whether Shops Count for Location Checks
ShopId: skip 1                     ; Shop ID. Used for indexing and loading inventory for custom shops
ShopType: skip 1                   ; Shop type. $FF = vanilla shop
                                   ; t d a v - - q q
                                   ; t = $01 - Take-any | d = $01 - Door check | a = $01 = Take-all
                                   ; v = Use alt vram   | q = Number of items
ShopInventory: skip $0D            ; For three possible shop items, row major:
                                   ; [Item ID][Price low][Price High][Purchase Count]
ShopState: skip 1                  ; - - - - - l c r | Bitfield that determines whether to draw an item
ShopCapacity: skip 1               ; Four lower bits of shop_config in ShopTable, number of items 1-3
ShopScratch: skip 1                ; Scratch byte used in shop drawing routines
ShopSRAMIndex: skip 1              ; SRAM index for purchase counts
ShopMerchant: skip 1               ; Loaded from ShopTable and used to jump to one of four drawing routines
ShopkeeperRefill: skip 1           ; Flag for the shopkeeper refill action
PowderFlag: skip 1                 ; Flag for powder junk
ShopPriceColumn: skip 3            ; Stores coordinates for drawing prices in shops
ShopInventoryPlayer: skip 3        ; Multiworld id for player inventory
ShopInventoryDisguise: skip 3      ; Bee trap is disguised as another item in shop
BeeTrapDisguise: skip 1            ; Unused
skip 2                             ; Reserved for OneMind
OneMindId: skip 1                  ; Current OneMind player
OneMindTimerRAM: skip 2            ; Frame counter for OneMind
skip 9                             ; Unused
ClockStatus: skip 2                ; 2 bytes second always zero padding
                                   ; ---- --dn
                                   ; d - DNF mode
                                   ; n - Negative
skip $10                           ; Unused
RNGLockIn: skip 1                  ; Used for RNG item (currently unused by rando)
BusyItem: skip 1                   ; Flags for indicating when these things are "busy"
BusyHealth: skip 1                 ; e.g. doing some animation
BusyMagic: skip 1                  ; 
DialogOffsetPointer: skip 2        ; Offset and return pointer into new dialog buffer used
DialogReturnPointer: skip 2        ; for e.g. free dungeon item text.
skip 1                             ; Unused
PreviousOverworldDoor: skip 1      ; Previous overworld door is cached or initialized here
skip 1                             ; Reserved
skip 1                             ; Unused
DuckMapFlag: skip 1                ; Temporary flag used and reset by flute map drawing routine
StalfosBombDamage: skip 1          ; Relocated from damage table
ValidKeyLoaded: skip 1             ;
TextBoxDefer: skip 1               ; Flag used to defer post-item text boxes
skip $10                           ; Unused
skip $10                           ; Reserved for enemizer
                                   ; Most of these modifiers are intended to be written to by
                                   ; a 3rd party (e.g. Crowd Control.) Writer is responsible
                                   ; for zeroing.
SwordModifier: skip 1              ; Adds level to current sword. Doesn't change graphics.
ShieldModifier: skip 1             ; Not implemented
ArmorModifier: skip 1              ; Adds level to current mail. Doesn't change graphics.
MagicModifier: skip 1              ; Adds level to magic consumption (1/2, 1/4.)
LightConeModifier: skip 1          ; Gives lamp cone when set to 1
CuccoStormer: skip 1               ; Non-zero write causes storm.
OldManDash: skip 1                 ; Unused
IceModifier: skip 1                ; - - - g - - - i | Flipping either sets ice physics
InfiniteArrows: skip 1             ; Setting these to $01 will give infinite ammo. Set by
InfiniteBombs: skip 1              ; EscapeAssist.
InfiniteMagic: skip 1              ;
ControllerInverter: skip 1         ; $01 = D-pad | $02 = Buttons | $03 = Buttons and D-Pad
                                   ; >=$04 = Swap buttons and D-pad
OHKOFlag: skip 1                   ; Any non-zero write sets OHKO mode
SpriteSwapper: skip 1              ; Loads new link sprite and glove/armor palette. No gfx or
                                   ; code currently in base ROM for this.
BootsModifier: skip 1              ; $01 = Give dash ability
OHKOCached: skip 1                 ; "Old" OHKO flag state. Used to detect changes.
                                   ; Crypto Block ($7F50D0 - $7F51FF)
KeyBase: skip $10                  ;
y: skip 4                          ;
z: skip 4                          ;
Sum: skip 4                        ;
p: skip 4                          ;
e: skip 2                          ;
CryptoScratch: skip $0E            ;
CryptoBuffer:                      ;
v: skip $100                       ;
RNGPointers: skip $100             ; Pointers for static RNG
                                   ; Network I/O block. See servicerequest.asm. Rx and Tx channels
                                   ; also allocated 8 persistent bytes each in sram.asm.
RxBuffer: skip $7F                 ;
RxStatus: skip 1                   ;
TxBuffer: skip $7F                 ;
TxStatus: skip 1                   ;
skip $10                           ; Unused
CompassTotalsWRAM: skip $20        ; \ Compass and map dungeon HUD display totals. Placed in WRAM
MapTotalsWRAM: skip $10            ; / on boot for tracking.
skip $20                           ; Reserved for general dungeon tracking data. May have over
                                   ; allocated here. Feel free to reassign.
MapCompassFlag: skip 2             ; Used to flag overworld map drawing.
skip $3E                           ; Unused
skip $220                          ; Unused
LimitedRunStore: skip $40          ; Easter Egg Buffer
DialogBuffer: skip $100            ; Dialog Buffer
                                   ;
PrivateBlockWRAM = $7F7700         ; Reserved for 3rd party use. $500 bytes.
                                   ; See also: $200 bytes at PrivateBlockPersistent, copied to SRAM.
BigDecompressionBuffer = $7F8000   ; Reserved for large gfx decompression buffer. $5000 bytes.
                                   ; KEEP THIS AT $8000+
                                   ; its location at an address with bit 7 set is used for detecting
                                   ; ROM location versus RAM locations
                                   ;
MiniGameTime = $7FFE00             ; Time spent in mini game. 32-bits.
MiniGameTimeFinal = $7FFE04        ; Final mini game time. 32 bits.

;================================================================================
; RAM Assertions
;--------------------------------------------------------------------------------
macro assertRAM(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

%assertRAM(Scrap00, $7E0000)
%assertRAM(Scrap01, $7E0001)
%assertRAM(Scrap02, $7E0002)
%assertRAM(Scrap03, $7E0003)
%assertRAM(Scrap04, $7E0004)
%assertRAM(Scrap05, $7E0005)
%assertRAM(Scrap06, $7E0006)
%assertRAM(Scrap07, $7E0007)
%assertRAM(Scrap08, $7E0008)
%assertRAM(Scrap09, $7E0009)
%assertRAM(Scrap0A, $7E000A)
%assertRAM(Scrap0B, $7E000B)
%assertRAM(Scrap0C, $7E000C)
%assertRAM(Scrap0D, $7E000D)
%assertRAM(Scrap0E, $7E000E)
%assertRAM(Scrap0F, $7E000F)
%assertRAM(GameMode, $7E0010)
%assertRAM(GameSubMode, $7E0011)
%assertRAM(NMIDoneFlag, $7E0012)
%assertRAM(INIDISPQ, $7E0013)
%assertRAM(NMISTRIPES, $7E0014)
%assertRAM(NMICGRAM, $7E0015)
%assertRAM(NMIHUD, $7E0016)
%assertRAM(NMIINCR, $7E0017)
%assertRAM(NMIUP1100, $7E0018)
%assertRAM(UPINCVH, $7E0019)
%assertRAM(FrameCounter, $7E001A)
%assertRAM(IndoorsFlag, $7E001B)
%assertRAM(MAINDESQ, $7E001C)
%assertRAM(SUBDESQ, $7E001D)
%assertRAM(TMWQ, $7E001E)
%assertRAM(TSWQ, $7E001F)
%assertRAM(LinkPosY, $7E0020)
%assertRAM(LinkPosX, $7E0022)
%assertRAM(LinkPosZ, $7E0024)
%assertRAM(LinkPushDirection, $7E0026)
%assertRAM(LinkRecoilY, $7E0027)
%assertRAM(LinkRecoilX, $7E0028)
%assertRAM(LinkRecoilZ, $7E0029)
%assertRAM(LinkAnimationStep, $7E002E)
%assertRAM(LinkDirection, $7E002F)
%assertRAM(FlagBY, $7E003A)
%assertRAM(OAMOffsetY, $7E0044)
%assertRAM(OAMOffsetX, $7E0045)
%assertRAM(LinkIncapacitatedTimer, $7E0046)
%assertRAM(ForceMove, $7E0049)
%assertRAM(LinkVisible, $7E004B)
%assertRAM(CapeTimer, $7E004C)
%assertRAM(LinkJumping, $7E004D)
%assertRAM(LinkStrafe, $7E0050)
%assertRAM(LinkTargetPosY, $7E0051)
%assertRAM(LinkTargetPosX, $7E0053)
%assertRAM(CapeOn, $7E0055)
%assertRAM(BunnyFlagDP, $7E0056)
%assertRAM(PitTileActField, $7E0059)
%assertRAM(LinkFallPose, $7E005A)
%assertRAM(LinkSlipping, $7E005B)
%assertRAM(FallTimer, $7E005C)
%assertRAM(LinkState, $7E005D)
%assertRAM(LinkSpeed, $7E005E)
%assertRAM(ManipTileField, $7E005F)
%assertRAM(LinkLastDirection, $7E0066)
%assertRAM(LinkWalkDirection, $7E0067)
%assertRAM(ScrapBuffer72, $7E0072)
%assertRAM(WorldCache, $7E007B)
%assertRAM(OverworldMap16Buffer, $7E0084)
%assertRAM(OverworldTilemapIndexX, $7E0086)
%assertRAM(OverworldTilemapIndexY, $7E0088)
%assertRAM(OverworldIndex, $7E008A)
%assertRAM(OverlayID, $7E008C)
%assertRAM(OAMPtr, $7E0090)
%assertRAM(BGMODEQ, $7E0094)
%assertRAM(MOSAICQ, $7E0095)
%assertRAM(W12SELQ, $7E0096)
%assertRAM(W34SELQ, $7E0097)
%assertRAM(WOBJSELQ, $7E0098)
%assertRAM(CGWSELQ, $7E0099)
%assertRAM(CGADSUBQ, $7E009A)
%assertRAM(HDMAENABLEQ, $7E009B)
%assertRAM(RoomIndex, $7E00A0)
%assertRAM(PreviousRoom, $7E00A2)
%assertRAM(CameraBoundH, $7E00A6)
%assertRAM(CameraBoundV, $7E00A7)
%assertRAM(LinkQuadrantH, $7E00A9)
%assertRAM(LinkQuadrantV, $7E00AA)
%assertRAM(RoomTag, $7E00AE)
%assertRAM(SubSubModule, $7E00B0)
%assertRAM(ObjPtr, $7E00B7)
%assertRAM(ObjPtrOffset, $7E00BA)
%assertRAM(PlayerSpriteBank, $7E00BC)
%assertRAM(ScrapBufferBD, $7E00BD)
%assertRAM(FileSelectPosition, $7E00C8)
%assertRAM(PasswordCodePosition, $7E00C8)
%assertRAM(PasswordSelectPosition, $7E00C9)
%assertRAM(BG1H, $7E00E0)
%assertRAM(BG2H, $7E00E2)
%assertRAM(BG3HOFSQL, $7E00E4)
%assertRAM(BG1V, $7E00E6)
%assertRAM(BG2V, $7E00E8)
%assertRAM(BG3VOFSQL, $7E00EA)
%assertRAM(LinkLayer, $7E00EE)
%assertRAM(DeathReloadFlag, $7E010A)
%assertRAM(CurrentMSUTrack, $7E010B)
%assertRAM(GameModeCache, $7E010C)
%assertRAM(GameSubModeCache, $7E010D)
%assertRAM(EntranceIndex, $7E010E)
%assertRAM(MedallionFlag, $7E0112)
%assertRAM(VRAMTileMapIndex, $7E0116)
%assertRAM(VRAMUploadAddress, $7E0118)
%assertRAM(BG1ShakeV, $7E011A)
%assertRAM(BG1ShakeH, $7E011C)
%assertRAM(CurrentVolume, $7E0127)
%assertRAM(TargetVolume, $7E0129)
%assertRAM(MusicControl, $7E012B)
%assertRAM(MusicControlRequest, $7E012C)
%assertRAM(SFX1, $7E012D)
%assertRAM(SFX2, $7E012E)
%assertRAM(SFX3, $7E012F)
%assertRAM(LastAPUCommand, $7E0130)
%assertRAM(LastSFX1, $7E0131)
%assertRAM(MusicControlQueue, $7E0132)
%assertRAM(CurrentControlRequest, $7E0133)
%assertRAM(LastAPU, $7E0134)
%assertRAM(SubModuleInterface, $7E0200)
%assertRAM(ItemCursor, $7E0202)
%assertRAM(BottleMenuCounter, $7E0205)
%assertRAM(MenuBlink, $7E0207)
%assertRAM(RaceGameFlag, $7E021B)
%assertRAM(MessageJunk, $7E0223)
%assertRAM(SprSourceItemId, $7E0230)
%assertRAM(ItemReceiptID, $7E02D8)
%assertRAM(ItemReceiptPose, $7E02DA)
%assertRAM(BunnyFlag, $7E02E0)
%assertRAM(Poofing, $7E02E1)
%assertRAM(PoofTimer, $7E02E2)
%assertRAM(SwordCooldown, $7E02E3)
%assertRAM(CutsceneFlag, $7E02E4)
%assertRAM(ItemReceiptMethod, $7E02E9)
%assertRAM(TileActBE, $7E02EF)
%assertRAM(LinkThud, $7E02F8)
%assertRAM(FollowerNoDraw, $7E02F9)
%assertRAM(UseY1, $7E0301)
%assertRAM(CurrentYItem, $7E0303)
%assertRAM(AButtonAct, $7E0308)
%assertRAM(CarryAct, $7E0309)
%assertRAM(LinkIFrames, $7E031F)
%assertRAM(LinkSwimDirection, $7E0340)
%assertRAM(LinkDeepWater, $7E0345)
%assertRAM(TileActIce, $7E0348)
%assertRAM(TileActDig, $7E035B)
%assertRAM(LinkZap, $7E0360)
%assertRAM(LinkDashing, $7E0372)
%assertRAM(DamageReceived, $7E0373)
%assertRAM(UseY2, $7E037A)
%assertRAM(NoDamage, $7E037B)
%assertRAM(AncillaGeneralA, $7E0385)
%assertRAM(AncillaGeneralD, $7E0394)
%assertRAM(AncillaGeneralF, $7E039F)
%assertRAM(AncillaSearch, $7E03C4)
%assertRAM(ForceSwordUp, $7E03EF)
%assertRAM(FluteTimer, $7E03F0)
%assertRAM(YButtonOverride, $7E03FC)
%assertRAM(RoomItemsTaken, $7E0403)
%assertRAM(OverworldIndexMirror, $7E040A)
%assertRAM(DungeonID, $7E040C)
%assertRAM(TransitionDirection, $7E0418)
%assertRAM(ManipIndex, $7E042C)
%assertRAM(TrapDoorFlag, $7E0468)
%assertRAM(LayerAdjustment, $7E047A)
%assertRAM(RoomIndexMirror, $7E048E)
%assertRAM(RespawnFlag, $7E04AA)
%assertRAM(Map16ChangeIndex, $7E04AC)
%assertRAM(HUDTimer, $7E04B4)
%assertRAM(HUDTimerDelay, $7E04B5)
%assertRAM(OWEntranceCutscene, $7E04C6)
%assertRAM(HammerPegCounter, $7E04C8)
%assertRAM(HeartBeepTimer, $7E04CA)
%assertRAM(ManipTileMapX, $7E0540)
%assertRAM(CameraTargetN, $7E0610)
%assertRAM(CameraTargetS, $7E0612)
%assertRAM(CameraTargetW, $7E0614)
%assertRAM(CameraTargetE, $7E0616)
%assertRAM(CameraScrollN, $7E0618)
%assertRAM(CameraScrollS, $7E061A)
%assertRAM(CameraScrollW, $7E061C)
%assertRAM(CameraScrollE, $7E061E)
%assertRAM(NMIAux, $7E0632)
%assertRAM(SpriteRoomTag, $7E0642)
%assertRAM(SomariaSwitchFlag, $7E0646)
%assertRAM(TileMapDoorPos, $7E068E)
%assertRAM(DoorTimer, $7E0690)
%assertRAM(TileMapUpdateId, $7E0692)
%assertRAM(TileMapEntranceDoors, $7E0696)
%assertRAM(TileMapTile32, $7E0698)
%assertRAM(RandoOverworldEdgeAddr, $7E06F8)
%assertRAM(RandoOverworldTargetEdge, $7E06FA)
%assertRAM(RandoOverworldWalkDist, $7E06FC)
%assertRAM(OverworldSlotPosition, $7E0700)
%assertRAM(RandoOverworldForceTrans, $7E0703)
%assertRAM(RandoOverworldTerrain, $7E0704)
%assertRAM(SkipOAM, $7E0710)
%assertRAM(OWScreenSize, $7E0712)
%assertRAM(SpawnedItemID, $7E0720)
%assertRAM(SpawnedItemIndex, $7E0722)
%assertRAM(SpawnedItemIsMultiWorld, $7E0724)
%assertRAM(SpawnedItemFlag, $7E0726)
%assertRAM(SpawnedItemMWPlayer, $7E0728)
%assertRAM(EnemyDropIndicator, $7E072A)
%assertRAM(SkipBeeTrapDisguise, $7E072D)
%assertRAM(SprDropsItem, $7E0730)
%assertRAM(SprItemReceipt, $7E0740)
%assertRAM(SprItemIndex, $7E0750)
%assertRAM(SprItemMWPlayer, $7E0760)
%assertRAM(SprItemFlags, $7E0770)
%assertRAM(SprItemGFXSlot, $7E0780)
%assertRAM(SprRedrawFlag, $7E0790)
%assertRAM(DynamicDropGFXIndex, $7E07F0)
%assertRAM(DynamicDropGFXSlots, $7E07F1)
%assertRAM(OAMBuffer, $7E0800)
%assertRAM(OAMBuffer2, $7E0A00)
%assertRAM(TransparencyFlag, $7E0ABD)
%assertRAM(OWTransitionFlag, $7E0ABF)
%assertRAM(ArcVariable, $7E0B08)
%assertRAM(OverlordXLow, $7E0B08)
%assertRAM(OverlordXHigh, $7E0B10)
%assertRAM(OverlordYLow, $7E0B18)
%assertRAM(OverlordYHigh, $7E0B20)
%assertRAM(EnemyStunTimer, $7E0B58)
%assertRAM(SpriteTileDeath, $7E0B68)
%assertRAM(BowDryFire, $7E0B9A)
%assertRAM(SecretId, $7E0B9C)
%assertRAM(SaveFileIndex, $7E0B9D)
%assertRAM(SpriteAncillaInteract, $7E0BA0)
%assertRAM(SpriteAncillaInteractID, $7E0BB0)
%assertRAM(SpritePrizeProps, $7E0BE0)
%assertRAM(AncillaGeneralM, $7E0BF0)
%assertRAM(AncillaVelocityY, $7E0C22)
%assertRAM(AncillaVelocityX, $7E0C2C)
%assertRAM(AncillaSubPixelY, $7E0C36)
%assertRAM(AncillaSubPixelX, $7E0C40)
%assertRAM(AncillaID, $7E0C4A)
%assertRAM(AncillaGeneralN, $7E0C54)
%assertRAM(AncillaGet, $7E0C5E)
%assertRAM(AncillaTimerA, $7E0C68)
%assertRAM(AncillaDirection, $7E0C72)
%assertRAM(AncillaLayer, $7E0C7C)
%assertRAM(AncillaOAMOffset, $7E0C86)
%assertRAM(AncillaOAMAlloc, $7E0C90)
%assertRAM(SpriteScreenOwner, $7E0C9A)
%assertRAM(SpriteDeflection, $7E0CAA)
%assertRAM(SpriteForceDrop, $7E0CBA)
%assertRAM(SpriteBump, $7E0CD2)
%assertRAM(SpriteDamageIncurred, $7E0CE2)
%assertRAM(BossSpecialAction, $7E0CF3)
%assertRAM(TreePullKills, $7E0CFB)
%assertRAM(TreePullHits, $7E0CFC)
%assertRAM(SpritePosYLow, $7E0D00)
%assertRAM(SpritePosXLow, $7E0D10)
%assertRAM(SpritePosYHigh, $7E0D20)
%assertRAM(SpritePosXHigh, $7E0D30)
%assertRAM(SpriteVelocityY, $7E0D40)
%assertRAM(SpriteVelocityX, $7E0D50)
%assertRAM(SpriteSubPixelY, $7E0D60)
%assertRAM(SpriteSubPixelX, $7E0D70)
%assertRAM(SpriteActivity, $7E0D80)
%assertRAM(SpriteMovement, $7E0D90)
%assertRAM(SpriteAuxTable, $7E0DA0)
%assertRAM(SpriteAuxTableB, $7E0DB0)
%assertRAM(SpriteGFXControl, $7E0DC0)
%assertRAM(SpriteAITable, $7E0DD0)
%assertRAM(SpriteMoveDirection, $7E0DE0)
%assertRAM(SpriteTimer, $7E0DF0)
%assertRAM(SpriteTimerB, $7E0E00)
%assertRAM(SpriteTimerC, $7E0E10)
%assertRAM(SpriteTypeTable, $7E0E20)
%assertRAM(SpriteAux, $7E0E30)
%assertRAM(SpriteOAMProperties, $7E0E40)
%assertRAM(SpriteHitPoints, $7E0E50)
%assertRAM(SpriteControl, $7E0E60)
%assertRAM(SpriteTileCollision, $7E0E70)
%assertRAM(SpriteJumpIndex, $7E0E80)
%assertRAM(SpriteAuxB, $7E0E90)
%assertRAM(SpriteRecoilTimer, $7E0EA0)
%assertRAM(SpriteDirectionTable, $7E0EB0)
%assertRAM(SpriteAuxC, $7E0EC0)
%assertRAM(SpriteSpawnStep, $7E0ED0)
%assertRAM(SpriteTimerD, $7E0EE0)
%assertRAM(SpriteInvulnerableTimer, $7E0EF0)
%assertRAM(SpriteHalt, $7E0F00)
%assertRAM(SpriteTimerE, $7E0F10)
%assertRAM(SpriteLayer, $7E0F20)
%assertRAM(SpriteKnockbackY, $7E0F30)
%assertRAM(SpriteKnockbackX, $7E0F40)
%assertRAM(SpriteOAMProp, $7E0F50)
%assertRAM(SpriteCollision, $7E0F60)
%assertRAM(SpriteZCoord, $7E0F70)
%assertRAM(SpriteVelocityZ, $7E0F80)
%assertRAM(SpriteSubPixelZ, $7E0F90)
%assertRAM(CurrentSpriteSlot, $7E0FA0)
%assertRAM(CurrentSpriteTile, $7E0FA5)
%assertRAM(FreezeSprites, $7E0FC1)
%assertRAM(GfxChrHalfSlotVerify, $7E0FC6)
%assertRAM(PrizePackIndexes, $7E0FC7)
%assertRAM(SpriteCoordCacheX, $7E0FD8)
%assertRAM(SpriteCoordCacheY, $7E0FDA)
%assertRAM(NoMenu, $7E0FFC)
%assertRAM(GFXStripes, $7E1000)
%assertRAM(RoomStripes, $7E1100)
%assertRAM(MirrorPortalPosXH, $7E1ACF)
%assertRAM(FluteSelection, $7E1AF0)
%assertRAM(IrisPtr, $7E1B00)
%assertRAM(MessageSubModule, $7E1CD8)
%assertRAM(MessageCursor, $7E1CE8)
%assertRAM(DelayTimer, $7E1CE9)

%assertRAM(TileMapA, $7E2000)
%assertRAM(TileMapB, $7E4000)
%assertRAM(TileUploadBuffer, $7EA180)
%assertRAM(RoomFade, $7EC005)
%assertRAM(FadeTimer, $7EC007)
%assertRAM(FadeDirection, $7EC009)
%assertRAM(FadeLevel, $7EC00B)
%assertRAM(MosaicLevel, $7EC011)
%assertRAM(RoomDarkness, $7EC017)
%assertRAM(SpriteOAM, $7EC025)
%assertRAM(SpriteDynamicOAM, $7EC035)
%assertRAM(EN_OWSCR2, $7EC140)
%assertRAM(EN_MAINDESQ, $7EC142)
%assertRAM(EN_SUBDESQ, $7EC143)
%assertRAM(EN_BG2VERT, $7EC144)
%assertRAM(EN_BG2HORZ, $7EC146)
%assertRAM(EN_POSY, $7EC148)
%assertRAM(EN_POSX, $7EC14A)
%assertRAM(EN_OWSCR, $7EC14C)
%assertRAM(EN_OWTMAPI, $7EC14E)
%assertRAM(EN_SCROLLATN, $7EC150)
%assertRAM(EN_SCROLLATW, $7EC152)
%assertRAM(EN_SCROLLAN, $7EC154)
%assertRAM(EN_SCROLLBN, $7EC156)
%assertRAM(EN_SCROLLAS, $7EC158)
%assertRAM(EN_SCROLLBS, $7EC15A)
%assertRAM(EN_OWTARGN, $7EC15C)
%assertRAM(EN_OWTARGS, $7EC15E)
%assertRAM(EN_OWTARGW, $7EC160)
%assertRAM(EN_OWTARGE, $7EC162)
%assertRAM(EN_AA0, $7EC164)
%assertRAM(EN_BGSET1, $7EC165)
%assertRAM(EN_BGSET2, $7EC166)
%assertRAM(EN_SPRSET1, $7EC167)
%assertRAM(EN_SCRMODYA, $7EC16A)
%assertRAM(EN_SCRMODYB, $7EC16C)
%assertRAM(EN_SCRMODXA, $7EC16E)
%assertRAM(EN_SCRMODXB, $7EC170)
%assertRAM(PegColor, $7EC172)
%assertRAM(GameOverSongCache, $7EC227)
%assertRAM(LastBGSet, $7EC2F8)
%assertRAM(LastSpriteSet, $7EC2FC)
%assertRAM(PaletteBufferAux, $7EC300)
%assertRAM(PaletteBuffer, $7EC500)
%assertRAM(HUDTileMapBuffer, $7EC700)
%assertRAM(HUDCurrentDungeonWorld, $7EC702)
%assertRAM(HUDKeyIcon, $7EC726)
%assertRAM(HUDGoalIndicator, $7EC72A)
%assertRAM(HUDPrizeIcon, $7EC742)
%assertRAM(HUDRupees, $7EC750)
%assertRAM(HUDBombCount, $7EC75A)
%assertRAM(HUDArrowCount, $7EC760)
%assertRAM(HUDKeyDigits, $7EC764)
%assertRAM(HUDMultiIndicator, $7EC790)
%assertRAM(HUDKeysObtained, $7EC7A2)
%assertRAM(HUDKeysSlash, $7EC7A4)
%assertRAM(HUDKeysTotal, $7EC7A6)
%assertRAM(BigRAM, $7EC900)

%assertRAM(DecompressionBuffer, $7F0000)
%assertRAM(HexToDecDigit1, $7F5003)
%assertRAM(HexToDecDigit2, $7F5004)
%assertRAM(HexToDecDigit3, $7F5005)
%assertRAM(HexToDecDigit4, $7F5006)
%assertRAM(HexToDecDigit5, $7F5007)
%assertRAM(SpriteSkipEOR, $7F5008)
%assertRAM(AltTextFlag, $7F5035)
%assertRAM(BossKills, $7F5037)
%assertRAM(LagTime, $7F5038)
%assertRAM(RupeesCollected, $7F503C)
%assertRAM(NonChestCounter, $7F503E)
%assertRAM(TileUploadOffsetOverride, $7F5042)
%assertRAM(ShopEnableCount, $7F504F)
%assertRAM(ShopId, $7F5050)
%assertRAM(ShopType, $7F5051)
%assertRAM(ShopInventory, $7F5052)
%assertRAM(ShopState, $7F505F)
%assertRAM(ShopCapacity, $7F5060)
%assertRAM(ShopScratch, $7F5061)
%assertRAM(ShopSRAMIndex, $7F5062)
%assertRAM(ShopMerchant, $7F5063)
%assertRAM(ShopkeeperRefill, $7F5064)
%assertRAM(ShopPriceColumn, $7F5066)
%assertRAM(ShopInventoryPlayer, $7F5069)
%assertRAM(ShopInventoryDisguise, $7F506C)
%assertRAM(BeeTrapDisguise, $7F506F)
%assertRAM(OneMindId, $7F5072)
%assertRAM(OneMindTimerRAM, $7F5073)
%assertRAM(ClockStatus, $7F507E)
%assertRAM(RNGLockIn, $7F5090)
%assertRAM(BusyItem, $7F5091)
%assertRAM(BusyHealth, $7F5092)
%assertRAM(BusyMagic, $7F5093)
%assertRAM(DialogOffsetPointer, $7F5094)
%assertRAM(DialogReturnPointer, $7F5096)
%assertRAM(PreviousOverworldDoor, $7F5099)
%assertRAM(DuckMapFlag, $7F509C)
%assertRAM(StalfosBombDamage, $7F509D)
%assertRAM(ValidKeyLoaded, $7F509E)
%assertRAM(TextBoxDefer, $7F509F)
%assertRAM(SwordModifier, $7F50C0)
%assertRAM(ShieldModifier, $7F50C1)
%assertRAM(ArmorModifier, $7F50C2)
%assertRAM(MagicModifier, $7F50C3)
%assertRAM(LightConeModifier, $7F50C4)
%assertRAM(CuccoStormer, $7F50C5)
%assertRAM(OldManDash, $7F50C6)
%assertRAM(IceModifier, $7F50C7)
%assertRAM(InfiniteArrows, $7F50C8)
%assertRAM(InfiniteBombs, $7F50C9)
%assertRAM(InfiniteMagic, $7F50CA)
%assertRAM(ControllerInverter, $7F50CB)
%assertRAM(OHKOFlag, $7F50CC)
%assertRAM(SpriteSwapper, $7F50CD)
%assertRAM(BootsModifier, $7F50CE)
%assertRAM(KeyBase, $7F50D0)
%assertRAM(y, $7F50E0)
%assertRAM(z, $7F50E4)
%assertRAM(Sum, $7F50E8)
%assertRAM(p, $7F50EC)
%assertRAM(e, $7F50F0)
%assertRAM(CryptoScratch, $7F50F2)
%assertRAM(CryptoBuffer, $7F5100)
%assertRAM(v, $7F5100)
%assertRAM(RNGPointers, $7F5200)
%assertRAM(RxBuffer, $7F5300)
%assertRAM(RxStatus, $7F537F)
%assertRAM(TxBuffer, $7F5380)
%assertRAM(TxStatus, $7F53FF)
%assertRAM(CompassTotalsWRAM, $7F5410)
%assertRAM(MapTotalsWRAM, $7F5430)
%assertRAM(MapCompassFlag, $7F5460)
%assertRAM(LimitedRunStore, $7F56C0)
%assertRAM(DialogBuffer, $7F5700)
%assertRAM(MiniGameTime, $7FFE00)
%assertRAM(MiniGameTimeFinal, $7FFE04)

pullpc
