;================================================================================
; Fake Flippers Softlock Fix
;--------------------------------------------------------------------------------

; Written over and used by OnEnterWater hook.
; UnequipCapeQuiet: 
; 	LDA.b #$20 : STA.w PoofTimer
; 	STZ.w NoDamage
; 	STZ.b CapeOn
; 	STZ.w LinkZap
; RTL

protectff:
	LDA.l AllowAccidentalMajorGlitch
	BEQ .yes_protect

	RTL

.yes_protect
	REP #$30

	LDA.b LinkPosY
	AND.w #$1E00
	ASL
	ASL
	ASL
	STA.b Scrap06

	LDA.b LinkPosX
	AND.w #$1E00
	ORA.b Scrap06

	XBA
	LSR
	TAX

	SEP #$30

	; Remove dark world bit
	; in game table that converts coordinates to actual screen ID
	; special case for other areas
	LDA.b OverworldIndex
	BMI .special_overworld

	AND.b #$3F
	CMP.l Overworld_ActualScreenID,X
	BEQ ++

.protect
	LDA.b #$15
	STA.b LinkState

	STZ.b LinkAnimationStep
	STZ.b LinkWalkDirection

	LDA.b #$02
	STA.b LinkDirection

	STZ.w MedallionFlag
	STZ.w CutsceneFlag
	STZ.w NoMenu

++	RTL

.special_overworld
	CMP.l .spow,X
	BNE .protect

	RTL

.spow
	db $80, $81, $81, $FF, $FF, $FF, $FF, $FF
	db $FF, $81, $81, $FF, $FF, $FF, $FF, $FF

FlipperScrollWarp:
	STZ.b Scrap00 : STZ.b Scrap02 ; what we wrote over
	LDA.l AllowAccidentalMajorGlitch : BEQ .checkX : RTL
	.checkX
		LDA.b LinkPosX : CMP.w $0604 : BCC +
		CMP.w CameraTargetE : BCS +
		BRA .checkY
		+ LDA.l $7EC186
		STA.b LinkPosX
	.checkY
		LDA.b LinkPosY : CMP.w $0600 : BCC +
		CMP.w CameraTargetS : BCS +
			RTL
		+ LDA.l $7EC184
		STA.b LinkPosY
RTL

pushpc
; fixes incorrect vanilla camera scroll boundary values for Zora's Domain
org $82E4E9 : dw $0600
org $82E529 : dw $0600
pullpc
