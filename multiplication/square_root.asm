; programme qui trouve une approximation de la racine carre
; utilise la fonction print_number pour l'afficher a l'ecran

section .bss
	number_store resb 12		; largest 32 bit number is 10 bytes + null character in the end
								; reserve 11 bytes for the number to be printed later
	mult_result resd 1			; reserve one dword (4 bytes - 32 bits)

section .text
	global _start
	_start:
		xor eax, eax
		xor edx, edx
		mov ax, 500
		mov bx, 400
		mul bx
		mov [mult_result], ax			; move lower bits into mult_result
		mov [mult_result+2], dx			; move higher bits into mult_result+2
		push dword [mult_result]
		call print_number
		add esp, 4
		jmp print_final
	print_number:				; print_number(unsigned int num)
		push ebp				; save previous base pointer
		mov ebp, esp			; set new stack frame
		sub esp, 0x0C			; int quotient, int divisor, int index
								; index tells us where we are in the number_store array
		mov ecx, [ebp+8]
		mov dword [ebp-4], ecx		; quotient = value on the right
		mov dword [ebp-8], 10			; divisor = 10
		mov byte [ebp-12], 10			; index counter for the array, start from the back of the
										; array to fill the number right to left
		lea esi, [number_store+10]		; address of the 10th element of the variable number_store
										; char number_store[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
										; we are in the 10th index, 11th index is to be a null character
		call fill_zeros
		jmp debut_boucle		; go to loop
	debut_boucle:				; start of the loop
		mov eax, [ebp-4]		; eax = 123
		test eax, eax			; cmp eax, 0 => if eax is 0 then we exit the loop
		jz fin_boucle			; if we have reached 0, exit loop
		mov ebx, [ebp-8]		; ebx = 10
		xor edx, edx			; zero out edx to store remainder
		div ebx					; eax = eax / ebx => eax = quotient, edx = remainder
		mov [ebp-4], eax		; update quotient
		add byte dl, '0'		; convert remainder to ascii
		mov ebx, [ebp-12]		; get the counter in ebx
		mov byte [esi+ebx], dl		; insert the character in the end of the array
		dec byte [ebp-12]			; reduce the index by 1
		jmp debut_boucle		; loop again
	fin_boucle:
		mov esp, ebp			; clear local variables
		pop ebp					; get saved base pointer
		ret						; return to next instruction after call
;;;;;;;;;;;;; END MAIN HERE
	fill_zeros:
		push ebp					; save previous base pointer
		mov ebp, esp				; create new stack frame
		xor ecx, ecx				; zero out ecx
		xor eax, eax				; to fill the array with zeros, we use al
		add eax, '0'
		mov esi, number_store		; address of the beginning of the array
		jmp start_loop
	start_loop:
		mov [esi+ecx], eax
		cmp ecx, 10
		jge end_loop
		inc ecx
		jmp start_loop
	end_loop:
		pop ebp					; restore base pointer
		ret						; end fill zeros
;;;;;;;;;;;;;;;; FILL ZEROS END here
	print_final:				; print the final number saved
		mov byte [number_store+11], 10
		mov eax, 4				; call to write
		mov ebx, 1
		mov ecx, number_store	; the number to be printed
		mov edx, 12
		int 0x80
		jmp fin					; go to fin
	fin:
		mov eax, 1				; call exit
		xor ebx, ebx
		int 0x80				; interrupt and call exit

