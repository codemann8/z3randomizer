;================================================================================
; Blind Boss fight
;--------------------------------------------------------------------------------

pushpc

org $9DA081					; Original Code
	JML check_blind_boss_room
Check_for_Blind_Fight:

org $9DA090
Initialize_Blind_Fight:

pullpc

check_blind_boss_room:
	LDA $A0                             ; load room index (low byte)
	CMP #172 : BNE +                    ; Is is Thieves Town Boss Room
	LDA !BLIND_DOOR_FLAG : BNE +		; Blind maiden does not need rescuing

	LDA FollowerIndicator : JML Check_for_Blind_Fight
	+
	JML Initialize_Blind_Fight
