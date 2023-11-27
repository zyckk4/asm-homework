.model small

STACKSIZE equ 160

data segment
    ;以下是表示21年的21个字符串
    db 	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db 	'1993','1994','1995'
        
    ;以下是表示21年公司总收的21个dword型数据
    dd 	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        
    ;以下是表示21年公司雇员人数的21个word型数据
    dw 	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 	11542,14430,45257,17800

    strBuffer db '0000000000$', 0  ; 字符串缓冲区（10个0 + 结束符）       
data ends

table segment
    db 21 dup('year summ ne ?? ')  ; 年 总收 人数 平均工资
table ends

stackseg segment stack
    dw STACKSIZE dup(0)
stackseg ends

.code
extrn MoveToTable:near
extrn PrintASpace:near
extrn PrintANewLine:near
extrn PrintStrES:near
extrn Int16ToStr:near
extrn Int32ToStr:near
extrn DosPrintStr:near
main:
mov ax, data
mov ds, ax  ; data段基址
mov ax, table
mov es, ax  ; table段基址

; 初始化堆栈
mov ax, stackseg
mov ss, ax
mov sp, STACKSIZE

xor bx, bx  ; 用于寻址data段
xor bp, bp  ; 用于寻址table段数据
mov si, 0  ; 用于寻址data段数据
mov di, 0  ; 用于寻址data段数据
call MoveToTable

mov bx, 0  ; 用于寻址table段
mov bp, sp
mov cx, 21

sub sp, 6
printTable:
    mov word ptr [bp-4], 4  ; 传参，要打印的个数
    mov [bp-6], bx  ; 传参，字符串开始地址
    call PrintStrES  ; 输出年份

    ; 输出总收
    call PrintASpace
    add bx, 5

    lea ax, strBuffer
    add ax, 10
    mov [bp-2], ax   ; 传参，要写入的地址
    mov ax, es:[bx+2]  ; 总收高16位
    mov [bp-4], ax  ; 传参，总收高16位
    mov ax, es:[bx]  ; 总收低16位
    mov [bp-6], ax  ; 传参，总收低16位
    call Int32ToStr

    mov [bp-6], ax  ; 返回值是数字字符串最高位地址，作为DosPrintStr参数传入
    call DosPrintStr

    ; 输出人数
    call PrintASpace
    add bx, 5

    lea ax, [strBuffer+10]
    mov [bp-4], ax   ; 传参，要写入的地址
    mov ax, es:[bx]
    mov [bp-6], ax  ; 传参，人数
    call Int16ToStr

    mov [bp-6], ax  ; 返回值是数字字符串最高位地址，作为DosPrintStr参数传入
    call DosPrintStr

    ; 输出平均工资
    call PrintASpace
    add bx, 3

    lea ax, [strBuffer+10]
    mov [bp-4], ax   ; 传参，要写入的地址
    mov ax, es:[bx]
    mov [bp-6], ax  ; 传参，平均工资
    call Int16ToStr

    mov [bp-6], ax  ; 返回值是数字字符串最高位地址，作为DosPrintStr参数传入
    call DosPrintStr

    add bx, 3

    call PrintANewLine

    loop printTable

quit:
    ; 退出程序
    mov ax, 4C00h
    int 21h

end main