                                                                                                    
.MODEL SMALL
.STACK 64
.DATA       
    titleString DB 'Project Assembly Final', 13, 10, '$'  

    inputString DB 100 DUP('$')    
    promptInput DB 'Enter a string with at least 10 characters: $'
    promptOptions DB 10, 13, 'Choose an option:', 10, 13
    DB '1. Convert all the characters to lower case (s)', 10, 13
    DB '2. Convert all the characters to uppet case (a)', 10, 13
    DB '3. Print the string in the center of the page (c)', 10, 13
    DB '4. Upper-left corner (ul)', 10, 13
    DB '5. Upper-right corner (ur)', 10, 13
    DB '6. Lower-left corner (ll)', 10, 13
    DB '7. Lower-right corner (lr)', 10, 13
    DB '8. Replace Neumaric numbers with "X" (x)', 10, 13
    DB '9. Exit (ESC)', '$'
    newline DB 13, 10, '$'         

    errorMsg DB 'Error please Input must be at least 10 characters.$'
    exitMsg DB 'Terminate the program...$' 
    
    commandBuffer DB 3               
                  DB ?       ;unknown      
                  DB 3 DUP('$')     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

.CODE
Begin PROC FAR
    MOV AX, @DATA
    MOV DS, AX

INPUT_STRING:
    MOV DX, OFFSET promptInput
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET inputString
    MOV AH, 0AH         
    INT 21H

    ; this for "asks the user to input a string with at least 10 characters "
    MOV AL, inputString+1   ;  the length of the input string
    CMP AL, 10
    JL ERROR

    MOV BL, AL              
    ADD BL, 2                
    MOV SI, OFFSET inputString    
    MOV [SI + BX], '$'       

 Options:
    ; Display  options menu
    MOV DX, OFFSET promptOptions
    MOV AH, 09H
    INT 21H

   
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    ; take  the choice 
    MOV DX, OFFSET commandBuffer
    MOV AH, 0AH                
    INT 21H

    ;  lowercase 
    MOV AL, commandBuffer+2
    CMP AL, 's'
    JE LowerCase

    ; uppercase 
    CMP AL, 'a'
    JE Uppercase

    ; Center  
    CMP AL, 'c'
    JE centerrText

    ;  upper left 
    MOV AX, WORD PTR [commandBuffer+2] 
    CMP AX, 'u' + 'l' * 256
    JE corner_ul

    ;  upper right 
    CMP AX, 'u' + 'r' * 256
    JE corner_UR

    ;  lower left 
    CMP AX, 'l' + 'l' * 256
    JE corner_LL

    ; lower right 
    CMP AX, 'l' + 'r' * 256
    JE  corner_LR

    ; Replace  with X
    MOV AL, commandBuffer+2
    CMP AL, 'x'
    JE replaceNeumaricNumberwithx

    ; Exit (ESC)
    CMP AL, 27               
    JE EXITT

    JMP Options


ERROR:
    ;  error message if input is less than 10 characters
    MOV DX, OFFSET errorMsg
    MOV AH, 09H
    INT 21H
    JMP INPUT_STRING 
Begin ENDP
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LowerCase PROC NEAR
    ; Convert  to lowercase
    MOV SI, OFFSET inputString + 2
    CALL converttoLowercase
    
    MOV AL, inputString+1         
    MOV BL, AL
    ADD BL, 2                     
    MOV SI, OFFSET inputString
    MOV [SI + BX], '$'            

    MOV DX, OFFSET inputString + 2
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
LowerCase ENDP

Uppercase PROC NEAR
    ; Convert  to uppercase
    MOV SI, OFFSET inputString + 2
    CALL convertToUPPERcase  
    
    MOV AL, inputString+1         ;  length of  input
    MOV BL, AL
    ADD BL, 2                     
    MOV SI, OFFSET inputString
    MOV [SI + BX], '$'            ; Set the last character as $

    ; Display the new string of output
    MOV DX, OFFSET inputString + 2
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
Uppercase ENDP

centerrText PROC NEAR
    CALL setCursorc 
    
    MOV DX, OFFSET inputString + 2 
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    
    JMP Options
centerrText ENDP

corner_ul PROC NEAR
    MOV DH, 0               ; Row 0 
    MOV DL, 0               ; Column 0 
    MOV AH, 02H
    INT 10H
    
    MOV DX, OFFSET inputString + 2
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H
    
    JMP Options
corner_ul ENDP

corner_UR PROC NEAR
    MOV DH, 0
    MOV DL, 79              
    MOV AH, 02H
    INT 10H
    MOV DX, OFFSET inputString + 2
    MOV AH, 09H
    INT 21H

    
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
corner_UR ENDP

corner_LL PROC NEAR
    
    MOV DH, 24              
    MOV DL, 0               
    MOV AH, 02H
    INT 10H                 

    MOV DX, OFFSET inputString + 2 
    MOV AH, 09H
    INT 21H                 

    
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
corner_LL ENDP

corner_LR PROC NEAR
    
    MOV DH, 24              ; Row 24 
    
    
    MOV AL, inputString+1   
    MOV BL, AL              
    SUB BL, 1               
    MOV DL, 79
    SUB DL, BL              
    
    MOV AH, 02H
    INT 10H                 

    MOV DX, OFFSET inputString + 2 
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
corner_LR ENDP



replaceNeumaricNumberwithx PROC NEAR
    ; Replace numbers with 'X'
    MOV SI, OFFSET inputString + 2
REPLACE_LOOP:
    LODSB
    CMP AL, '0'
    JB SKIP_REPLACE
    CMP AL, '9'
    JA SKIP_REPLACE
    MOV AL, 'X'
SKIP_REPLACE:
    MOV [SI-1], AL
    CMP AL, '$'
    JNZ REPLACE_LOOP

    
    MOV AL, inputString+1         
    MOV BL, AL
    ADD BL, 2                     
    MOV SI, OFFSET inputString
    MOV [SI + BX], '$'            

    ; Display the outpue 
    MOV DX, OFFSET inputString + 2
    MOV AH, 09H
    INT 21H

    
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    JMP Options
replaceNeumaricNumberwithx ENDP

EXITT PROC NEAR
    MOV DX, OFFSET exitMsg
    MOV AH, 09H
    INT 21H
    MOV AH, 4CH             
    INT 21H
EXITT ENDP

converttoLowercase PROC NEAR
LOWER_LOOP:
    LODSB
    CMP AL, 'A'
    JB LOWER_SKIP
    CMP AL, 'Z'
    JA LOWER_SKIP
    ADD AL, 32              
LOWER_SKIP:
    MOV [SI-1], AL
    CMP AL, '$'
    JNZ LOWER_LOOP
    RET
converttoLowercase ENDP

convertToUPPERcase PROC NEAR
UPPER_LOOP:
    LODSB
    CMP AL, 'a'
    JB UPPER_SKIP
    CMP AL, 'z'
    JA UPPER_SKIP
    SUB AL, 32              
UPPER_SKIP:
    MOV [SI-1], AL
    CMP AL, '$'
    JNZ UPPER_LOOP          
    RET
convertToUPPERcase ENDP


setCursorc PROC NEAR
    MOV AL, inputString+1   
    MOV CL, AL              
    SHR CL, 1               
    MOV DH, 12              
    MOV DL, 40              
    SUB DL, CL              
    MOV AH, 02H
    INT 10H                 
    RET
setCursorc ENDP

END Begin   

