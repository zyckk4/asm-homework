import ctypes

lib = ctypes.CDLL("./utils_win64.dll")

print(lib.asm_add(1,2))
print(lib.asm_sub(1,2))
print(lib.asm_mul(6,2))
print(lib.asm_div(-24,6))