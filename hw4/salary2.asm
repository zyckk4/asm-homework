.model small

.code
public MoveToTable
_salary:
MoveToTable:
    ; void MoveToTable()
    ; 把数据从data段按要求移到table段
    ; 摧毁 ax, bx, si, di
    mov cx, 21
    _MoveToTable__Loop:
        mov ax, [bx+si]      ; 年份低2字节
        mov es:[bp], ax
        mov ax, [bx+si+2]    ; 年份高2字节
        mov es:[bp+2], ax
        mov ax, [bx+si+84]   ; 总收低2字节
        mov es:[bp+5], ax
        mov ax, [bx+si+86]   ; 总收高2字节
        mov es:[bp+7], ax
        mov ax, [bx+di+168]  ; 雇员人数
        mov es:[bp+10], ax
        call CalcAndMoveAvgSalary
        add si, 4
        add di, 2
        add bp, 16
        loop _MoveToTable__Loop
    ret

CalcAndMoveAvgSalary:
    ; 计算es:bp所对应年份的平均工资，并移动到table段
    ; 摧毁 ax, dx
    mov dx, es:[bp+7]  ; 总收的高两字节
    mov ax, es:[bp+5]  ; 总收的低两字节
    push cx  ; 暂存
    mov cx, es:[bp+10]
    div cx  ; dx:ax /= cx -> 商在ax, 余数在dx
    pop cx
    mov es:[bp+13], ax  ; 存储平均收入
    ret

end _salary