#       CSE 3666 Lab 1

        .globl  main

        .text
main:   

        # GCD examples:
        #     gcd(11, 121) = 11
        #     gcd(24, 60) = 12
        #     gcd(192, 270) = 6
        #     gcd(14, 97) = 1

        # read two positive integers from the console and 
        # save them in s1 and s2 

        # use system call 5 to read i3ntegers
        addi    a7, x0, 5
        ecall
        addi    s1, a0, 0       # a in s1

        addi    a7, x0, 5
        ecall
        addi    s2, a0, 0       # b in s2

        # TODO
        # Add you code here
        # compute GCD(a, b) and print it
loop:	beq s1, s2, exit

	bge s2, s1, else
	sub s1, s1, s2
	beq x0, x0, loop
	
else:	sub s2, s2, s1
	beq x0, x0, loop
	

        # sys call to exit
exit:	addi	a7, x0, 1
	add	a0, s1, x0
	ecall

	addi    a7, x0, 10      
        ecall
