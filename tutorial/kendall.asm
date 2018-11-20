; Kendall Molas
; CSc 211
.MODEL SMALL
.STACK 100h 
.CODE

assume cs:cseg, ds:cseg
cseg segment

START:

    ; Push Video into ES
    mov ax, 0b800h
    mov es, ax

    ; Clear Screen
    mov ah, 0
    mov al, 03 
    int 10h
    
    ; 30 x 58?60 board
    mov BYTE PTR es:[0], 201 ; Top Left
    mov BYTE PTR es:[60], 187 ; Top Right
    mov BYTE PTR es:[1600], 200; Bottom Left
    mov BYTE PTR es:[1660], 188; Bottom Right

    mov di,2 

    ; Top Border
    l1:
        mov BYTE PTR es:[di], 205 
        add di, 2 
        cmp di, 60
		je fix_di_l1
        loop l1

    fix_di_l1:
        mov di, 160

    ; Left Border
	l2:
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1600
        jnb fix_di_l2
        loop l2

    fix_di_l2:
        mov di, 1602

    ; Bottom Border
    l3:
		mov BYTE PTR es:[di], 205
        add di, 2
        cmp di, 1660
        jnb fix_di_l3
        loop l3

    fix_di_l3:
        mov di, 220

    ; Right Border
    l4:
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1620
        jnb continuing2; debugging purposes
        loop l4

    ; Main Region of Code
    continuing2:
        mov byte ptr es:[162], 42 ;bomb
        ;mov BYTE PTR es:[166], 205 ;placement

        xor di, di
        mov di, 4 

        mov ax, 60 ; This does tho, USE AX

    ; Create the | at the top border
    top_columns:
        mov BYTE PTR es:[di], 194
        add di, 4 
        cmp di, ax
        jnb set_columns
        loop top_columns 

    set_columns:
        xor di, di
        mov di, 1604
        xor ax,ax
        mov ax, 1660

    bot_columns:
        mov BYTE PTR es:[di], 193
        add di, 4
        cmp di, ax
        jnb fix_di_col
        loop bot_columns


    fix_di_col:
        xor di, di
        mov di, 320
        xor ax, ax
        mov ax, 378

    ; Fix DI so it will start at next row
    begin_column_di:
        add di, 2
        jmp build_row

    repeat_cycle_row:
        add di, 264
        add ax, 320
        cmp ax, 1658
        ;jnb wait_for_f8
        jnb ending
        jmp build_row

    build_row:
        mov BYTE PTR es:[di], 196
        add di, 2
        mov BYTE PTR es:[di], 197
        add di, 2
        cmp di, ax
        jnb end_column_di
        loop build_row

    ; Bottom row before bottom edge board
    end_column_di:
        mov BYTE PTR es:[di], 196
        cmp ax, 1658
        jna repeat_cycle_row

    ending:
        mov BYTE PTR es:[164], 179
        jmp wait_for_f8

    build_columns:


    ; Get keystroke
    ; Add cursor pos here
    wait_for_f8:
        mov ah, 00
        int 16h
        cmp ah, 42h
        jne wait_for_f8

    ; DONE
    ; Exit game
    done:
        mov ah, 0
        mov al, 03 
        int 10h
        mov al, 0
        mov ah, 4ch
        int 21h

    cseg ends

END START
