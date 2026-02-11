
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ PIXELS_SQUARE,     10


.globl main

main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------
//

	movz x10, 0x00, lsl 16
	movk x10, 0x00FF, lsl 00
	mov x1, 0
	mov x2, 0
	mov x3, 640
	mov x4, 480
	BL drawBigSquare
	
	mov x1, 180						//Sets where the Jake will be placed
	mov x2, 125
    BL jakefigureB
	//---------------------------------------------------------------

	B InfLoop

drawSquaredCircle:					// Procedure takes coordinates and dimensions to draw "circles" 
	sub sp, sp, 32					// Substracts from sp to store original values of registers
	stur x1, [sp, 24]
	stur x2, [sp, 16]
	stur x3, [sp, 8]
	stur x4, [sp, 0]
	mov x19, x30
loop9:
	BL drawBigSquare				// Draws a square of x3 and x4, x3 = width, x4 = height
	sub x4, x4, 2					// Substracts from y dimention of the bigSquares
	add x3, x3, 2					// Increments from x dimention of bigSquares
	add x1, x1, 10					// Increases y coordinate to draw the next square
	sub x2, x2, 10					// Substracts x coordinate to draw the next square
	subs xzr, x4, 1					// Sets flags to know if the cilcle has already been drawn
	B.GT loop9						// If not the continues the process
	ldur x1, [sp, 24]				// If it has, then restores the values of the previously stored registers
	ldur x2, [sp, 16]
	ldur x3, [sp, 8]
	ldur x4, [sp, 0]
	add sp, sp, 32
	BR x19

drawBigSquare:						// Procedure takes coordinates to draw a big square by drawing x4 horizontal lines of x3 squares
	sub sp, sp, 16
	stur x1, [sp, 8]
	stur x2, [sp, 0]
	mov x18, x4
	mov x17, x30
loop8:
	BL drawHLine
	add x1, x1, 10					// Increases y coordinate to draw the next line
	sub x18, x18, 1					// Substracts row counter
	cbnz x18, loop8
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	add sp, sp, 16
	BR x17

drawDiagonalDULine:					// Procedure takes coordinates and draws a diagonal line from down to up, like an increasing linear function
	sub sp, sp, 16
	stur x1, [sp, 8]
	stur x2, [sp, 0]
	mov x14, x3
	mov x15, PIXELS_SQUARE
	mov x16, x30
loop7:
	BL drawSquare
	add x2, x2, 10					// Increments x coordinate and decreases y coordinate to draw the next square in a diagonal from 
	sub x1, x1, 10
	sub x14, x14, 1
	cbnz x14, loop7
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	add sp, sp, 16
	BR x16

drawDiagonalUDLine:					// Procedure takes coordinates and draws a diagonal line from up to down, like a decreasing linear function
	sub sp, sp, 16
	stur x1, [sp, 8]
	stur x2, [sp, 0]
	mov x14, x3
	mov x16, x30
loop6:
	BL drawSquare
	add x2, x2, 10					// Increments both coordinates fot the next square to draw the next square in a diagonal form
	add x1, x1, 10
	sub x14, x14, 1
	cbnz x14, loop6
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	add sp, sp, 16
	BR x16

drawHLine:							// Procedure takes coordinates and draws a Vertical line of squares
	sub sp, sp, 16					// Substracts from sp to save two registers
	stur x1, [sp, 8]				// Saves the registers
	stur x2, [sp, 0]
	mov x14, x3						// Saves content from x3 in x14 so it doesnt modify the original value, usefun for creating shapes with less code
	mov x16, x30					// Saves the return addres because x30 will be modified by BL drawSquare
loop5:
	BL drawSquare					// Draws the square
	add x2, x2, 10					// Increments y coordinate by 10 to draw the next square next to the previous square
	sub x14, x14, 1					// substracts the square counter
	cbnz x14, loop5					// Go to loop 5 if not zero
	ldur x1, [sp, 8]				// Restores the registers previously saved
	ldur x2, [sp, 0]			
	add sp, sp, 16					// Incrememts sp to original value
	mov x0, x20						// Restores to x0 the addres of the first pixel
	BR x16

drawVLine:							// Procedure takes coordinates and draws a Vertical line of squares
	sub sp, sp, 16					// Substracts from sp to save two registers
	stur x1, [sp, 8]				// Saves the registers
	stur x2, [sp, 0]
	mov x14, x3						// Saves content from x3 in x14 so it doesnt modify the original value, usefun for creating shapes with less code		
	mov x16, x30					// Saves the return addres because x30 will be modified by BL drawSquare
loop4:
	BL drawSquare					// Draws the square
	add x1, x1, 10					// Increments y coordinate by 10 to draw the next square below the previous square
	sub x14, x14, 1					// Substracts the square counter
	cbnz x14, loop4					// Go to loop 4 if not zero
	ldur x1, [sp, 8]				// Restores the registers previously saved
	ldur x2, [sp, 0]				
	add sp, sp, 16					// Increments sp to restore its original value
	mov x0, x20						// Restores to x0 the address of the first pixel
	BR x16


drawSquare:							// Procedure takes start coordinates in x1 and x2
	sub sp, sp, 16
	stur x1, [sp, 8]
	stur x2, [sp, 0]
	mov x11, PIXELS_SQUARE			// Size of each square
	mov x12, SCREEN_WIDTH			// Screen Width
	mul x9, x1, x12				
	add x9, x9, x2
	lsl x9, x9, 2
	add x0, x20, x9					// Sets the direction of the first pixel to be coloured
loop3:
	mov x13, PIXELS_SQUARE			// Size of each square
loop2:
	stur x10, [x0]					// Sets colour of Pixel					
	add x0, x0, 4					// Next pixel
	sub x13, x13, 1					// Decrement x counter
	cbnz x13, loop2					// If not end row then jump
	add x1, x1, 1					// Increments Row counter
	mul x9, x1, x12					// nextPixel = startPoint + (4*(x + (y * 640)))
	add x9, x9, x2
	lsl x9, x9, 2
	add x0, x20, x9
	sub x11, x11, 1					// Decrement y counter
	cbnz x11, loop3					// If not last row jump
	mov x0, x20						// Returns to x0 its original value
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	add sp, sp, 16
	BR x30

jakefigureB:
	sub sp, sp, 24
	stur x30, [sp, 16] 
	stur x1, [sp, 8]
	stur x2, [sp, 0]

	movz x10, 0xFE, lsl 16				// Sets the yelow color for the drawing
	movk x10, 0xEB3B, lsl 0
	sub x1, x1, 120
	mov x3, 34
	mov x4, 50
	BL drawBigSquare
	sub x1, x1, 30
	add x2, x2, 30
	mov x3, 28
	mov x4, 3
	BL drawBigSquare
	add x1, x1, 20
	sub x2, x2, 10
	mov x3, 30
	mov x4, 1
	BL drawBigSquare
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	sub x1, x1, 90
	sub x2, x2, 30
	mov x3, 40
	mov x4, 9
	BL drawBigSquare
	mov x3, 38
	sub x1, x1, 10
	add x2, x2, 10
	BL drawHLine

	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 0
	mov x3, 30							// starts drawing the outline
	BL drawVLine
	sub x2, x2, 20
	mov x3, 3
	BL drawHLine
	sub x1, x1, 20
	sub x2, x2, 20
	BL drawDiagonalUDLine
	sub x1, x1, 60
	mov x3, 6
	BL drawVLine
	mov x3, 8
	BL drawDiagonalDULine
	sub x1, x1, 80
	add x2, x2, 80
	mov x3, 25
	BL drawHLine
	add x2, x2, 250
	mov x3, 8
	BL drawDiagonalUDLine
	add x1, x1, 80
	add x2, x2, 80
	mov x3, 7
	BL drawVLine
	add x1, x1, 80
	sub x2, x2, 20
	mov x3, 3
	BL drawDiagonalDULine
	sub x2, x2, 20
	mov x3, 3
	BL drawHLine
	mov x3, 30
	BL drawVLine
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	mov x3, 3
	BL drawDiagonalDULine
	sub x1, x1, 40
	add x2, x2, 20
	BL drawVLine
	mov x3, 29
	BL drawHLine
	add x2, x2, 290
	mov x3, 3
	BL drawVLine
	add x1, x1, 20
	BL drawDiagonalUDLine
	add x1, x1, 150
	sub x2, x2, 40
	mov x3, 2
	BL drawVLine
	add x1, x1, 20
	sub x2, x2, 10
	mov x3, 15
	BL drawVLine
	sub x2, x2, 40
	BL drawVLine
	sub x2, x2, 20
	mov x3, 4
	BL drawHLine
	sub x1, x1, 10
	BL drawSquare
	sub x1, x1, 10
	sub x2, x2, 140
	mov x3, 2
	BL drawVLine
	add x1, x1, 20
	add x2, x2, 10
	mov x3, 15
	BL drawVLine
	add x2, x2, 40
	BL drawVLine
	sub x2, x2, 10
	mov x3, 4
	BL drawHLine
	sub x1, x1, 10
	add x2, x2, 30
	mov x3, 2
	BL drawVLine

	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	sub x1, x1, 110						// Starts drawing the eyes
	add x2, x2, 50
	mov x3, 9
	mov x4, 13
	BL drawBigSquare
	add x2, x2, 150
	BL drawBigSquare
	add x1, x1, 80
	sub x2, x2, 59
	movz x10, 0x3F, lsl 16				// Sets the color for the nose
	movk x10, 0x2722, lsl 0
	mov x3, 6
	mov x4, 4
	BL drawBigSquare					// Draws the nose
	movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 0
	add x1, x1, 40
	mov x3, 6
	BL drawHLine						// Starts drawing the mustache
	add x1, x1, 10
	sub x2, x2, 40
	mov x3, 5
	BL drawVLine
	add x1, x1, 50
	add x2, x2, 10
	mov x3, 2
	BL drawHLine
	sub x1, x1, 20
	add x2, x2, 20
	BL drawVLine
	sub x1, x1, 20
	add x2, x2, 10
	mov x3, 3
	BL drawVLine
	sub x1, x1, 10
	add x2, x2, 10
	mov x3, 4
	BL drawHLine
	add x1, x1, 10
	add x2, x2, 40
	mov x3, 3
	BL drawVLine
	add x1, x1, 20
	add x2, x2, 10
	mov x3, 2
	BL drawVLine
	add x1, x1, 20
	add x2, x2, 10
	BL drawHLine
	sub x1, x1, 50
	add x2, x2, 20
	mov x3, 5
	BL drawVLine

	movz x10, 0xFF, lsl 16					// Sets the color for the eye reflexes
	movk x10, 0xFFFF, lsl 0
	
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	sub x1, x1, 90
	add x2, x2, 90
	mov x3, 3
	mov x4, 7
	BL drawSquaredCircle					// Draws the circle reflex in the eyes
	add x2, x2, 150
	BL drawSquaredCircle
	ldur x1, [sp, 8]
	ldur x2, [sp, 0]
	ldur x30, [sp, 16]
	add sp, sp, 24
	BR x30


	//---------------------------------------------------------------
	// Infinite Loop 

InfLoop: 
	b InfLoop
