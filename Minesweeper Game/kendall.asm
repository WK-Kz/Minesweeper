; Kendall Molas
; CSc 211
.MODEL SMALL
.STACK 100h 
.CODE
assume cs:cseg, ds:cseg
cseg segment

JUMPS

START:
    ; Push Video into ES
    mov ax, 0b800h
    mov es, ax

    ; Clear Screen
    mov ah, 0
    mov al, 03 
    int 10h

    ; Print Messages
    mov BYTE PTR es:[420], 'H'
    mov BYTE PTR es:[422], 'o'
    mov BYTE PTR es:[424], 'w'
    mov BYTE PTR es:[428], 't'
    mov BYTE PTR es:[430], 'o'
    mov BYTE PTR es:[434], 'p'
    mov BYTE PTR es:[436], 'l'
    mov BYTE PTR es:[438], 'a'
    mov BYTE PTR es:[440], 'y'
    mov BYTE PTR es:[442], ':'

    mov BYTE PTR es:[560], 'W'
    mov BYTE PTR es:[562], ':'
    mov BYTE PTR es:[566], 'U'
    mov BYTE PTR es:[568], 'P'

    mov BYTE PTR es:[584], 'R'
    mov BYTE PTR es:[586], ':'
    mov BYTE PTR es:[590], 'R'
    mov BYTE PTR es:[592], 'E'
    mov BYTE PTR es:[594], 'S'
    mov BYTE PTR es:[596], 'E'
    mov BYTE PTR es:[598], 'T'

    mov BYTE PTR es:[720], 'S'
    mov BYTE PTR es:[722], ':'
    mov BYTE PTR es:[726], 'D'
    mov BYTE PTR es:[728], 'O'
    mov BYTE PTR es:[730], 'W'
    mov BYTE PTR es:[732], 'N'

    mov BYTE PTR es:[744], 'F'
    mov BYTE PTR es:[746], '8'
    mov BYTE PTR es:[748], ':'
    mov BYTE PTR es:[752], 'Q'
    mov BYTE PTR es:[754], 'U'
    mov BYTE PTR es:[756], 'I'
    mov BYTE PTR es:[758], 'T'

    mov BYTE PTR es:[880], 'A'
    mov BYTE PTR es:[882], ':'
    mov BYTE PTR es:[886], 'L'
    mov BYTE PTR es:[888], 'E'
    mov BYTE PTR es:[890], 'F'
    mov BYTE PTR es:[892], 'T'

    mov BYTE PTR es:[1040], 'D'
    mov BYTE PTR es:[1042], ':'
    mov BYTE PTR es:[1046], 'R'
    mov BYTE PTR es:[1048], 'I'
    mov BYTE PTR es:[1050], 'G'
    mov BYTE PTR es:[1052], 'H'
    mov BYTE PTR es:[1054], 'T'

    mov BYTE PTR es:[1200], 'S'
    mov BYTE PTR es:[1202], 'P'
    mov BYTE PTR es:[1204], 'A'
    mov BYTE PTR es:[1206], 'C'
    mov BYTE PTR es:[1208], 'E'
    mov BYTE PTR es:[1210], ':'
    mov BYTE PTR es:[1214], 'C'
    mov BYTE PTR es:[1216], 'H'
    mov BYTE PTR es:[1218], 'E'
    mov BYTE PTR es:[1220], 'C'
    mov BYTE PTR es:[1222], 'K'
    mov BYTE PTR es:[1226], 'C'
    mov BYTE PTR es:[1228], 'E'
    mov BYTE PTR es:[1230], 'L'
    mov BYTE PTR es:[1232], 'L'

    
    ; ------------ Board begin -----------------
    
    ; Set board edges
    mov BYTE PTR es:[0], 201 ; Top Left
    mov BYTE PTR es:[60], 187 ; Top Right
    mov BYTE PTR es:[1600], 200; Bottom Left
    mov BYTE PTR es:[1660], 188; Bottom Right

    mov di,2 

    ; Top Border
    L1:
        mov BYTE PTR es:[di], 205 
        add di, 2 
        cmp di, 60
		je FIX_DI_L1
        loop L1

    FIX_DI_L1: ; Fix di 
        mov di, 160

    ; Left Border
	L2:
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1600
        jnb FIX_DI_L2
        loop L2

    FIX_DI_L2: ; Fix di 
        mov di, 1602

    ; Bottom Border
    L3: ; Fix di 
		mov BYTE PTR es:[di], 205
        add di, 2
        cmp di, 1660
        jnb FIX_DI_L3
        loop L3

    FIX_DI_L3:
        mov di, 220

    ; Right Border
    L4 :; Fix di 
		mov BYTE PTR es:[di], 186
        add di, 160
        cmp di, 1620
        jnb COLOR_L1_DI; debugging purposes
        loop L4

    COLOR_ALL:
        mov BYTE PTR es:[di], 04h
        add di, 2
        
        cmp di, 60
        mov di, 161

        cmp di, 1658
        jnb BOARD_BUILD

    COLOR_L1_DI:
        xor di, di
        mov di, 1

    COLOR_L1:
        mov BYTE PTR es:[di], 04h
        add di, 2
        cmp di, 60
        jnb COLOR_L2_DI
        loop COLOR_L1

    COLOR_L2_DI:
        mov di, 161

    COLOR_L2:
        mov BYTE PTR es:[di], 04h
        add di, 160
        cmp di, 1600
        jnb BOARD_BUILD
        loop COLOR_L2
        
    ; ------------ Board end -----------------

    ; ------------ Build board rows and cols begin ------------

    ; Main Region of Code
    BOARD_BUILD:
        mov BYTE PTR es:[166], 42 ;bomb

        xor di, di
        mov di, 4 

        mov ax, 60 ; This does tho, USE AX

    ; Create the | at the top border
    TOP_COLUMNS:
        mov BYTE PTR es:[di], 194
        add di, 4 
        cmp di, ax
        jnb SET_ROWS
        loop TOP_COLUMNS 

    ; Place 1604 in di in order to build the bottom row
    SET_ROWS:
        xor di, di
        mov di, 1604
        xor ax,ax
        mov ax, 1660

    ; The ascii added to this row is done every four bites.
    BOT_ROWS:
        mov BYTE PTR es:[di], 193
        add di, 4
        cmp di, ax
        jnb FIX_DI_ROWS
        loop BOT_ROWS

    ; Clear Registers
    FIX_DI_ROWS:
        xor di, di
        mov di, 320
        xor ax, ax
        mov ax, 378

    ; Fix DI so it will start at next row
    BEGIN_ROW_DI:
        add di, 2
        jmp BUILD_ROW
    
    ; Used in loop
    REPEAT_CYCLE_ROW:
        mov BYTE PTR es:[di], 196 ; Place last - in board
        add di, 264
        add ax, 320
        cmp ax, 1658
        jnb fix_di_cols
        jmp BUILD_ROW

    BUILD_ROW:
        mov BYTE PTR es:[di], 196
        add di, 2
        mov BYTE PTR es:[di], 197
        add di, 2
        cmp di, ax
        jnb REPEAT_CYCLE_ROW
        loop BUILD_ROW

    ; Clear registers and move values into di and ax
    FIX_DI_COLS:
        xor di, di
        mov di, 162
        xor ax, ax
        mov ax, 218

    ; Offset by 2
    BEGIN_COL_DI:
        add di, 2
        jmp BUILD_COLUMNS

    ; Loop through this until di reaches ax
    REPEAT_CYCLE_COLUMN:
        add di, 264
        add ax, 320
        cmp di, 1498
        jnb CLEAN
        jmp BUILD_COLUMNS

    ; Main column building
    BUILD_COLUMNS:
        mov BYTE PTR es:[di], 179
        add di, 4
        cmp di, ax
        jnb REPEAT_CYCLE_COLUMN
        loop BUILD_COLUMNS

    CLEAN:
        xor ax, ax
        xor dx, dx
        xor di,di
        mov di, 162
        jmp ENABLE_CURSOR_MOVEMENT

    ENABLE_CURSOR_MOVEMENT:
        mov ah, 02h
        mov dh, 1
        mov dl, 1
        int 10h
        jmp KEYPRESS 

    ; Get keystroke
    KEYPRESS:
        mov ah, 00
        int 16h

        ; check for keypress
        cmp al, 's'
        je DOWN_KEY

        cmp al, 'w'
        je UP_KEY

        cmp al, 'd'
        je RIGHT_KEY

        cmp al, 'a'
        je LEFT_KEY

        cmp al, 'r'
        je START

        cmp ah, 39h
        je BOMB_CHECK

        cmp ah, 42h ; Exit key
        je DONE

        jne KEYPRESS

    BOMB_CHECK:
        push ax
        mov ax, di
        push es:[di]
        pop ax
        cmp al, 43
        mov BYTE PTR es:[414], al
        pop ax
        jmp KEYPRESS
        
    
    DOWN_KEY:
        cmp dh, 9 ; Restrict to bounding of box
        jge KEYPRESS
        mov ah, 02h
        add dh, 2
        add di, 320
        int 10h
        jmp KEYPRESS

    UP_KEY:
        cmp dh, 1
        jle KEYPRESS
        mov ah, 02h
        sub dh, 2
        sub di, 320
        int 10h
        jmp KEYPRESS

    RIGHT_KEY:
        cmp dl, 29
        jge KEYPRESS
        mov ah, 02h
        add dl, 2
        add di, 4
        int 10h
        jmp KEYPRESS

    LEFT_KEY:
        cmp dl, 1
        jle KEYPRESS
        mov ah, 02h
        sub dl, 2
        sub di, 4
        int 10h
        jmp KEYPRESS

    ; DONE
    ; Exit game
    DONE:
        mov ah, 0
        mov al, 03 
        int 10h
        mov al, 0
        mov ah, 4ch
        int 21h

    cseg ends

END START
