#       CSE 3666 Lab 4
#	TAG: 61ed0598ed0f3e3e43c5abc168c4387d

	.data
	.align	2	
word_array:     .word
        0,   10,   20,  30,  40,  50,  60,  70,  80,  90, 
        100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
        200, 210, 220, 230, 240, 250, 260, 270, 280, 290,
        300, 310, 320, 330, 340, 350, 360, 370, 380, 390,
        400, 410, 420, 430, 440, 450, 460, 470, 480, 490,
        500, 510, 520, 530, 540, 550, 560, 570, 580, 590,
        600, 610, 620, 630, 640, 650, 660, 670, 680, 690,
        700, 710, 720, 730, 740, 750, 760, 770, 780, 790,
        800, 810, 820, 830, 840, 850, 860, 870, 880, 890,
        900, 910, 920, 930, 940, 950, 960, 970, 980, 990

        # code
        .text
        .globl  main
main:   
	addi	s0, x0, -1
	addi	s1, x0, -1
	addi	s2, x0, -1
	addi	s3, x0, -1
	addi	s4, x0, -1
	addi	s5, x0, -1
	# help to check if any saved registers are changed during the function call
	# could add more...

        # la      s1, word_array
        lui     s1, 0x10010      # starting addr of word_array in standard memory config
        addi    s2, x0, 100      # 100 elements in the array

        # read an integer from the console
        addi    a7, x0, 5
        ecall

        addi    s3, a0, 0       # keep a copy of v in s3
        
        # call binary search
        addi	a0, s1, 0
        addi	a1, s2, 0
        addi	a2, s3, 0
        jal	ra, binary_search

	# print the return value
        jal	ra, print_int

	# set a breakpoint here and check if any saved register was changed
        # exit
exit:   addi    a7, x0, 10      
        ecall

# a function that prints an integer, followed by a newline
print_int: 
        addi    a7, x0, 1
        ecall
 
        # print newline
        addi    a7, x0, 11
        addi    a0, x0, '\n'
        ecall        
         
        jalr    x0, ra, 0
	
#### Do not change lines above
binary_search:
	addi sp, sp, -8 #add space on the stack and add ra and s1 to the stack
	sw ra, 0(sp)
	sw s1, 4(sp)

firstif:	
	bne a1, x0, divide #if there's something in the array, move on to divide, otherwise go to f_exit and set rv to -1
	addi a0, x0, -1 
	beq x0, x0, f_exit

divide:
	srli t0, a1, 1 #half = n / 2
	slli t1, t0, 2 #half * 4
	add t1, t1, a0 #a[half]
	lw a6, 0(t1) #half_v = a[half]
	
if:	
	bne a2, a6, elseif #if half_v == v set rv equal to half and then jump to f_exit
	add a0, t0, x0 #rv = half
	beq x0, x0, f_exit
	
elseif:
	blt a6, a2, else #if v is less than half_v, set rv = a recursive call of binary search with arugments, a0 = a, a1 = half, a2 = v 
	add a1, t0, x0
	jal ra, binary_search #(search the first half excluding a[half]
	beq x0, x0, f_exit
	
else:
	addi s1, t0, 1 #left = half + 1
	slli t2, s1, 2 #multiply by 4
	add a0, a0, t2 #calculate the address &a[left]
	sub a1, a1, s1 #subtract n - left and set it to a1
	jal ra, binary_search #call binary search for the left side
	
	blt a0, x0, f_exit #inner if rv >= 0
	add a0, a0, s1 #rv += left
	
	
f_exit:
	
	lw ra, 0(sp) #restore the registers
	lw s1, 4(sp)
	
	addi sp, sp, 8 #reset the stack pointer
	
	jalr x0, ra, 0
        
