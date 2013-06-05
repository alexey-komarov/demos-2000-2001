; Graphic routines for Fractal Winter 4kb
; Alexey Komarov <alexey@komarov.org.ru>, 2001

_0_16       equ 03E23D70Ah
_0_85       equ 03F59999Ah
_0_04       equ 03D23D70Ah
__0_04      equ 0BD23D70Ah
_1_6        equ 03FCCCCCDh
_0_2        equ 03E4CCCCDh
__0_26      equ 0BE851EB8h
_0_22       equ 03E6147AEh
_0_23       equ 03E6B851Fh
__0_15      equ 0BE19999Ah
_0_28       equ 03E8F5C29h
_0_26       equ 03E851EB8h
_0_44       equ 03EE147AEh
_0_24       equ 03E75C28Fh

;---------------------------------------------------
;putpixel(px, py, pc, es)
;---------------------------------------------------
putpixel:
	pusha
	mov     bx, word [pc]
	mov     si, word [py]
	mov     di, word [px]
	cmp     si, 199
	ja      exitpp
	cmp     di, 319
	ja      exitpp
	shl     si, 6
	mov     dx, si
	shl     dx, 2
	add     si, dx
	add     si, di
	mov     [es:si], bl
exitpp:
	popa
	ret

;---------------------------------------------------
;getpixel(px, py, pc, es)
;---------------------------------------------------
getpixel:
	pusha
	mov     si, word [py]
	mov     di, word [px]
	cmp     si, 199
	ja      exitgp
	cmp     di, 319
	ja      exitgp
	shl     si, 6
	mov     dx, si
	shl     dx, 2
	add     si, dx
	add     si, di
	xor     bx, bx
	mov     bl, [es:si]
	mov     word [pc], bx
exitgp:
	popa
	ret

;---------------------------------------------------
;line(x1l, y1l, x2l, y2l, color, vseg)
;---------------------------------------------------
line:
	pusha
	mov     bx, word [x1l]
	mov     ax, word [x2l]
	mov     cx, word [y1l]
	mov     dx, word [y2l]
	cmp     ax, 319
	ja      exitline
	cmp     bx, 319
	ja      exitline
	cmp     cx, 199
	ja      exitline
	cmp     dx, 199
	ja      exitline
	cmp     cx, dx
	jne     lskip0
	cmp     bx, ax
	je      exitline
lskip0:
	cmp     bx, ax
	ja      lskip1
	mov     word [xil], 1
	mov     word [dxl], ax
	sub     word [dxl], bx
	jmp     short lskip3
lskip1:
	mov     word [xil], -1
	mov     word [dxl], bx
	sub     word [dxl], ax
lskip3:
	cmp     cx, dx
	ja      lskip2
	mov     word [yil], 1
	mov     word [dyl], dx
	sub     word [dyl], cx
	jmp     short lskip4

exitline:
	popa
	ret

lskip2:
	mov     word [yil], -1
	mov     word [dyl], cx
	sub     word [dyl], dx
lskip4:
	mov     word [px], bx
	mov     word [py], cx
	call    putpixel2

	mov     di, word [dxl]
	mov     si, word [dyl]
	cmp     di, si
	jb      lskip5
	sub     si, di
	mov     ax, 2
	imul    si
	mov     word [ail], ax
	mov     ax, 2
	imul    word [dyl]
	mov     word [bil], ax
	sub     ax, word [dxl]
	mov     word [dll], ax
lloop1:
		test    word [dll], 32768
		jnz     lskip6
		add     cx, word [yil]
		mov     ax, word [ail]
		add     word [dll], ax
		jmp     short lskip7
	lskip6:
		mov     ax, word [bil]
		add     word [dll], ax
	lskip7:
		add     bx, word [xil]
		mov     word [px], bx
		mov     word [py], cx
		call    putpixel2

		cmp     bx, word [x2l]
	jne     lloop1
	jmp     short exitline
lskip5:
	sub     di, si
	mov     ax, 2
	imul    di
	mov     word [ail], ax
	mov     ax, 2
	imul    word [dxl]
	mov     word [bil], ax
	sub     ax,word [dyl]
	mov     word [dll], ax

	lloop2:
		test    word [dll], 32768
		jnz     lskip8
		add     bx, word [xil]
		mov     ax, word [ail]
		add     word [dll], ax
		jmp     short lskip9
	lskip8:
		mov     ax, word [bil]
		add     word [dll], ax
	lskip9:
		add     cx, word [yil]
		mov     word [px], bx
		mov     word [py], cx
		call    putpixel2
		mov     ax, word [y2l]
		cmp     ax, cx
	jne     lloop2
	jmp     exitline

;---------------------------------------------------
;cls(es)
;---------------------------------------------------
cls:
	pusha
	xor     eax, eax
	xor     di, di
	mov     cx, 16383
	rep     stosd
	popa
	ret

;---------------------------------------------------
;setpal(al, ah, bl, bh)
;---------------------------------------------------
setpal:
	pusha
	mov     dx, 3c8h
	out     dx, al
	inc     dx
	xchg    al, ah
	out     dx, al
	xchg    al, bl
	out     dx, al
	xchg    al, bh
	out     dx, al
	popa
	ret

;---------------------------------------------------
;getpal(al, ah, bl, bh)
;---------------------------------------------------
getpal:
	mov     dx, 3c7h
	out     dx, al
	inc     dx
	inc     dx
	in      al, dx
	mov     ah, al
	in      al, dx
	mov     bl, al
	in      al, dx
	mov     bh, al
	ret

;---------------------------------------------------
;smooth(es)
;---------------------------------------------------
smooth:
	pusha
	xor     di, di
	mov     cx, 64000
	xor     bh, bh
	sloop:
		xor     ax, ax
		mov     al, [es:di - 1]
		mov     bl, [es:di + 320]
		add     ax, bx
		mov     bl, [es:di + 1]
		add     ax, bx
		mov     bl, [es:di - 320]
		add     ax, bx
		shr     ax, 2
		mov     [es:di], al
		inc     di
	loop    sloop
	popa
	ret

;---------------------------------------------------
;putpixel2(px, py, pc, es)
;---------------------------------------------------
putpixel2:
	push    es
	cmp     word [flag], 1
	jne     pp2skip1
	push    word [useg]
	pop     es
	call    putpixel
pp2skip1:
	pop     es
	cmp     word [flag], 3
	jne     pp2skip2
	inc     word [px]
	mov     ax,word [pc]
	mov     word [pc], 252
	call    putpixel
	dec     word [px]
	inc     word [py]
	call    putpixel        
	inc     word [py]
	mov     word [pc], ax
pp2skip2:
	call    putpixel
	ret

;---------------------------------------------------
;copyscreen(vseg, es)
;---------------------------------------------------
copyscreen:
	push    ds
	pusha
	mov     ax, word [vseg]
	mov     ds, ax
	xor     si, si
	xor     di, di
	mov     cx, 16000
	rep     movsd
	popa
	pop     ds
	ret

;---------------------------------------------------
;vret()
;---------------------------------------------------
vret:
	mov     dx, 3dah
	vert1:
		in      al, dx
		test    al, 8
	jz vert1
	vert2:
		in      al, dx
		test    al, 8
	jnz     vert2
	ret

;---------------------------------------------------
;fadepal()
;---------------------------------------------------
fadepal:
	pusha
	mov     cx,255

	fploop:
		mov     al, cl
		call    getpal
		or      ah, ah
		jz      fpskip1
		dec     ah 
	fpskip1:
		or      bl, bl
		jz      fpskip2
		dec     bl
	fpskip2:
		or      bh, bh
		jz      fpskip3
		dec     bh
	fpskip3:
		mov     al, cl
		call    setpal
	loop    fploop
	popa 
	ret

workpp:
	mov     dx, word [pc]
	mov     ax, word [mseg]
	mov     es, ax
	call    getpixel
	add     word [pc], 63
	mov     ax, word [nseg]
	mov     es, ax
	call    putpixel
	mov     word [pc], dx
	ret

;---------------------------------------------------
;writegrz(wgx, wgy, di)
;---------------------------------------------------
writegrz:
	mov     word [ur], 1
	pusha
	push    es
	mov     ax, word [fes]
	mov     es, ax
	mov     word [di_orig], di

	nextp:
		mov     al, [di]
		cmp     al, '$'
		je      wdone
		xor     bx, bx

		nexty1:
			xor     ax, ax
			mov     al, [di]
			shl     ax, 4
			add     ax, bx
			mov     si, word [fbp]
			add     si, ax
			xor     cx, cx

			nextx1:
				mov     al, [es:si]
				mov     ah, 128
				shr     ah, cl
				test    ah, al
				jz      bit_off
				mov     ax, di
				sub     ax, word [di_orig]
				shl     ax, 3
				add     ax, cx
				shl     ax, 1
				add     ax, word [wgx]
				cmp     ax, 0
				jl      bit_off
				cmp     ax, 336
				jg      wdone
				mov     word [px], ax
				mov     word [temp1], bx
				fild    word [temp1]
				fmul    dword [_1_4]
				fiadd   word [wgy]
				frndint
				fistp   word [py]
				push    di
				mov     di, word [ur]
				add     di, word [nshift]
				xchg    ax, di
				mov     di, 360
				xor     dx, dx
				div     di
				mov     di, dx
				shl     di, 1
				mov     di, [di + sinus]
				mov     ax, 20
				imul    di
				sar     ax, 7
				add     word [py], ax
				pop     di
 
				push    es
				call    workpp
				inc     word [px]
				call    workpp
				inc     word [py]
				call    workpp
				dec     word [px]
				call    workpp
				pop     es
			bit_off:
				inc     cx
				cmp     cx, 8
			jne     nextx1
			inc     word [ur]
			cmp     word [ur], 720
			jb      wgskip
			mov     word [ur], 0
		wgskip:
			inc     bx
			cmp     bx, 16
		jne     nexty1
		inc     di
	jmp     nextp
wdone:
	pop     es
	popa
	ret

;---------------------------------------------------
;draw_fern(fcx, fcy, fzx, fzy, ft)
;---------------------------------------------------
draw_fern:
	mov     cx, 60000
	xor     ebx, ebx
	mov     dword [fy], ebx
	mov     dword [fx], ebx
	mov     dword [fnewx], ebx
	mov     dword [fnewy], ebx
	mov     dword [fa], ebx
	mov     dword [fb], ebx
	mov     dword [fc], ebx
	mov     dword [fd], ebx
	mov     dword [ff], ebx

	fernloop:
		xor     ebx, ebx
		mov     di, 100
		call    random

		cmp     ax, 10
		ja      ffskip1
		mov     dword [fa], ebx
		mov     dword [fb], ebx
		mov     dword [fc], ebx
		mov     dword [fd], _0_16
		mov     dword [ff], ebx
		jmp ffskip2
	ffskip1:
		cmp     ax, 86
		ja      ffskip3
		mov     dword [fa], _0_85
		mov     dword [fb], _0_04
		mov     dword [fc], _0_04
		mov     dword [fd], _0_85
		mov     dword [ff], _1_6
		jmp     short ffskip2
	ffskip3:
		cmp     ax, 93
		ja      ffskip5  
		mov     dword [fa], _0_2
		mov     dword [fb], __0_26
		mov     dword [fc], _0_23
		mov     dword [fd], _0_22
		mov     dword [ff], _1_6
		jmp     short ffskip2
	ffskip5:
		mov     dword [fa], __0_15
		mov     dword [fb], _0_28
		mov     dword [fc], _0_26
		mov     dword [fd], _0_24
		mov     dword [ff], _0_44
	ffskip2:
		fld     dword [fy]
		fmul    dword [fb]
		fstp    dword [temp]
		fld     dword [fx]
		fmul    dword [fa]
		fadd    dword [temp]
		fst     dword [fnewx]
		fld     dword [fy]
		fmul    dword [fd]
		fstp    dword [temp]
		fld     dword [fx]
		fmul    dword [fc]
		fadd    dword [temp]
		fadd    dword [ff]
		fst     dword [fnewy]
		fstp    dword [fy]
		fstp    dword [fx]
		inc     word [iter]
		fld     dword [fx]
		fimul   word [fzy]
		frndint
		fistp   word [temp]
		mov     ax, 10
		sub     ax, word [temp]
		add     ax, word [fcy]
		mov     word [py], ax
		fld     dword [fy]
		fimul   word [fzx]
		fiadd   word [fcx]
		frndint
		fistp   word [temp]
  
		cmp     word [ft], 0
		jne     ffskip10
		push    word [temp]
		pop     word [px]
		jmp     short ffskip11
	ffskip10:
		mov     ax, 320
		sub     ax, word [temp]
		mov     word [px], ax
	ffskip11:
		mov     word [pc], 128
		call    putpixel
		loop    fernloop1
		jmp     short ffskip0
fernloop1:
	jmp fernloop
ffskip0:
	ret

getfont:
	mov     di, bp
	mov     ax, 1130h
	mov     bh, 6
	int     10h
	mov     word [fes], es
	mov     word [fbp], bp
	mov     bp, di
	ret
