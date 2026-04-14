/*function next_greater(arr) {
let stack = new Stack()
let result = [-1] * len(arr) #allocate entire array of result with -1.
for (let i = len(arr) - 1; i >= 0; i-
-) {
while (!stack.empty() && arr[stack.top()] <= arr[i]) stack.pop()
if (!stack.empty()) result[i] = stack.top()
stack.push(i)
}
return result
}

riscv64-unknown-elf-gcc q2.s -o a.out
spike $PK a.out 85 96 70 80 102
*/

.section .data
#indiactes below part is about data-memory ie r or rw not executed.
#below things useful while printing.
    space:  .asciz " " #ie represents memory adress where space is stored. used when space needed.
    newline: .asciz "\n"
    fmt:    .asciz "%ld" #for formatting string-to treat a reg value -base 10.

.section .text #executable instructions.
.globl main 
#when program starts its actually been called by os here the os uses sertain regsters.
main:
    # Save context
    addi sp, sp, -48
    sd ra, 0(sp). #ra holds adress of os so that after main finishes it returns.
    sd s0, 8(sp)    # s0 = n (number of students)
    sd s1, 16(sp)   # s1 = argv pointer
    sd s2, 24(sp)   # s2 = IQ array pointer
    sd s3, 32(sp)   # s3 = Result array pointer
    sd s4, 40(sp)   # s4 = Stack pointer (for indices)

    mv s0, a0       #s0=a0=argc=count no of args
    #s1=argv(pointer to strungs)
    mv s1, a1   #moved to store them as a0,a1 changes for diff funcns.    
    
    # Adjust n (argc - 1)
    addi s0, s0, -1 #as not considering argv[0] as itself is a program name.
    li t0, 0 
    ble s0, t0, exit_early #n<=0 ie no arg passed

    # Dynamic Allocation on Stack
    slli t0, s0, 3  # n * 8 bytes =no of values -8 bytes each.
    sub sp, sp, t0
    mv s2, sp       # IQs->s2 stores actual integer values.
    sub sp, sp, t0
    mv s3, sp       # Results- stores the fount NGEle indices.
    sub sp, sp, t0
    mv s4, sp       # Manual Stack-0(n)

    # Manual String to Integer Conversion
    li s5, 0        # i = 0
convert_loop:
    beq s5, s0, solve
    slli t0, s5, 3
    addi t0, t0, 8  # Offset for argv[i+1]
    add t0, s1, t0
    ld t1, 0(t0)    # t1 = pointer to string char

    li t2, 0        # current_val = 0
parse_char:
    lbu t3, 0(t1)   # load 1 char(byte) at a time.
    beq t3, zero, store_val
    li t4, 48       # ASCII '0'
    sub t3, t3, t4  # digit = char - '0'
    
    # current_val = (current_val * 10) + digit
    li t4, 10
    mul t2, t2, t4
    add t2, t2, t3
    
    addi t1, t1, 1  # next char
    j parse_char

store_val:
    slli t0, s5, 3
    add t0, s2, t0
    sd t2, 0(t0)    # Store result in IQ array -s2.
    addi s5, s5, 1
    j convert_loop

# Next Greater Element Logic
solve:
    addi s5, s0, -1 # i = n - 1
    li s6, 0        # stack_ptr = 0 (top of stack offset)

solve_loop:
    bltz s5, print_results #for index<0 
    
    slli t0, s5, 3
    add t0, s2, t0
    ld t0, 0(t0)    # t0 = arr[i] load iq of current student into t0

while_stack:
    blez s6, stack_empty
    # Peek: index = stack[stack_ptr - 8]
    addi t1, s6, -8
    add t1, s4, t1
    ld t1, 0(t1)    
    
    # Get IQ at that index: arr[stack.top()]
    slli t2, t1, 3
    add t2, s2, t2
    ld t2, 0(t2)    
    
    bgt t2, t0, stack_found
    addi s6, s6, -8 # pop
    j while_stack

stack_empty:
    li t3, -1       
    j store_res

stack_found:
    mv t3, t1 # Next greater index

store_res:
    slli t4, s5, 3
    add t4, s3, t4
    sd t3, 0(t4)    

    # Push current index onto stack
    add t4, s4, s6
    sd s5, 0(t4)
    addi s6, s6, 8
    
    addi s5, s5, -1
    j solve_loop

#Output Formatting 
print_results:
    li s5, 0        
print_loop:
    beq s5, s0, exit_early
    
    slli t0, s5, 3
    add t0, s3, t0
    ld a1, 0(t0)    
    
    la a0, fmt
    call printf

    addi t0, s0, -1
    beq s5, t0, skip_space
    la a0, space
    call printf
skip_space:
    addi s5, s5, 1
    j print_loop

exit_early:
    la a0, newline
    call printf
    
    # Restore and Exit
    # (In a real environment, you'd reset SP to original here)
    li a7, 93          # <--- Use 'li' here, not 'ld'
    li a0, 0           # Return code 0
    ecall

