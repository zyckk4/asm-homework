.model small

stacksize equ 100h
inputBufferSize equ 255
wptr equ <word ptr>

PrintChar macro char
    mov dl, char
    Interrupt 02h, 21h
endm

Interrupt macro ah_num, intnum
    mov ah, ah_num
    int intnum
endm

AddTwoNumbers macro num1, num2
    mov ax, num1
    add ax, num2
endm

.data
    inputBuffer db inputBufferSize         ; 最大长度
                db ?                       ; 实际输入的字符数
                db inputBufferSize dup(0)  ; 为输入字符串预留的空间
                dw 0 

stackseg segment stack
    db stacksize dup(0)
stackseg ends

.code
main:
mov ax, _DATA
mov ds, ax

mov ax, stackseg
mov ss, ax
mov sp, stacksize
mov bp, sp

xor ax, ax
AddTwoNumbers 6, '0' 
mov wptr [bp], ax
PrintChar [bp]
xor ax, ax

quit:
    ; 退出程序
    Interrupt 4Ch, 21h

end main