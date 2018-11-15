; Kendall Molas
; CSc 211
.MODEL SMALL
.STACK 10h 
.CODE

assume cs:cseg, ds:cseg
cseg segment

START:

    ; Push Video into ES
    mov ax, 0b800h
    mov es, ax

    ; Clear Screen
    ;mov ah, 0
    ;int 10h
    
    ; 30 x 58?60 board
    mov BYTE PTR es:[2], 201 ; Top Left
    mov BYTE PTR es:[60], 187 ; Top Right
    mov BYTE PTR es:[1762], 200; Bottom Left
    mov BYTE PTR es:[1820], 188; Bottom Right

    mov di,4 

    ; Top Border
    l1:
        mov BYTE PTR es:[di], 205 
        add di, 2 
        cmp di, 60
		je fix_di_l1
        loop l1

    fix_di_l1:
        mov di, 162

    ;mov BYTE PTR es:[484], 186
    ;mov BYTE PTR es:[487], 071h

    ; Left Border
	l2:
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1620
        jnb fix_di_l2
        loop l2

    fix_di_l2:
        mov di, 1764

    ; Bottom Border
    l3:
		mov BYTE PTR es:[di], 205
        add di, 2
        cmp di, 1820
        jnb fix_di_l3
        loop l3

    fix_di_l3:
        mov di, 220

    ; Right Border
    l4:
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1820
        jnb wait_for_f8
        loop l4

    ; Get keystroke
    wait_for_f8:
        mov ah, 00
        int 16h
        cmp ah, 42h
        jne wait_for_f8

    ; DONE
    done:
        mov al, 0
        mov ah, 4ch
        int 21h

    cseg ends

END START
