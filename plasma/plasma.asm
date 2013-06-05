; plasma 512b
; Alexey Komarov <alexey@komarov.org.ru>, 2000

	org    100h
	mov    di, xcrd
	mov    cx, 1800
	xor    ax, ax
	rep    stosw

	mov    di, nycrd
	mov    cx, 700
	mov    ax, 199
	rep    stosw
 
	mov    ax, 13h
	int    10h
	xor    bx, bx 

looppal:
	inc    bh

	pusha

	xor    bl, bl
	xor    ch, ch
	mov    cl, bh
	shr    cl, 1
	call   setrgb

	mov    bl, 63
	mov    ch, 32
	sub    ch, cl
	xchg   cl, ch
	mov    ch, bl
	sub    ch, bh
	add    bh, 126
	call   setrgb

	sub    bh, 126
	mov    cl, 32
	mov    bl, bh
	mov    ch, bh
	add    bh, 63
	call   setrgb

	mov    bl, 63
	sub    bh, bl
	mov    ch, bh
	xor    cl, cl
	add    bh, 186
	call   setrgb

	popa

	cmp    bh, 63
	jne    looppal

	mov    ah, 4ah
	mov    bx, 1000h
	int    21h
	mov    ah, 48h
	int    21h     
	jc     exit

	mov    word [vseg], ax
	mov    es, ax
	xor    ax, ax
	xor    di, di
	mov    cx, 32000
	rep    stosw
	xor    di, di
	xor    bx, bx
loop1:
	mov    si, xcrd
	add    si, di
	mov    bl, 50
	call   random
	add    bl, 150
	mov    [si], bx

	call   plus1200
	mov    bl, 50
	call   random
	add    bl, 75
	mov    [si], bx

	call   plus1200
	mov    bl,186
	mov    [si], bl

	inc    di
	inc    di
	cmp    di, 800
	jne    loop1

mloop:
	xor    di, di
	in     al, 60h
	cmp    al, 1
	jne    loop3

exit:
	mov    ax, 3
	int    10h
	ret

loop3:
	mov    si, xcrd
	add    si, di
	mov    bl, 11
	call   random
	sub    bx, 5
	add    word [si], bx
	call   plus1200
	mov    bl, 11
	call   random
	sub    bx, 5
	add    word [si], bx
	call   plus1200
	mov    bl, 5
	call   random
	sub    bx, 2
	add    word [si], bx

	pusha
	mov    si, xcrd
	add    si, di
	mov    cx, [si]
	call   plus1200
	mov    dx, [si]
	call   plus1200
	mov    bl, [si]
	call   putpixel
	inc    dx
	inc    cx
	mov    bl, 0ffh
	call   putpixel
	dec    dx
	dec    cx
	dec    dx
	dec    cx
	call   putpixel
	popa

	inc    di
	inc    di
	cmp    di, 1200
	jne    loop3
	call   smooth
	call   smooth
	mov    dx, 3dah

vert:
	in     al, dx
	test   al, 8h
	jz     vert

	pusha
	push   ds
	mov    ax, word [vseg]
	mov    ds, ax
	mov    ax, 0A000h
	mov    es, ax
	xor    si, si
	xor    di, di
	mov    cx, 16000
	db     66h
	rep    movsw
	pop    ds
	popa

	inc    byte [count]
	cmp    byte [count], 17
	je     mmm
	jmp    mloop

mmm:
	pusha
	xor    di, di
	mov    byte [count], 0

lloop:
	mov    si, xcrd
	add    si, di
	cmp    [si], byte 160
	ja     ll1
	add    [si], byte 2
	jmp    ll2

ll1:
	sub    [si], byte 2

ll2:
	call   plus1200
	cmp    [si], byte 100
	ja     ll3
	add    [si], byte 2
	jmp    ll4

ll3:
	sub    [si], byte 2
ll4:
	call   plus1200
	mov    byte [si], 200
	inc    di
	inc    di
	cmp    di, 1200
	jne    lloop
	popa
	jmp    mloop

putpixel:  ; input: cx, dx, bl - x, y, colors
	pusha
	cmp    dx, 196
	ja     exit1
	mov    ax, word [vseg]
	mov    es, ax
	shl    dx, 6
	mov    di, dx
	shl    dx, 2
	add    di, dx
	add    di, cx
	cmp    di, 960
	jb     exit1
	mov    byte [es:di], bl
exit1:
	popa
	ret

random:  
	xor    ax, ax
	out    43h, al
	in     al, 40h
	xchg   al, ah
	out    43h, al
	in     al, 41h
	xor    al, ah
	xor    ah, ah
	div    bl
	xor    bx, bx
	mov    bl, ah
	ret

smooth:
	push ds 
	pusha
	mov    ax, word [vseg]
	mov    ds, ax
	mov    di, 320
	xor    bh, bh

next:
	xor    ax, ax
	mov    al, [di - 1]
	mov    bl, [di + 320]
	add    ax, bx
	mov    bl, [di - 320]
	add    ax, bx
	mov    bl, [di + 1]
	add    ax, bx
	shr    ax, 2
	mov    [di], al
	inc    di
	cmp    di, 63360
	jne    next
	popa
	pop    ds
	ret

setrgb:
	mov    dx, 3c8h
	mov    al, bh
	out    dx, al
	inc    dx
	mov    al, bl
	out    dx, al
	mov    al, ch
	out    dx, al
	mov    al, cl
	out    dx, al
	ret

plus1200:
	add si, 1200
	ret

	vseg   dw ?
	count  dw ?
	xcrd   dw 600 dup(?)
	ycrd   dw 500 dup(?)
	nycrd  dw 100 dup(?)
