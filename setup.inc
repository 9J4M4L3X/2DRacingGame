INCLUDE Irvine32.inc

;draws vertical line
WriteLineV PROTO,
		xcoord:BYTE,
		char:BYTE

;draws horizontal line
WriteLineH PROTO,
		ycoord:BYTE,
		char:BYTE

;draws car, position (0->left, 1->center, 2->right)
DrawCar PROTO,
		position:BYTE,
		char:BYTE

;draws barrier, position (0->left, 1->center, 2->right), positionV (Y coordinate)
DrawBarrier PROTO,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

;draws coin, position (0->left, 1->center, 2->right), positionV (Y coordinate)
DrawCoin PROTO,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

;draws score at the top
UpdateScore PROTO,
		Msg1:PTR BYTE,
		lifes:BYTE,
		Msg2:PTR BYTE,
		coins:BYTE

;draws one coin row
CoinRow PROTO,
		position:BYTE,
		positionV:BYTE,
		char:BYTE

;draws one barrier row
BarrierRow PROTO,
		position:BYTE,
		positionV:BYTE,
		char:BYTE