; magtro
; Alexey Komarov <alexey@komarov.org.ru>, 2001

	org 100h

magtro2:
	mov     cx, 2
	mov     di, tseg

	memloop:
		mov     ah, 4ah
		mov     bx, 1000h
		int     21h
		mov     ah, 48h
		int     21h
		mov     [di], ax
		mov     es, ax
		call    clearscreen
		inc     di
		inc     di
	loop    memloop

	mov     di, bp
	mov     ax, 1130h
	mov     bh, 6
	int     10h
	mov     word [fes], es
	mov     word [fbp], bp
	mov     bp, di
	mov     ax, 13h
	int     10h
	xor     ax, ax

	next1:
		mov     ah, al
		xor     bx, bx
		call    setpal
		add     al, 64
		mov     bh, al
		mov     bl, al
		mov     ah, 63
		call    setpal
		sub     al, 63
		cmp     al, 64
	jne     next1

	push    str1
	pop     word [wt]
	mov     word [zoomx], 5
	mov     byte [textcolor], 63
	push    word [vseg]
	pop     word [pseg]
	call    print
	call    smooth

	mov     word [ny], 0
	push    word [tseg]
	pop     word [pseg]
	call    print

	mov     byte [textcolor], 100
	push    str3
	pop     word [wt]
	mov     word [zoomx], 3
	call    print

	mov     byte [textcolor], 100
	push    str8
	pop     word [wt]
	mov     word [zoomx], 2
	call    print

	mov     byte [textcolor], 128
	push    str2
	pop     word [wt]
	call    print
	call    smooth

	next2:
		in      al, 60h
		cmp     al, 1
		je      quit
		mov     byte [textcolor], 255
		push    word [vseg]
		pop     word [pseg]
		xor     cx, cx

		next3:
			xor     dx, dx
			mov     ax, cx
			mov     bx, 630
			div     bx
			xchg    bx, ax
			shl     bx, 1
			mov     di, radius
			mov     ax, [di + bx]
			mov     word [r], ax
			xor     dx, dx
			mov     ax, cx
			mov     bx, 10
			div     bx
			xchg    si, ax
			mov     word [x], cx
			fild    word [x]
			fidiv   word [_100]
			fsin
			fimul   word [r]
			frndint
			fistp   word [x]
			mov     di, word [x]
			add     di, word [y]
			call    putpixel
			inc     cx
			cmp     cx, 3191
		jne     next3

		push    ds
		mov     ax, word [vseg]
		mov     es, ax
		mov     ax, word [tseg]
		mov     ds, ax
		mov     ds, ax
		xor     cx, cx

		kk0:
			xor     bx, bx

			kk1:
				mov     si, bx
				add     si, cx
				mov     ah, [es:si + 320]
				cmp     ah, 255
				je      kk3
				mov     ah, [es:si]
				jmp     kk4

			kk3:
				xor     ax,ax
			kk4:
				mov     di,si
				movsb
				cmp     ah, 255
				je      kk5
				add     bx, 320
				cmp     bx, 64000
			jb      kk1

		kk5:
			inc     cx
			cmp     cx, 320
		jne     kk0

		pop     ds
		push    word [vseg]
		pop     word [pseg]
		call    smooth
		mov     dx, 3dah

		vert1:
			in      al, dx
			test    al, 8
		jz      vert1
		vert2:
			in      al, dx
			test    al, 8
		jnz     vert2

		call    copyscreen

		inc     word [y]
		cmp     word [y], 230
	jb      next2

	push    word [tseg]
	push    word [tseg]
	pop     word [pseg]
	pop     es
	call    clearscreen
	inc     word [counter]
	cmp     word [counter], 5
	jne     skip1
	mov     word [counter], 0

skip1:
	mov     word [ny], 0
	mov     word [zoomx], 5
	mov     byte [textcolor], 63
	mov     word [wt], str1
	call    print

	mov     byte [textcolor], 100
	mov     word [zoomx], 3
	cmp     word [counter], 0
	jne     skip2
	mov     word [wt], str3
	call    print
	dec     word [zoomx]
	mov     word [wt], str8
	call    print

skip2:
	cmp     word [counter], 1
	jne     skip3
	mov     word [wt], str4
	call    print
	dec     word [zoomx]
	mov     word [wt], str9
	call    print

skip3:
	cmp     word [counter], 2
	jne     skip4
	mov     word [wt], str5
	call    print
	dec     word [zoomx]
	mov     word [wt], str0
	call    print

skip4:
	cmp     word [counter], 3
	jne     skip5
	mov     word [wt], str6
	call    print
	dec     word [zoomx]
	mov     word [wt], str0
	call    print

skip5:
	cmp     word [counter], 4
	jne     skip6
	mov     word [wt], str7
	call    print
	dec     word [zoomx]
	mov     word [wt], stra
	call    print

skip6:
	mov     byte [textcolor], 128
	mov     word [wt], str2
	call    print
	call    smooth
	mov     word [y],40
	jmp     next2

quit:
	mov     ax, 3
	int     10h
	ret

write:
	mov     ax, word [zoomy]
	dec     ax
	mov     word [wzy1], ax
	mov     ax, word [zoomx]
	dec     ax
	mov     word [wzx1], ax
	mov     word [wp], 0

	label1:
		mov     word [wy1], 0
		label2:
			mov     ax,word [wy1]
			imul    word [zoomy]
			mov     word [wy1z], ax
			xor     ax, ax
			mov     si, word [wt]
			add     si, word [wp]
			inc     si
			lodsb
			shl     ax, 4
			add     ax, word [wy1]
			add     ax, word [fbp]
			xchg    si, ax
			mov     ax, word [fes]
			mov     es, ax
			mov     al, [es:si]
			mov     byte [wk], al
			mov     al, [es:si - 1]
			mov     byte [ww], al
			mov     al, [es:si + 1]
			mov     byte [wv], al
			mov     word [wx1], 0

			label3:
				mov     ax, [wp]
				shl     ax, 3
				add     ax, word [wx1]
				inc     ax
				imul    word [zoomx]
				mov     word [wx1z], ax
				mov     cl, 7
				sub     cl, byte [wx1]
				mov     al, 1
				shl     al, cl
				mov     ah, byte [wk]
				test    al, ah
				jz      label4
				mov     ax, word [wx]
				add     ax, word [wx1z]
				sub     ax, word [zoomx]
				mov     word [wux], ax
				mov     word [wxz], ax
				add     ax, word [wzy1]
				inc     ax

				label6:
					mov     bx, word [wy1z]
					add     bx, word [wy]
					mov     word [wuy], bx
					mov     word [wyz], bx
					add     bx, word [wzx1]
					inc     bx

					label7:
						mov     si, word [wxz]
						mov     di, word [wyz]
						call    putpixel
						inc     word [wyz]
						cmp     word [wyz], bx
					jne     label7

					inc     word [wxz]
					cmp     word [wxz], ax
				jne     label6

				mov     cl, 7
				sub     cl, byte [wx1]
				inc     cl
				mov     al, 1
				shl     al, cl
				mov     ah, byte [wk]
				test    al, ah
				jnz     label8
				mov     ax, word [zoomx]
				sub     word [wux], ax
				mov     dx, word [wy]
				mov     word [wyz], dx
				add     dx, word [wzy1]
				inc     dx

				label9:
					mov     bx, word [wux]
					add     bx, [wzx1]
					inc     bx
					mov     cx, word [wyz]
					sub     cx, word [wy]
					add     cx, word [wux]
					mov     word [wxz], cx

					label10:
						mov     cl, 7
						sub     cl, byte [wx1]
						inc     cl
						mov     al, 1
						shl     al, cl
						mov     ah, byte [ww]
						test    al, ah
						jz      label11
						mov     si, word [wxz]
						mov     di, word [wyz]
						add     di, word [wy1z]
						call    putpixel

					label11:
						mov     cl, 7
						sub     cl, byte [wx1]
						inc     cl
						mov     al, 1
						shl     al, cl
						mov     ah, byte [wv]
						test    al, ah
						jz      label12
						mov     si, word [wxz]
						mov     di, word [zoomy]
						sub     di, word [wyz]
						add     di, word [wy]
						add     di, word [wy]
						add     di, word [wy1z]
						call    putpixel

					label12:
						inc     word [wxz]
						cmp     word [wxz], bx
					jne     label10
					inc     word [wyz]
					cmp     word [wyz], dx
				jne     label9

			label8:
				mov     cl, 7
				sub     cl, byte [wx1]
				dec     cl
				mov     al, 1
				shl     al, cl
				mov     ah, byte [wk]
				test    al, ah
				jnz     label4
				mov     dx, word [wy]
				mov     word [wyz], dx
				add     dx, word [wzy1]
				inc     dx

			label13:
				mov     bx, word [wx]
				add     bx, word [wzx1]
				inc     bx
				mov     cx, word [wyz]
				sub     cx, word [wy]
				add     cx, word [wx]
				mov     word [wxz], cx

			label14:
				mov     ax, word [wzx1]
				sub     ax, word [wxz]
				add     ax, word [wx]
				add     ax, word [wx]
				add     ax, word [wx1z]
				mov     word [wux], ax
				mov     cl, 7
				sub     cl, byte [wx1]
				dec     cl
				mov     al, 1
				shl     al, cl
				mov     ah, byte [ww]
				test    al, ah
				jz      label15
				mov     si, word [wux]
				mov     di, word [wyz]
				add     di, word [wy1z]
				call    putpixel

			label15:
				mov     cl, 7
				sub     cl, byte [wx1]
				dec     cl
				mov     al, 1
				shl     al, cl
				mov     ah, byte [wv]
				test    al, ah
				jz      label16
				mov     si, word [wux]
				mov     di, word [zoomy]
				sub     di, word [wyz]
				add     di, word [wy]
				add     di, word [wy]
				add     di, word [wy1z]
				call    putpixel

			label16:
				inc     word [wxz]
				cmp     word [wxz], bx
				jne     label14
				inc     word [wyz]
				cmp     word [wyz], dx
				jne     label13

			label4:
				inc     word [wx1]
				cmp     word [wx1], 8
			jne     label3
			inc     word [wy1]
			cmp     word [wy1], 16
		jne     label2
		inc     word [wp]
		mov     si, word [wt]
		lodsb
		cmp     byte [wp], al
	jne     label1
	ret

putpixel:
	pusha
	cmp     di, 199
	ja      pexit
	cmp     si, 319
	ja      pexit
	mov     ax, word [pseg]
	mov     es, ax
	mov     dx, di
	shl     dx, 6
	mov     di, dx
	shl     dx, 2
	add     di, dx
	add     di, si
	mov     bl, byte [textcolor]
	mov     [es:di], bl
pexit:
	popa
	ret

clearscreen:
	pusha
	xor     eax, eax
	xor     di, di
	mov     cx, 16383
	rep     stosd
	popa
	ret

setpal:     ;al, ah, bl, bh
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

print:      ; (wt: string; zoomx, textcolor, pseg: word);
	xor     ax, ax
	mov     di, word [wt]
	mov     al, [di]
	shl     ax, 2
	imul    word [zoomx]
	mov     dx, 160
	sub     dx, ax
	mov     word [wx], dx
	push    word [ny]
	pop     word [wy]
	mov     ax, word [zoomx]
	mov     word [zoomy], ax
	mov     dx, 12
	imul    dx
	add     word [ny], ax
	add     word [ny], 15
	call    write
	ret

copyscreen:
	push    ds
	pusha
	mov     ax, 0a000h
	mov     es, ax
	mov     ax, word [pseg]
	mov     ds, ax
	xor     si, si
	xor     di, di
	mov     cx, 16000
	rep     movsd
	popa
	pop ds
	ret

smooth:
	pusha
	mov     ax, word [pseg]
	mov     es, ax
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

counter     dw 0
str1        db 3, 'MAG'
str2        db 19, 'DALNET: #Antibiotic'
str3        db 9, 'UDALEATOR'
str4        db 12,'CHESHIRE CAT'
str5        db 5, 'LOMIX'
str6        db 5, 'TYR43'
str7        db 2, 'HZ'
str8        db 14,'coder, founder'
str9        db 5, 'coder'
str0        db 6, 'hi-rez'
stra        db 5, 'music'
radius      dw 10, 40, 20, 46, 27, 10
ny          dw 0
y           dw 40
_100:       dw 100
x           dw ?
r           dw ?
pseg        dw ?
wx          dw ?
wy          dw ?
zoomx       dw ?
zoomy       dw ?
wt          dw ?
tseg        dw ?
vseg        dw ?
fes         dw ?
fbp         dw ?
wx2         dw ?
wp          dw ?
wx1         dw ?
wy1         dw ?
wk          db ?
ww          db ?
wv          db ?
wxz         dw ?
wyz         dw ?
wux         dw ?
wuy         dw ?
wy1z        dw ?
wx1z        dw ?
wzy1        dw ?
wzx1        dw ?
textcolor   db ?
