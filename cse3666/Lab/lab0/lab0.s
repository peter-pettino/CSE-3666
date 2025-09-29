#       CSE 3666 Lab 0

#       Anything after # is comments.

        # .data starts data segments
        .data
        # msg is a label in data segment 
        # .asciz specifies an ASCII string ends with a NUL character
        # we can also use ".string", instead of ".asciz"
msg:    .asciz  "Hello, welcome to CSE 3666. Greetings from RISC-V.\n"

        # .text starts code segments
        .text

        # define a label, in code segment
main:   
        lui     a0, 0x10010     # a0 = the address of msg. hard-coded
        addi    a7, zero, 4     # a7 = 4, the system call number for printing a string
        ecall                   # system call

        # system call 10: exit with code 0
        addi    a7, zero, 10    # a7 = 10
        ecall                   # system call
