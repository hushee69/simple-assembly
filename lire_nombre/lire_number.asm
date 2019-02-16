; ce programme lit des caracteres en tant qu'il recoit pas un caractere qui n'est pas un chiffre
; ou en tant qu'il ne depasse pas 11 chiffres
; et l'affiche

section .bss
	number_store resb 11		; largest 32 bit number is 10 bytes + null character in the end
								; reserve 11 bytes for the number to be printed later

section .text
	global _start
	_start:
		call main						; call main
		jmp print_final
	main:
		push ebp
		mov ebp, esp
		sub esp, 8						; make space for variables
										; int i - to verify that we haven't exceeded 11 digits
										; char c - to check if the character is a digit
		xor ecx, ecx					; ecx = 0
		mov [ebp-4], ecx				; i = 0
		lea esi, [number_store]			; the address of the start of buffer
		jmp start_loop
	start_loop:
		cmp ecx, 11						; test if we are equal to 11
		jge end_loop					; finish loop
		push dword [ebp-8]
		call read_char
		add esp, 4						; restore esp to the right place
										; now ecx contains the character entered
		mov [ebp-8], ecx				; put the character in ecx in the the variable c (char c)
		mov ebx, [ecx]					; store the variable temporarily in ebx for comparison reasons
										; use square brackets so as to access the memory and not the address
		mov ecx, [ebp-4]				; put i in ecx
		mov [esi+ecx], ebx
		cmp byte bl, '0'
		jl end_loop
		cmp byte bl, '9'
		jg end_loop
		inc byte [ebp-4]				; increment i
		jmp start_loop
	end_loop:
		mov byte [esi+ecx], 10				; add the new line character
		mov esp, ebp					; clear variables
		pop ebp							; restore base pointer
		ret								; return
;;;;;;;;;;;;;;END main
	read_char:							; read one character from terminal
		push ebp
		mov ebp, esp
		mov eax, 3
		xor ebx, ebx
		lea ecx, [ebp+8]				; pointer to buffer
		mov edx, 1						; read one character
		int 0x80
		pop ebp
		ret								; at this point, ecx contains the character typed
;;;;;;;;;;;;;END read_char
	print_final:				; print the final number saved
		mov eax, 4				; call to write
		mov ebx, 1
		mov ecx, number_store	; the number to be printed
		mov edx, 11
		int 0x80
		jmp fin					; go to fin
	fin:
		mov eax, 1				; call exit
		xor ebx, ebx
		int 0x80				; interrupt and call exit

