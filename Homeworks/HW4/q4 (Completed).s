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
	addi	sp, sp, -8 #allocate save space
	sw	ra, 4(sp) #save ra
	sw	a1, 0(sp) #save a1
	addi	t1, x0, 10 #set t1 equal to 10
	bltu	a1, t1, else #if a1 < 10 go to else
	divu	a1, a1, t0 #uint2decstr(buffer, a1/10)
	jal	ra, uint2decstr #recursive call ^
	
else:	
	lw	ra, 4(sp) #restore ra
	lw	a1, 0(sp) #restore a1
	addi	t1, x0, 10 #t1 is 10 again
	remu	t2, a1, t1 #convert remainder to decimal and add to mem
	addi	t1, t2, '0' 
	sb	t1, 0(a0) #least sd in mem
	sb	t1, 1(a0) #2nd least sd in mem
	addi	a0, a0, 1 #increment pointer
	addi	sp, sp, 8 #put back the space on the stack
	jr	ra 
