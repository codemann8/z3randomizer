;================================================================================
; Master / Tempered / Golden Sword Swap
;================================================================================
;$03348E: smith sword check (to see if uprade-able)
;================================================================================
LoadSwordForDamage:
	LDA.w SpriteTypeTable, X : CMP.b #$88 : BNE .notMoth
		JSR LoadModifiedSwordLevel ; load normal sword value
		CMP.b #$04 : !BLT + : DEC : + ; if it's gold sword, change it to tempered
		RTL
	.notMoth
	JSR LoadModifiedSwordLevel ; load normal sword value
RTL
;================================================================================
LookupDamageLevel:
	CPX.w #$0918 : BNE +
		LDA.l StalfosBombDamage
		RTL
	+
	PHP
		REP #$20 ; set 16-bit accumulator
		TXA : LSR : TAX : BCS .lower
.upper
	PLP
	LDA.l Damage_Table, X
	LSR #4
RTL
.lower
	PLP
	LDA.l Damage_Table, X
	AND.b #$0F
RTL
;================================================================================
LoadModifiedSwordLevel: ; returns short
	LDA.l SwordModifier : BEQ +
		!ADD.l SwordEquipment ; add normal sword value to modifier
			BNE ++ : LDA.b #$01 : RTS : ++
			CMP.b #$05 : !BLT ++ : LDA.b #$04 : RTS : ++
		RTS
	+
	LDA.l SwordEquipment ; load normal sword value
RTS
;================================================================================
; ArmorEquipment - Armor Inventory
LoadModifiedArmorLevel:
	PHA
		LDA.l ArmorEquipment : !ADD.l ArmorModifier
		CMP.b #$FF : BNE + : LDA.b #$00 : +
		CMP.b #$03 : !BLT + : LDA.b #$02 : +
		STA.l ScratchBufferV
	PLA
	!ADD.l ScratchBufferV
RTL
;================================================================================
; MagicConsumption - Magic Inventory
LoadModifiedMagicLevel:
	LDA.l MagicModifier : BEQ +
		!ADD.l MagicConsumption ; add normal magic value to modifier
			CMP.b #$FF : BNE ++ : LDA.b #$00 : RTL : ++
			CMP.b #$03 : !BLT ++ : LDA.b #$02 : ++
		RTL
	+
	LDA.l MagicConsumption ; load normal magic value
RTL
;================================================================================
; $7E0348 - Ice Value
LoadModifiedIceFloorValue_a11:
	LDA.b RoomIndex : CMP.b #$91 : BEQ + : CMP.b #$92 : BEQ + : CMP.b #$93 : BEQ + ; mire basement currently broken - not sure why
	LDA.b LinkState : CMP.b #$01 : BEQ + : CMP.b #$17 : BEQ + : CMP.b #$1C : BEQ +
	LDA.b LinkSpeed : CMP.b #$02 : BEQ +  
	LDA.b LinkSlipping : BNE +  
		LDA.w TileActIce : ORA.l IceModifier : AND.b #$11 : RTL  
	+ : LDA.w TileActIce : AND.b #$11  
RTL  
LoadModifiedIceFloorValue_a01:  
	LDA.b RoomIndex : CMP.b #$91 : BEQ + : CMP.b #$92 : BEQ + : CMP.b #$93 : BEQ + ; mire basement currently broken - not sure why
	LDA.b LinkState : CMP.b #$01 : BEQ + : CMP.b #$17 : BEQ + : CMP.b #$1C : BEQ +
	LDA.b LinkSpeed : CMP.b #$02 : BEQ +
	LDA.b LinkSlipping : BNE +
		LDA.w TileActIce : ORA.l IceModifier : AND.b #$01 : RTL
	+ : LDA.w TileActIce : AND.b #$01
RTL
;================================================================================
CheckTabletSword:
	LDA.l AllowHammerTablets : BEQ +
	LDA.l HammerEquipment : BEQ + ; check for hammer
		LDA.b #$02 : RTL
	+
	LDA.l SwordEquipment ; get actual sword value
RTL
;================================================================================
GetSwordLevelForEvilBarrier:
	LDA.l AllowHammerEvilBarrierWithFighterSword : BEQ +
	LDA.b #$FF : RTL
	+
	LDA.l SwordEquipment
RTL
;================================================================================
CheckGanonHammerDamage:
	LDA.l HammerableGanon : BEQ +
	LDA.w SpriteTypeTable, X : CMP.b #$D8 ; original behavior except ganon
RTL
	+
	LDA.w SpriteTypeTable, X : CMP.b #$D6 ; original behavior
RTL
;================================================================================
GetSmithSword:
	JSL ItemCheck_SmithSword : BEQ + : JML Smithy_AlreadyGotSword : +
	LDA.l SmithItemMode : BNE +
		JML Smithy_DoesntHaveSword ; Classic Smithy
	+

	REP #$20 : LDA.l CurrentRupees : CMP.w #$000A : SEP #$20 : !BGE .buy
	.cant_afford
		REP #$10
		LDA.b #$7A
		LDY.b #$01
		JSL Sprite_ShowMessageUnconditional
		LDA.b #$3C : STA.w SFX2 ; error sound
		SEP #$10
		BRA .done

	.buy
		LDA.l SmithItem_Player : STA.l !MULTIWORLD_ITEM_PLAYER_ID
		LDA.l SmithItem : TAY
		STZ.w ItemReceiptMethod ; Item from NPC
		PHX : JSL Link_ReceiveItem : PLX

		REP #$20 : LDA.l CurrentRupees : !SUB.w #$000A : STA.l CurrentRupees : SEP #$20 ; Take 10 rupees
		JSL ItemSet_SmithSword
	
	.done
		JML Smithy_AlreadyGotSword
;================================================================================
CheckMedallionSword:
	LDA.l AllowSwordlessMedallionUse : BEQ .check_sword
	CMP.b #$01 : BEQ .check_pad
		LDA.b #$02 ; Pretend we have master sword
		RTL
	.check_sword
		LDA.l SwordEquipment
		RTL
	.check_pad
		PHB : PHX : PHY
		LDA.b IndoorsFlag : BEQ .outdoors
		.indoors
			REP #$20 ; set 16-bit accumulator
			LDA.b RoomIndex ; load room ID
			CMP.w #$000E : BNE + ; freezor1
				LDA.b LinkPosX : AND.w #$01FF ; check x-coord
					CMP.w #368-8 : !BLT .normal
					CMP.w #368+32-8 : !BGE .normal
				LDA.b LinkPosY : AND.w #$01FF ; check y-coord
					CMP.w #400-22 : !BLT .normal
					CMP.w #400+32-22 : !BGE .normal
				JMP .permit
			+ : CMP.w #$007E : BNE + ; freezor2
				LDA.b LinkPosX : AND.w #$01FF ; check x-coord
					CMP.w #112-8 : !BLT .normal
					CMP.w #112+32-8 : !BGE .normal
				LDA.b LinkPosY : AND.w #$01FF ; check y-coord
					CMP.w #400-22 : !BLT .normal
					CMP.w #400+32-22 : !BGE .normal
				JMP .permit
			+ : CMP.w #$00DE : BNE + ; kholdstare
				LDA.b LinkPosX : AND.w #$01FF ; check x-coord
					CMP.w #368-8 : !BLT .normal
					CMP.w #368+32-8 : !BGE .normal
				LDA.b LinkPosY : AND.w #$01FF ; check y-coord
					CMP.w #144-22 : !BLT .normal
					CMP.w #144+32-22 : !BGE .normal
				BRA .permit
			+ : .normal
			SEP #$20 ; set 8-bit accumulator
			BRA .done
		.outdoors
			LDA.b OverworldIndex : CMP.b #$70 : BNE +
				LDA.l MireRequiredMedallion : TAX : LDA.l .medallion_type, X : CMP.w CurrentYItem : BNE .done
				LDA.l OverworldEventDataWRAM+$70 : AND.b #$20 : BNE .done
				LDA.b #$08 : PHA : PLB ; set data bank to $08
				LDY.b #$02 : JSL Ancilla_CheckIfEntranceTriggered : BCS .permit ; misery mire
				BRA .done
			+ : CMP.b #$47 : BNE +
				LDA.l TRockRequiredMedallion : TAX : LDA.l .medallion_type, X : CMP.w CurrentYItem : BNE .done
				LDA.l OverworldEventDataWRAM+$47 : AND.b #$20 : BNE .done
				LDA.b #$08 : PHA : PLB ; set data bank to $08
				LDY.b #$03 : JSL Ancilla_CheckIfEntranceTriggered : BCS .permit ; turtle rock
			+
	.done
		PLY : PLX : PLB
		LDA.l SwordEquipment
		RTL
	.permit
		SEP #$20 ; set 8-bit accumulator
		PLY : PLX : PLB
		LDA.b #$02 ; Pretend we have master sword
		RTL
.medallion_type
db #$0F, #$10, #$11
;================================================================================
