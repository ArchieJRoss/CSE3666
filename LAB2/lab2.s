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
       
	addi	t0, x0, 32
	addi	t6, x0, 0
	addi	t1, s1, 0
	addi	s2, x0, 0
	
loop: 	beq	t0, t6, Print 

Move:	slli 	s2, s2, 1
	andi	t3, t1, 1
	or	s2, s2, t3
	srli	t1, t1, 1
	addi	t6, t6, 1
	beq	x0, x0, loop

Print:        #   print s1 in binary, with a system call
        addi 	a0, s1, 0
        addi	a7, x0, 35
        ecall   	
        #   print newline
	addi 	a0, x0, '\n'
        li	a7, 11
        ecall
        #   print s2 in binary
        addi 	a0, s2, 0
        addi	a7, x0, 35
        ecall
        #   print newline
	addi 	a0, x0, '\n'
        li	a7, 11
        ecall
        
        # exit
exit:   addi    a7, x0, 10      
        ecall
