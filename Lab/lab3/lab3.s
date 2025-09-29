# CSE 3666
        
        .data                   #data segment
        .align 2

src:   .word   
  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
 10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
 20,  21,  22,  23,  24,  25,  26,  27,  28,  29,
 30,  31,  32,  33,  34,  35,  36,  37,  38,  39,
 40,  41,  42,  43,  44,  45,  46,  47,  48,  49,
 50,  51,  52,  53,  54,  55,  56,  57,  58,  59,
 60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
 70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
 80,  81,  82,  83,  84,  85,  86,  87,  88,  89,
 90,  91,  92,  93,  94,  95,  96,  97,  98,  99,
100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
120, 121, 122, 123, 124, 125, 126, 127

dst:    .space  1024

        .text
        .globl  main

main: 
        lui     s1, 0x10010     # hard-coded src address
        addi    s3, s1, 512     # s3 is the destination array

        # read n, the number of words to shuffle
        # n is even and 2 <= n <= 128
        addi    a7, x0, 5
        ecall

        # n is in a0

        # TODO:
        # write a loop to shuffle n words
        # the address of the source array src is in s1
        # the address of the destination array dst is in s3
        # register s2 will store the address of the second half of src
        # the folloiwng code can use any t and a registers
        
        slli	t0, a0, 1	# t0 = n*2
        add	s2, s1, t0	# right address
        
        add	t0, x0, x0	# t0 = 0
        srli	t1, a0, 1	# t1 = n/2
        
loop:	beq	t0, t1, exit	# if(t0 == t1) goto exit

	add	t5, s1, t2	# update offset for s1
	lw	t3, 0(t5)	# save contents to t3
	
	slli	t4, t2, 1	# apply offset to s3
	add	t4, t4, s3
		
	sw	t3, 0(t4)	# save to s3
	
	add	t5, s2, t2	# apply offset to s2
	lw	t3, 0(t5)	# save contents to t3
	
	addi,	t4, t4, 4	# update s3 offset
	
	sw	t3, 0(t4)	# save to s3

	addi	t2, t2, 4	# update offset
	
	addi	t0, t0, 1	# t0 += 1
	beq	x0, x0, loop	# goto loop

#// s1 is the starting address of src
#// s1 is also the address of the left half
#// s3 is the starting address of dst

#Place the starting address of the right half in s2

#for (i = 0; i < n/2; i += 1) {
#    dst[i+i] = left[i]
#    dst[i+i+1] = right[i]
#}

exit:   addi    a7, x0, 10      # syscall to exit
        ecall   
