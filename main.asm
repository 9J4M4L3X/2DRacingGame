.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

INCLUDE Configuration.inc
INCLUDE setup.inc

.data?
	 current_position BYTE ?
	 vertical_positionB BYTE ?
	 vertical_positionC BYTE ?
	 barrier_position BYTE ?
	 coin_position BYTE ?
	 delay_speed BYTE ?
	 lifes BYTE ?
	 coins BYTE ?
	 hit_barrier BYTE ?
	 hit_coin BYTE ?
	 coin_deleted BYTE ?
	 freq_delay BYTE ?
.data
	 Msg1 BYTE " - LIFES",13,10,0
	 Msg2 BYTE " - COINS",13,10,0
	 Msg3 BYTE "GAME OVER!",13,10,0
	 Msg4 BYTE " coins collected",13,10,0
	 Msg5 BYTE "Press ENTER to play again!",13,10,0

.code
    main proc
	

;variables initialization
init:
	mov ebx, 0

	mov current_position, 1
	mov coin_position, 0
	mov delay_speed, DelaySpeedConst
	mov lifes, 3
	mov coins, 0
	mov hit_barrier, 0
	mov hit_coin, 0
	mov coin_deleted, 0
	mov freq_delay, FreqDelay

	mov ecx, 1
	call Randomize
	mov  eax, 3
	call RandomRange

	;sets barrier & coin random position
	mov barrier_position, al
	call Randomize
	mov  eax, 2
	call RandomRange
	inc eax
	add al, barrier_position
	.IF(eax > 2)
		sub eax, 3
	.ENDIF
	mov coin_position, al

	;sets barrier & coin random vertical position
	sub eax, 5
	sub al, freq_delay
	.IF(al & cl)
		mov vertical_positionB, al
		mov vertical_positionC, 0
	.ELSE
		mov vertical_positionC, al
		mov vertical_positionB, 0
	.ENDIF	

start:
	
	;sets ecx counter at 0
	mov ecx, 0

	;calling procedures to draw initial score and lines
	INVOKE UpdateScore, ADDR Msg1, lifes, ADDR Msg2, coins
	INVOKE WriteLineV, 0,VerticalLineChar
	INVOKE WriteLineV, 26,VerticalLineChar
	INVOKE WriteLineV, 53,VerticalLineChar
	INVOKE WriteLineV, 79,VerticalLineChar
	INVOKE WriteLineH, 2, HorizontalLineChar1
	INVOKE WriteLineH, 29, HorizontalLineChar2

	.WHILE(1)		

		;draws objects at initial positions

		INVOKE DrawBarrier, barrier_position, vertical_positionB, 219
		.IF(!hit_coin)
			INVOKE DrawCoin, coin_position, vertical_positionC, 219
		.ENDIF
		INVOKE DrawCar, current_position, 219

		LookForKey:	
		
			;checks if counter reached delay_speed value 
			;if true moves barrier & coin one Y cordinate down, else increments ecx counter
			.IF (cl > delay_speed)
				
				;moves coin down if not hit, else deletes it
				.IF(hit_coin && !coin_deleted)
					INVOKE DrawCoin, coin_position, vertical_positionC, 32
					mov vertical_positionC, 28
					mov coin_deleted, 1
				.ELSEIF(!hit_coin)
					INVOKE CoinRow, coin_position, vertical_positionC, 32
					add vertical_positionC, 4
					INVOKE CoinRow, coin_position, vertical_positionC, 219
					sub vertical_positionC, 3
				.ELSE
					inc vertical_positionC
				.ENDIF
				.IF(hit_coin)
					INVOKE DrawCar, current_position, 219
				.ENDIF

				;moves barrier down, if hit draws car over it
				INVOKE BarrierRow, barrier_position, vertical_positionB, 32
				add vertical_positionB, 2	
				INVOKE BarrierRow, barrier_position, vertical_positionB, 219
				dec vertical_positionB				
				.IF(hit_barrier)
					INVOKE DrawCar, current_position, 219
				.ENDIF
				
				;INVOKE DrawCar, current_position, 219
				mov ecx, 0
			.ELSE
				inc ecx
			.ENDIF

			mov al, barrier_position

			;checks if barrier reached end of console
			.IF(vertical_positionB == 29)
				
				;updates delay_speed & freq_delay
				.IF(delay_speed > DelaySpeedMinimum)
					dec delay_speed
				.ENDIF
				.IF(freq_delay > 0)
					dec freq_delay
				.ENDIF

				;sets new random barrier coordinates
				call Randomize
				mov  eax, 6
				call RandomRange
				sub eax, 5
				sub al, freq_delay
				mov vertical_positionB, al

				call Randomize
				mov  eax, 2
				call RandomRange
				inc eax
				add al, coin_position
				.IF(eax > 2)
					sub eax, 3
				.ENDIF
				mov hit_barrier, 0
				mov barrier_position, al

			;updates and checks score
			.ELSEIF(vertical_positionB > 14 && vertical_positionB < 23 && current_position == al && hit_barrier == 0)
				dec lifes
				INVOKE UpdateScore, ADDR Msg1, lifes, ADDR Msg2, coins
				.IF(lifes == 0)
					jmp game_over
				.ENDIF
				mov hit_barrier, 1
			.ENDIF

			mov al, coin_position

			;checks if coin reached end of console
			.IF(vertical_positionC == 29)
				
				mov coin_deleted, 0

				;sets new random coin coordinates
				call Randomize
				mov  eax, 6
				call RandomRange
				sub al, 6
				sub al, freq_delay
				mov vertical_positionC, al

				call Randomize
				mov  eax, 2
				call RandomRange
				inc eax
				add al, barrier_position
				.IF(eax > 2)
					sub eax, 3
				.ENDIF
				mov hit_coin, 0
				mov coin_position, al

			;updates score
			.ELSEIF(vertical_positionC > 12 && vertical_positionC < 23 && current_position == al && hit_coin == 0)
				inc coins
				mov hit_coin, 1
				INVOKE UpdateScore, ADDR Msg1, lifes, ADDR Msg2, coins
			.ENDIF

			;waits for key to be pressed
            mov  eax, ButtonPollingTime
		    call Delay
			call ReadKey
			jz   LookForKey

			;if key pressed, updates car position
		    .IF (DL == VK_RIGHT && current_position != 2)
				INVOKE DrawCar, current_position, 32
				mov al, current_position
				inc al
				mov current_position, al
				INVOKE DrawCar, current_position, 219
		    .ELSEIF (DL == VK_LEFT && current_position != 0)
				INVOKE DrawCar, current_position, 32
				mov al, current_position
				dec al
				mov current_position, al
				INVOKE DrawCar, current_position, 219
		    .ENDIF 
	.ENDW

;writes game over message and asks to play again
game_over:
	call Clrscr

	mov  eax, white
    call SetTextColor
	
	mov edx, OFFSET Msg3
	call WriteString
	mov al, coins
    call WriteDec
	mov edx, OFFSET Msg4
	call WriteString
	mov edx, OFFSET Msg5
	call WriteString

;waits for 'ENTER'
wait_enter:
	mov  eax, ButtonPollingTime
	call Delay
	call ReadKey
	jz wait_enter

	.IF (DL == 13)
		call Clrscr
		jmp init
	.ELSE
		jmp wait_enter
	.ENDIF

    main endp
END main