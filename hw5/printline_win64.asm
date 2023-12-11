extern printf
global printNewLine

section .text

printNewLine:
    mov rcx, L
    sub rsp, 32
    call printf
    add rsp, 32
    ret
L:
    db 10, 0