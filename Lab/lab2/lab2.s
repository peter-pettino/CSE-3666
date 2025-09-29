#       CSE 3666 Lab 2

        .globl  main

        .text
main:   
        # use system call 5 to read integer
        addi    a7, x0, 5
        ecall
        addi    s1, a0, 0       # copy to s1

        # TODO
        # Add you code here
        #   reverse bits in s1 and save the results in s2
        #   print s1 in binary, with a system call
        #   print newline
        #   print '=' if s1 is palindrome, otherwise print s2 in binary
        #   print newline
        
        addi t0, s1, 0		#t0 = s1
        addi s2, x0, 0		#s2 = 0
        addi s5, x0, 0		#s5 = 0
        
        addi s3, x0, 0		#s3 = 0
        addi s4, x0, 32		#s4 = 32
        
loop:	beq s3, s4, next	#if(s3 = s4): next

	slli s2, s2, 1		#s2 <<= 1
	andi s5, t0, 1		#s5 = (t0 & 1)
	or s2, s2, s5		#s2 = s2 | s5
	srli t0, t0, 1		#t0 >>= 1

	addi s3, s3, 1		#s3 += 1
	beq x0, x0, loop	#loop
	
next:	addi a0, s1, 0		# print s1
	addi a7, zero, 35
	ecall
	
	addi a0, x0, '\n'	# print new line
	addi a7, zero, 11
	ecall
	
	beq s1, s2, if		# if palindrome
	
	addi a0, s2, 0		# if not palindrome
	addi a7, zero, 35
	ecall
	beq x0, x0, exit

if: 	addi a0, x0, 61		# print =
	addi a7, zero, 11
	ecall
        
        # exit 
exit:   addi a0, x0, '\n'	# print new line
	addi a7, zero, 11
	ecall

	addi    a7, x0, 10      
        ecall