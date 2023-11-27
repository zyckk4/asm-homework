.model small

.code
public PrintChar, PrintASpace, PrintANewLine, PrintStr, PrintStrES, Int16ToStr, Int32ToStr, DosPrintStr
_utils:
PrintChar:
    ; void __cdecl PrintChar(int8 char)
    ; 输出char字符
    ; 摧毁 ah
    push bp
    mov bp, sp

    push dx

    mov dl, [bp+4]
    mov ah, 02h
    int 21h

    pop dx
    pop bp
    ret

PrintASpace:
    ; void __cdecl PrintASpace()
    ; 输出一个空格字符
    ; 摧毁 ah
    push dx
    mov dl, ' '
    mov ah, 02h
    int 21h
    pop dx
    ret

PrintANewLine:
    ; void __cdecl PrintANewLine()
    ; 输出一个换行字符
    ; 摧毁 ah
    push dx
    mov dl, 10
    mov ah, 02h
    int 21h
    pop dx
    ret

PrintStr:
    ; void __cdecl PrintStr(int16 ea, int16 cnt)
    ; ds:ea处开始输出，直到[ea+cnt-1]，共输出cnt个字符
    ; 摧毁 ah
    push bp
    mov bp, sp
    push bx
    push cx
    push dx

    mov bx, [bp+4]  ; 字符串开始地址
    mov cx, [bp+6]  ; 输出字符数
    mov ah, 02h
    _PrintStr__printLoop:
        mov dl, [bx]
        int 21h  ; 输出dl字符
        inc bx
        loop _PrintStr__printLoop

    pop dx
    pop cx
    pop bx
    pop bp
    ret

PrintStrES:
    ; void __cdecl PrintStr(int16 ea, int16 cnt)
    ; es:ea处开始输出，直到es:[ea+cnt-1]，共输出cnt个字符
    ; 摧毁 ah
    push bp
    mov bp, sp
    push bx
    push cx
    push dx

    mov bx, [bp+4]  ; 字符串开始地址
    mov cx, [bp+6]  ; 输出字符数
    mov ah, 02h
    _PrintStrES__printLoop:
        mov dl, es:[bx]
        int 21h  ; 输出dl字符
        inc bx
        loop _PrintStrES__printLoop

    pop dx
    pop cx
    pop bx
    pop bp
    ret

Int16ToStr:
    ; int16 __cdecl Int16ToStr(int16 num_high, int16 ea_out)
    ; 将16位数字in转为字符存到ea_out
    ; 其中ea_out是转换出的字符串的末尾+1位置，倒着填充
    ; 返回字符串开始位置（在ax）
    ; 摧毁 ax
    push bp
    mov bp, sp
    push bx
    push cx
    push di
    push dx

    mov ax, [bp+4]  ; 将in数值加载到 ax
    mov bx, [bp+6]  ; ea_out
    lea di, [bx]

    mov cx, 10   ; 除数（10，用于转换成十进制）
    call _NumConvert

    mov ax, di  ; 返回值，字符串的起始处

    pop dx
    pop di
    pop cx
    pop bx
    pop bp
    ret

Int32ToStr:
    ; int16 __cdecl Int32ToStr(int16 num_low, int16 num_high, int16 ea_out)
    ; num_high和num_low拼成的32位数字转为字符存到ea_out
    ; 要求数字不能大于655359999
    ; 其中ea_out是转换出的字符串的末尾+1位置，倒着填充
    ; 返回字符串开始位置（在ax）
    ; 摧毁 ax
    push bp
    mov bp, sp
    ; 保存要摧毁的寄存器
    push bx
    push cx
    push di
    push dx
    ; 读取 32 位数值
    mov ax, [bp+4]
    mov dx, [bp+6]
    ; ea_out
    mov bx, [bp+8]

    mov cx, 10000
    div cx  ; 商在ax，余数在dx

    ; 暂存商，先处理<10000的部分
    push ax  
    mov ax, dx

    mov cx, 10   ; 除数（10，用于转换成十进制）
    mov di, bx  ; 指向末尾字符-1处。 从低到高倒着填充

    test ax, ax  ; 判断ax是否为0
    jz end_of_loop1
    call _NumConvert
    end_of_loop1:
    pop ax
    test ax, ax  ; 判断ax是否为0
    jz _Int32ToStr__done
    sub bx, 5  ; 指向万位
    _Int32ToStr__fillzero:
        ; 需将千位以下的高位0填充
        dec di  
        cmp di, bx
        je _Int32ToStr__fillzero_done
        mov byte ptr [di], '0'
        jmp _Int32ToStr__fillzero
    _Int32ToStr__fillzero_done:
    inc di
    call _NumConvert
    _Int32ToStr__done:
    mov ax, di  ; 返回值，字符串的起始处
    
    pop dx
    pop di
    pop cx
    pop bx
    pop bp
    ret

_NumConvert:
    ; 内部函数
    xor dx, dx
    div cx  ; ax / 10, 商在 ax 中, 余数在 dx 中
    add dl, '0'  ; 将数字转换为字符
    dec di  ; 移动到下一个字符位置
    mov [di], dl  ; 存储字符
    test ax, ax  ; 检查 ax 是否为 0
    jnz _NumConvert
    ret

DosPrintStr:
    ; void __cdecl DosPrintStr(int ea)
    ; 输出字符串，ds:ea指向字符串首字符，字符串以'$'结尾（不输出'$'）
    ; 摧毁 ah
    push bp
    mov bp, sp
    push dx

    mov dx, [bp+4]
    mov ah, 09h
    int 21h

    pop dx
    pop bp
    ret

end _utils