mov cx, 10
sub ax, ax

l: 
    add ax,cx
    dec cx
    cmp cx,5
    jnl l
    jnz l

