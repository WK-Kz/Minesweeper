ASSUME cs:cseg, ds:cseg

cseg segment

org 100h
start:
    mov ax, 0B800h
    mov es,ax
    mov BYTE PTR ES:[0], 'a'
    INT 20h

cseg ends

end start
