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
        # use li to make it easier to load the number 
        li	a1, -1
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
