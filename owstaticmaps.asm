;===================================================================================================
; Static overworld tile overlays
;---------------------------------------------------------------------------------------------------
; Same OWW command language as invertedmaps.asm (stripes, RLE, skips, etc.).
; Unconditional only: do not use !OWW_CustomCommand or !OWW_InvertedOnly.
; Streams live in bank $A3; skip targets are 16-bit addresses in this bank.
; Use OverworldStaticOWWSentinel ($A3B104) as skip-to-end.
;
; The generator owns this blob; asar ships an empty pointer table.
; Referenced by the generator. Do not move.
; SNES $A3B000 / PC 0x11B000
;===================================================================================================

OverworldStaticMapPointers:
	; light world
	dw $0000      ; 00
	dw $0000      ; 01
	dw $0000      ; 02
	dw $0000      ; 03
	dw $0000      ; 04
	dw $0000      ; 05
	dw $0000      ; 06
	dw $0000      ; 07
	dw $0000      ; 08
	dw $0000      ; 09
	dw $0000      ; 0A
	dw $0000      ; 0B
	dw $0000      ; 0C
	dw $0000      ; 0D
	dw $0000      ; 0E
	dw $0000      ; 0F
	dw $0000      ; 10
	dw $0000      ; 11
	dw $0000      ; 12
	dw $0000      ; 13
	dw $0000      ; 14
	dw $0000      ; 15
	dw $0000      ; 16
	dw $0000      ; 17
	dw $0000      ; 18
	dw $0000      ; 19
	dw $0000      ; 1A
	dw $0000      ; 1B
	dw $0000      ; 1C
	dw $0000      ; 1D
	dw $0000      ; 1E
	dw $0000      ; 1F
	dw $0000      ; 20
	dw $0000      ; 21
	dw $0000      ; 22
	dw $0000      ; 23
	dw $0000      ; 24
	dw $0000      ; 25
	dw $0000      ; 26
	dw $0000      ; 27
	dw $0000      ; 28
	dw $0000      ; 29
	dw $0000      ; 2A
	dw $0000      ; 2B
	dw $0000      ; 2C
	dw $0000      ; 2D
	dw $0000      ; 2E
	dw $0000      ; 2F
	dw $0000      ; 30
	dw $0000      ; 31
	dw $0000      ; 32
	dw $0000      ; 33
	dw $0000      ; 34
	dw $0000      ; 35
	dw $0000      ; 36
	dw $0000      ; 37
	dw $0000      ; 38
	dw $0000      ; 39
	dw $0000      ; 3A
	dw $0000      ; 3B
	dw $0000      ; 3C
	dw $0000      ; 3D
	dw $0000      ; 3E
	dw $0000      ; 3F

	; dark world
	dw $0000      ; 40
	dw $0000      ; 41
	dw $0000      ; 42
	dw $0000      ; 43
	dw $0000      ; 44
	dw $0000      ; 45
	dw $0000      ; 46
	dw $0000      ; 47
	dw $0000      ; 48
	dw $0000      ; 49
	dw $0000      ; 4A
	dw $0000      ; 4B
	dw $0000      ; 4C
	dw $0000      ; 4D
	dw $0000      ; 4E
	dw $0000      ; 4F
	dw $0000      ; 50
	dw $0000      ; 51
	dw $0000      ; 52
	dw $0000      ; 53
	dw $0000      ; 54
	dw $0000      ; 55
	dw $0000      ; 56
	dw $0000      ; 57
	dw $0000      ; 58
	dw $0000      ; 59
	dw $0000      ; 5A
	dw $0000      ; 5B
	dw $0000      ; 5C
	dw $0000      ; 5D
	dw $0000      ; 5E
	dw $0000      ; 5F
	dw $0000      ; 60
	dw $0000      ; 61
	dw $0000      ; 62
	dw $0000      ; 63
	dw $0000      ; 64
	dw $0000      ; 65
	dw $0000      ; 66
	dw $0000      ; 67
	dw $0000      ; 68
	dw $0000      ; 69
	dw $0000      ; 6A
	dw $0000      ; 6B
	dw $0000      ; 6C
	dw $0000      ; 6D
	dw $0000      ; 6E
	dw $0000      ; 6F
	dw $0000      ; 70
	dw $0000      ; 71
	dw $0000      ; 72
	dw $0000      ; 73
	dw $0000      ; 74
	dw $0000      ; 75
	dw $0000      ; 76
	dw $0000      ; 77
	dw $0000      ; 78
	dw $0000      ; 79
	dw $0000      ; 7A
	dw $0000      ; 7B
	dw $0000      ; 7C
	dw $0000      ; 7D
	dw $0000      ; 7E
	dw $0000      ; 7F

	; special world
	dw $0000      ; 80
	dw $0000      ; 81

; this space is reserved for the generator to provide
; should allow for an estimated max $2000 bytes
; inverted changes alone account for ~$800 bytes
OverworldStaticMapData:
print "Static OWW data: ", pc
