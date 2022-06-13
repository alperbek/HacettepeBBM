ORG 200H

MODEREG		EQU	086H
PORT1CTL	EQU	088H

PORT1	EQU	090H
PORT2	EQU	092H

TEKRAR:	MOV	AL,00H		;port 2 hepsi input
	OUT	MODEREG,AL
	MOV	AL,0AH		;port1 3. ve 1. bit output
	OUT	PORT1CTL,AL	;2.bit input yap

	MOV	AL,02H		;Bu blok k�sa negatif- 
	OUT	PORT1,AL	;sinyal uretir.  
	MOV	AL,00H		;bunun i�in p11'e s�ras�yla- 
	OUT	PORT1,AL	;1-0-1 g�nderir
	MOV	AL,02H
	OUT	PORT1,AL

BEKLE:	IN	AL,PORT1	;Analogtan dijitale-
	TEST	AL,04H		;�evrimi bekle
	JZ	BEKLE

	MOV	AL,0F7H		;ADC'i etkinle�tir
	OUT	PORT1,AL
	IN	AL,PORT2	;Dijital de�eri al
	MOV	BL,AL		;de�eri BL de sakla

	;START MOTOR
	MOV	AL,01H		;Port1 0.bit output yap
	OUT	PORT1CTL, AL
	MOV	AL,03H		;Port2 t�m bitler output
	OUT	MODEREG,AL	           
	MOV	AL,00H		;DAC etkinle�tir
	OUT	PORT1,AL

	CMP	BL,40H		;sinyal 40h dan a�a�� m�?
	JB	YAVAS		;evetse 40h olarak devam et
	MOV	AL,BL		;de�ilse BL deki de�eri al
	JMP	DVM		

YAVAS:	MOV	AL,40H

DVM:	OUT	PORT2,AL	;Port2 output olarak ayarl�
				;verilen de�erler do�rudan
				;motor d�n�� h�z�n� etkiliyor
	
	MOV	CX,0FFFFH	;0.2 sec lik bir bekletme
DELY2:	LOOP	DELY2
			
	;END MOTOR

	JMP	TEKRAR

	END