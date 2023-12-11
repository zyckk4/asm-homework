int inline_asm_add(int a, int b) {
	int sum;
	__asm__("add %2, %0" : "=r"(sum) : "0"(a), "r"(b));
	return sum;
}

int inline_asm_sub(int a, int b) {
	int sum;
	__asm__("sub %2, %0" : "=r"(sum) : "0"(a), "r"(b));
	return sum;
}

int inline_asm_mul(int a, int b) {
	int sum;
	__asm__("imul %2, %0" : "=r"(sum) : "0"(a), "r"(b));
	return sum;
}

int inline_asm_div(int a, int b) {
	int result;
	__asm__(".intel_syntax noprefix\n"
			"mov eax, %1\n"
			"cdq\n"
			"idiv %2\n"
			"mov %0, eax\n"
			".att_syntax prefix\n"
			: "=r"(result)
			: "r"(a), "r"(b)
			: "eax", "edx");
	return result;
}
