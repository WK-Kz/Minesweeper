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
    mov ah, 0
    mov al, 03 
    int 10h
    
    ; 30 x 58?60 board
    mov BYTE PTR es:[0], 201 ; Top Left
    mov BYTE PTR es:[60], 187 ; Top Right
    mov BYTE PTR es:[1760], 200; Bottom Left
    mov BYTE PTR es:[1820], 188; Bottom Right

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
        cmp di, 1620
        jnb fix_di_l2
        loop l2

    fix_di_l2:
        mov di, 1762

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
        jnb continuing2; debugging purposes
        loop l4

    ;mov BYTE PTR es:[484], 186
    ;mov BYTE PTR es:[487], 071h

    continuing1:
        mov BYTE PTR es:[4], 194 ;6 is top border
        mov BYTE PTR es:[6], 194 ;6 is top border
        mov BYTE PTR es:[10], 194
        mov BYTE PTR es:[14], 194
        mov BYTE PTR es:[18], 194

        ;mov BYTE PTR es:[166], 124
        ;mov BYTE PTR es:[], 95
        mov BYTE PTR es:[166], 179
        mov byte ptr es:[162], 42 ;bomb
        ;mov BYTE PTR es:[166], 205
        ;mov BYTE PTR es:[164], 205

        mov BYTE PTR es:[322], 196 ; -
        mov BYTE PTR es:[324], 196 ; -
        mov BYTE PTR es:[326], 197 ; |
        mov BYTE PTR es:[328], 196
        mov BYTE PTR es:[330], 197
        jmp wait_for_f8

    ;push ax, 58

    continuing2:
        mov byte ptr es:[162], 42 ;bomb
        ;mov BYTE PTR es:[166], 205
        xor cx, cx
        mov cx, 68

        sub di, di
        mov di, 4 

        mov ax, 194

        jmp top_columns


    top_columns:
        mov BYTE PTR es:[di], 194
        add di, 4
        cmp di, cx
        jnb begin_column_di
        loop top_columns 

    begin_column_di:
        sub di, di
        add di, 322
        sub cx, cx
        add cx, 388
        ;mov BYTE PTR es:[di], 196
        ;add di, 2
        ;mov BYTE PTR es:[58], 186 ; Top Right

    build_row:
        mov BYTE PTR es:[di], 196
        add di, 2
        mov BYTE PTR es:[di], 197
        add di, 2
        cmp di, cx
        jnb end_column_di
        loop build_row

    end_column_di:
        mov BYTE PTR es:[di], 196
        



    ; Get keystroke
    wait_for_f8:
        mov ah, 00
        int 16h
        cmp ah, 42h
        jne wait_for_f8

    ; DONE
    done:
        mov ah, 0
        mov al, 03 
        int 10h
        mov al, 0
        mov ah, 4ch
        int 21h

    cseg ends

END START
