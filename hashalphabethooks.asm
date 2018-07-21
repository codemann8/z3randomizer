;--------------------------------------------------------------------------------
!FSTILE_SPACE = "$0188"

!FSTILE_BRACKET_OPEN_TOP = "$1D8A"
!FSTILE_BRACKET_OPEN_BOTTOM = "$1D9A"

!FSTILE_BRACKET_CLOSE_TOP = "$1D8B"
!FSTILE_BRACKET_CLOSE_BOTTOM = "$1D9B"

!FSTILE_A_TOP = "$1D4A"
!FSTILE_A_BOTTOM = "$1D5A"

!FSTILE_C_TOP = "$1D4C"
!FSTILE_C_BOTTOM = "$1D5C"

!FSTILE_D_TOP = "$1D4D"
!FSTILE_D_BOTTOM = "$1D5D"

!FSTILE_E_TOP = "$1D4E"
!FSTILE_E_BOTTOM = "$1D5E"

!FSTILE_F_TOP = "$1D4F"
!FSTILE_F_BOTTOM = "$1D5F"

!FSTILE_H_TOP = "$1D61"
!FSTILE_H_BOTTOM = "$1D71"

!FSTILE_I_TOP = "$1D62"
!FSTILE_I_BOTTOM = "$1D72"

!FSTILE_K_TOP = "$1D64"
!FSTILE_K_BOTTOM = "$1D74"

!FSTILE_L_TOP = "$1D65"
!FSTILE_L_BOTTOM = "$1D75"

!FSTILE_N_TOP = "$1D67"
!FSTILE_N_BOTTOM = "$1D77"

!FSTILE_O_TOP = "$1D68"
!FSTILE_O_BOTTOM = "$1D78"

!FSTILE_P_TOP = "$1D69"
!FSTILE_P_BOTTOM = "$1D79"

!FSTILE_S_TOP = "$1D6C"
!FSTILE_S_BOTTOM = "$1D7C"

!FSTILE_T_TOP = "$1D6D"
!FSTILE_T_BOTTOM = "$1D7D"

!FSTILE_Y_TOP = "$1D82"
!FSTILE_Y_BOTTOM = "$1D92"
;--------------------------------------------------------------------------------
org $0CDE60 ; <- 65E60
FileSelect_CopyFile_Top:
db $62, $A5, $00, $15
dw !FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE
;dw !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_O_TOP, !FSTILE_SPACE, !FSTILE_P_TOP, !FSTILE_SPACE, !FSTILE_Y_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1CAC, !FSTILE_SPACE, $1D23, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D04, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D07
;--------------------------------------------------------------------------------
org $0CDE7A ; <- 65E7A
FileSelect_CopyFile_Bottom:
db $62, $C5, $00, $15
dw !FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE,!FSTILE_SPACE
;dw !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_O_BOTTOM, !FSTILE_SPACE, !FSTILE_P_BOTTOM, !FSTILE_SPACE, !FSTILE_Y_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1CBC, !FSTILE_SPACE, $1D33, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D14, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D17
;--------------------------------------------------------------------------------
org $0CDE94 ; <- 65E94
FileSelect_KillFile_Top:
db $63, $25, $00, $19
dw !FSTILE_D_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_T_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_SPACE
;dw !FSTILE_K_TOP, !FSTILE_SPACE, !FSTILE_I_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw !FSTILE_K_TOP, !FSTILE_SPACE, !FSTILE_I_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, $1D04, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D07
;--------------------------------------------------------------------------------
;org $0CDEB2 ; <- 65EB2
;FileSelect_KillFile_Bottom:
db $63, $45, $00, $19
dw !FSTILE_D_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_T_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE
;dw !FSTILE_K_BOTTOM, !FSTILE_SPACE, !FSTILE_I_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw !FSTILE_K_BOTTOM, !FSTILE_SPACE, !FSTILE_I_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, $1D14, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D17
;--------------------------------------------------------------------------------
;org $0CDDE8 ; <- 65DE8
;FileSelect_PlayerSelectText_Top:
;db $60, $62, $00, $37
;db $8A, $1D, $88, $01, $69, $1D, $88, $01, $65, $1D, $88, $01, $4A, $1D, $88, $01
;db $82, $1D, $88, $01, $4E, $1D, $88, $01, $6B, $1D, $88, $01, $88, $01, $6C, $1D
;db $88, $01, $4E, $1D, $88, $01, $65, $1D, $88, $01, $4E, $1D, $88, $01, $4C, $1D
;db $88, $01, $6D, $1D, $88, $01, $8B, $1D
;--------------------------------------------------------------------------------
;org $0CDE24 ; <- 65E24
;FileSelect_PlayerSelectText_Bottom:
;db $60, $82, $00, $37
;db $9A, $1D, $88, $01, $79, $1D, $88, $01, $75, $1D, $88, $01, $5A, $1D, $88, $01
;db $92, $1D, $88, $01, $5E, $1D, $88, $01, $7B, $1D, $88, $01, $88, $01, $7C, $1D
;db $88, $01, $5E, $1D, $88, $01, $75, $1D, $88, $01, $5E, $1D, $88, $01, $5C, $1D
;db $88, $01, $7D, $1D, $88, $01, $9B, $1D
;--------------------------------------------------------------------------------
;CopyFile_Header:
org $0CE228 ; <- 66228
dw !FSTILE_BRACKET_OPEN_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_C_TOP, !FSTILE_O_TOP, !FSTILE_P_TOP, !FSTILE_Y_TOP, !FSTILE_SPACE, !FSTILE_F_TOP, !FSTILE_I_TOP, !FSTILE_L_TOP, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_BRACKET_CLOSE_TOP
org $0CE24A ; <- 6624A
dw !FSTILE_BRACKET_OPEN_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_C_BOTTOM, !FSTILE_O_BOTTOM, !FSTILE_P_BOTTOM, !FSTILE_Y_BOTTOM, !FSTILE_SPACE, !FSTILE_F_BOTTOM, !FSTILE_I_BOTTOM, !FSTILE_L_BOTTOM, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_BRACKET_CLOSE_BOTTOM

;CopyFile_Which:
org $0CE2DB ; <- 662DB
dw $0D80, $0D61, $0D62, $0D4C, $0D61, $0D86, !FSTILE_SPACE
org $0CE2ED ; <- 662ED
dw $0D90, $0D71, $0D72, $0D5C, $0D71, $0D96, !FSTILE_SPACE

;CopyFile_Where:
org $0CE39C ; <- 6639C
dw $0D80, $0D61, $0D4E, $0D6B, $0D4E, $0D86, !FSTILE_SPACE
org $0CE3AE ; <- 663AE
dw $0D90, $0D71, $0D5E, $0D7B, $0D5E, $0D96, !FSTILE_SPACE

;CopyFile_Execute:
org $0CD13A ; <- 6513A
dw !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_O_TOP, !FSTILE_SPACE, !FSTILE_P_TOP, !FSTILE_SPACE, !FSTILE_Y_TOP, !FSTILE_SPACE, !FSTILE_SPACE
org $0CD150 ; <- 65150
dw !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_O_BOTTOM, !FSTILE_SPACE, !FSTILE_P_BOTTOM, !FSTILE_SPACE, !FSTILE_Y_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE

;CopyFile_Cancel:
org $0CE29A ; <- 6629A
dw !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_A_TOP, !FSTILE_SPACE, !FSTILE_N_TOP, !FSTILE_SPACE, !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
org $0CE2BA ; <- 662BA
dw !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_A_BOTTOM, !FSTILE_SPACE, !FSTILE_N_BOTTOM, !FSTILE_SPACE, !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE

;KillFile_Header:
org $0CE002 ; <- 66002
dw !FSTILE_BRACKET_OPEN_TOP, !FSTILE_SPACE, !FSTILE_D_TOP, !FSTILE_E_TOP, !FSTILE_L_TOP, !FSTILE_E_TOP, !FSTILE_T_TOP, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_F_TOP, !FSTILE_I_TOP, !FSTILE_L_TOP, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_BRACKET_CLOSE_TOP, !FSTILE_SPACE, !FSTILE_SPACE
org $0CE028 ; <- 66028
dw !FSTILE_BRACKET_OPEN_BOTTOM, !FSTILE_SPACE, !FSTILE_D_BOTTOM, !FSTILE_E_BOTTOM, !FSTILE_L_BOTTOM, !FSTILE_E_BOTTOM, !FSTILE_T_BOTTOM, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_F_BOTTOM, !FSTILE_I_BOTTOM, !FSTILE_L_BOTTOM, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_BRACKET_CLOSE_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE

;KillFile_Which:
org $0CE04E ; <- 6604E
dw $0D4D, $0D4E, $0D65, $0D4E, $0D6D, $0D4E, !FSTILE_SPACE, $0D80, $0D61, $0D62, $0D4C, $0D61, !FSTILE_SPACE, $0D4F, $0D62, $0D65, $0D4E, $0D86, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
org $0CE084 ; <- 66084
dw $0D5D, $0D5E, $0D75, $0D5E, $0D7D, $0D5E, !FSTILE_SPACE, $0D90, $0D71, $0D72, $0D5C, $0D71, !FSTILE_SPACE, $0D5F, $0D72, $0D75, $0D5E, $0D96, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE

;KillFile_Execute:
org $0CD328 ; <- 65328
dw !FSTILE_D_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_T_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE
org $0CD344 ; <- 65344
dw !FSTILE_D_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_T_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE

;KillFile_Cancel:
org $0CE0BA ; <- 660BA
dw !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_A_TOP, !FSTILE_SPACE, !FSTILE_N_TOP, !FSTILE_SPACE, !FSTILE_C_TOP, !FSTILE_SPACE, !FSTILE_E_TOP, !FSTILE_SPACE, !FSTILE_L_TOP, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
org $0CE0DA ; <- 660DA
dw !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_A_BOTTOM, !FSTILE_SPACE, !FSTILE_N_BOTTOM, !FSTILE_SPACE, !FSTILE_C_BOTTOM, !FSTILE_SPACE, !FSTILE_E_BOTTOM, !FSTILE_SPACE, !FSTILE_L_BOTTOM, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
