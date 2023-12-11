global asm_add, asm_sub, asm_mul, asm_div

section .text

; windows下64位模式编译，遵循Microsoft x64 calling convention
; rcx, rdx, r8, r9传递前四个参数，其余RTL栈上传参
asm_add:
    ; int asm_add(int a, int b)
    ; return a+b
    mov eax, ecx
    add eax, edx
    ret

asm_sub:
    ; int asm_sub(int a, int b)
    ; return a-b
    mov eax, ecx
    sub eax, edx
    ret

asm_mul:
    ; int asm_mul(int a, int b)
    ; return a*b
    mov eax, ecx
    imul edx
    ret

asm_div:
    ; int asm_div(int a, int b)
    ; return a/b
	mov	eax, ecx
	mov	ecx, edx
	cdq
	idiv	ecx
	ret