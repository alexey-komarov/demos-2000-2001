; clouds 512b
; Alexey Komarov <alexey@komarov.org.ru>, 2001

	org    100h
	db     '*MAG', 13, 10, 90h
	mov    ax, 13h
	int    10h
	mov    cx, 201
l1:
	mov    word [i1], cx
	fild   word [i1]
	fidiv  word [_32]
	fst    dword [i2]
	fsin
	mov    di, 20
	call   random
	mov    word [i1], ax
	fimul  word [i1]
	fimul  word [_100 + 1]
	mov    si, cx
	shl    si, 1
	add    si, sinr - 2
	frndint
	fistp  word [si]
	fld    dword [i2]
	fcos
	mov    di, 20
	call   random
	mov    word [i1], ax
	fimul  word [i1]
	fimul  word [f]
	sub    si, 404
	frndint
	fistp  word [si]
	add    word [si], 260
	loop   l1
	inc    cx
	inc    cx
l2:
	mov    ah, 4ah
	mov    bx, 1000h
	int    21h
	mov    ah, 48h
	int    21h
	push   ax
	inc    di
	inc    di
	loop   l2
	pop    gs
	pop    fs
	mov    ax, 20
l3:
	call   setpal
	inc    al
	jnz    l3
	mov    cl, 63
l4:
	mov    al, cl
	add    al, 20
	mov    ah, cl
	mov    bl, cl
	mov    bh, cl
	shr    bh, 1
	add    bh, 16
	call   setpal
	loop   l4
	mov    cl, 84
l5:
	mov    ax, cx
	shr    al, 3
	mov    bx, 3f3fh
	sub    bh, al
	mov    al, cl
	mov    ah, bl
	call   setpal
	inc    cl
	jnz    l5
	push   gs
	pop    es
	xor    di, di
	mov    al, 14h
	dec    cx
	rep    stosb
l7:
	inc    byte [f]
	push   fs
	pop    es
	mov    di, 4
	call   random
	inc    ax
	inc    ax
	mov    bl, 100
	mul    bl
	push   ax
	mov    di, 150
	call   random
	xchg   cx, ax
	pop    bx
	xor    di, di
r1:
	pusha
	shl    di, 1
	add    di, cosr
	mov    si, [di]
	add    di, 402
	mov    ax, [di]
	cwd
	idiv   bx
	add    ax, 25
	add    ax, cx
	xchg   di, ax
	mov    bl, 120
	mov    dx, di
	shl    dx, 6
	mov    di, dx
	shl    dx, 2
	add    di, dx
	add    di, si
	mov    bh, bl
	xchg   ax, bx
	stosw
	popa
	inc    di
	cmp    di, 201
	jne    r1
l9:
	mov    di, 320
	mov    cx, 64000 - 640
	xor    bx, bx
l10:
	xor    ax, ax
	mov    al, [es:di - 1]
	mov    bl, [es:di + 320]
	add    ax, bx
	mov    bl, [es:di + 1] 
	add    ax, bx
	mov    bl, [es:di - 320]
	add    ax, bx
	shr    ax, 2
	stosb
	loop   l10
	push   gs
	pop    es
	mov    ax, word [f]
	mov    bl, 10
	div    bl
	push   ds
	or     ah, ah
	jnz    l12
	push   fs
	pop    ds
	xor    bx,bx
op1:
	mov    di, bx
	add    di, 200
	mov    si, di
	mov    cx, 60
	rep    movsw
	call   _64000bx
	jne    op1
l12:
	push   es
	pop    ds
	xor    bx, bx
op2:
	mov    di, bx
	mov    si, bx
	inc    si
	mov    cl, 159
	rep    movsw
	call   _64000bx
	jne    op2
	pop    ds
	mov    ax, gs
	push   fs
	pop    es
	call   flip
	push   gs
	pop    es
	mov    dx, 3dah
vert:
	in     al, dx
	test   al, 8
	jz     vert
	push   ds
	push   0A000h
	pop    es
	push   gs
	pop    ds
	xor    bx, bx
op3:
	mov    di, bx
	mov    si, bx
	add    di, 60
_100:
	mov    cx, 100
	rep    movsw
	call   _64000bx
	jne    op3
	pop    ds
	mov    ax,fs
	push   gs
	pop    es
	call   flip
	in     al, 60h
	cmp    al, 1
	jne    l7
	xor    ax, ax
	int    16h
	mov    ax, 3
	int    10h
	ret

random:    ; input: di
initr1:
	mov    ax, 45637
initr2:
	mov    bx, 36437
	xor    ax, bx
	shl    ax, 1
	adc    bx, 10
	xor    bx, ax
	xchg   bl, bh
	mov    word [initr1 + 1], ax
	mov    word [initr2 + 1], bx
	xor    dx, dx
	div    di
	xchg   ax, dx
	ret

setpal:    ;input: al, ah, bl, bh
	push   ax
	mov    dx, 3c8h
	out    dx, al
	inc    dx
	mov    al, ah
	out    dx, al
	xchg   ax, bx
	out    dx, al
	mov    al, ah
	out    dx, al
	pop    ax
	ret

flip:
	push   ds
	mov    ds, ax
	xor    si, si
	xor    di, di
	mov    cx, 16000
	rep    movsd
	pop    ds
	ret

_64000bx:
	add    bx, 320
	cmp    bx, 64000
	ret

	f      dw 2
	_32    dw 32
	cosr   dw 202 dup(?)
	sinr   dw 202 dup(?)
	i1     dw ?
	i2     dd ?
