# CSE 3666. Cache
        .data
        .align 2
# 256 words
warray: .space 1024

        # .text starts code segments
        .text
        .globl  main

main:   
        # s2: the stride size, in number of words
        # Try different values, 1, 2, 4, 8, and so on
        addi    s2, zero, 1
        
        # s3: the number of accesses to data memory
        # note that the lowest 12 bits are 0
        lui     s3, 0x00003

        # s0: starting address of the word array. Hard coded
        # s1: number of elements in the array
        lui     s0, 0x10010
        addi    s1, zero, 256

        # call read_array
        addi    a0, s0, 0
        addi    a1, s1, 0
        addi    a2, s2, 0
        addi    a3, s3, 0
        jal     ra, read_array
        
        # exit from the program
exit:   addi    a7, x0, 10      
        ecall

# read_array(int a[], unsigned int n_elements, unsigned int stride_size, unsigned int n_accesses)
read_array:

        beq     a1, x0, ra_exit # array length cannot be 0
        
        add     t1, x0, x0      # t1 is the index
        
        beq     x0, x0, ra_test

ra_loop:
        slli    t0, t1, 2
        add     t0, a0, t0
        lw      x0, 0(t0)       # do not need data
        
        # Set a breakpoint after LW
        add     t1, t1, a2      # index += stride_size
        bltu    t1, a1, ra_skip # out of the range?

        # reset the index
        add     t1, x0, x0
        
ra_skip:
        addi    a3, a3, -1

ra_test:
        bne     a3, x0, ra_loop
        
ra_exit:
        jalr    x0, ra, 0

