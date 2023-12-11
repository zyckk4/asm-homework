PROGRAM = main_win32.exe
PROGRAM2 = main_win64.exe
DLL = utils_win64.dll

all: $(PROGRAM) $(PROGRAM2) $(DLL)

$(PROGRAM): utils_win32.obj printline_win32.obj
	gcc main.c utils_win32.obj printline_win32.obj -m32 -o $(PROGRAM)

$(PROGRAM2): utils_win64.obj printline_win64.obj
	gcc main.c utils_win64.obj printline_win64.obj -o $(PROGRAM2)

$(DLL): utils_win64.obj
	ld -shared utils_win64.obj -o $(DLL)

utils_win32.obj:
	nasm -f win32 utils_win32.asm -o utils_win32.obj

utils_win64.obj:
	nasm -f win64 utils_win64.asm -o utils_win64.obj

printline_win32.obj:
	nasm -f win32 printline_win32.asm -o printline_win32.obj

printline_win64.obj:
	nasm -f win64 printline_win64.asm -o printline_win64.obj

clean:
	del utils_win32.obj utils_win64.obj printline_win32.obj printline_win64.obj $(PROGRAM) $(PROGRAM2) $(DLL)