.model small

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

    strBuffer db '0000000000$', 0 ; 字符串缓冲区（10个0 + 结束符）       
data ends

table segment
    db 21 dup('year summ ne ?? ')  ; 年 总收 人数 平均工资
table ends

stackseg segment stack
    dw 160 dup(0)
stackseg ends

.code
main:
mov ax, data
mov ds, ax
mov ax, table
mov es, ax

mov ax, stackseg
mov ss, ax
mov sp, 160

mov bp, 0  ; 用于寻址data段数据
mov bx, 0  ; 用于寻址table段
mov si, 0  ; 用于寻址data段数据
mov di, 0  ; 用于寻址data段数据
mov cx, 21

moveToTable:
    mov ax, ds:[bp+si]      ; 年份低2字节
    mov es:[bx], ax
    mov ax, ds:[bp+si+2]    ; 年份高2字节
    mov es:[bx+2], ax
    mov ax, ds:[bp+si+84]   ; 总收低2字节
    mov es:[bx+5], ax
    mov ax, ds:[bp+si+86]   ; 总收高2字节
    mov es:[bx+7], ax
    mov ax, ds:[bp+di+168]  ; 雇员人数
    mov es:[bx+10], ax
    call CalcAndMoveAvgSalary
    add si, 4
    add di, 2
    add bx, 16
    loop moveToTable

mov bx, 0  ; 用于寻址table段
mov cx, 21

printTable:
    push cx
    mov ax, 4
    push ax
    push bx 
    call PrintChars
    add sp, 4

    mov dl, ' '
    call PrintChar
    add bx, 5  
    call PrintInt32InMemory

    mov dl, ' '
    call PrintChar
    add bx, 5
    call PrintInt16InMemory

    mov dl, ' '
    call PrintChar
    add bx, 3
    call PrintInt16InMemory

    add bx, 3

    mov dl, 10
    call PrintChar
    pop cx
    loop printTable

quit:
    ; 退出程序
    mov ax, 4C00h
    int 21h

CalcAndMoveAvgSalary:
    ; 计算es:bx所对应年平均工资并移动到table段
    mov dx, es:[bx+7]  ; 总收的高两字节
    mov ax, es:[bx+5]  ; 总收的低两字节
    push cx  ; 暂存
    mov cx, es:[bx+10]
    div cx  ; dx:ax /= cx -> 商在ax, 余数在dx
    pop cx
    mov es:[bx+13], ax  ; 存储平均收入
    ret

PrintString:
    ; 输出字符串，ds:dx指向字符串，字符串以'$'结尾
    mov ah, 09h
    int 21h
    ret

PrintChar:
    ; 输出dl字符
    mov ah, 02h
    int 21h
    ret

PrintChars:
    ; void __cdecl PrintChars(int16 ea, int16 cnt)
    ; es:ea处开始输出，直到[ea+cnt-1]，共输出cnt个字符
    ; 摧毁ah, dl
    push bp
    mov bp, sp

    push bx
    push cx
    mov cx, [bp+6]
    mov bx, [bp+4]

    _PrintChars__printLoop:
        mov dl, es:[bx]
        call PrintChar
        inc bx
        loop _PrintChars__printLoop

    pop cx  ; 恢复cx原来的值
    pop bx  ; 恢复bx原来的值

    pop bp
    ret

PrintInt16InMemory:
    ; 打印从 es:[bx] 到 es:[bx+1] 表示的 16 位数字
    ; 摧毁 ax, cx, di, dx
    mov ax, es:[bx] ; 将数值加载到 ax

    ; 转换数字到字符串
    mov cx, 10   ; 除数（10，用于转换成十进制）
    lea di, [strBuffer+10]

    convert_loop:
        xor dx, dx       ; 清零 dx
        div cx            ; ax / 10, 商在 ax 中, 余数在 dx 中
        add dl, '0'        ; 将数字转换为字符
        dec di            ; 移动到下一个字符位置
        mov [di], dl      ; 存储字符
        test ax, ax      ; 检查 ax 是否为 0
        jnz convert_loop   ; 如果不为 0，继续循环

    ; 显示字符串
    mov dx, di
    call PrintString

    ret

PrintInt32InMemory:
    ; 打印从 [bx] 到 [bx+3] 的 32 位数字
    ; 数字不能大于655359999
    ; 摧毁 ax, cx, di, dx

    ; 读取 32 位数值
    mov dx, es:[bx+2]
    mov ax, es:[bx]  ; 低16位
    mov cx, 10000
    div cx  ; 商在ax，余数在dx
    push ax
    mov ax, dx

    mov cx, 10   ; 除数（10，用于转换成十进制）
    lea di, [strBuffer+10]  ; 指向末尾。 从低到高倒着填充

    test ax, ax  ; 判断ax是否为0
    jz end_of_loop1
    convert_loop1:
        xor dx, dx
        div cx  ; ax / 10, 商在ax中, 余数在dx中
        add dl, '0'  ; 将数字转换为字符
        dec di  ; 移动到下一个字符位置
        mov [di], dl  ; 存储字符
        test ax, ax  ; 检查ax是否为0
        jnz convert_loop1   ; 如果不为 0，继续循环
    end_of_loop1:
    pop ax
    test ax, ax  ; 判断ax是否为0
    jz done
    lea di, [strBuffer+5]
    convert_loop2:
        xor dx, dx
        div cx  ; ax / 10, 商在ax中, 余数在dx中
        add dl, '0'  ; 将数字转换为字符
        dec di  ; 移动到下一个字符位置
        mov [di], dl  ; 存储字符
        test ax, ax  ; 检查ax是否为0
        jnz convert_loop2   ; 如果不为 0，继续循环
    done:
        ; 显示字符串
        mov dx, di
        call PrintString

    ret

end main