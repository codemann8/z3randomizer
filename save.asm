;--------------------------------------------------------------------------------
WriteSaveChecksumAndBackup:
        LDX.w #$0000 : TXA : - ; Checksum first $04FE bytes
                CLC : ADC.l SaveDataWRAM, X
                INX #2
        CPX.w #$04FE : BNE -
        LDX.w #$0000 : - ; Checksum extended save data
                CLC : ADC.l ExtendedFileNameWRAM, X
                INX #2
        CPX.w #$0FFE : BNE -
        STA.b Scrap00
        LDA.w #$5A5A
        SEC : SBC.b Scrap00
        STA.l InverseChecksumSRAM

        PHB
        LDA.w #$14FF             ; \
        LDX.w #CartridgeSRAM     ;  | Copies $1500 bytes from beginning of cart SRAM to 
        LDY.w #SaveBackupSRAM    ;  | $704000
        MVN !SRAMBank, !SRAMBank ; /
        PLB
        TDC
        TAX

RTL
;--------------------------------------------------------------------------------
ValidateSRAM:
        REP #$30
        LDX.w #$0000 : TXA : - ; Checksum first $04FE bytes
                CLC : ADC.l CartridgeSRAM, X
                INX #2
        CPX.w #$04FE : BNE -
        LDX.w #$0000 : - ; Checksum extended save data
                CLC : ADC.l ExtendedFileNameSRAM, X
                INX #2
        CPX.w #$0FFE : BNE -
        STA.b Scrap00
        LDA.w #$5A5A
        SEC : SBC.b Scrap00
        CMP.l InverseChecksumSRAM : BEQ .goodchecksum
                LDX.w #$0000 : TXA : - ; Do the same for the backup save
                        CLC : ADC.l SaveBackupSRAM, X
                        INX #2
                CPX.w #$04FE : BNE -
                LDX.w #$0000 : -
                        CLC : ADC.l SaveBackupSRAM+$500, X
                        INX #2
                CPX.w #$0FFE : BNE -
                STA.b Scrap00
                LDA.w #$5A5A
                SEC : SBC.b Scrap00
                CMP.l SaveBackupSRAM+$4FE : BEQ +
                        TDC : STA.l FileValiditySRAM ; Delete save by way of zeroing validity marker
                        BRA .goodchecksum : +
                PHB
                LDA.w #$14FF             ; \
                LDX.w #SaveBackupSRAM    ;  | Copies $1500 bytes from backup on cart SRAM to 
                LDY.w #CartridgeSRAM     ;  | main save location at $700000
                MVN !SRAMBank, !SRAMBank ; /
                PLB

        .goodchecksum
	LDX.w #$00FE : - ; includes prize pack reset after save and quit
		STZ.w $0D00, X
		STZ.w $0E00, X
		STZ.w $0F00, X
		DEX #2
	BPL -
	SEP #$30
RTL
;--------------------------------------------------------------------------------
ClearExtendedSaveFile:
        STA.l $700400, X ; what we wrote over
        STA.l $700500, X
        STA.l $700600, X
        STA.l $700700, X
        STA.l $700800, X
        STA.l $700900, X
        STA.l $700A00, X
        STA.l $700B00, X
        STA.l $700C00, X
        STA.l $700D00, X
        STA.l $700E00, X
        STA.l $700F00, X
        STA.l $701000, X
        STA.l $701100, X
        STA.l $701200, X
        STA.l $701300, X
        STA.l $701400, X
        ; Clear backup save
        STA.l $704000, X
        STA.l $704100, X
        STA.l $704200, X
        STA.l $704300, X
        STA.l $704400, X
        STA.l $704500, X
        STA.l $704600, X
        STA.l $704700, X
        STA.l $704800, X
        STA.l $704900, X
        STA.l $704A00, X
        STA.l $704B00, X
        STA.l $704C00, X
        STA.l $704D00, X
        STA.l $704E00, X
        STA.l $704F00, X
        STA.l $705000, X
        STA.l $705100, X
        STA.l $705200, X
        STA.l $705300, X
        STA.l $705400, X
RTL
;--------------------------------------------------------------------------------
ClearExtendedWRAMSaveFile:
        STA.l $7EF400, X ; what we wrote over
        STA.l $7F6000, X
        STA.l $7F6100, X
        STA.l $7F6200, X
        STA.l $7F6300, X
        STA.l $7F6400, X
        STA.l $7F6500, X
        STA.l $7F6600, X
        STA.l $7F6700, X
        STA.l $7F6800, X
        STA.l $7F6900, X
        STA.l $7F6A00, X
        STA.l $7F6B00, X
        STA.l $7F6C00, X
        STA.l $7F6D00, X
        STA.l $7F6E00, X
        STA.l $7F6F00, X
RTL
;--------------------------------------------------------------------------------
CopyExtendedSaveFileToWRAM:
        PHA
        PHB
        LDA.w #$0FFF
        LDX.w #ExtendedSaveDataSRAM
        LDY.w #ExtendedSaveDataWRAM
        MVN $7F, !SRAMBank
        PLB
        PLA
        STA.l $7EC00D ; What we wrote over. Keep this write last.
RTL
;--------------------------------------------------------------------------------
CopyExtendedWRAMSaveFileToSRAM:
        PHB
        LDA.w #$0FFF
        LDX.w #ExtendedSaveDataSRAM
        LDY.w #ExtendedSaveDataWRAM
        MVN !SRAMBank, $7F
        PLB
        TDC
        TAX
RTL
