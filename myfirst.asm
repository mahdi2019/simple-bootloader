	BITS 16         ;    isn't an x86 CPU instruction; it just tells the NASM assembler that we're working in 16-bit mode. NASM can then translate the following instructions into raw x86 binary

start:
	; setting up the segment registers so that our OS knows where the stack pointer and executable code resides.
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	; ss = stack segment
	mov ss, ax
	; sp = stack pointer
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	; ds = data segment
	mov ds, ax


	mov si, text_string	; copy the location of the text string below into the SI register
	call print_string	; Call our string-printing routine

	jmp $			; Jump here - infinite loop!


	text_string db 'hello world!', 0


print_string:			; Routine: output string in SI to screen
	; ah = the upper byte of AX
	mov ah, 0Eh		; 0Eh = print the character in the AL register to the screen!
	; int 10h 'print char' function

.repeat:
	lodsb			; (load string byte) which retrieves a byte of data from the location pointed to by SI, and stores it in AL (the lower byte of AX) & increments SI each time
	cmp al, 0
	je .done		; jump if equal
	int 10h			; (interrupt our code and go to the BIOS), which reads the value in the AH register
	jmp .repeat

.done:
	ret    ; popping the code location from the stack back into the IP register


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	; dw = define a word
	dw 0xAA55		; The standard PC boot signature (the boot signature)
