

      ; Reset Vector
      org   0000h
      jmp   Start
      ORG 00023H
      JMP REC_UART

;====================================================================
; CODE SEGMENT
;====================================================================
REC_UART:
      JNB RI, $
      MOV A, SBUF
      CLR RI
RETI 
TRUYEN:
   MOV SBUF, A
   HERE: JNB TI, HERE
   CLR TI
RET
; H CUA 8051 = 921600 HZ
; T = 1.08us
; DEM 65536 - 20 = 65516 LAN
; => DUTY CYCLE = 65516 * 1.08US = 0.071
; DUTY CYCLE TIEN 25% LUI 75%
DELAY_PULSE:
      ;MOV TMOD, #01h
      MOV TH0, #000H
      MOV TL0, #014H
      SETB TR0
      JNB TF0, $
      CLR TF0
      CLR TR0
RET
;------------------------------	CHUONG TRINH CON GOC SERVO -------------------

;------------------------------GOC-90---------------------------------------------
MOVE90:
	MOV R7,#100
MOVE900:
	SETB P2.4
	CALL DELAY90
	CLR P2.4
	CALL DELAY90
	DJNZ R7,MOVE900
	MOV R7,#0
RET
;------------------------------------GOC-45------------------------------------------
MOVE45:
	MOV R7,#100
MOVE455:
	SETB P2.4
	CALL DELAY45
	CLR P2.4
	CALL DELAY45
	DJNZ R7,MOVE455
	MOV R7,#0
RET
;-------------------------------------GOC-0---------------------------------------------
MOVE0:
	MOV R7,#100
MOVE00:
	SETB P2.4
	CALL DELAY0
	CLR P2.4
	CALL DELAY0
	DJNZ R7,MOVE00
	MOV R7,#0
	RET
;--------------------------------------GOC-TRU-45------------------------------------------
MOVET45:
	MOV R7,#100
MOVET455:
	SETB P2.4
	CALL DELAYT45
	CLR P2.4
	CALL DELAYT45
	DJNZ R7,MOVET455
	MOV R7,#0
	RET
;------------------------------------------GOC-TRU-90------------------------------------------
MOVET90:
	MOV R7,#100
MOVET900:
	SETB P2.4
	CALL DELAYT90
	CLR P2.4
	CALL DELAYT90
	DJNZ R7,MOVET900
	MOV R7,#0
	RET
;---------------------------------------CHUONG TRINH DELAY CHO TUNG LOAI GOC-----------------		
DELAY90:
	MOV TL0,#LOW(-2700)
	MOV TH0,#HIGH(-2700)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAY45:
	MOV TL0,#LOW(-2000)
	MOV TH0,#HIGH(-2000)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAY0:
	MOV TL0,#LOW(-1500)
	MOV TH0,#HIGH(-1500)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAYT45:
	MOV TL0,#LOW(-1000)
	MOV TH0,#HIGH(-1000)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET	
DELAYT90:
	MOV TL0,#LOW(-500)
	MOV TH0,#HIGH(-500)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAY: MOV R1,#100
LAP1: MOV R2,#99
LAP2: MOV R3,#74
LAP3: DJNZ R3,LAP3
DJNZ R2,LAP2
DJNZ R1,LAP1
RET
DELAY_SV:
      MOV TH0, #0FEH
      MOV TL0, #40H
      SETB TR0
      JNB TF0, $
      CLR TF0
      CLR TR0
RET
DELAYSV:
	MOV	R7,#20
	DELAYSVV:
	MOV TL0,#LOW(-60000)
	MOV TH0,#HIGH(-60000)
	SETB	TR0
	AGAIN:	JNB	TF0,	AGAIN
	CLR	TR0
	CLR	TF0
	DJNZ R7,DELAYSVV
	MOV	R7,#0
	RET
;---------------------CHUONG TRINH CHINH------------------------------------------------------
      org   0100h
Start:	
      MOV IE, #90H
      MOV SCON , #50H
      MOV TMOD ,#21H
      MOV TH1, #0FDH
      SETB TR1
	  MOV A, #0
	  CLR P3.5
      CLR P3.4
      CLR P3.6
      CLR P3.7	
;-----------------------------------------VONG LAP WHILE(1)-----------------------------------------
	  LOOP:  
      CJNE A,#"B", CONTI_1; BACK
	  CJNE A,#"B", CONTI_1;
	  ACALL MOVE0
	  SETB P3.6
	  CLR P3.7
	  SETB P3.4
	  CLR P3.5
      MOV A,#0
      JMP LOOP
;---------------------------------------------------------------------------------------------------
      CONTI_1:
      CJNE A,#"F", CONTI_2 ; FORWARD
	  ACALL MOVE0 ; GOI HAM CTRL SERVO VE GOC 0
	  SETB P3.7  ; CHO MOTOR TIEN
	  CLR  P3.6                       
	  SETB P3.5
	  CLR P3.4      
      MOV A,#0 ; RESET GIA TRI NHAN
      JMP LOOP ; QUAY VE NHAN LAI GIA TRI KHAC
;---------------------------------------------------------------------------------------------------
      CONTI_2:
      CJNE A,#"R", CONTI_3 ; RIGHT
	  ACALL MOVET45
	  SETB P3.6
	  CLR P3.7
	  CLR P3.5
	  CLR P3.4
	  MOV A,#0
	  JMP LOOP
	  CONTI_3:
;---------------------------------------------------------------------------------------------------
	  CJNE A,#"L", CONTI_4 ; LEFT 
	  ACALL MOVE45
	  CLR P3.7
	  CLR P3.6
	  SETB P3.4
	  CLR P3.5     
	  MOV A,#0
	  JMP LOOP
;---------------------------------------------------------------------------------------------------
	  CONTI_4: ;  STOP
	  CJNE A,#"W", CONTI_5
	  ACALL MOVE0      
	  CLR P3.7
	  CLR P3.6
	  CLR P3.4
	  CLR P3.5
	  MOV A,#0
	  JMP LOOP   
	  CONTI_5:
jmp LOOP


RET 
	      
;====================================================================
      END
