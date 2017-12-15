TITLE ASM1 (SIMPLIFIED .EXE )
.MODEL SMALL
.STACK 300
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

  PATHFILENAME5  DB 'notcatch.txt', 00H
  FILEHANDLE5    DW ?

  PATHFILENAME6  DB 'gameover.txt', 00H
  FILEHANDLE6    DW ?

  PAGE1 DB 2000 DUP('$'), '$'
  PAGE2 DB 3000 DUP('$'), '$'
  PAGE3 DB 2000 DUP('$'), '$'
  NEWPAGE DW 2000 DUP('$')
  OVER DW 2000 DUP('$')

  LEVEL1 DB 500 DUP('$'), '$'
  HOLDER DB 500 DUP('$'), '$'
  PLAYER_INPUT DB 50 DUP('$'), '$'
  UNCATCH DB 100 DUP('$'), '$'



  P1 DB ? ,  "$"
  P2 DB ? ,  "$"
  P3 DB ? ,  "$"
  
  INVALID  DB 'WRONG INPUT ---->  $'
  CHOICE1  DB 'spacebar : continue$'
  CHOICE2  DB '    esc  : Main Menu$'
  VALID    DB 'CORRECT INPUT ---->  $'
  LIFE_IS_TWO   DB 'You have 2 lives left. $'
  LIFE_IS_ONE   DB 'You have 1 life left. $'

  INVALID1  DB 'Was not able to catch word.$'
  INVALID2  DB 'WRONG INPUT$'

  ERROR1_STR    DB 'Error in opening file.$'
  ERROR2_STR    DB 'Error reading from file.$'
  ERROR3_STR    DB 'No record read from file.$'

  POSX DB ?
  POSY DB ?
  BEEPCX DW ?
  BEEPBX DW ?
  NEW_INPUT DB ?

  FLAG1 DB 'N','$'
  LIFE1 DB 'N','$'
  LIFE2 DB 'N','$'

  FLAG2 DB '0','$'

;---------------------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX

  MOV POSX, 0
  MOV POSY, 0
  MOV FLAG1, 'N'
  MOV LIFE1, 'N'
  MOV LIFE2, 'N'

;----------------------------------------------display main menu
  CALL CLEAR_SCREEN0                            
  CALL CLEAR_SCREEN1
  CALL SET_CURSOR
  CALL DISPLAY1                               ;diplays home screen
  
  MOV AH, 09
  INT 21H

  MOV AH, 10H                                 ;ask choice from user /reads character
  INT 16H
  MOV P1, AL                                  ;store character to AL

  CMP AL, 49                                  ;if AL is 1, Play game
  JE Play_1

  CMP AL, 50                                  ;if AL is 2, display instuction screen
  JE Ins_2

  CMP AL, 51                                  ;terminate game
  JE EXIT
  JNE Main_3

  Play_1:                                     ;Play game logic starts
    CALL CLEAR_SCREEN0
    CALL CLEAR_SCREEN1
    CALL CLEAR_SCREEN3
    MOV POSX, 00
    MOV POSY, 00
    CALL SET_CURSOR
    CALL DISPLAY3                             ;display "Ready" screen

    MOV AH, 09
    INT 21H

    MOV AH, 10H                               ;ask user to contunue and start play or back to main menu/read char
    INT 16H
    MOV P1, AL                                ;store char to AL

    CMP AL, 32                                ;if AL is space, game officially starts
    JE Ready_Play

    CMP AL, 49                                ;if AL is 1, back to main menu
    JE Main_3

    JNE Play_1                                ;if input is not space or 1, remain same page

    JMP EXIT

  Ins_2:                                      ;instruction page start load
    CALL CLEAR_SCREEN0
    CALL CLEAR_SCREEN2
    MOV   DL, 00
    MOV   DH, 00
    CALL SET_CURSOR
    CALL DISPLAY2                             ;display contents to screen (interface)

    MOV AH, 09
    INT 21H

    MOV AH, 10H                               ;ask user to enter char/option to do next
    INT 16H
    MOV P1, AL                                ;store char to AL

    CMP AL, 49                                ;if AL is 1, continue and play
    JE Play_1

    CMP AL, 50                                ;if al is 2, back to main menu
    JE Main_3

    CMP AL, 51                                ;if al is 3, terminate program
    JE EXIT
    JNE Ins_2

    JMP EXIT

  Main_3:
   CALL MAIN

  Ready_Play:                                 ;call ready screen to officially start game
    CALL PLAY_GAME

  EXIT:
  MOV AH, 4CH
  INT 21H

MAIN ENDP

;------------------------------------------------------------------CLEAR_SCREEN1
CLEAR_SCREEN1 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 8BH                                 ;black background (8 - blinking), light aqua foreground (B)
  MOV CX, 0000H                               ;upper left row:column (0:0)
  MOV DX, 104FH                               ;lower right row:column (16:79)
  INT 10H

  RET
CLEAR_SCREEN1 ENDP

;------------------------------------------------------------------CLEAR_SCREEN0
CLEAR_SCREEN0 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 09H                                 ;black background (0), blue foreground (9)
  MOV CX, 0000H                               ;upper left row:column (0:0)
  MOV DX, 184FH                               ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN0 ENDP

;------------------------------------------------------------------CLEAR_SCREEN2
CLEAR_SCREEN2 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 8AH                                 ;dark gray background (8), light green foreground (A)
  MOV CX, 0505H                               ;upper left row:column (05:05)
  MOV DX, 104DH                               ;lower right row:column (9:76)
  INT 10H

  RET
CLEAR_SCREEN2 ENDP

;------------------------------------------------------------------CLEAR_SCREEN3
CLEAR_SCREEN3 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 8AH                                 ;dark gray background (8), light green foreground (A)
  MOV CX, 1010H                               ;upper left row:column (0:0)
  MOV DX, 174CH                               ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN3 ENDP

;------------------------------------------------------------------CLEAR_SCREEN4
CLEAR_SCREEN4 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 84H                                 ;dark gray background (8), red foreground (4)
  MOV CX, 0505H                               ;upper left row:column (0:0)
  MOV DX, 104DH                               ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN4 ENDP

;------------------------------------------------------------------CLEAR_SCREEN5
CLEAR_SCREEN5 PROC NEAR
  MOV AX, 0600H                               ;full screen
  MOV BH, 84H                                 ;dark gray background (8), red foreground (4)
  MOV CX, 0000H                               ;upper left row:column (0:0)
  MOV DX, 184DH                               ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN5 ENDP
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
DISPLAY1 PROC NEAR                            ;read text file containing interface design
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

  LEA SI, PAGE1                                 ;store string to PAGE1
  CALL OUTPUT_EXT                               ;parse each character from string incase of extended special characters

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE
  INT 21H

  JMP HERE

DISPLAY_ERROR1:                                  ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2

DISPLAY_ERROR2:                                  ;error handling for text file
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2

DISPLAY_ERROR3:                                  ;error handling for text file     
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
DISPLAY2 PROC NEAR                                ;read text file containing interface design
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

  LEA SI, PAGE2                                     ;store string to PAGE2
  CALL OUTPUT_EXT                                   ;parse each character from string incase of extended special characters

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE2
  INT 21H

  JMP HERE_2

DISPLAY_ERROR1_2:                                   ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_2

DISPLAY_ERROR2_2:                                   ;error handling for text file
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_2

DISPLAY_ERROR3_2:                                   ;error handling for text file
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT2_2:
  MOV AH, 4CH
  INT 21H

 HERE_2:

RET
DISPLAY2 ENDP

;-----------------------------------------------------------------------PAGE 3 (Ready Play)
DISPLAY3 PROC NEAR                                  ;read text file containing interface design
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

  LEA SI, PAGE3                                       ;store string to PAGE3
  CALL OUTPUT_EXT                                     ;parse each character from string incase of extended special characters

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE3
  INT 21H

  JMP HERE_3

DISPLAY_ERROR1_3:                                     ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_3

DISPLAY_ERROR2_3:                                     ;error handling for text file
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_3

DISPLAY_ERROR3_3:                                     ;error handling for text file
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT2_3:
  MOV AH, 4CH
  INT 21H

 HERE_3:

RET
DISPLAY3 ENDP

;-----------------------------------------------------------------------Diplay 4, was not able to catch word
DISPLAY4 PROC NEAR                                     ;read text file containing interface design

  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH SI
  PUSH DI

  ;open page5
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME5
  INT 21H
  JC DISPLAY_ERROR1_5
  MOV FILEHANDLE5, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE5
  MOV CX, 100  
  LEA DX, UNCATCH
  INT 21H
  JC DISPLAY_ERROR2_5
  CMP AX, 00 
  JE DISPLAY_ERROR3_5

  LEA SI, UNCATCH                                         ;store string to PAGE4
  CALL OUTPUT_EXT                                         ;parse each character from string incase of extended special characters

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE5
  INT 21H

  JMP HERE_05

DISPLAY_ERROR1_5:                                         ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_5

DISPLAY_ERROR2_5:                                         ;error handling for text file
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_5

DISPLAY_ERROR3_5:                                          ;error handling for text file   
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT2_5:
  MOV AH, 4CH
  INT 21H

 HERE_05:
 POP DI
 POP SI
 POP DX
 POP CX
 POP BX
 POP AX


RET
DISPLAY4 ENDP

;-----------------------------------------------------------------------GAME OVER
DISPLAY5 PROC NEAR                                       ;read text file containing interface design
  ;open page3
  MOV AH, 3DH 
  MOV AL, 00  
  LEA DX, PATHFILENAME6
  INT 21H
  JC DISPLAY_ERROR1_6
  MOV FILEHANDLE6, AX

  ;read file
  MOV AH, 3FH
  MOV BX, FILEHANDLE6
  MOV CX, 2000  
  LEA DX, OVER
  INT 21H
  JC DISPLAY_ERROR2_6
  CMP AX, 00 
  JE DISPLAY_ERROR3_6

  LEA SI, OVER                                           ;store string to OVER
  CALL OUTPUT_EXT                                        ;parse each character from string incase of extended special characters

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE6
  INT 21H

  JMP HERE_006

DISPLAY_ERROR1_6:                                         ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_6

DISPLAY_ERROR2_6:                                         ;error handling for text file  
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_6

DISPLAY_ERROR3_6:                                          ;error handling for text file 
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT2_6:
  MOV AH, 4CH
  INT 21H

 HERE_006:

RET
DISPLAY5 ENDP
;----------------------------------------------------------------OUTPUT_EXT
OUTPUT_EXT PROC NEAR                                        ;parse extended characters
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
PLAY_GAME PROC NEAR                                           ;call to start game
  MOV POSX, 36
  MOV POSY, 0

  CALL CLEAR_SCREEN0
  CALL SET_CURSOR
  CALL PLAY_ONE                                               ;get words from file
  
RET
PLAY_GAME ENDP

;-----------------------------------------------------------------------------LEVEL 1
PLAY_ONE PROC NEAR                                           ;read file containing the words
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
  MOV CX, 500  
  LEA DX, LEVEL1                                              ;store string of words to LEVEL1
  INT 21H
  JC DISPLAY_ERROR2_4
  CMP AX, 00 
  JE DISPLAY_ERROR3_4

  LEA SI, LEVEL1                                              ;set source to string LEVEL1                                  
  LEA DI, HOLDER                                              ;set destination to string HOLDER   (mpty string)
  CALL EXTRACT                                                ;call to parse the string of words into single words (get each word)

  ;close file handle
  MOV AH, 3EH
  MOV BX, FILEHANDLE4
  INT 21H

  JMP HERE_4

DISPLAY_ERROR1_4:                                             ;error handling for text file
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_4

DISPLAY_ERROR2_4:                                             ;error handling for text file
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT2_4

DISPLAY_ERROR3_4:                                             ;error handling for text file  
  LEA DX, ERROR3_STR
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
  MOV CX, 5                                                    ;set cx to the number of letters the words in level 1 of the game
  MOV BX, 7                                                    ;set bx to the number of words that must go out for level 1

  RUN:
    MOV POSX, 36                                                ;set x position of cursor
    CMP BX, 0                                                   ;if bx = 0, mean the number of words in level 1 are completely typed
    JE JUMP_LEVEL2                                              ;move to level 2 if done in level 1

    CMP CX, 1                                                   ;if cx is 1, meaning the parsing of each word is done
    JE PRINT0                                                   ;if yes, continue and make words move
    JNE CONT5                                                   ;if no, continue parsing 

    PRINT0:                                                     ;print the extracted word
      CALL SET_CURSOR
      PUSH SI                                                   ;push si to stack to retain value of SI incase it will be used for other procedures
      PUSH BX                                                   ;push bx to stack to retain value of SI incase it will be used for other procedures
      PUSH DI                                                   ;push si to stack to retain value of SI incase it will be used for other procedures
      MOV AL, '$'                                                      
      MOV [DI], AL                                              ;set the end of word as $ for the next conditions                                                 
      CALL START_MOVE                                           ;make word move procedure

      JMP RESET                                                 ;reset the pointers and index that needs to be reset to parse the next word and storage

    RESET:
      POP DI                                                    ;pop original value of di
      POP BX                                                    ;pop original value of di
      POP SI                                                    ;pop original value of di
      MOV DI, 0                                                 ;set di to 0 again, for the new parsed word
      LEA DI, HOLDER                                            ;set di to same word holder
      MOV CX, 6                                                 ;loop index for the next word
      INC SI                                                    ;INC SI to skip $
      INC SI                                                    ;INC SI gain to skip newline
      INC POSY                                                  ;inrement position of y for movement
      DEC BX                                                    ;decrement bx to determine the number of words being extracted

      JMP HERE_5

    CONT5:                                                             
    MOV AL, [SI]                                                ;get character in [si]
    MOV [DI], AL                                                ;copy it to index for HOLDER string
    INC SI                                                      ;increment index of string 
    INC DI                                                      ;increment index of holder string

    JMP HERE_5

    HERE_5:
 
    LOOP RUN
  ;-------------------------------------------------------------------LEVEL2
  JUMP_LEVEL2:

  MOV CX, 7                                                      ;same will happen to level 2(same with level 1) except the value of cx is 7, meaning, the word for level 2 has 6 letters
  MOV BX, 7                                                      ;7 words for level2
  
  MOV DI, 0
  LEA DI, HOLDER
  MOV POSY, 0
  MOV POSX, 35

  RUN2:
    MOV POSX, 35
    CMP BX, 0
    JE JUMP_LEVEL3

    CMP CX, 1
    JE PRINT00
    JNE CONT_06

    PRINT00:
      CALL SET_CURSOR
      PUSH SI
      PUSH BX
      PUSH DI
      MOV AL, '$'
      MOV [DI], AL
      CALL START_MOVE

      JMP RESET2

    RESET2:
      POP DI
      POP BX
      POP SI
      MOV DI, 0
      LEA DI, HOLDER
      MOV CX, 8
      INC SI
      INC SI
      INC POSY
      DEC BX

      JMP HERE_06

    CONT_06:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI

    JMP HERE_06

    HERE_06:
 
    LOOP RUN2
;--------------------------------------------------------------------------------LEVEL3
    JUMP_LEVEL3:

    MOV CX, 9                                                   ;same will happen to level 3(same with level 1) except the value of cx is 9, meaning, the word for level 2 has 8 letters
    MOV BX, 7                                                   ;7 words for level3
    
    MOV DI, 0
    LEA DI, HOLDER
    MOV POSY, 0
    MOV POSX, 35

    RUN3:
      MOV POSX, 35
      CMP BX, 0
      JE JUMP_LEVEL4

      CMP CX, 1
      JE PRINT000
      JNE CONT_07

      PRINT000:
        CALL SET_CURSOR
        PUSH SI
        PUSH BX
        PUSH DI
        MOV AL, '$'
        MOV [DI], AL
        CALL START_MOVE

        JMP RESET3

      RESET3:
        POP DI
        POP BX
        POP SI
        MOV DI, 0
        LEA DI, HOLDER
        MOV CX, 10
        INC SI
        INC SI
        INC POSY
        DEC BX

        JMP HERE_07

      CONT_07:
      MOV AL, [SI]
      MOV [DI], AL
      INC SI
      INC DI

      JMP HERE_07

      HERE_07:
   
      LOOP RUN3
;-------------------------------------------------------------------------LEVEL4
      JUMP_LEVEL4:                                              

      MOV CX, 11                                                    ;same will happen to level 3(same with level 1) except the value of cx is 9, meaning, the word for level 2 has 10 letters      
      MOV BX, 7
      
      MOV DI, 0
      LEA DI, HOLDER
      MOV POSY, 0
      MOV POSX, 34

      RUN4:
        MOV POSX, 34
        CMP BX, 0
        JE JUMP

        CMP CX, 1
        JE PRINT0000
        JNE CONT_08

        PRINT0000:
          CALL SET_CURSOR
          PUSH SI
          
          PUSH BX
          PUSH DI
          MOV AL, '$'
          MOV [DI], AL
          CALL START_MOVE

          JMP RESET4

        RESET4:
          POP DI
          POP BX
          POP SI
          MOV DI, 0
          LEA DI, HOLDER
          MOV CX, 12
          INC SI
          INC SI
          INC POSY
          DEC BX

          JMP HERE_08

        CONT_08:
        MOV AL, [SI]
        MOV [DI], AL
        INC SI
        INC DI

        JMP HERE_08

        HERE_08:
     
        LOOP RUN4

  JUMP:
RET
EXTRACT ENDP

;------------------------------------------------------------------ START MOVE
START_MOVE PROC NEAR                                             ;this will start the movement of the words; falling from the top of the screen until the bottom 
  CALL SOUND
  MOV SI, 0
  MOV DI, 0
  LEA SI, PLAYER_INPUT                                           ;get the input from the user                                             
  MOV FLAG1, 'N'

  PLAY:
      CALL CLEAR_SCREEN0
      
      LEA DX, HOLDER                                             ;holds the words that are falling or needs to be typed correctly
      MOV AH, 09
      INT 21H
      CALL SET_CURSOR

      PUSH SI
      PUSH DI
      CALL DELAY
      CALL GET_KEY
      
      POP DI
      POP SI

      CMP AL, 00
      JE PADAYON2
      JNE ENTER

      ENTER:
      CMP AL, 13
      JE COMPARE_STRINGS
      JNE STORE2

      COMPARE_STRINGS:                                           ;compare if the input of the user is the same with the word displayed on the screen 
        CALL SOUND
        PUSH SI
        PUSH DI
        PUSH BX

        MOV SI, 0
        MOV DI, 0

        LEA SI, HOLDER
        LEA DI, PLAYER_INPUT

        CHECK:
          MOV BL, [SI]
          MOV BH, [DI]

          INC SI
          INC DI

          CMP BL, BH
          JNE CHECK_FIRST

          CMP BL, '$'
          JE YES

          JMP CHECK

          YES:
          CALL SOUND3
          POP BX
          POP DI
          POP SI
          MOV FLAG1, 'Y'
          MOV POSY, 25
          JMP PADAYON2

        STORE2:
          JMP STORE
        PADAYON2:
          JMP PADAYON

        CHECK_FIRST:

          CMP LIFE1, 'N'
          JE LIFE1_DEAD
          JNE CHECK_LIFE2

          LIFE1_DEAD:
            MOV LIFE1, 'K'
            JMP LIFE_LEFT2

          CHECK_LIFE2:
            CMP LIFE2, 'N'
            JE LIFE2_DEAD
            JNE EXXX

            EXXX:
            MOV POSX, 0
            MOV POSY, 0
            CALL SET_CURSOR
            CALL CLEAR_SCREEN0
            CALL CLEAR_SCREEN5
            CALL DISPLAY5

            MOV AH, 10H
            INT 16H
            MOV P2, AL

            CMP AL, 32
            JE YES_DONE
            JNE EXXX

            YES_DONE:
              CALL MAIN


          LIFE2_DEAD:
             MOV LIFE2, 'K'
             JMP LIFE_LEFT1

          LIFE_LEFT2:
            MOV POSY, 17
            MOV POSX, 28
            CALL SET_CURSOR

            MOV FLAG2, '2'
            JMP NO

          LIFE_LEFT1:
            MOV POSY, 17
            MOV POSX, 28
            CALL SET_CURSOR

            MOV FLAG2, '1'

            JMP NO

      JUMP_PLAY:
        JMP PLAY

          NO:

          CMP FLAG2, '1'
          JE PRINT_ONE
          JNE NEXT_STEP

          PRINT_ONE:
            LEA DX, LIFE_IS_ONE
            MOV AH, 09H
            INT 21H

            JMP GOGOGO

          NEXT_STEP:
          CMP FLAG2, '2'
          JE PRINT_TWO

          PRINT_TWO:
            LEA DX, LIFE_IS_TWO
            MOV AH, 09H
            INT 21H

            JMP GOGOGO
      NO2:
        JMP NO

          GOGOGO:

          CALL SOUND2
          MOV POSY, 8
          MOV POSX, 35
          CALL SET_CURSOR
          CALL CLEAR_SCREEN0
          CALL CLEAR_SCREEN4

          LEA DX, PLAYER_INPUT
          MOV AH, 09H
          INT 21H

          MOV POSY, 10
          MOV POSX, 32
          CALL SET_CURSOR

          LEA DX, INVALID2
          MOV AH, 09H
          INT 21H

          CALL DISPLAY4

          MOV POSY, 19
          CALL SET_CURSOR
          MOV AH, 10H
          INT 16H
          MOV P2, AL

          CMP AL, 32
          JE CONTINUE_MORE2
          JNE GO_BACK_MAIN2

          CONTINUE_MORE2:
          POP BX
          POP DI
          POP SI
          MOV POSY, 0
          JMP CONT40

          GO_BACK_MAIN2:
          CMP AL, 27
          JE CALL_MAIN2
          JNE NO2

          CALL_MAIN2:
            CALL MAIN


      STORE:
        MOV [SI], AL
        INC SI
        JMP PADAYON


      PADAYON:
      CMP POSY, 25
      JE SETPOSY
      JNE CONT30

      SETPOSY:
        CMP FLAG1, 'N'
        JE CHECK_FIRST2
        MOV POSY, 0
        JMP CONT40

        CHECK_FIRST2:
          MOV LIFE1, 'K'
          CALL SOUND2
          MOV POSY, 8
          MOV POSX, 26
          CALL SET_CURSOR
          CALL CLEAR_SCREEN0
          CALL CLEAR_SCREEN4


          LEA DX, INVALID1
          MOV AH, 09H
          INT 21H

          CALL DISPLAY4

          CMP LIFE1, 'N'
          JE LIFE1_DEAD2
          JNE CHECK_LIFE22

          LIFE1_DEAD2:
            MOV LIFE1, 'K'
            JMP LIFE_LEFT22

          CHECK_LIFE22:
            CMP LIFE2, 'N'
            JE LIFE2_DEAD2
            JNE EXXX2
    CONT30:
      JMP CONT3

          EXXX2:
          MOV POSX, 0
          MOV POSY, 0
          CALL SET_CURSOR
          CALL CLEAR_SCREEN0
          CALL CLEAR_SCREEN5
          CALL DISPLAY5

          MOV AH, 10H
          INT 16H
          MOV P2, AL

          CMP AL, 32
          JE YES_DONE2
          JNE EXXX2

          YES_DONE2:
            CALL MAIN


          LIFE2_DEAD2:
             MOV LIFE2, 'K'
             JMP LIFE_LEFT12

          LIFE_LEFT22:
            MOV POSY, 17
            MOV POSX, 28
            CALL SET_CURSOR

            MOV FLAG2, '1'

            JMP WOW

          LIFE_LEFT12:
            MOV POSY, 17
            MOV POSX, 26
            CALL SET_CURSOR

           MOV FLAG2, '1'

            JMP WOW

    CONT40:
      JMP CONT4

      WOW:

          CMP FLAG2, '1'
          JE PRINT_ONE2
          JNE NEXT_STEP2

          PRINT_ONE2:
            LEA DX, LIFE_IS_ONE
            MOV AH, 09H
            INT 21H

            JMP GOGOGO1

          NEXT_STEP2:
          CMP FLAG2, '2'
          JE PRINT_TWO2

          PRINT_TWO2:
            LEA DX, LIFE_IS_TWO
            MOV AH, 09H
            INT 21H

            JMP GOGOGO1

        GOGOGO1:

        MOV POSY, 18
        CALL SET_CURSOR
        MOV AH, 10H
        INT 16H
        MOV P2, AL

        CMP AL, 32
        JE CONTINUE_MORE
        JNE GO_BACK_MAIN

        CONTINUE_MORE:
        MOV POSY, 0
        JMP CONT4

        GO_BACK_MAIN:
        CMP AL, 27
        JE CALL_MAIN
        JNE WOW

        CALL_MAIN:
          CALL MAIN

      CONT3:
      INC POSY

      JMP JUMP_PLAY
  
  CONT4:
RET
START_MOVE ENDP
;--------------------------------------------------------DELAY
DELAY PROC NEAR                                               ;delay on the screen, how fast or how slow the movements are
      MOV BP, 3                                               ;lower value faster
      MOV SI, 3                                               ;lower value faster
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
;------------------------------------------------------------BEEP
SOUND   PROC                                         ;sound number 1  
  PUSH    AX
  PUSH    BX
  PUSH    CX
  PUSH    DX
  PUSH    DI
  
  MOV     DX,2000                                     ;number of times to repeat whole routine.

  MOV     BX,1                                        ;frequency value.

  MOV     AL, 10110110B                               ;the Magic Number (use this binary number only)
  OUT     43H, AL                                     ;send it to the initializing port 43H Timer 2.

  NEXT_FREQUENCY:                                     ;this is were we will jump back to 2000 times.

  MOV     AX, BX                                      ;move our Frequency value into AX.

  OUT     42H, AL                                     ;send LSB to port 42H.
  MOV     AL, AH                                      ;move MSB into AL  
  OUT     42H, AL                                     ;send MSB to port 42H.

  IN      AL, 61H                                     ;get current value of port 61H.
  OR      AL, 00000011B                               ;OR AL to this value, forcing first two bits high.
  OUT     61H, AL                                     ;copy it to port 61H of the PPI Chip
                                                      ;to turn ON the speaker.

  MOV     CX, 10                                      ;repeat loop 100 times
  DELAY_LOOP:                                         ;here is where we loop back too.
  LOOP    DELAY_LOOP                                  ;jump repeatedly to DELAY_LOOP until CX = 0


  INC     BX                                          ;incrementing the value of BX lowers 
                                                      ;the frequency each time we repeat the
                                                      ;whole routine

  DEC     DX                                          ;decrement repeat routine count

  CMP     DX, 0                                       ;is DX (repeat count) = to 0
  JNZ     NEXT_FREQUENCY                              ;if not jump to NEXT_FREQUENCY
                                                      ;and do whole routine again.

                                                      ;else DX = 0 time to turn speaker OFF

  IN      AL,61H                                      ;get current value of port 61H.
  AND     AL,11111100B                                ;AND AL to this value, forcing first two bits low.
  OUT     61H,AL                                      ;copy it to port 61H of the PPI Chip
                                                      ;to turn OFF the speaker.

  POP DI
  POP DX
  POP CX
  POP BX
  POP AX
  RET
SOUND   ENDP

;------------------------------------------------------------BEEP2
SOUND2   PROC                                         ;sound number 2
  PUSH    AX
  PUSH    BX
  PUSH    CX
  PUSH    DX
  PUSH    DI
  
  MOV     DX,2000                                     ; Number of times to repeat whole routine.

  MOV     BX,1                                        ; Frequency value.

  MOV     AL, 10110110B                               ; The Magic Number (use this binary number only)
  OUT     43H, AL                                     ; Send it to the initializing port 43H Timer 2.

  NEXT_FREQUENCY2:                                    ; This is were we will jump back to 2000 times.

  MOV     AX, BX                                      ; Move our Frequency value into AX.

  OUT     42H, AL                                     ; Send LSB to port 42H.
  MOV     AL, AH                                      ; Move MSB into AL  
  OUT     42H, AL                                     ; Send MSB to port 42H.

  IN      AL, 61H                                     ; Get current value of port 61H.
  OR      AL, 00000011B                               ; OR AL to this value, forcing first two bits high.
  OUT     61H, AL                                     ; Copy it to port 61H of the PPI Chip
                                                      ; to turn ON the speaker.

  MOV     CX, 300                                     ; Repeat loop 300 times
  DELAY_LOOP2:                                        ; Here is where we loop back too.
  LOOP    DELAY_LOOP2                                 ; Jump repeatedly to DELAY_LOOP until CX = 0


  INC     BX                                          ; Incrementing the value of BX lowers 
                                                      ; the frequency each time we repeat the
                                                      ; whole routine

  DEC     DX                                          ; Decrement repeat routine count

  CMP     DX, 0                                       ; Is DX (repeat count) = to 0
  JNZ     NEXT_FREQUENCY2                             ; If not jump to NEXT_FREQUENCY
                                                      ; and do whole routine again.

                                                      ; Else DX = 0 time to turn speaker OFF

  IN      AL,61H                                      ; Get current value of port 61H.
  AND     AL,11111100B                                ; AND AL to this value, forcing first two bits low.
  OUT     61H,AL                                      ; Copy it to port 61H of the PPI Chip
                                                      ; to turn OFF the speaker.

  POP DI
  POP DX
  POP CX
  POP BX
  POP AX
  RET
SOUND2   ENDP

;------------------------------------------------------------BEEP3
SOUND3   PROC
  PUSH    AX
  PUSH    BX
  PUSH    CX
  PUSH    DX
  PUSH    DI
  
  MOV     DX,2000                                     ; Number of times to repeat whole routine.

  MOV     BX,5                                        ; Frequency value.

  MOV     AL, 10110110B                               ; The Magic Number (use this binary number only)
  OUT     43H, AL                                     ; Send it to the initializing port 43H Timer 2.

  NEXT_FREQUENCY3:                                    ; This is were we will jump back to 2000 times.

  MOV     AX, BX                                      ; Move our Frequency value into AX.

  OUT     42H, AL                                     ; Send LSB to port 42H.
  MOV     AL, AH                                      ; Move MSB into AL  
  OUT     42H, AL                                     ; Send MSB to port 42H.

  IN      AL, 61H                                     ; Get current value of port 61H.
  OR      AL, 00000011B                               ; OR AL to this value, forcing first two bits high.
  OUT     61H, AL                                     ; Copy it to port 61H of the PPI Chip
                                                      ; to turn ON the speaker.

  MOV     CX, 100                                     ; Repeat loop 100 times
  DELAY_LOOP3:                                        ; Here is where we loop back too.
  LOOP    DELAY_LOOP3                                 ; Jump repeatedly to DELAY_LOOP until CX = 0


  INC     BX                                          ; Incrementing the value of BX lowers 
                                                      ; the frequency each time we repeat the
                                                      ; whole routine

  DEC     DX                                          ; Decrement repeat routine count

  CMP     DX, 0                                       ; Is DX (repeat count) = to 0
  JNZ     NEXT_FREQUENCY3                             ; If not jump to NEXT_FREQUENCY
                                                      ; and do whole routine again.

                                                      ; Else DX = 0 time to turn speaker OFF

  IN      AL,61H                                      ; Get current value of port 61H.
  AND     AL,11111100B                                ; AND AL to this value, forcing first two bits low.
  OUT     61H,AL                                      ; Copy it to port 61H of the PPI Chip
                                                      ; to turn OFF the speaker.

  POP DI
  POP DX
  POP CX
  POP BX
  POP AX
  RET
SOUND3   ENDP

END MAIN
