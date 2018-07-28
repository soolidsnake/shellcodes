
;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 184 bytes
; Purpose: read files from a directory
;
; nasm -f elf64 read_files.asm; ld -m elf_x86_64 -s -o read_files read_files.o
;

section .text
  global _start

_start:
	;; put string in stack
	xor rax, rax
	push rax
	mov rbx, 'passwd'; directory to open, change here
	push rbx

	mov rbp, rsp
	add rsp, 0x100

	;; sys_open("passwd", 0, 0)
	mov al, 2      
	mov rdi, rbp   
	xor rsi, rsi 
	xor rdx, rdx 
	syscall	

	;;  getdents(fd, rsp, 0x3210)
	mov rdi,rax 		
	xor rdx,rdx
	xor rax,rax
	mov dx, 0x3210	
	sub rsp, rdx 	
	mov rsi, rsp 	
	mov al, 78 	
	syscall

	;; FIRST LOOP
	mov rbx, rsp
	LOOP1:
		xor rcx, rcx
		mov cx, WORD [rbx + 0x10];get lenght from d_reclen
		mov r8, rcx

		mov rax, rbx
		add rax, 0x0b;pin point to d_name
		
		sub rcx, 0x13;lenght of d_name

		;add directory path here for instance "passwd/"
		mov dl, 'p'
		mov BYTE [rax], dl
		mov dl, 'a'
		mov BYTE [rax+0x01], dl
		mov dl, 's'
		mov BYTE [rax+0x02], dl
		mov dl, 's'
		mov BYTE [rax+0x03], dl
		mov dl, 'w'
		mov BYTE [rax+0x04], dl
		mov dl, 'd'
		mov BYTE [rax+0x05], dl
		mov dl, '/'
		mov BYTE [rax+0x06], dl
		;/************CODE***************/

		;open file
		xor rsi, rsi
		mov rdi, rax
		mov eax, 0x02
		syscall

		test rax, rax
		jl ERROR_OPEN

		;read content of file
		mov rdi, rax
		lea rsi, [rbp+0x100]
		mov dl, 0x30
		xor rax, rax 
		syscall	

		;write content to stdout
		xor rdx, rdx
		mov rdi, 0x01
		mov dl, al; get number of read bytes
		mov al, 0x01
		syscall 		

		;/************CODE***************/

		ERROR_OPEN:

		add rbx, r8;next dirent structure

		cmp QWORD [rbx], 0
		jnz LOOP1

	xor rax, rax
	mov al, 60
	syscall;exit


