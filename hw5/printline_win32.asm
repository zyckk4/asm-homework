extern _printf
global _printNewLine

section .text

_printNewLine:
    mov eax, L
    push eax
    call _printf
    add esp, 4
    ret
L:
    db 10, 0