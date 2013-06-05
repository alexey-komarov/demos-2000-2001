; Math routines for Fractal Winter 4kb
; Alexey Komarov <alexey@komarov.org.ru>, 2001

;---------------------------------------------------
;rot(rx, ry, rz)
;---------------------------------------------------
rot:
	pusha
	shl     word [ry], 1
	shl     word [rx], 1
	shl     word [rz], 1
	xor     di, di
	rloop1:
		xor     bx, bx

		rloop2:
			mov     si, di
			mov     dx, di
			shl     si, 3
			shl     dx, 2
			add     si, dx
			mov     dx, bx
			shl     dx, 1
			add     si, dx
			add     si, dx
			add     si, dx

			push    di
			push    si
			push    bx
				add     si, lin1
				mov     ax, word [si]
				mov     word [rox], ax
				mov     ax, word [si + 2]
				mov     word [roy], ax
				mov     si, cosinus
				mov     di, sinus
				mov     bx, word [ry]

				mov     ax, word [rox]
				imul    word [si + bx]
				sar     ax, 7
				mov     word [rox1], ax
				mov     ax, word [zshift]
				imul    word [di + bx]
				sar     ax, 7
				sub     word [rox1], ax

				mov     ax,word [rox]
				imul    word [di + bx]
				sar     ax, 7
				mov     word [roz1], ax
				mov     ax, word [zshift]
				imul    word [si + bx]
				sar     ax, 7
				add     word [roz1], ax
				mov     bx, word [rz]

				mov     ax, word [rox1]
				imul    word [si + bx]
				sar     ax, 7
				mov     word [rox], ax
				mov     ax, word [roy]
				imul    word [di + bx]
				sar     ax, 7
				add     word [rox], ax

				mov     ax, word [roy]
				imul    word [si + bx]
				sar     ax, 7
				mov     word [roy1], ax
				mov     ax, word [rox1]
				imul    word [di + bx]
				sar     ax, 7
				sub     word [roy1], ax
				mov     bx, word [rx]
				mov     ax, word [roz1]
				imul    word [si + bx]
				sar     ax, 7
				mov     word [roz], ax
				mov     ax, word [roy1]
				imul    word [di + bx]
				sar     ax, 7
				sub     word [roz], ax

				mov     ax, word [roz1]
				imul    word [di + bx]
				sar     ax, 7
				mov     word [roy], ax
				mov     ax,word [roy1]
				imul    word [si + bx]
				sar     ax, 7
				sub     word [roy], ax
			pop     bx
			pop     si
			pop     di

			add     si, lin2
			mov     ax, word [rox]
			mov     word [si], ax
			mov     ax, word [roy]
			mov     word [si + 2], ax
			mov     ax, word [roz]
			mov     word [si + 4],ax
			inc     bx
			cmp     bx, 2
			je      exitrloop2
		jmp     rloop2
	exitrloop2:
		inc     di
		cmp     di, 726
		je      exitrloop1
	jmp     rloop1
exitrloop1:
	popa
	ret

;--------------------------------------------------------
;conv3d (c3x, c3y, c3z)
;--------------------------------------------------------
conv3d:
	mov     ax, -200
	sub     ax, word [c3z]
	mov     word [temp1], ax
	fild    word [zeye]
	fidiv   word [temp1]
	fst     dword [temp]
	fimul   word [c3x]
	frndint
	fistp   word [c3x]
	add     word [c3x], 159
	fld     dword [temp]
	fimul   word [c3y]
	frndint
	fistp   word [c3y]
	add     word [c3y], 99
	ret

;--------------------------------------------------------
;random (di) : di
;--------------------------------------------------------
random:
initr:
	mov     ax, 43637
initr2:
	mov     bx, 36437
	xor     ax, bx
	shl     ax, 1
	adc     bx, 0
	xor     bx, ax
	xchg    bl, bh
	mov     word [initr + 1], ax
	mov     word [initr2 + 1], bx
	xor     dx, dx
	div     di
	xchg    ax, dx
	ret

ln:
	fldln2
	fxch
	fyl2x
	ret

rad dd 0.00872664626

exp:
	fld     dword [e]
	fyl2x
	fld     st0
	frndint
	fsub    st1, st0
	fxch 
	f2xm1
	fld1
	faddp   st1, st0
	fscale
	ffree   st1
	ret

e dd 2.718281828
