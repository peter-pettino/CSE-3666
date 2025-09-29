#       CSE 3666 uint2decstr

        .globl  main

        .text
main:   
        # create an array of 128 bytes on the stack
        addi    sp, sp, -128

        # copy array's address to a0
        addi    a0, sp, 0

	# set all bytes in the buffer to 'A'
        addi    a1, x0, 0       # a1 is the index
	addi	a2, x0, 128
	addi	t2, x0, 'A'
clear:
        add     t0, a0, a1
	sb	t2, 0(t0)
        addi    a1, a1, 1
	bne	a1, a2, clear
	
        # change -1 to other numbers to test
        # you can use li load other numbers for testing
        # li      a1, 36663666
        addi	a1, zero, -1
	jal	ra, uint2decstr

        # print the string
        addi    a0, sp, 0
        addi    a7, x0, 4
        ecall

exit:   addi    a7, x0, 10      
        ecall

# char * uint2decstr(char *s, unsigned int v) 
# the function converts an unsigned 32-bit value to a decimal string
# Here are some examples:
# 0:    "0"
# 2022: "2022"
# -1:   "4294967295"
# -3666:   "4294963630"
uint2decstr:
	addi	sp, sp, -12
	sw	ra, 8(sp)
	sw	s0, 4(sp)
	sw	s1, 0(sp)
	add	s0, x0, a0	# s0 = s
	add	s1, x0, a1	# s1 = v
	
	addi	t1, x0, 10	# t1 = 10
	bltu	s1, t1, skip	# if(v < 10) goto skip
	add	a0, x0, s0	# a0 = s
	divu	a1, s1, t1	# a1 = v / 10
	jal	ra, uint2decstr
	add	s0, x0, a0	# s = uint2decstr(s, v / 10)

skip:
	remu	t0, s1, t1	# r = v % 10
	addi	t0, t0, '0'	# t0 = '0' + r
	sb	t0, 0(s0)	# s[0] = '0' + r
	sb	x0, 1(s0)	# s[1] = 0
	
	addi	a0, s0, 1	# a0 = &s[1]
	lw	ra, 8(sp)
	lw	s0, 4(sp)
	lw	s1, 0(sp)
	addi	sp, sp 12
	jalr	x0, ra, 0	# return
