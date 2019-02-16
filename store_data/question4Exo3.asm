section .data
    c          db  10    
    r          db  10
    n          dd  15
    quotient   dd  0
    reste       dd  0
    message1 :  db   'le nombre est : '
	longueur1 : equ   $-message1
    
;ASSUME SS:segment_pile MOV AX, segment_pile MOV SS, AX ; initialise le segment de pile MOV SP, base_pile ; copie l'adresse de la base de la pile dans SP


;while n > 10
;    division

section .text
    global _start


_start :    
    call ecrireNombre    
    jmp exit




ecrireNombre :
    mov eax, 4
    mov ebx, 1   
    mov ecx, message1 
    mov edx, longueur1
    int 80h
    mov eax, [n]
    jmp debut_boucle

    debut_boucle :
        mov  edx, 0
	    mov  ecx, 10
	    idiv ecx
        cmp  edx, 0
        je fin_boucle
        add edx, '0'
        mov [reste] , edx
        mov [quotient], eax
        
        ; ecriture
        mov eax, 4
        mov ebx, 1   
        mov ecx, reste 
        mov edx, 1 
        int 80h
        
        mov eax, [quotient]  
        jmp debut_boucle  
       
    fin_boucle :
        mov eax, 4
        mov ebx, 1   
        mov ecx, r
        mov edx, 1 
        int 80h
    ret

exit :
    
    mov eax, 1
	mov ebx, 0
	int 80h
    



