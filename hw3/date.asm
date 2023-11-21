.model small

; 输入缓冲区大小(1-255)，这里由于最大8个字符设成9其实就够了（8位+回车)
maxInputBufferSize equ 9

.data
    msg db "WHAT IS THE DATE(MM/DD/YY)?$", 0

    ;  int 21h, ah=0Ah 的输入缓冲区
    inputBuffer db maxInputBufferSize         ; 最大长度
                db 0                          ; 实际输入的字符数
                db maxInputBufferSize dup(0)  ; 为输入字符串预留的空间
                dw 0  ; 确保输入字符串满长度时，有空间在末尾添加一个'$'和一个尾0，便于处理

stackseg segment stack
    db 16 dup(0)
stackseg ends

.code
main:
mov ax, @data
mov ds, ax

mov ax, stackseg
mov ss, ax
mov sp, 16

lea dx, msg
call PrintString
mov dl, 7
call PrintChar  ; 响铃字符

; 输入
lea dx, inputBuffer
call GetNum

; 换行
mov dl, 10
call PrintChar

; 输出年月日
lea si, [inputBuffer+8]
call Disp  ; 输出年
mov dl, '-'
call PrintChar
sub si, 6  
call Disp  ; 输出月
mov dl, '-'
call PrintChar
add si, 3  
call Disp  ; 输出日

quit:
    ; 退出程序
    mov ax, 4C00h
    int 21h

PrintChar:
    ; 输出dl字符
    mov ah, 02h
    int 21h
    ret

PrintString:
    ; 输出字符串，ds:dx指向字符串，字符串以'$'结尾
    mov ah, 09h
    int 21h
    ret

GetNum:
    ; 输入字符串到ds:dx处的缓冲区
    mov ah, 0Ah
    int 21h
    ret

Disp:
    ; 输出ds:si指向的字节以及下一字节所代表的字符
    ; 这里用于输出年月日
    ; 摧毁ah
    mov dl, [si]
    call PrintChar
    mov dl, [si+1]
    call PrintChar
    ret

end main