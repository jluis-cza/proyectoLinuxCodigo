;************************************************************************
;		MACROS
;************************************************************************
;****************************************************
;		INICIO
;****************************************************
inicio		macro	datoseg
			push	ds
			sub		ax,ax
			push	ax
			mov		ax,datos
			mov		ds,ax
			mov		es,ax
			endm
;****************************************************
;		DIBUJA
;****************************************************
dibuja		macro	px0,py0,colour,fuente,filagraf
			mov		pxx0,px0
			mov		pyy0,py0
			mov		color,colour
			lea		si,fuente
			mov     fil_graf,filagraf
			call	dibujo
			endm
;****************************************************
;		DIBUJA LINEAS HORIZONTALES 
;****************************************************
l_horiz		macro	color,x1,y1,x2
			local	rep1
			mov		ah,0ch
			mov		al,color
			mov		dx,y1
			mov		cx,x1
	rep1:
			int		10h
			inc		cx
			cmp		cx,x2
			jne		rep1
			endm
;****************************************************
;		DIBUJA LINEAS VERTICALES
;*****************************************************
l_vert		macro	color,x1,y1,y2
			local	rep1
			mov		ah,0ch
			mov		al,color
			mov		dx,y1
			mov		cx,x1
	rep1:
			int		10h
			inc		dx
			cmp		dx,y2
			jne		rep1
			endm
;****************************************************
;		EXCIBE MENSAJES 
;****************************************************
PXY_write	MACRO	X,Y,mensaje
			mov		ah,15
			int 	10h
			mov		dh,Y
			mov		dl,X
			mov		ah,2				; posicionar el cursor
			int		10h
			lea		dx,mensaje			; imprimir en pantalla un mensaje
			mov		ah,09h
			int		21h
			ENDM
;****************************************************
;		POSICIONA EL CURSOR
;****************************************************
posi_cursor	MACRO	X,Y
			mov		ah,15
			int 	10h
			mov		dl,X
			mov		dh,Y
            mov     ah,02
			mov		bh,00
            int     10h
			ENDM
;****************************************************
;		CONVIERTE DE ASCII A BINARIO
;****************************************************
conv_dec	MACRO	variable0,valor0,cantidad,variable
			LOCAL	salt1
			mov 		ah,0AH
			lea 		dx,variable0			;recibe la cadena y lo guarda
			int 		21h
			mov		si,0
			mov		ax,0
			and 	valor0[si],0fh
			and 	valor0[si+1],0fh
			cmp		cantidad,1
			je		salt1
			mov		al,10
			mul		valor0[si]
			inc		si
	salt1:
			add		al,valor0[si]	
			mov		variable,ax
			ENDM
;****************************************************
;		GENERA LOS BORDES DE UN RECTANGULO
;****************************************************
marco0		macro	color,x1,y1,x2,y2
			local	rep1,rep2,rep3,rep4
			mov		ah,0ch				; para dibujar un pixel en pantalla
			mov		al,color			; color
			mov		dx,y1				; posicion vertical
			mov		cx,x1				; posicion horizontal
	rep1:
			int		10h
			inc		cx
			cmp		cx,x2
			jne		rep1
	rep2:
			int		10h
			inc		dx
			cmp		dx,y2
			jne		rep2
	rep3:
			int		10h
			dec		cx
			cmp		cx,x1
			jne		rep3
	rep4:
			int		10h
			dec		dx
			cmp		dx,y1
			jne		rep4
			endm
;****************************************************
;		LINEA HORIZONTAL SEGMENTADA
;****************************************************
marco1		macro	color,x1,y1,x2,ancho
			local	rep0,rep1
			mov		bx,ancho
			mov		ah,0ch
			mov		al,color
			mov		dx,y1
			mov		cx,x1
	rep0:
			int		10h
			inc		cx
			dec		bx
			cmp		bx,0
			jne		rep1
			mov		bx,ancho
			add		cx,ancho
	rep1:
			cmp		cx,x2
			jle		rep0
			endm
;****************************************************
;		LINEA VERTICAL SEGMENTADA
;****************************************************
marco2		macro	color,x1,y1,y2,ancho
			local	rep0,rep1
			mov		bx,ancho
			mov		ah,0ch
			mov		al,color
			mov		dx,y1
			mov		cx,x1
	rep0:
			int		10h
			inc		dx
			dec		bx
			cmp		bx,0
			jne		rep1
			mov		bx,ancho
			add		dx,ancho
	rep1:
			cmp		dx,y2
			jle		rep0
			endm
;****************************************************
;		PARA BRESEMHAM
;****************************************************
;****************************************************
suma		macro		valor1,valor2,resultado
			mov			ax,valor1
			add			ax,valor2
			mov			resultado,ax
			endm
;****************************************************
resta		macro		valor1,valor2,resultado
			mov			ax,valor1
			sub			ax,valor2
			mov			resultado,ax
			endm
;****************************************************
multi		macro		valor1,valor2,resultado
			mov			ax,valor1
			mul			valor2
			mov			resultado,ax
			endm
;****************************************************
punto		macro		color
			mov			ax,desx
			mov			cx,px0
			add			cx,ax
			mov			ax,desy
			mov			dx,py0
			sub			dx,ax
			neg			dx
			mov			al,color
			call		pixel
			endm
;****************************************************
comMa		macro		valor1,valor2,salto
			mov			ax,valor1
			cmp			ax,valor2
			jg			salto
			endm
;****************************************************
comMe		macro		valor1,valor2,salto
			mov			ax,valor1
			cmp			ax,valor2
			jl			salto
			endm


			