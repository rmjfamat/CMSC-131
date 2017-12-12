TITLE ASM1 (SIMPLIFIED .EXE )
.MODEL SMALL
;---------------------------------------------
.DATA
  PATHFILENAME  DB 'page1.txt', 00H
  FILEHANDLE    DW ?

  PATHFILENAME2  DB 'page2.txt', 00H
  FILEHANDLE2    DW ?

  PATHFILENAME3  DB 'page3.txt', 00H
  FILEHANDLE3    DW ?

  PATHFILENAME4  DB 'level.asm', 00H
  FILEHANDLE4    DW ?


  PAGE1 DB 2000 DUP('$'), '$'
  PAGE2 DB 3000 DUP('$'), '$'
  PAGE3 DB 2000 DUP('$'), '$'
  NEWPAGE DW 2000 DUP('$')

  LEVEL1 DB 50 DUP('$'), '$'
  HOLDER DB 50 DUP('$'), '$'

  P1 DB ? ,  "$"
  Test1    DB 'Playing$'
  Test2    DB 'PLAQ$'
  Test3    DB '12WEE$'

  ERROR1_STR    DB 'Error in opening file.$'
  ERROR2_STR    DB 'Error reading from file.$'
  ERROR3_STR    DB 'No record read from file.$'

  ERROR1_STR2    DB 'Error in opening file.$'
  ERROR2_STR2    DB 'Error reading from file.$'
  ERROR3_STR2    DB 'No record read from file.$'

  ERROR1_STR3    DB 'Error in opening file.$'
  ERROR2_STR3    DB 'Error reading from file.$'
  ERROR3_STR3    DB 'No record read from file.$'

  ERROR1_STR4    DB 'Error in opening file.$'
  ERROR2_STR4   DB 'Error reading from file.$'
  ERROR3_STR4   DB 'No record read from file.$'

  POSX DB ?
  POSY DB ?
  NEW_INPUT DB ?

;---------------------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX

  CALL CLEAR_SCREEN0
  CALL CLEAR_SCREEN1
  CALL SET_CURSOR
  CALL DISPLAY1
  
  MOV AH, 09
  INT 21H

  MOV AH, 10H
  INT 16H
  MOV P1, AL

  CMP AL, 49
  JE Play_1

  CMP AL, 50
  JE Ins_2

  CMP AL, 51
  JE EXIT
  JNE Main_3

  Play_1:
    CALL CLEAR_SCREEN0
    CALL CLEAR_SCREEN1
    CALL CLEAR_SCREEN3
    MOV POSX, 00
    MOV POSY, 00
    CALL SET_CURSOR
    CALL DISPLAY3

    MOV AH, 09
    INT 21H

    MOV AH, 10H
    INT 16H
    MOV P1, AL

    CMP AL, 32
    JE Ready_Play

    CMP AL, 49
    JE Main_3

    JNE Play_1

    JMP EXIT

  Ins_2:
    CALL CLEAR_SCREEN0
    CALL CLEAR_SCREEN2
    MOV   DL, 00
    MOV   DH, 00
    CALL SET_CURSOR
    CALL DISPLAY2

    MOV AH, 09
    INT 21H

    MOV AH, 10H
    INT 16H
    MOV P1, AL

    CMP AL, 49
    JE Play_1

    CMP AL, 50
    JE Main_3

    CMP AL, 51
    JE EXIT
    JNE Ins_2

    JMP EXIT

  Main_3:
   CALL MAIN

  Ready_Play:
    CALL PLAY_GAME

  EXIT:
  MOV AH, 4CH
  INT 21H

MAIN ENDP

;------------------------------------------------------------------CLEAR_SCREEN1
CLEAR_SCREEN1 PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV BH, 8BH    ;white background (7), blue foreground (1)
  MOV CX, 0000H   ;upper left row:column (0:0)
  MOV DX, 104FH   ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN1 ENDP

;------------------------------------------------------------------CLEAR_SCREEN0
CLEAR_SCREEN0 PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV BH, 09H    ;white background (7), blue foreground (1)
  MOV CX, 0000H   ;upper left row:column (0:0)
  MOV DX, 184FH   ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN0 ENDP

;------------------------------------------------------------------CLEAR_SCREEN2
CLEAR_SCREEN2 PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV BH, 8AH    ;white background (7), blue foreground (1)
  MOV CX, 0505H   ;upper left row:column (0:0)
  MOV DX, 094CH   ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN2 ENDP

;------------------------------------------------------------------CLEAR_SCREEN3
CLEAR_SCREEN3 PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV BH, 8AH    ;white background (7), blue foreground (1)
  MOV CX, 1010H   ;upper left row:column (0:0)
  MOV DX, 174CH   ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN3 ENDP


;--------------------------------------------------------------------SET_CURSOR
SET_CURSOR PROC  NEAR
      MOV   AH, 02H
      MOV   BH, 00

      MOV DL, POSX
      MOV DH, POSY 
      INT   10H
      RET
SET_CURSOR ENDP

;-----------------------------------------------------------------------PAGE 1
DISPLAY1 PROC NEAR
  ;open page1
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME
  INT 21H
  JC DISPLAY_ERROR1
  MOV FILEHANDLE, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE
  MOV CX, 2000  
  LEA DX, PAGE1 
  INT 21H
  JC DISPLAY_ERROR2
  CMP AX, 00 
  JE DISPLAY_ERROR3

  LEA SI, PAGE1
  CALL OUTPUT_EXT

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE
  INT 21H

  JMP HERE

DISPLAY_ERROR1:
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2

DISPLAY_ERROR2:
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2

DISPLAY_ERROR3:
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT2:
  MOV AH, 4CH
  INT 21H

 HERE:

RET
DISPLAY1 ENDP

;-----------------------------------------------------------------------PAGE 2 (INS)
DISPLAY2 PROC NEAR
  ;open page2
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME2
  INT 21H
  JC DISPLAY_ERROR1_2
  MOV FILEHANDLE2, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE2
  MOV CX, 5000  
  LEA DX, PAGE2 
  INT 21H
  JC DISPLAY_ERROR2_2
  CMP AX, 00 
  JE DISPLAY_ERROR3_2

  LEA SI, PAGE2
  CALL OUTPUT_EXT

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE2
  INT 21H

  JMP HERE_2

DISPLAY_ERROR1_2:
  LEA DX, ERROR1_STR2
  MOV AH, 09
  INT 21H

  JMP EXIT2_2

DISPLAY_ERROR2_2:
  LEA DX, ERROR2_STR2
  MOV AH, 09
  INT 21H

  JMP EXIT2_2

DISPLAY_ERROR3_2:
  LEA DX, ERROR3_STR2
  MOV AH, 09
  INT 21H

EXIT2_2:
  MOV AH, 4CH
  INT 21H

 HERE_2:

RET
DISPLAY2 ENDP

;-----------------------------------------------------------------------PAGE 3 (Ready Play)
DISPLAY3 PROC NEAR
  ;open page3
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME3
  INT 21H
  JC DISPLAY_ERROR1_3
  MOV FILEHANDLE3, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE3
  MOV CX, 3000  
  LEA DX, PAGE3
  INT 21H
  JC DISPLAY_ERROR2_3
  CMP AX, 00 
  JE DISPLAY_ERROR3_3

  LEA SI, PAGE3
  CALL OUTPUT_EXT

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE3
  INT 21H

  JMP HERE_3

DISPLAY_ERROR1_3:
  LEA DX, ERROR1_STR3
  MOV AH, 09
  INT 21H

  JMP EXIT2_3

DISPLAY_ERROR2_3:
  LEA DX, ERROR2_STR3
  MOV AH, 09
  INT 21H

  JMP EXIT2_3

DISPLAY_ERROR3_3:
  LEA DX, ERROR3_STR3
  MOV AH, 09
  INT 21H

EXIT2_3:
  MOV AH, 4CH
  INT 21H

 HERE_3:

RET
DISPLAY3 ENDP

;----------------------------------------------------------------OUTPUT_EXT
OUTPUT_EXT PROC NEAR
PRINT:
  MOV   DX, [SI]
  CMP   DL, 226
  JNE   CONT

  INC   SI
  MOV   DX, [SI]
  CMP   DL, 96H
  JE    SPECIAL
  INC   SI
  MOV   DX, [SI]
  CMP   DL, 94H
  JE    UP_LEFT
  CMP   DL, 97H
  JE    UP_RIGHT
  CMP   DL, 91H
  JE    STRA_VERT
  CMP   DL, 9DH
  JE    LOW_LEFT
  CMP   DL, 9AH
  JE    LOW_RIGHT
  CMP   DL, 90H
  JE    STRA_HORI
  CMP   DL, 166
  JE    TOP_DOWN
  CMP   DL, 169
  JE    BOTTOM_UP
  JNE   CONT

CONT:
  CMP   DL, 24H
  JE    RETURN_LOAD
  MOV   AH, 02H
  INT   21H
  INC   SI
  JMP   PRINT

TOP_DOWN:
  MOV   DL, 203
  JMP   CONT
BOTTOM_UP:
  MOV   DL, 202
  JMP   CONT
UP_LEFT:
  MOV   DL, 201
  JMP   CONT
UP_RIGHT:
  MOV   DL, 187
  JMP   CONT
STRA_VERT:
  MOV   DL, 186
  JMP   CONT
LOW_RIGHT:
  MOV   DL, 200
  JMP   CONT
LOW_LEFT:
  MOV   DL, 188
  JMP   CONT
STRA_HORI:
  MOV   DL, 205
  JMP   CONT
STRIKE:
  MOV   DL, 176
  JMP   CONT
BLACK:
  MOV   DL, 219
  JMP   CONT
BLACK_STRIKE:
  MOV   DL, 178
  JMP   CONT
CURSOR_POINT:
  MOV   DL, 16
  JMP   CONT

SPECIAL:
  INC   SI 
  MOV   DX, [SI]
  CMP   DL, 91H
  JE    STRIKE
  CMP   DL, 88H
  JE    BLACK
  CMP   DL, 93H
  JE    BLACK_STRIKE
  CMP   DL, 186
  JE    CURSOR_POINT
  JNE   CONT
RETURN_LOAD:
  RET

OUTPUT_EXT ENDP

;----------------------------------------------------------------PLAY GAME
PLAY_GAME PROC NEAR
  MOV POSX, 36
  MOV POSY, 0

  CALL CLEAR_SCREEN0
  CALL SET_CURSOR
  CALL PLAY_ONE
  
RET
PLAY_GAME ENDP
;-------------------------------------------------------------------

;-----------------------------------------------------------------------------LEVEL 1
PLAY_ONE PROC NEAR
  ;open level1
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME4
  INT 21H
  JC DISPLAY_ERROR1_4
  MOV FILEHANDLE4, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE4
  MOV CX, 50  
  LEA DX, LEVEL1
  INT 21H
  JC DISPLAY_ERROR2_4
  CMP AX, 00 
  JE DISPLAY_ERROR3_4

  LEA SI, LEVEL1
  LEA DI, HOLDER
  CALL EXTRACT

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE4
  INT 21H

  JMP HERE_4

DISPLAY_ERROR1_4:
  LEA DX, ERROR1_STR4
  MOV AH, 09
  INT 21H

  JMP EXIT2_4

DISPLAY_ERROR2_4:
  LEA DX, ERROR2_STR4
  MOV AH, 09
  INT 21H

  JMP EXIT2_4

DISPLAY_ERROR3_4:
  LEA DX, ERROR3_STR4
  MOV AH, 09
  INT 21H

EXIT2_4:
  MOV AH, 4CH
  INT 21H

 HERE_4:

RET
PLAY_ONE ENDP

;-------------------------------------------------- EXTRACT
EXTRACT PROC NEAR
  MOV CX, 5
  MOV BX, 7

  RUN:

    CMP BX, 0
    JE JUMP

    CMP CX, 1
    JE PRINT0
    JNE CONT5

    PRINT0:
      CALL SET_CURSOR
      PUSH SI

      CALL START_MOVE

      JMP RESET

    RESET:
      POP SI
      MOV DI, 0
      LEA DI, HOLDER
      MOV CX, 6
      INC SI
      INC SI
      INC POSY
      DEC BX

      JMP HERE_5

    CONT5: 
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI

    JMP HERE_5

    HERE_5:
 
    LOOP RUN

  JUMP:
RET
EXTRACT ENDP

;-------------------------------------------------- START MOVE
START_MOVE PROC NEAR

  PLAY:
      CALL CLEAR_SCREEN0
      
      LEA DX, HOLDER
      MOV AH, 09
      INT 21H
      CALL SET_CURSOR
      CALL DELAY

      CALL GET_KEY

      CMP POSY, 24
      JE SETPOSY
      JNE CONT3

      SETPOSY:
        MOV POSY, 0
        JMP CONT4

      CONT3:
      INC POSY

      JMP PLAY
  CONT4:
RET
START_MOVE ENDP
;--------------------------------------------------------DELAY
DELAY PROC NEAR
      MOV BP, 3 ;lower value faster
      MOV SI, 3 ;lower value faster
    DELAY2:
      DEC BP
      NOP
      JNZ DELAY2
      DEC SI
      CMP SI,0
      JNZ DELAY2
      RET
DELAY ENDP

GET_KEY  PROC  NEAR
      MOV   AH, 01H
      INT   16H

      JZ    LEAVETHIS

      MOV   AH, 00H 
      INT   16H

      MOV   NEW_INPUT, AH

  LEAVETHIS:
      RET
GET_KEY  ENDP

END MAIN