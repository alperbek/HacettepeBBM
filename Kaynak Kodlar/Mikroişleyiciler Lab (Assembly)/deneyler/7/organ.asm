ORG	200H

PORTCTL1	EQU	088H
PORT1		EQU	090H

	;INIT
	MOV	AL, 20H
	OUT	PORTCTL1, AL

	PUSH	BX

ANA_DONGU:
	; TUSA BAS
	MOV	DI, OFFSET KEY_CODE    
        MOV     BL,3
        MOV     CX,1
        MOV     AH,00H   	; Klavyeden tu� oku
        INT     28H

	MOV	AX, KEY_CODE

	CMP	AX, 39H		; tu� 39h dan b�y�k m�?
	JA	HARF		
	
	SUB	AX, 31H		; tu� 39h dan k���kse
	JMP	DEVAM		; 31h ��kar ve devam et

HARF:	SUB	AX, 41H		; 39h'dan b�y�kse 41h ��kar
	ADD	AX, 9		; 9 ekle - indeks 0'dan ba�lar

DEVAM:	
	POP	BX	
	SHL	AX,1		 ; Dizi WORD'l�k oldu�undan  
	MOV	DI, OFFSET NOTES ; Dizi offset'ini al	
	ADD	DI, AX		 ; Dizi offset'i �zerinde ilerle
	MOV	BX, [DI]	 ; Diziden d�ng� de�eri al
	PUSH	BX	       	 ; Al�nan dizi d�ng�s�n� sakla

	MOV	BX, 0FH

PIEZO_CAL:			; PIEZO ses �ald�rma rutini
	MOV	AL, 00H		
	OUT	PORT1, AL	; piezo mod�l kapat
	
	POP	CX		; saklanan d�ng� de�erini al
	PUSH	CX		; tekrar sakla
DELY1:	LOOP	DELY1		; 1. bekleme

	MOV	AL, 20H
	OUT	PORT1, AL	; piezo mod�l a�
	
	POP	CX		; saklanan d�ng� de�erini al
	PUSH	CX		; tekrar sakla
DELY2:	LOOP	DELY2		; 2. bekleme
	
	MOV	AL, 00H		
	OUT	PORT1, AL	; piezo mod�l kapat

	DEC	BX		
	CMP	BX,0		; PIEZO ses �ald�rmas� bitti mi?
	JNZ	PIEZO_CAL	; bitmediyse �ald�rmaya devam

	JMP	ANA_DONGU	; bittiyse her �ey en ba�tan tekrar

NOTES	DW	1712, 1524, 1436, 1275, 1136, 1016, 936, 853, 766, 716, 637, 568, 507, 478, 418

KEY_CODE DB 	?

	END