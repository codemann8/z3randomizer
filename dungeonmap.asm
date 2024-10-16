DoDungeonMapBossIcon:
	LDA.b NMISTRIPES
	CMP.b #$09
	BEQ .dungeonmap

.cave
	RTL

.dungeonmap

	LDX.w DungeonID
	BMI .cave

	; get dungeon boss room
++	REP #$30
	LDA.l DungeonMapBossRooms, X
	ASL
	TAX

	; get sprite pointer for room
	LDA.l UWSpritesPointers,X
	STA.b Scrap00                ; pointer in $00
	LDA.w #$0028 : STA.b Scrap02 ; set the bank to 28 for now
	LDY.w #$0001 ; to skip the "sort"

	; get first byte to make sure it isn't an empty room
	SEP #$20
	LDA.b [Scrap00], Y
	CMP.b #$FF
	BNE ++

	SEP #$30
	BRA .cave

	; check first sprite
++	INY #2
	LDA.b [Scrap00], Y
	SEP #$10

	; match boss id
	LDX.b #$0B

--	CMP.l .boss_id,X
	BEQ .match

	DEX
	BPL --

	TXA
	BRA .cave

.match
	LDA.b #$80
	STA.w CGADD

	REP #$30

	TXA
	ASL ; x32 for palette data
	ASL
	ASL
	ASL
	ASL

	TAX

	; prep dma
	ASL ; x128 for graphics
	ASL
	ADC.w #BossMapIconGFX
	STA.w A1T1L

	PHY
	LDY.w #32

	SEP #$20
--	LDA.l .boss_palettes,X
	STA.w CGDATA
	INX
	DEY
	BNE --

	PLY


	; GFX DMA
	REP #$20
	SEP #$10

	LDA.w #$1801
	STA.w DMAP1

	LDX.b #BossMapIconGFX>>16
	STX.w A1B1

	LDA.w #$A060>>1
	STA.w VMADDL
	LDA.w #$0040
	STA.w DAS1L

	LDX.b #$02
	STX.w DMAENABLE

	STA.w DAS1L
	LDA.w #$A260>>1
	STA.w VMADDL

	STX.w DMAENABLE

	; done
	SEP #$30
	RTL

.boss_id
	db $53 ; armos
	db $54 ; lanmolas
	db $09 ; moldorm

	db $7A ; agahnim

	db $92 ; helma king
	db $8C ; arrghus
	db $88 ; mothula
	db $CE ; blind
	db $A3 ; khold shell
	db $BD ; vitreous
	db $CB ; trinexx

	db $D6 ; ganon

.boss_palettes
	dw hexto555($000000), hexto555($F8F8F8), hexto555($D86060), hexto555($5070C8), hexto555($B090F8), hexto555($282828), hexto555($F0A068), hexto555($B06028), hexto555($B88820), hexto555($E8A800), hexto555($F8F8F8), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($50C090), hexto555($408858), hexto555($305830), hexto555($282828), hexto555($D8A800), hexto555($E06018), hexto555($787040), hexto555($585030), hexto555($484018), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($903018), hexto555($D85800), hexto555($F8A828), hexto555($282828), hexto555($E88068), hexto555($B04038), hexto555($F8D018), hexto555($C8B818), hexto555($A89818), hexto555($806818), hexto555($503818), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($C04080), hexto555($B08828), hexto555($E8C070), hexto555($282828), hexto555($90D038), hexto555($688020), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($4848B0), hexto555($7870E8), hexto555($A8A8F8), hexto555($282828), hexto555($F8F8F8), hexto555($181818), hexto555($A00028), hexto555($D03828), hexto555($E88820), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($903018), hexto555($D85800), hexto555($F8A828), hexto555($282828), hexto555($E88068), hexto555($B04038), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($4848B0), hexto555($7870E8), hexto555($A8A8F8), hexto555($282828), hexto555($F8A840), hexto555($D85820), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($903018), hexto555($D85800), hexto555($F8A828), hexto555($282828), hexto555($E88068), hexto555($B04038), hexto555($88D0F8), hexto555($7890F8), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($4828C8), hexto555($4828F0), hexto555($8070F8), hexto555($282828), hexto555($F8C8F8), hexto555($E088B0), hexto555($7098C0), hexto555($58B0E8), hexto555($D0F8F8), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($50C090), hexto555($408858), hexto555($305830), hexto555($282828), hexto555($D8A800), hexto555($E06018), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($4848B0), hexto555($7870E8), hexto555($A8A8F8), hexto555($282828), hexto555($989868), hexto555($78C0A8), hexto555($A00028), hexto555($D03828), hexto555($E88820), hexto555($503860), hexto555($505060), hexto555($788890), hexto555($484868), hexto555($707068)
	dw hexto555($000000), hexto555($F8F8F8), hexto555($B090F8), hexto555($C0A028), hexto555($886008), hexto555($282828), hexto555($B83010), hexto555($E86040), hexto555($385088), hexto555($5088A8), hexto555($88C8A0), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000), hexto555($000000)
