INCLUDE Configuration.inc
INCLUDE setup.inc

.code

WriteLineV PROC,
		xcoord:BYTE,
		char:BYTE

	mov  eax,white
    call SetTextColor

	mov dl, xcoord
	mov dh, 3
	mov  al, char
	  
	.WHILE(dh < ConsoleYMax)
		call Gotoxy
		call WriteChar
		inc dh

		call Gotoxy
		call WriteChar
		inc dh

		call Gotoxy
		mov al, 32
		call WriteChar
		inc dh
		mov al, char
	.ENDW

	ret
WriteLineV ENDP

WriteLineH PROC,
		ycoord:BYTE,
		char:BYTE

	mov  eax,white
    call SetTextColor

	mov dl, 0
	mov dh, ycoord
	mov  al, char

	.WHILE(dl < ConsoleXMax)
		call Gotoxy
		call WriteChar
		inc dl

		call Gotoxy
		call WriteChar
		inc dl
	.ENDW

	ret
WriteLineH ENDP

DrawCar PROC,
		position:BYTE,
		char:BYTE

	mov  eax,gray
    call SetTextColor

	mov eax, 27
	mul position
	add eax, 7
	mov dl, al
	mov dh, 16

	mov cl,0
	mov ch,0

	mov al, char

	.WHILE(cl < 7)
		inc cl
		.WHILE(ch < 10)
			inc ch
			inc dl
			call Gotoxy
			call WriteChar
		.ENDW
		mov ch,0
		sub dl, 10 
		inc dh
	.ENDW

	ret
DrawCar ENDP

DrawBarrier PROC,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

	mov  eax, lightCyan
    call SetTextColor

	mov eax, 26
	mul position
	add eax, 2
	mov dl, al
	mov dh, positionV

	mov cl,0
	mov ch,0

	mov al, char

	.WHILE(cl < 2)
		inc cl
		push edx
		.WHILE(ch < 22 && dh > 2 && dh < 29)
			inc ch
			inc dl
			call Gotoxy
			call WriteChar
		.ENDW		
		pop edx
		mov ch,0
		inc dh
	.ENDW

	ret
DrawBarrier ENDP

DrawCoin PROC,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

	mov  eax, brown
    call SetTextColor

	mov eax, 27
	mul position
	add eax, 5
	mov dl, al
	mov dh, positionV

	mov cl, 0
	mov ch, 0

	mov al, char

	.WHILE(cl < 4)
		inc cl
		push edx
		.WHILE(ch < 14 && dh > 2 && dh < 29)
			inc ch
			inc dl
			call Gotoxy
			call WriteChar
		.ENDW
		pop edx
		mov ch,0
		inc dh
	.ENDW

	ret
DrawCoin ENDP

UpdateScore PROC,
		Msg1:PTR BYTE,
		lifes:BYTE,
		Msg2:PTR BYTE,
		coins:BYTE

	mov eax,white
	call SetTextColor

	mov dl, 0
	mov dh, 0
	call Gotoxy
	mov  eax, 0
	mov al, lifes
	call WriteDec
	mov edx, Msg1
	call WriteString
	mov al, coins
	call WriteDec
	mov edx, Msg2
	call WriteString
	ret
UpdateScore ENDP


CoinRow PROC,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

	mov  eax, brown
    call SetTextColor

	mov eax, 27
	mul position
	add eax, 5
	mov dl, al
	mov dh, positionV

	mov al, char
	mov ch, 0

	.WHILE(ch < 14 && dh > 2 && dh < 29)
		inc ch
		inc dl
		call Gotoxy
		call WriteChar
	.ENDW

	ret
CoinRow ENDP

BarrierRow PROC,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

	mov  eax, lightCyan
    call SetTextColor

	mov eax, 26
	mul position
	add eax, 2
	mov dl, al
	mov dh, positionV

	mov al, char
	mov ch, 0

	.WHILE(ch < 22 && dh > 2 && dh < 29)
		inc ch
		inc dl
		call Gotoxy
		call WriteChar
	.ENDW

	ret
BarrierRow ENDP

END