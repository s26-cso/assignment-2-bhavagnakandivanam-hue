Number name       ABI name      Purpose
x10                 a0     arg0/ret value
x11                 a1      arg1
x12                 a2       arg2
x8                  s0       saved reg
x9                   s1      saved reg
x18                   s2      saved reg
x1                  ra        ret adr


.asciz: This is a directive that stands for "ASCII Zero." It tells the computer to store the characters inside the quotes in memory and automatically add a null terminator (a byte of 0) at the end. This is how the printf function knows exactly where a string ends.

.asciz: This is an assembler directive. It tells the assembler to:

Convert the string inside the quotes into ASCII bytes.

Add a Zero (null terminator) at the very end. The z in asciz stands for zero. Without this zero, printf wouldn't know when to stop printing and would start printing random garbage from your RAM.





When you type ./a.out 85 96 70 in your terminal and hit Enter, the OS does the following:

Counts the words: It sees ./a.out (1), 85 (2), 96 (3), and 70 (4). Total = 4.

Loads a0: It puts that total (4) into register a0. This is argc (Argument Count).

Prepares the strings: It places the actual text strings somewhere in memory.

Loads a1: It puts the memory address (the pointer) of where those strings start into register a1. This is argv (Argument Vector).

Jumps to main: Only after these registers are filled does the OS start executing your code.


q3 a
KfKP0qXSiXiC7SCJTMde2zUvFUi/L/JwiqJpWmXNh0c= 




make sure docker running:
docker ps 

started docker container docker 
run -it --rm ubuntu bash

installed container tools
apt update
apt install qemu-user -y




docker ps
enter a country,city..

we get a prompt like root@xxxx:/#

docker ps

docker cp target_bhavagnakandivanam-hue <container_id>:/root/

cd /root
ls -our file should be visible..

qemu-riscv64 target_bhavagnakandivanam-hue
some failing issues so

file target_bhavagnakandivanam-hue
output-----ELF 64-bit LSB executable, RISC-V

give execuatble permission
qemu-riscv64 ./target_bhavagnakandivanam-hue


dissamble
riscv64-unknown-elf-objdump -d target_bhavagnakandivanam-hue > out.txt

looked for main function

see that strcmp,other functions which lead to success/fail
10644: auipc a1,0x74
10648: ld a1,-1732(a1)
1064c: jal strcmp

a1-hidden string
adress around 0x83f80
using grep check it
hex to char 

found password put in payload and executed.


