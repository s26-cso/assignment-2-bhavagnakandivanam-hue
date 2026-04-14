.section .rodata
filename:   .string "input.txt"
yes_msg:    .string "Yes\n"
no_msg:     .string "No\n"

.section .text
.globl _start

_start:
    # Open the file
    li a7, 56           # sys_openat
    li a0, -100         # AT_FDCWD
    la a1, filename     # "input.txt"
    li a2, 0            # O_RDONLY
    li a3, 0
    ecall
    mv s0, a0           # s0 = file descriptor (fd)

    # Get file size (lseek to end)
    li a7, 62           # sys_lseek
    mv a0, s0           # fd
    li a1, 0            # offset 0
    li a2, 2            # SEEK_END
    ecall
    mv s1, a0           # s1 = n (file size)

    # Initialize pointers
    li s2, 0            # s2 = Left index (0)
    addi s3, s1, -1     # s3 = Right index (n-1)

loop:
    bge s2, s3, success # If Left >= Right, we are done

    # Read char at Left
    li a7, 62           # sys_lseek
    mv a0, s0
    mv a1, s2           # Left index
    li a2, 0            # SEEK_SET
    ecall
    
    li a7, 63           # sys_read
    mv a0, s0
    addi sp, sp, -16    # make space on stack for 1 char
    mv a1, sp           # buffer = stack address
    li a2, 1            # read 1 byte
    ecall
    lbu s4, 0(sp)       # s4 = char at Left

    # Read char at Right
    li a7, 62           # sys_lseek
    mv a0, s0
    mv a1, s3           # Right index
    li a2, 0            # SEEK_SET
    ecall

    li a7, 63           # sys_read
    mv a0, s0
    mv a1, sp           # buffer
    li a2, 1            # read 1 byte
    ecall
    lbu s5, 0(sp)       # s5 = char at Right
    addi sp, sp, 16     # restore stack

    # Compare
    bne s4, s5, fail    # If charL != charR, fail

    addi s2, s2, 1      # Left++
    addi s3, s3, -1     # Right--
    j loop

fail:
    la a0, no_msg
    j print_exit

success:
    la a0, yes_msg

print_exit:
    # Print the result string
    mv a1, a0           # address of string
    li a0, 1            # stdout
    # Simple length calculation or just hardcode for Yes/No
    li a2, 4            # Length of "Yes\n" or "No\n" (both 4)
    li a7, 64           # sys_write
    ecall

    # Exit
    li a0, 0
    li a7, 93           # sys_exit
    ecall


