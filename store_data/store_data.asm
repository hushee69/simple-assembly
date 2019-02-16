section .bss
	number_store resb 12			; 32 bit unsigned number is 11 digits and a null terminating character

section .text
	global _start
	_start:
		xor ecx, ecx
		xor ebx, ebx
		add bl, '0'
		mov edi, number_store
		jmp debut_boucle
	debut_boucle:
		mov byte [edi+ecx], bl
		cmp ecx, 9
		jg fin
		inc ecx
		jmp debut_boucle
	fin:
		mov byte [edi+ecx], 10
		mov eax, 4
		mov ebx, 1
		mov ecx, number_store
		mov edx, 12
		int 0x80
		mov eax, 1
		xor ebx, ebx
		int 0x80

