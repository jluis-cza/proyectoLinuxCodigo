;************************************************************************
.386	;Directivas para invocar al
.387	;coprocesador.
;************************************************************************
title		GRAFICA DE LA RESPUESTA AL PASO DE UN CIRCUITO RLC PASA BAJO
;************************************************************************
include		mlc.asm
;************************************************************************
;			SEGMENTO DE PILA
;************************************************************************
pila		segment para stack 'stack'
			dw		300 dup(0)
pila		ends
;************************************************************************
;			SEGMENTO DE DATOS
;************************************************************************
datos		segment para 'data'
		d_res	label	byte			; para la resistencia 
		nmax_r	db		3
		nact_r	db		?
		num_r	db		3 dup(0)

		d_bob	label	byte			; para la bobina 
		nmax_b	db		3
		nact_b	db		?
		num_b	db		3 dup(0)

		d_cap	label	byte			; para el capacitor 
		nmax_c	db		3
		nact_c	db		?
		num_c	db		3 dup(0)

		; variables para dibujar fonts

		color	db	15
		fil_graf	dw	?
		p_x			dw	10	
		p_y			dw	10
		pxx0		dw	00
		pyy0		dw	00
		
		symbRes  db	00h,80h,00h,00h,01h,40h,00h,00h,01h,40h,00h,00h,02h
		        db  20h,00h,00h,02h,20h,00h,00h,04h,10h,00h,00h,04h,10h
				db  00h,00h,08h,08h,00h,00h,08h,08h,00h,00h,10h,04h,00h
				db  00h,10h,04h,00h,00h,20h,02h,00h,00h,20h,02h,00h,00h
				db  40h,01h,00h,00h,40h,01h,00h,00h,80h,00h,80h,00h,00h
				db  00h,40h,01h,00h,00h,40h,01h,00h,00h,20h,02h,00h,00h
				db  20h,02h,00h,00h,10h,04h,00h,00h,10h,04h,00h,00h,08h
				db  08h,00h,00h,08h,08h,00h,00h,04h,10h,00h,00h,04h,10h
				db  00h,00h,02h,20h,00h,00h,02h,20h,00h,00h,01h,40h,00h
				db  00h,01h,40h,00h,00h,00h,80h,00h,00h,00h,00h			
		symbBob1  db 03h,0C0h,07h,80h,0Ch,30h,18h,60h,08h,10h,10h,20h,10h
				  db 08h,20h,10h,10h,08h,20h,10h,20h,04h,40h,08h,20h,04h
				  db 40h,08h,20h,04h,40h,08h,40h,02h,80h,04h,40h,02h,80h
				  db 04h,40h,02h,80h,04h,80h,01h,00h,02h,80h,01h,00h,02h
				  db 80h,01h,00h,02h,80h,01h,00h,02h,80h,03h,80h,01h,00h
				  db 02h,80h,01h,00h,02h,80h,01h,00h,04h,40h,02h,00h,04h
				  db 40h,02h,00h,04h,40h,02h,00h,08h,20h,04h,00h,08h,20h
				  db 04h,00h,08h,20h,04h,00h,08h,20h,04h,00h,04h,10h,02h
				  db 00h,04h,10h,02h,00h,04h,10h,02h,00h,04h,10h,02h,00h
				  db 02h,20h,01h,00h,02h,20h,01h,00h,01h,0C0h,00h			
		symbBob2  db 03h,0C0h,07h,80h,0Ch,30h,18h,60h,08h,10h,10h,20h,10h
		          db 08h,20h,10h,10h,08h,20h,10h,20h,04h,40h,08h,20h,04h
				  db 40h,08h,20h,04h,40h,08h,40h,02h,80h,04h,40h,02h,80h
				  db 04h,40h,02h,80h,04h,80h,01h,00h,02h,80h,01h,00h,02h
				  db 80h,01h,00h,02h,80h,01h,00h,02h,0C0h,03h,80h,02h,40h
				  db 02h,80h,00h,40h,02h,80h,00h,20h,04h,40h,00h,20h,04h
				  db 40h,00h,20h,04h,40h,00h,10h,08h,20h,00h,10h,08h,20h
				  db 00h,10h,08h,20h,00h,10h,08h,20h,00h,08h,04h,10h,00h
				  db 08h,04h,10h,00h,08h,04h,10h,00h,08h,04h,10h,00h,10h
				  db 02h,20h,00h,10h,02h,20h,00h,0E0h,01h,0C0h,00h			
	
		Res		dw	0		; valor de Resistencia en [ohm]  	10[ohm]>=R<=24[ohm]
		L		dw	0		; valor de Bobina en [uH] 			1[uH]>=L<=60[uH]
		Cap		dw	0		; valor de capasitor en [nF]  		3[nF]>=Cap<=40[nF]

		wn		dd	0.0		; frecuencia natural no amortiguada 
		En		dd	0.0		; coeficiente de amortiguamiento
		En2		dd	0.0		; (En)^2
		En_1	dd	0.0		; (1-En^2)^(1/2)
		wd		dd	0.0		; wn*En_1
		exp		dd	0.0		; e^(En*Wn*t)
		tita	dd	0.0		; arctang(En_1/En)
		t		dw 	240		; tiempo maximo de datos
		
		can		dw	0		; variable auxiliar
		v1		dw	1000	; valor de 1k
		v2		dw	2		; constante 2
		;v3		dw	3		; constante 3
		;v4		dw	4		; constante 4
		v100	dd	10000000.0	; para escalar al valor de 10^-5
		;v180	dw	180			; para convertir a radianes
		seriet	dw	500 dup(0)	; valores para la variable t
		seriey	dw	500	dup(0)	; valores para la variable y
		
		escala	dw	260			; escala para los valores de y(t)
		
		desx	equ	40			; desplazamiento en el eje x
		desy	equ	460			; desplazamiento en el eje y
		
		esy0	db	'0$'		; escala de y
		esy1	db	'1$'		; escala de y
		esy2	db	'1.6$'		; escala de y
		esx1	db	'1$'		; escala de t
		esx2	db	'2$'		; escala de t
		esx3	db	'2.25$'		; escala de t
		esx		db	't[10^-5 s]$'	; escala de la variable t
		esy     db  'v_o(t)[V]$'
		t_R		db	'R$'
		t_L		db	'L$'
		t_C		db	'C$'
		titulo1  db  'CIRCUITO RLC PASA BAJOS$'
		footer  db   'ETN-903L$'
		vi		db	'v_i(t)$'
		vo		db	'v_o(t)$'		; titulo del eje y
		mensaje1 db 'INGRESE LOS VALORES PARA...$'
		t_vr	db	'R  (10[ohm]>=R<=24[ohm])=     [ohm]$'
		t_vl	db	'L    (1[uH]>=L<=60[uH]) =     [uH]$'
		t_vc	db	'C    (3[nF]>=C<=40[nF]) =     [nF]$'
		t_salir	db	'SALIR [S]$'	; mensaje para salis con la letra 'S'
		t_graf	db	'GRAFICAR RESPUESTA AL PASO UNITARIO [G]$'	; mensaje para graficar con la tetra 'G'
		t_rep	db	'REPETIR [R]$'		; mansaje para repetir la operacion con la letra 'R'
		
		
		;*********** datos de la recta por bresenham
		px0			dw	?			; coordenadas para el
		py0			dw	?			; primer punto
		px1			dw	?			; coordenadas para el 
		py1			dw	?			; segundo punto
		d_x			dw	?			; para la diferencia px1-px0
		d_y			dw	?			; para la diferencia py1-py0
		E			dw	?			; para el error
		dos			dw	2			; constante
		ix			dw	?			; es igual a 2*d_x
		iy			dw	?			; es igual a 2*d_y 
		
		col_graf    db  10
datos		ends
;************************************************************************
;			SEGMENTO DE CÓDIGO
;************************************************************************
codigo		segment	use16
programa	proc far
			assume	ss:pila,cs:codigo,ds:datos
			inicio	datoseg
	rep01:
			call	modo_g
			call	pagina1
	rep00:
			mov		ah,07
			int		21h
			cmp		al,'s'
			je		salir
			cmp		al,'g'
			jne		rep00
			call	funcion
			call	modo_g
			call	pagina2
			call	datos0
			call	recta
	rep02:
			mov		ah,07
			int		21h
			cmp		al,'r'
			je		rep01
			cmp		al,'s'
			jne		rep02
	salir:
			call	modo_t
			ret
programa	endp
;***************************************************
;		PAGINA 1 DEL PROGRAMA
;***************************************************
pagina1		proc
			
			marco0      4,10,10,629,40
			marco0      4,12,12,627,38
			marco0      4,10,439,629,469
			marco0      4,12,441,627,467
			marco0      4,10,50,629,429
			marco0      4,12,52,627,427

			PXY_write	30,1,titulo1
			PXY_write	38,28,footer
			
			dibuja      223,84,2,symbRes,32  ; Resistor
			dibuja      255,84,2,symbRes,32
			dibuja      351,84,2,symbBob1,32 ; Inductor
			dibuja      383,84,2,symbBob2,32
			l_horiz		2,440,150,480        ; Capacitor
			l_horiz		2,440,169,480 
			l_horiz		2,445,245,475        ; Ground
			l_horiz		2,450,250,470
			l_horiz		2,455,255,465
			
			l_horiz		2,180,100,223		; Conexiones
			l_horiz		2,287,100,352		; 
			l_horiz		2,414,100,513		; 
			l_vert		2,460,100,150		; 
			l_vert		2,460,170,245		; 
			
			PXY_write	32,4,t_r    ; Etiquetas
			Pxy_write	48,4,t_l	;
			Pxy_write	62,10,t_c	;
			PXY_write	64,7,vo		;
			PXY_write	16,7,vi		;

			PXY_write	4,17,mensaje1
			
			PXY_write	4,19,t_vr				;Valor de la 
			posi_cursor	31,19					;resistencia.
			conv_dec	d_res,num_r,nact_r,res	;
			PXY_write	4,20,t_vl				;Valor del
			posi_cursor	31,20					;inductor.
			conv_dec	d_bob,num_b,nact_b,L	;
			PXY_write	4,21,t_vc				;Valor del
			posi_cursor	31,21					;capacitor.
			conv_dec	d_cap,num_c,nact_c,Cap	;
			
			PXY_write	22,24,t_graf
			PXY_write	37,25,t_salir
			
			ret
pagina1		endp
;***************************************************
;		PAGINA 2 DEL PROGRAMA
;***************************************************
pagina2		proc
			marco0		4,40,20,520,460	; color,x1,y1,x2,y2
			marco0		4,38,18,522,462	; color,x1,y1,x2,y2
			mov			can,408			; genera la linea horizontal segmentada
	for10:
			marco1		1,41,can,519,7	; color,x1,y1,x2,ancho
			sub			can,52			; ancho
			cmp			can,20			; ultimo valor
			jg			for10
			mov			can,490			; genera la lineas vertical segmentada
	for11:
			marco2		1,can,21,463,6	;color,x1,y1,y2,ancho
			sub			can,50			; ancho
			cmp			can,40			; ultimo valor
			jg			for11
			
			PXY_write	68,22,t_salir  ; Mensajes.
			PXY_write	68,24,t_rep
			
			PXY_write	30,0,vo   ; Titulo de la grafica.
			
			PXY_write   2,0,esy   ; Etiqueta y escalas eje y. 
			PXY_write	3,29,esy0
			PXY_write	3,12,esy1
			PXY_write	2,2,esy2
			
			PXY_write	67,29,esx  ; Etiqueta y escalas eje x. 
			PXY_write	30,29,esx1
			PXY_write	55,29,esx2
			PXY_write	60,29,esx3
			ret
pagina2		endp
;***************************************************
;		GENERA LOS PUNTOS(x,y) DE LA FUNCION
;***************************************************
datos0		proc
			mov			cx,t				; numero de puntos a generar
			mov			si,0
			mov			ax,0
	SERXY1:
			mov			seriet[si],ax		; genera la seriet
			call		funcion0			; genera la seriey
			add			ax,1				; incremento del valor de seriet
			add			si,2
			loop		SERXY1
			ret
datos0		endp
;***************************************************
;		CALCULA LAS CONSTANTES wn,wd,En
;***************************************************
funcion		proc
			finit
			;*********** para Wn
			fld1					;
			fild		L			; L en [uH]
			fild		Cap			; Cap en [nF]
			fmulp		st(1),st 	; L*C		
			fdivp		st(1),st 	; 1/(L*C)
			push		cx
			mov			cx,5
		for20:
			fild		v1		 
			fmulp		st(1),st 	; 1k/(L*C)
			loop		for20
			pop			cx
			fsqrt					; (1/(L*C))^(1/2)
			fstp		wn			; wn = (1/(L*C))^(1/2) frecuencia natural no amortiguada
			;*********** para En
			fild		Cap			; cap en [nF]
			fild		L			; L en [uH]
			fdivp		st(1),st	; Cap[n]/L[u]
			fild		v1
			fdivp		st(1),st	; (Cap/L) unidades en [10^3]
			fsqrt					; (Cap/L)^0.5
			fild		Res
			fild		v2
			fdivp		st(1),st	; R/2
			fmulp		st(1),st	; (R/2)*((Cap/L)*10^3)^0.5
			fst			En			; E = (R/2)*(Cap/L)^0.5  coeficiente de amortiguamiento
			;*********** para En^2
			fld			En
			fmulp		st(1),st
			fst			En2			; En2 = E^2
			;************ para En_1
			fld1
			fsubrp		st(1),st
			fsqrt		
			fst			En_1		; En_1 = (1-E^2)^0.5
			;************ para Wd = Wn* En_1
			fld			Wn
			fmulp		st(1),st
			fstp		Wd			; Wd = Wn*(1-E^2)^0.5
			ret
funcion		endp
;***************************************************
;		Para la funcion y(t)
;***************************************************
funcion0	proc
			finit
			;************ para arctg
			fld			En_1			; En_1 = (1-E^2)^0.5
			fld			En				; En = (R/2)*(Cap/L)^0.5
			fpatan						
			fst			tita			; arctang (En_1/En)
			;************ para sin
			fld			wd				; wd = wn*(1-En^2)^0.5
			fild		seriet[si]		; t
			fld			v100
			fdivp		st(1),st		; escalando t en 10^-5
			fmulp		st(1),st		; Wd*t
			faddp		st(1),st		; alfa = Wd*t + arctang(En_1/En)
			fldpi						; pi
			fild		v2				; 2
			fdivp		st(1),st		; 
			fsubp		st(1),st		; alfa - pi/2
			fsin						; cos(alfa - pi/2) = sin(alfa) 
			;*********** para exponente
			fld			En			; E
			fld			Wn			; Wn
			fld			v100
			fdivp		st(1),st
			fmulp		st(1),st	; E*Wn
			fldl2e	
			fmulp		st(1),st	; (E*Wn)*log2(e)
			f2xm1
			fld1
			faddp		st(1),st	; e^(E*Wn)
			fst			exp
			push		cx
			mov			cx,seriet[si]
			cmp			cx,0
			je			exp0
	exp1:
			fld			exp
			fmulp		st(1),st		
			loop		exp1
	exp0:
			fld			exp
			fdivp		st(1),st	; e^(E*Wn*t)
			pop			cx
			fld			En_1
			fmulp		st(1),st	; En_1*e^(E*Wn*t) 
			fdivp		st(1),st	; sin(alfa)/(En_1*e^(E*Wn*t))
			fld1
			fsubrp		st(1),st	; 1-((e^-(E*Wn*t))/En_1)*sin(alfa)
			fild		escala		
			fmulp		st(1),st	; escalamos el valor
			frndint					; redondeamos
			fistp		seriey[si]	; guadamos en y(t) 
			fild		seriet[si]	;
			fild		v2		
			fmulp		st(1),st	; escalamos t
			fistp		seriet[si]	; guardamos t
			ret
funcion0 	endp
;***************************************************
;		RECTA
;***************************************************
recta		proc
			mov		si,0				;inicializamos puntero para graficar la funcion
	graf_rec:
			mov		cx,seriet[si]		;para los primero valores
			mov		dx,seriey[si]	; de las series
			mov		px0,cx				;obtenemos las coordenadas
			mov		py0,dx				;inferires p(x0,y0)
			add		si,2
			mov		cx,seriet[si]
			mov		dx,seriey[si]
			mov		px1,cx				;obtenemos las coordenadas 
			mov		py1,dx				;superiores p(x1,y1)
			call	bresen				;hacemos el algoritmo de bresenham para una recta
			mov		ax,2
			mul		t
			sub		ax,2
			cmp		si,ax				
			jne		graf_rec
			ret
recta		endp
;***************************************************
;		ALGORITMO DE BRESENHAM PARA LA RECTA
;***************************************************
bresen		proc
			resta	px1,px0,d_x			;dx=x1-x0
			resta	py1,py0,d_y			;dy=y1-y0
			multi	d_x,dos,ix			;ix=2*dx
			multi	d_y,dos,iy			;iy=2*dy
			resta	iy,d_y,E			;E=iy-dx
			
			comMa	d_y,0,posi
			mov		ax,d_y
			neg		ax
			cmp		d_x,ax				;dx>dy
			jl		menor0
			call	menor1
			jmp		reto
	menor0:
			call	menor2
			jmp		reto
	posi:
			comMe	d_x,d_y,mayor		;vemos si dx>dy
			call	may1				;realiza el algoritmo de bresen para 0<m<1
			jmp		reto
	mayor:
			call	may2				;realiza el algoritmo de bresen para m>1
	reto:
			ret
bresen		endp
;----------------------------------------
may1		proc
	otroo:
			comMa	px0,px1,re
			punto	col_graf
			comMe	E,0,otroo1
			inc		py0
			resta	E,ix,E
	otroo1:
			suma	E,iy,E
			inc		px0
			jmp		otroo
	re:
			ret
may1		endp
;----------------------------------------
may2		proc
	otroo2:
			comMa	py0,py1,re1			
			punto	col_graf
			comMe	E,0,otroo3
			inc		px0
			resta	E,iy,E
	otroo3:
			suma	E,ix,E
			inc		py0
			jmp		otroo2
	re1:
			ret
may2		endp
;----------------------------------------
menor1		proc
	otroo4:
			comMa	px0,px1,re2
			punto	col_graf
			comMa	E,0,otroo5
			dec		py0
			suma	E,ix,E
	otroo5:
			suma	E,iy,E
			inc		px0
			jmp		otroo4
	re2:
			ret
menor1		endp
;----------------------------------------
menor2		proc
	otroo6:
			comMe	py0,py1,re3
			punto	col_graf
			comMa	E,0,otroo7
			inc		px0
			resta	E,iy,E
	otroo7:
			resta	E,ix,E
			dec		py0
			jmp		otroo6
	re3:
			ret
menor2		endp
;***************************************************
;		MODO GRAFICO
;***************************************************
modo_g	proc
			mov			ah,0	;Modo gráfico.
			mov			al,12h	;640x480
			int			10h		
			ret
modo_g	endp
;***************************************************
;		MODO TEXTO
;***************************************************
modo_t	proc
			mov			ah,0h	;Modo texto.
			mov			al,3h	;80X25
			int			10h	
			ret
modo_t	endp
;***************************************************
;       DIBUJA UN PIXEL
;***************************************************
pixel   	proc
			push		bx
        	mov     	ah,0ch
        	mov     	bh,0          ;pagina 0
        	int     	10h
			pop			bx
        	ret
pixel   	endp
;***************************************************
;       DIBUJO DE fil_graf X 32 pixeles 
;***************************************************
dibujo		proc
			mov		cx,fil_graf
			mov		dx,pyy0
			mov		p_y,dx;161;pyy0
	s3:
			mov		dx,pxx0
			mov		p_x,dx;73;pxx0
			push	cx
			mov		cx,4
	s2:
			push	cx
			mov		cx,8
			mov		al,[si]
	s1:
			push	cx
			shl		al,1
			jnc		s0
			push	ax
			mov		al,color
			mov		cx,p_x
			mov		dx,p_y
			push	bx
			call	pixel
			pop		bx
			pop		ax
	s0:
			inc		p_x
			pop		cx
			loop	s1
			pop		cx
			inc		si
			loop	s2
			inc		p_y
			pop		cx
			loop	s3
			ret
dibujo		endp
;************************************
codigo		ends
			end			programa