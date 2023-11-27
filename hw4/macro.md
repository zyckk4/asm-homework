# MASM 5.0 中的宏

作者：https://github.com/zyckk4

## `equ`

`equ`在MASM中用于给一个标识符赋予一个常数值或用于文本替换。这有利于代码保持简洁和易于维护。

### 使用方法

- 定义常变量：

    ```assembly
    var equ 666
    ```
    这定义了一个常量`var`的值为666。

    在定义一些数据结构或开辟空间时，使用常变量有利于代码的可读性和且易于维护。
    例如在定义dos ah=0Ah; int 21h 的输入缓冲区时：
    ```assembly
    inputBufferSize equ 255

    inputBuffer db inputBufferSize         ; 最大长度
                db ?                       ; 实际输入的字符数
                db inputBufferSize dup(0)  ; 为输入字符串预留的空间
                dw 0
    ; ...
    mov si, inputBufferSize  
    ; ...                       
    ```
    这样，在修改缓冲区大小时，只需修改inputBufferSize一处。

- 文本替换：

    ```assembly
    var equ <text>
    ```
    这将`var`直接文本替换成`text`。例如可以使用
    ```assembly
    wptr equ <word ptr>
    mov wptr [bp], ax
    ```

其实使用文本替换也可以实现定义常变量的功能，不过加不加<>还是有区别的。
直接定义的常变量不可以被重复定义，否则MASM编译时会报错
`error A2005: Symbol is multidefined: var`。
但文本替换可以重复替换

## `macro`

在MASM 5.0中可以使用`macro`和`endm`指令来定义一个宏，语法规则如下：

```assembly
name macro arg1, arg2, ...
    ; 宏体
endm
```

这里，`name`是宏的名称，`arg1`, `arg2`等是传递给宏的参数。

- 使用示例:

    ```assembly
    AddTwoNumbers macro num1, num2
        mov ax, num1
        add ax, num2
    endm

    ; 调用宏
    AddTwoNumbers 5, 10
    ```

    当然，在宏体里面也可以调用另一个宏，例如：
    ```assembly
    PrintChar macro char
        mov dl, char
        Interrupt 02h, 21h
    endm

    Interrupt macro ah_num, intnum
        mov ah, ah_num
        int intnum
    endm

    ; 调用PrintChar输出一个字符
    PrintChar '6'
    ```

要注意的是，相比于函数，宏是在汇编器预处理时就展开了，没有`call`和`ret`的开销。
但是一方面，这样的宏相比函数不方便和C语言等高级语言交互，另一方面，
宏可能不利于调试，例如编译时，若宏体里的代码有错误，只会在宏调用的那一行报错，
而无法具体定位到代码中宏体内的某一行。

## 总结

宏是MASM的一大特性。上文是对MASM 5.0宏的介绍。正确使用`equ`和`macro`有利于提高代码的重用性、可读性、可维护性。
