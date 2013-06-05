; Fractal Winter 4kb
; Alexey Komarov <alexey@komarov.org.ru>, 2001

	org     100h
	mov     cx, 7
	mov     di, mseg

	memloop:
		mov     ah, 4ah
		mov     bx, 1000h
		int     21h
		mov     ah, 48h
		int     21h     
		jnc     all_ok
		mov     ah, 09
		mov     dx, error
		int     21h
		ret

	all_ok:
		mov     [di], ax
		mov     es, ax
		call    cls
		inc     di
		inc     di
	loop    memloop

	push    ds
	pop     es
	mov     di, start_var
	mov     cx, end_var - start_var
	xor     ax, ax
	rep     stosb
	call    getfont
	mov     ax, 13h
	int     10h
	mov     al, 1

	ploop0:
		xor     bl, bl
		mov     bh, al
		mov     ah, al
		shr     bh, 3
		shr     ah, 1
		call    setpal
		mov     bl, al
		mov     ah, al
		shr     ah, 1
		add     ah, 32
		mov     bh, al
		add     al, 63
		call    setpal
		sub     al, 63
		inc     al
		cmp     al, 64
	jne     ploop0

	push    word [mseg]
	pop     es
	xor     di, di

	b1:
		xor     dx, dx
		mov     ax, di
		mov     bx, 320
		div     bx
		cmp     ax, 8
		jb      b1skip
		cmp     ax, 190
		ja      b1skip
		inc     ax
		or      ax, dx
		xor     dx, dx
		mov     bx, 64
		div     bx
		mov     [es:di], dl
	b1skip:
		inc     di
		or      di, di
	jnz     b1

	push    word [mseg]
	pop     word [vseg]
	push    word [nseg]
	pop     es
	call    copyscreen

	mov     word [wgx], 25
	mov     word [wgy], 10
	mov     di, m1
	call    writegrz

	mov     word [wgx], 100
	mov     word [wgy], 40
	mov     di, m2
	call    writegrz

	mov     word [wgx], 15
	mov     word [wgy], 70
	mov     di, m3
	call    writegrz

	mov     word [wgx], 95
	mov     word [wgy], 90
	mov     di, m4
	call    writegrz

	mov     word [wgx], 35 + 16
	mov     word [wgy], 120
	mov     di, m41
	call    writegrz

	mov     word [wgx], 5
	mov     word [wgy], 170
	mov     di, m5
	call    writegrz

	call    smooth

	push    word [nseg]
	pop     word [vseg]
	push    0a000h
	pop     es
	call    copyscreen

	push    word [mseg]
	pop     es
	call    cls
	call    drawtree

	mov     word [flag], 1
	mov     word [pc], 0
	call    calctunnel
	call    makeblob
	call    mandel

	mov cx,200
	delay:
		call    vret
	loop delay

	mov cx,63
	begin:
		call    fadepal
		call    vret
	loop    begin

	push    0a000h
	pop     es
	call    cls

	push    word [mseg]
	pop     es
	call    cls

	xor     cx, cx

	gel1:
		mov     si, cx
		shl     si, 1
		mov     di, 640
		call    random

		sub     ax, 320
		mov     [si + snowx], ax
		mov     di, 190
		call    random

		mov     [si + snowy], ax
		mov     di, 4
		call    random

		add     ax, 2
		mov     [si + snows], ax
		inc     cx
		cmp     cx,700
	jne     gel1
       
	xor     di, di
	xor     si, si

	cloop1:
		mov     word [temp], si
		fild    word [temp]
		fmul    dword [rad]
		fsin
		fimul   word [_128]
		frndint
		fistp   word [di + sinus]
		fild    word [temp]
		fmul    dword [rad]
		fcos
		fimul   word [_128]
		frndint
		fistp   word [di + cosinus]
		inc     di
		inc     di
		inc     si
		cmp     si, 721
	jbe     cloop1

	call    getfont

	mov     al, 63

	ploop1:
		xor     ah, ah
		mov     bl, al
		shr     bl, 2
		mov     bh, al
		shr     bh, 1
		call    setpal

		mov    ah, al
		mov    bl, al
		shr    bl, 1
		mov    bh, bl
		add    bl, 15
		add    bh, 32
		add    al, 63
		call   setpal

		sub    al, 63
		mov    ah, 63
		mov    bh, ah
		mov    bl, al
		shr    bl, 2
		add    bl, 48
		add    al, 126
		call   setpal

		sub    al, 126
		dec    al
		or     al, al
	jnz ploop1

	mov     ax, 3fffh
	mov     bx, 0ffffh
	call    setpal

	mov     ax, 20fch
	mov     bx, 2020h
	call    setpal

	mov     word [pc], 63
	push    word [mseg]
	pop     es
	mov     cl, 5

	makeback:
		mov     word [mx], 159
		mov     word [my], 99
		mov     word [mradius], 109
		call    make

		mov word [mx], 159
		mov word [my], 99
		mov word [mradius], 19
		call make

		call smooth
	loop makeback

	push    word [useg]
	pop     es
	mov     word [fcx], -40
	mov     word [fcy], 40
	mov     word [fzx], 24
	mov     word [fzy], 18
	mov     word [ft], 0
	call    draw_fern
	call    draw_fern

	mov     word [fcx], -20
	mov     word [fcy], 160
	call    draw_fern

	inc     word [ft]
	mov     word [fcx], -40
	mov     word [fcy], 90
	call    draw_fern

	call    smooth
	call    smooth

	mov     word [iter], 0
	push    word [mseg]
	pop     es
	mov     word [x1l], 0
	mov     word [x2l], 319

	xor     di, di
	liloop:
		mov     word [y1l], di
		mov     word [y2l], di
		mov     ax, 63
		mov     bx, di
		shl     bx, 3
		sub     ax, bx
		mov     word [pc], ax
		call    line
		mov     ax, 199
		sub     ax, di
		mov     word [y1l], ax
		mov     word [y2l], ax
		call    line
		inc     di
		cmp     di, 7
	jne     liloop

	mov     word [flag], 0
	mov     word [mx], 159
	mov     word [my], 99
	mov     word [mradius], 40
	call    make2

	mov     word [bangle], 180
	mov     word [mx], 159
	mov     word [my], 99
	mov     word [mradius], 40
	call    make2

	mov     word [flag], 3
	mov     word [pc], 255
	xor     bx, bx
	mov     word [rx], 0
	mov     word [ry], 0
	mov     word [rz], 0

	scene1:
		mov     cx, 90

		scloop1:
			in      al, 60h
			cmp     al, 1
			jne     notexit1
			jmp     finish

		notexit1:
			mov     word [rx], bx
			mov     word [ry], 720
			mov     ax, cx
			shl     ax, 3
			sub     word [ry], ax
			mov     word [rz], ax 
			call    rot
			call    flake

			inc     word [nshift]
			inc     word [iter]

			cmp     word [iter], 500
			jb      sskip3
			dec     word [zshift]

		sskip3:
			cmp     word [iter], 740
			ja      scene1end
			inc     bx
			inc     bx
			cmp     bx, 721
			jb      sskip1
			xor     bx, bx
		sskip1:
		loop    scloop1
	jmp     scene1

scene1end:
	mov     word [nshift], 0
	push    word [useg]
	pop     word [vseg]
	push    word [mseg]
	pop     es
	call    copyscreen

	mov    word [iter], 0
	mov    al, 63

	ploop2:
		mov     ah, al
		shr     ah, 2
		xor     bl, bl
		mov     bh, al
		shr     bh, 1
		call    setpal

		mov     ah, al
		mov     bl, al
		shr     bl, 1
		mov     bh, bl
		add     bl, 15
		add     bh, 32
		add     al, 63
		call    setpal

		sub     al, 63
		mov     ah, 63
		mov     bh, ah
		mov     bl, al
		shr     bl, 2
		add     bl, 48
		add     al, 126
		call    setpal

		sub     al, 126
		dec     al
		or      al, al
	jnz     ploop2

	scene2:
		in      al, 60h
		cmp     al, 1
		jne     sc2skip1
		jmp     finish
	sc2skip1:
		inc     word [nshift]
		inc     word [iter]

		mov     ax, word [mseg]
		mov     word [vseg], ax
		mov     ax, word [nseg]
		mov     es, ax
		call    copyscreen

		xor     ax, ax
		mov     di, word [iter]
		sub     ax, di
		mov     word [wgx], ax
		mov     word [wgy], 60
		mov     di, t2
		call    writegrz

		mov     word [mx], 159
		mov     word [my], 99
		fild    word [iter]
		fidiv   word [_20]
		fsin
		fimul   word [_80]
		frndint
		fistp   word [mradius]
		add     word [mradius], 50
		mov     di, word [iter]
		call    calc

		mov     word [mx], bx
		mov     word [my], cx
		call    writeblob

		mov     word [mx], 159
		mov     word [my], 99
		fild    word [iter]
		fidiv   word [_32]
		fsin
		fimul   word [_60]
		frndint
		fistp   word [mradius]
		add     word [mradius], 50
		mov     di, word [iter]
		call    calc

		mov     word [mx], bx
		mov     word [my], cx
		call    writeblob

		cmp     word [iter], 1400
		jb      sskip4
		call    fadepal

	sskip4:
		cmp     word [iter], 1540
		ja      scene2end

		call    vret

		mov     ax, word [nseg]
		mov     word [vseg], ax
		mov     ax, 0a000h
		mov     es, ax
		call    copyscreen
	jmp scene2

scene2end:
	mov     ax, 0a000h
	mov     es, ax
	call    cls
	mov     al, 1

	ploop3:
		xor     ah, ah
		xor     bx, bx
		mov     bh, al
		call    setpal
		mov     ah, al
		shl     ah, 1
		mov     bl, ah
		add     bh, 32
		add     al, 32
		call    setpal

		sub     al, 32
		inc     al
		cmp     al, 33
	jne     ploop3

	mov     al,1
	ploop4:
		mov     ah, al
		mov     bl, al
		shr     bl, 1
		mov     bh, bl
		add     bl, 15
		add     bh, 32
		add     al, 63
		call    setpal

		sub     al, 63
		inc     al
		cmp     al, 64
	jne     ploop4

	mov     word [iter], 0
	push    word [nseg]
	pop     es
	call    cls

	mov word [nshift], 0
	scene3:
		in      al, 60h
		cmp     al, 1
		jne     sc3skip1
		jmp     finish

	sc3skip1:
		call    do_tunnel
		mov     ax, word [nseg]
		mov     word [vseg], ax
		mov     ax, 0a000h
		mov     es, ax
		call    copyscreen

		fld     dword [fft]
		fadd    dword [_0_9]
		fst     dword [fft]
		frndint
		fistp   word [tt]
		mov     ax, word [tt]
		mov     dx, -3
		imul    dx
		mov     word [radoff], ax
		mov     ax, word [tt]
		sal     ax, 1
		mov     word [angoff], ax
		inc     word [nshift]
		inc     word [iter]
		cmp     word [iter], 700
		jb      sskip5
		call    fadepal

sskip5:
		cmp     word [iter], 840
		ja      scene3end
	jmp     scene3

scene3end:
	mov     al, 1
	ploop5:
		xor     ah, ah
		mov     bl, al
		mov     bh, al
		call    setpal

		add     al, 63
		mov     ah, 3fh
		mov     bx, 3f3fh
		call    setpal

		sub     al, 63
		add     al, 126
		mov     ah, 20h
		mov     bx, 203fh
		call    setpal

		sub     al, 126
		add     al, 190
		mov     ah, al
		xor     bx, bx
		mov     bl, al
		call    setpal

		sub     al, 190
		inc     al
		cmp     al, 64
	jne     ploop5

	mov     ax, 3ffeh
	mov     bx, 3f3fh
	call    setpal

	mov     ax, 20ffh
	mov     bx, 2020h
	call    setpal

	mov     word [nshift], 0
	mov     word [iter], 0

	scene4:
		in      al, 60h
		cmp     al, 1
		jne     sc4skip1
		jmp     finish
	sc4skip1:
		mov     ax, word [tseg]
		mov     word [vseg], ax
		mov     ax, word [nseg]
		mov     es, ax
		call    copyscreen

		xor cx, cx
		snow:
			mov     ax, word [nseg]
			mov     es, ax

			mov     si, cx
			shl     si, 1
			mov     bx, [si + snowx]
			mov     dx, [si + snowy]
			mov     word [px], bx
			mov     word [py], dx
			mov     word [pc], 254
			call    putpixel

			mov     word [pc], 255
			dec     word [px]
			call    putpixel
			add     word [px], 2
			call    putpixel

			dec     word [px]
			dec     word [py]
			call    putpixel

			add     word [py], 2
			call    putpixel

			dec     word [py]
			mov     word [pc], 0
			inc     word [py]
			mov     ax, word [tseg]
			mov     es, ax
			call    getpixel

			dec     word [py]
			cmp     word [pc], 254
			jb      sc4skip2

			inc     word [px]
			call    getpixel
			cmp     word [pc], 254
			jae     sc4skip3

			while1:
				call    getpixel
				cmp     word [pc], 254
				jae     wend1
				cmp     word [py], 194
				je      wend1
				inc     word [py]
			jmp     short while1

		wend1:
			dec     word [py]
			mov     word [pc], 254
			call    putpixel

			inc     word [pc]
			dec     word [py]
			call    putpixel

			inc     word [py]
			dec     word [pc]
			dec     word [px]
			jmp     short endif1

		sc4skip3:
			dec     word [px]
			dec     word [px]
			call    getpixel

			cmp     word [pc], 254
			jb      sc4skip4

			while2:
				call    getpixel
				cmp     word [pc], 254
				jae     wend2
				cmp     word [py], 194
				je      wend2
				inc     word [py]
			jmp     short while2

		wend2:
			dec     word [py]
			mov     word [pc], 254
			call    putpixel  
			inc     word [px]
			jmp     short endif1

		sc4skip4: 
			inc     word [px]
			dec     word [py]
			call    putpixel

		endif1:
			mov     word [si + snowy], 194

		sc4skip2:
			mov     ax, [si + snows]
			add     [si + snowy], ax
			inc     word [si + snowx]
			cmp     word [si + snowy], 193
			jbe     sc4skip5
			mov     ax, [si + snowx]
			mov     word [px], ax
			mov     word [py], 194
			mov     word [pc], 254
			call putpixel

			inc     word [pc]
			dec     word [py]
			call    putpixel

			mov     di, 640
			call    random

			sub     ax, 320
			mov     [si + snowx], ax
			mov     word [si + snowy], 7
			mov     di, 4
			call    random

			inc     ax
			mov     [si + snowy], ax

		sc4skip5:
			inc     cx
			cmp     cx, 700
		jne snow

		xor     ax, ax
		mov     di, word [iter]
		sub     ax, di
		mov     word [wgx], ax
		mov     word [wgy], 60
		mov     di, t3
		call    writegrz

		call    vret

		mov     ax, word [nseg]
		mov     word [vseg], ax
		mov     ax, 0a000h
		mov     es, ax
		call    copyscreen

		inc     word [nshift]
		inc     word [iter]
		cmp     word [iter], 1800
		jb      sskip6

		call fadepal

	sskip6:
		cmp     word [iter], 1940
		ja      scene4end
	jmp     scene4

scene4end:

finish:
	mov ax, 3
	int 10h
	ret

;---------------------------------------------------
;procedure calc(mx, my, mradius, di : integer)
;---------------------------------------------------
calc:
	mov     word [temp1], di
	fild    word [temp1]
	fiadd   word [bangle]
	fdiv    dword [_57_3]
	fst     dword [temp]
	fcos
	fimul   word [mradius]
	fiadd   word [mx]
	frndint
	fistp   word [temp1]
	mov     bx, word [temp1]
	fld     dword [temp]
	fsin
	fimul   word [mradius]
	fiadd   word [my]
	frndint
	fistp   word [temp1]
	mov     cx, word [temp1]
	ret

;---------------------------------------------------
;make(mx, my, mradius)
;---------------------------------------------------
make:
	cmp     word [mradius], 5
	jb      m1skip1
	pusha

	xor     di, di
	m1loop:
		call    calc
		push    word [mx]
		pop     word [x1l]
		push    word [my]
		pop     word [y1l]
		mov     word [x2l], bx
		mov     word [y2l], cx
		call    line
		add     di, 72
		push    word [mradius]
		push    word [mx]
		push    word [my]
		mov     word [mx], bx
		mov     word [my], cx   
		shr     word [mradius], 1
		call    make
		pop     word [my]
		pop     word [mx]
		pop     word [mradius]
		cmp     di, 360
	jb     m1loop
	popa
m1skip1:
	ret

;---------------------------------------------------
;make2(mx, my, mradius)
;---------------------------------------------------
make2:
	cmp     word [mradius], 2
	jb      m2skip1
	pusha

	xor     di, di
	m2loop:
		call    calc
		mov     si, word [pixel]
		mov     ax, 12
		mul     si
		xchg    ax, si
		add     si, lin1
		push    word [mx]
		pop     word [si]
		sub     word [si], 159
		push    word [my]
		pop     word [si + 2]
		sub     word [si + 2],99
		mov     word [si + 6], bx
		mov     word [si + 8], cx
		sub     word [si + 6], 159
		sub     word [si + 8], 99
		inc     word [pixel]

		add     di, 120
		push    word [mradius]
		push    word [mx]
		push    word [my]
		mov     word [mx], bx
		mov     word [my], cx
		shr     word [mradius], 1
		call    make2
		pop     word [my]
		pop     word [mx]
		pop     word [mradius]
		cmp     di, 360
	jb      m2loop
	popa
m2skip1:
	ret

;---------------------------------------------------
;flake()
;---------------------------------------------------
flake:
	cmp     word [zshift], -140
	jg      flskip1
	call    fadepal
flskip1:
	mov     ax, word [mseg]
	mov     word [vseg], ax
	mov     ax, word [nseg]
	mov     es, ax
	call    copyscreen

	xor     ax, ax
	mov     di, word [iter]
	shl     di, 1
	sub     ax, di
	mov     word [wgx], ax
	mov     word [wgy], 40
	mov     di, t1
	call    writegrz
	xor     si, si

	dloop1:
		mov     di, si
		mov     dx, si
		shl     di, 3
		shl     dx, 2
		add     di, dx
		add     di, lin2
		mov     ax, word [di]
		mov     word [c3x], ax
		mov     ax, word [di + 2]
		mov     word [c3y], ax
		mov     ax, word [di + 4];
		mov     word [c3z], ax
		call    conv3d

		mov     ax, word [c3x]
		mov     word [x1l], ax
		mov     ax, word [c3y]
		mov     word [y1l], ax
		mov     ax, word [di + 6]
		mov     word [c3x], ax
		mov     ax, word [di + 8]
		mov     word [c3y], ax
		mov     ax, word [di + 10]
		mov     word [c3z], ax
		test    word [zshift], 32768
		jnz     fskip2
		and     word [c3z], 10

	fskip2:
		call    conv3d
		mov     ax, word [c3x]
		mov     word [x2l], ax
		mov     ax, word [c3y]
		mov     word [y2l], ax
		call    line

		shr     word [x1l], 1
		shr     word [x2l], 1
		shr     word [y1l], 1
		shr     word [y2l], 1
		sub     word [x1l], 20
		sub     word [x2l], 20
		add     word [y1l], 100
		add     word [y2l], 100
		call    line

		add     word [x1l], 200
		add     word [x2l], 200
		call    line

		inc     si
		cmp     si, 726
	jne     dloop1

	call    vret

	mov     ax, word [nseg]
	mov     word [vseg], ax
	mov     ax, 0a000h
	mov     es, ax
	call    copyscreen
	ret

;---------------------------------------------------
;makeblob()
;---------------------------------------------------
makeblob:
	xor     si, si
	mnexty:
		xor     di, di
		mnextx:
			mov     ax, di
			sub     ax, 32
			imul    ax
			mov     word [temp1], ax
			mov     ax, si
			sub     ax, 32
			imul    ax
			add     word [temp1], ax
			fild    word [temp1]
			fsqrt
			fiadd   word [_1]
			fstp    dword [temp1]
			fild    word [_3500]
			fdiv    dword [temp1]
			frndint
			fistp   word [temp1]
			mov     ax, word [temp1]
			sub     ax, 109
			test    ax, 32768
			jz      mbskip3
			xor     ax, ax
		mbskip3:
			cmp     ax, 127
			jb      mbskip4
			mov     ax, 126
		mbskip4:      
			mov     bx, si
			shl     bx, 6
			add     bx, si
			add     bx, di
			mov     byte [bx + blob], al
			inc     di
			cmp     di, 65
		jne     mnextx
		inc     si
		cmp     si, 65
	jne     mnexty
	ret

;---------------------------------------------------
;writeblob(mx, my, es)
;---------------------------------------------------
writeblob:
	pusha
	xor     si, si
	wbloop1:
		xor     di, di
		wbloop2:
			mov     bx, si
			shl     bx, 6
			add     bx, si
			add     bx, di
			xor     cx, cx
			mov     cl, byte [bx + blob]
			mov     ax, word [mx]
			add     ax, si
			sub     ax, 32
			mov     word [px], ax
			mov     ax, word [my]
			add     ax, di
			sub     ax, 32      
			mov     word [py], ax
			call    getpixel

			add     cx, word [pc]
			cmp     cx, 189
			jb      wbskip1

			mov     cx, 189

		wbskip1:
			mov     word [pc], cx
			call    putpixel

			inc     di
			cmp     di, 65
		jne     wbloop2
		inc     si
		cmp     si, 65
	jne     wbloop1
	popa
	ret

calccolor:
	mov     word [temp1], di
	fild    word [temp1]
	fdiv    dword [_10666]
	fisub   word [_2]
	fstp    dword [currx]
	mov     word [temp1], si
	fild    word [temp1]
	fdiv    dword [_7692]
	fsub    dword [_1_3]
	fstp    dword [curry]
	mov     dword [realp], 0
	mov     dword [imagp], 0
	xor     ax, ax

	rep1:
		fld     dword [realp]
		fmul    dword [realp]
		fstp    dword [a2]
		fld     dword [imagp]
		fmul    dword [imagp]
		fstp    dword [b2]
		fld     dword [realp]
		fmul    dword [imagp]
		fimul   word [_2]
		fadd    dword [curry]
		fstp    dword [imagp]
		fld     dword [a2]
		fsub    dword [b2]
		fadd    dword [currx]
		fstp    dword [realp]
		inc     al
		cmp     al, 63
		jae     until1
		fld     dword [a2]
		fadd    dword [b2]
		frndint
		fistp   word [temp1]
		cmp     word [temp1], 8
		jae     until1
	jmp     short rep1
until1:
	dec     al
	ret

mandel:
	push    word [iseg]
	pop     es
	mov     si, 14800
	mal1:
		mov     di, 16000
		mal2:
			call    calccolor
			push    di
			push    si
			sub     di, 16000
			sub     si, 14800
			mov     bx, si
			shl     bx, 8
			add     bx, di

			mov     [es:bx], al
			mov     dx, 255
			sub     dx, di
			mov     bx, si
			shl     bx, 8
			add     bx, dx
			mov     [es:bx], al

			mov     bx, 255
			sub     bx, si
			shl     bx, 8
			add     bx, di
			mov     [es:bx], al

			mov     dx, 255
			sub     dx, di
			mov     bx, 255
			sub     bx, si
			shl     bx, 8
			add     bx, dx
			mov     [es:bx], al
			pop     si
			pop     di
			inc     di
			cmp     di, 16127
		jne     mal2
		inc     si
		cmp     si, 14928
	jne     mal1
	mov     cx, 10
	mallp0:
		push    cx
		xor     di, di
		mov     cx, 65535
		xor     bh, bh
		mallp:
			xor     ax, ax
			mov     al, [es:di - 1]
			mov     bl, [es:di + 256]
			add     ax, bx
			mov     bl, [es:di + 1]
			add     ax, bx
			mov     bl, [es:di - 256]
			add     ax, bx
			shr     ax, 2
			stosb
		loop    mallp
		pop     cx
	loop    mallp0
	ret 

calctunnel:
	push    word [rseg]
	pop     es
	mov     di, -128
	ctl1:
		mov     si, -128
		ctl2:
			or      di, di
			jz      cts1
			mov     word [j2], di
			jmp     short cts2
		cts1:
			mov     word [j2], 1
		cts2:
			or      si, si
			jz      cts3
			mov     word [i2], si
			jmp     short cts4
		cts3:
			mov     word [i2], 1
		cts4:             
			fild    word [i2]
			fimul   word [i2]
			fistp   word [temp1]
			fild    word [j2]
			fimul   word [j2]
			fiadd   word [temp1]
			fsqrt
			frndint
			fistp   dword [crad]
			shl     dword [crad], 18
			fild    dword [crad]
			call    ln
			fmul    dword [_0_1]
			call    exp
			fimul   word [_256]
			frndint
			fist    dword [crad]
			fmul    dword [_0_02]
			fsin
			fimul   word [_32]
			frndint
			fiadd   dword [crad]
			fistp   dword [crad]
			mov     eax, dword [crad]
			and     al, 255
			push    di
			add     di, 128
			shl     di, 8
			add     di, si
			add     di, 128
			stosb
			pop     di
			inc     si
			cmp     si,129
		jne     ctl2
		inc     di
		cmp     di, 129
	jne     ctl1
	push    word [aseg]
	pop     es
	mov     di, -128

	cctl1:
		mov     si, -128
		cctl2:
			or      di, di
			jz      ccts1
			mov     word [xx], di
			fild    word [xx]
			fstp    dword [xx]
			jmp     short ccts2
		ccts1:
			push    dword [_0_0001]
			pop     dword [xx]
		ccts2:
			or      si, si
			jz      ccts3
			mov     word [yy], si
			fild    word [yy]
			fstp    dword [yy]
			jmp     short ccts4
		ccts3:
			push    dword [_0_0001]
			pop     dword [yy]
		ccts4:
			fld     dword [yy]
			fabs
			fld     dword [xx]
			fabs
			fpatan
			fmul    dword [_40_7]
			frndint
			test    di, 32768
			jz      gskip1
			fimul   word [minus1]
		gskip1:
			test    si, 32768
			jz      gskip2
			fimul   word [minus1]
		gskip2:
			fistp   dword [temp]
			mov     eax, dword [temp]
			and     al, 255
			push    di
			add     di, 128
			shl     di, 8
			add     di, si
			add     di, 128
			stosb
			pop     di
			inc     si
			cmp     si, 129
		jne     cctl2
		inc     di
		cmp     di, 129
	jne cctl1
	ret

;---------------------------------------------------
;do_tunnel(radoff, angoff)
;---------------------------------------------------
do_tunnel:
	push    ds
	mov     di, 256
	mov     cx, 65024
	mov     ax, word [rseg]
	mov     es, ax
	mov     ax, word [aseg]
	mov     dx, ax
	mov     ax, word [iseg]
	mov     gs, ax
	mov     ax, word [nseg]
	mov     fs, ax 
	mov     ds, dx
	mov     dx, word [cs:radoff]

	tloop:
		mov     al, [es:di]
		add     ax, dx
		shl     ax, 8
		add     ax, word [cs:angoff]
		mov     si, ax
		xor     ax, ax
		mov     al, [ds:di]
		shl     ax, 1
		Add     si, ax
		mov     bl, [gs:si]
		pusha
		xor     dx, dx
		mov     ax, di
		mov     di, 256
		div     di
		mov     di, dx
		mov     dx, 320
		sub     ax, 28
		cmp     ax, 199
		ja      skip1
		mul     dx
		add     di, ax
		mov     [fs:di + 30], bl
	skip1:
		popa
		inc     di
		dec     cx
	jnz     tloop
	pop     ds
	ret

;------------------------------------------------
;maketree(alpha, mx, my, mradius)
;------------------------------------------------
maketree:
	mov     di, sp
	mov     ax, [ss:di + 2]
	mov     word [mradius], ax
	mov     ax, [ss:di + 4]
	mov     word [my], ax
	mov     ax, [ss:di + 6]
	mov     word [mx], ax
	mov     ax, [ss:di + 8]
	mov     word [alpha], ax
	pusha
	dec     word [iter]
	mov     cx, 1

	trl1:
		mov     ax, 15
		imul    cx
		add     ax, word [alpha]
		mov     word [angle], ax
		push    word [mx]
		push    word [my]
		push    word [angle]
		push    word [mradius]
		push    word [alpha]
		push    cx
		mov     di, word [angle]
		call    calc
		push    word [mx]
		pop     word [x1l]
		push    word [my]
		pop     word [y1l]
		push    bx
		pop     word [x2l]
		push    cx
		pop     word [y2l]
		xor     dx, dx
		mov     ax, word [iter]
		mov     si, 63
		div     si
		mov     word [pc], dx
		call    line
		cmp     word [mradius], 6
		jb      trs1
		push    word [angle]
		push    bx
		push    cx
		fild    word [mradius]
		fdiv    dword [_1_2]
		frndint
		fistp   word [mradius]
		push    word [mradius]
		call    maketree

	trs1:
		pop     cx
		pop     word [alpha]
		pop     word [mradius]
		pop     word [angle]
		pop     word [my]
		pop     word [mx]
		mov     ax, 15
		imul    cx
		push    word [alpha]
		pop     word [angle]
		sub     word [angle], ax
		push    word [mx]
		push    word [my]
		push    word [angle]
		push    word [mradius]
		push    word [alpha]
		push    cx
		mov     di, word [angle]
		call    calc
		push    word [mx]
		pop     word [x1l]
		push    word [my]
		pop     word [y1l]
		push    bx
		pop     word [x2l]
		push    cx
		pop     word [y2l]
		xor     dx, dx
		mov     ax, word [iter]
		mov     si, 63
		div     si
		mov     word [pc], dx
		call    line
		cmp     word [mradius], 6
		jb      trs2
		push    word [angle]
		push    bx
		push    cx
		fild    word [mradius]
		fdiv    dword [_1_2]
		frndint
		fistp   word [mradius]
		push    word [mradius]
		call    maketree
	trs2:
		pop     cx
		pop     word [alpha]
		pop     word [mradius]
		pop     word [angle]
		pop     word [my]
		pop     word [mx]
		inc     cx
		cmp     cx, 3
	jne     trl1
	popa
	mov     di, sp
	mov     ax, [di + 2]
	mov     word [mradius], ax
	mov     ax, [di + 4]
	mov     word [mx], ax
	mov     ax, [di + 6]
	mov     word [my], ax
	mov     ax, [di + 8]
	mov     word [alpha], ax
	pop     si
	pop     ax
	pop     ax
	pop     ax
	pop     ax
	push    si
	ret

drawtree:
	mov     word [bangle], 0
	mov     word [iter], 63
	mov     word [flag], 4
	push    word [tseg]
	pop     es
	push    270
	push    159
	push    140
	push    25
	call    maketree

	mov     word [x1l], 159
	mov     word [y1l], 140
	mov     word [x2l], 159
	mov     word [y2l], 190
	mov     word [pc], 63
	call    line
	call    smooth
	call    smooth
	mov     di, -20

	sphl1:
		mov     ax, di
		imul    ax
		mov     bx, 400
		sub     bx, ax
		mov     si, -20

		sphl2:
			mov     ax, si
			imul    ax
			mov     cx, bx
			sub     cx, ax
			test    cx, 32768
			jnz     sphs1
			mov     word [temp1], cx
			fild    word [temp1]
			fsqrt
			fimul   word [_63]
			fidiv   word [_20]
			frndint
			fistp   word [pc]
			cmp     word [pc], 64
			ja      sphs1
			mov     word [py], si
			mov     word [px], di
			add     word [py], 25
			add     word [px], 298
			add     word [pc], 190
			cmp     word [pc], 254
			jb      sphs2
			mov     word [pc], 253
		sphs2:
			call    putpixel
		sphs1:
			inc     si
			cmp     si, 21
		jne     sphl2
		inc     di
		cmp     di, 21
	jne     sphl1
	ret

include "gra.asm"
include "math.asm"
include "var.inc"
