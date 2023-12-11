#include "inline_asm_utils.c"
#include <stdio.h>

// 汇编实现加减乘除函数
extern int asm_add(int a, int b);
extern int asm_sub(int a, int b);
extern int asm_mul(int a, int b);
extern int asm_div(int a, int b);

// 输出\n，为在汇编里调用printf实现
extern void printNewLine();

int main() {
	int a, b;
	a = -24;
	b = 8;
	printf("Start testing.");
	printNewLine();
	printNewLine();
	printf("equation|correct ans|asm ans|inline asm ans");
	printNewLine();
	printf("%d+%d  %d  %d  %d", a, b, a + b, asm_add(a, b),
		   inline_asm_add(a, b));
	printNewLine();
	printf("%d-%d  %d  %d  %d", a, b, a - b, asm_sub(a, b),
		   inline_asm_sub(a, b));
	printNewLine();
	printf("%d*%d  %d  %d  %d", a, b, a * b, asm_mul(a, b),
		   inline_asm_mul(a, b));
	printNewLine();
	printf("%d/%d  %d  %d  %d", a, b, a / b, asm_div(a, b),
		   inline_asm_div(a, b));
	printNewLine();
	printNewLine();
	printf("Test finished.");
}