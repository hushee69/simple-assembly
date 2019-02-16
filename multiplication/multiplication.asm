section .data
	result dd 0

section .text
	global _start
	_start:
		mov ax, 0x0304
		mov bx, 0x0807
		mul bx
		mov [result], ax
		mov [result+2], dx
		mov ebx, [result]
		mov eax, 1
		xor ebx, ebx
		int 0x80
