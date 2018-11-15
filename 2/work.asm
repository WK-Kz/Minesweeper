assume cs:cseg, ds:cseg

cseg segment

start:
    org 100h   ; COM file start at origin 100h

    mov ax, 0B800h
    ; move 0B800h into ax
    ; 0B800h is the address of VGA card for text mode
    mov ds, ax
    ; move AX into DS, so DS hold the address of VGA card

    mov cl, 'a'
    ; move char 'A' into CL
    mov ch, 01011111b
    ; move 01011111b (= 05Fh) into CH

    mov bx, 15eh
    ; move 015Eh into BX

    mov [bx], cx
    ; move the value from CX (one word) into the address pointed by DS:BX
cseg ends
end start
