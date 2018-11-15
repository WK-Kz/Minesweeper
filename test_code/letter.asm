.MODEL SMALL
.STACK 200H
.CODE

start:

mov ch, 0
mov cl, 7
mov ah, 1
int 10h

MOV AH, 01h
int 21h

MOV AL, 21 
MOV AH, 4Ch
INT 21h

end start
