ORG 00H
;---------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------TEST SECTION-------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------P1.0 -> P1.3 == IN1 ---------------------------------------------------------
;----------------------------------------------P1.0 P1.1 BANH PHAI----------------------------------------------------------
;----------------------------------------------P1.2 P1.3 BANH TRAI----------------------------------------------------------
;MOV TMOD,#00100000B
MOV R1, #0
MOV R2, #0
MOV TMOD,#00010000B
MOV P1, #0D						;P1 = OUTPUT
CLR P3.0						;P3.0 = TRIGGER
SETB P3.1						;P3.1 = ECHO
CLR P2.0

MAIN:
;------------------------------------------------------------------------------------
	MOV TH1, #0FAH 
	MOV TL1, #25H 
	SETB P2.0 ;Make P2.0 HIGH
	SETB TR1 ;Start the timer 0
	JNB TF1, $;Wait till the TF1 flag is set 
	CLR P2.0 ;Make P2.0 LOW 
	CLR TF1 ;Clear the flag manually
	CLR TR1 ;Stop the timer 1
	JMP DISTANCECHECK
;------------------------------------------------------------------------------------
DISTANCECHECK:
	MOV A, #0D				;BIEN DEM
	SETB P3.0
	ACALL TRGDELAY
	CLR P3.0
	JNB P3.1, $					; DOI ECHO TOGGLE THI BAT DAU BAT TIMER DE LUU THOI GIAN
	PULSEWD:
		MOV TH1, #0FFH			;MOD 3 8 BIT, TH = TL
		MOV TL1, #08CH
		SETB TR1
		JNB TF1, $
		CLR TR1
		CLR TF1
		INC A
		JB P3.1, PULSEWD		;NEU VAN CON TIN HIEU ECHO THI TIEP TUC DEM THOI GIAN
		CJNE R1, #0D, BACK		; NEU BANG R1 = 1 THI LA TURNRIGHT DANG GOI HAM SCAN, RESET R1 VA BACK
		CJNE R2, #0D, BACK		; NEU BANG R2 = 1 THI LA TURNRLEFT DANG GOI HAM SCAN, RESET R2 VA BACK
CHECK:
	CJNE A, #15D, NEXT
	NEXT:
		JC STOP
		JNC RUN
BACK:
RET

TRGDELAY:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET
DELAY:
	MOV R4, #2
DELAY1:
	MOV R5, #200
DELAY2:
	MOV R6, #200
DELAY3:					
	DJNZ R6, DELAY3
	DJNZ R5, DELAY2
	DJNZ R4, DELAY1
	RET

TURNDELAY:
	MOV R4, #3
TURNDELAY1:
	MOV R5, #180
TURNDELAY2:
	MOV R6, #200
TURNDELAY3:					
	DJNZ R6, TURNDELAY3
	DJNZ R5, TURNDELAY2
	DJNZ R4, TURNDELAY1
	RET
	
	
RUN:
	SETB P1.0
	CLR P1.1
	SETB P1.2
	CLR P1.3
	ACALL DELAY
	JMP MAIN
STOP:
	CLR P1.0
	CLR P1.1
	CLR P1.2
	CLR P1.3
	

SCANRIGHT: 
	MOV TH1, #0FEH 
	MOV TL1, #0DH 
	SETB P2.0 ;Make P2.0 HIGH
	SETB TR1 ;Start the timer 0
	JNB TF1, $ ;Wait till the TF0 flag is set 
	CLR P2.0 ;Make P2.0 LOW 
	CLR TF1 ;Clear the flag manually
	CLR TR1 ;Stop the timer 0
	ACALL DELAY99
	MOV R1, #1D								; CHO R1 = 1 DE GOI HAM SCAN DC TRO VE
	ACALL DISTANCECHECK	
	MOV R1, A
	MOV B, R1								; LUU KHOANG CACH PHAI VAO B
	MOV R1, #0D						
	


SCANLEFT: 
	MOV TH1, #0F6H 
	MOV TL1, #0A1H 
	SETB P2.0 ;Make P2.0 HIGH
	SETB TR1 ;Start the timer 0
	JNB TF1, $ ;Wait till the TF0 flag is set
	CLR P2.0 ;Make P2.0 LOW 
	CLR TF1 ;Clear the flag manually
	CLR TR1 ;Stop the timer 0
	ACALL DELAY99
	MOV R2, #1D								; CHO R2 = 1 DE GOI HAM SCAN DC TRO VE
	ACALL DISTANCECHECK
	CJNE A, B, NEXTLEFT
	NEXTLEFT:
		JC TURNRIGHT
		JNC TURNLEFT
TURNLEFT:
;------------------------------------------------------------------------------------
	MOV TH1, #0FAH 
	MOV TL1, #25H 
	SETB P2.0 ;Make P2.0 HIGH
	SETB TR1 ;Start the timer 0
	JNB TF1, $ ;Wait till the TF0 flag is set 
	CLR P2.0 ;Make P2.0 LOW 
	CLR TF1 ;Clear the flag manually
	CLR TR1 ;Stop the timer 0
	ACALL DELAY99

;------------------------------------------------------------------------------------
	CLR P1.2
	SETB P1.3
	SETB P1.0
	CLR P1.1
	ACALL TURNDELAY

	
	MOV P1, #0D
	ACALL DELAY
	ACALL DELAY
	JMP MAIN		
TURNRIGHT:
;------------------------------------------------------------------------------------
	MOV TH1, #0FAH 
	MOV TL1, #25H 
	SETB P2.0 ;Make P2.0 HIGH
	SETB TR1 ;Start the timer 0
	JNB TF1, $ ;Wait till the TF0 flag is set 
	CLR P2.0 ;Make P2.0 LOW 
	CLR TF1 ;Clear the flag manually
	CLR TR1 ;Stop the timer 0
	ACALL DELAY99
;------------------------------------------------------------------------------------
	CLR P1.0
	SETB P1.1
	SETB P1.2
	CLR P1.3
	ACALL TURNDELAY

	
	MOV P1, #0D
	ACALL DELAY
	ACALL DELAY
	JMP MAIN		

DELAY99: 
	MOV R4,#32H ;100us * 100us * 100us = 1s
LOOP1:MOV R3,#64H
LOOP2:MOV R2,#64H
LOOP3:DJNZ R2,LOOP3
	DJNZ R3,LOOP2
	DJNZ R4,LOOP1
RET

END 
