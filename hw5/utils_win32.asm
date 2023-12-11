global _asm_add, _asm_sub, _asm_mul, _asm_div

section .text

; windows下32位模式编译，遵循cdecl，RTL栈上传参
_asm_add:
    ; int asm_add(int a, int b)
    ; return a+b
    mov eax, [esp+4]
    add eax, [esp+8]
    ret

_asm_sub:
    ; int asm_sub(int a, int b)
    ; return a-b
    mov eax, [esp+4]
    sub eax, [esp+8]
    ret

_asm_mul:
    ; int asm_mul(int a, int b)
    ; return a*b
    mov eax, [esp+4]
    imul dword [esp+8]
    ret

_asm_div:
    ; int asm_div(int a, int b)
    ; return a/b
    mov	eax, [esp+4]
    cdq
    idiv dword [esp+8]
    ret