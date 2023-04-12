	addi sp, sp, 16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)

msortexit:
	jalr ra

msort:
	addi s0, x0, 1028 #address c[256] stored in s0
	addi s1, x0, 1 #set s1 to 1
	bge s1, a1, msortexit #check if n <= 1, if not stop the function.
	srai s1, a1, 2 #n / 2
	addi a1, s1, 0 #set a1 to n1
	addi sp, sp, 8
	sw a0, 16(sp) #I'm just gonna store these just incase msort changes them
	sw a1, 20(sp)
	
	jal ra, msort #go back to msort!
	
	lw a0, 16(sp) #time to restore them :)
	lw a1, 20(sp)
	
	addi s2, a0, x0#save this to s2 because we need to change a0 and use both a0 and s2 in the next call.
	slli s1, s1, 4 #n1 * 4
	addi a0, a0, s1 #&d[n1] set to a0
	sub a1, a1, s1
	sw a0, 16(sp) #store again
	sw a1, 20(sp)
	
	jal ra, msort #go back again.
	
	lw a0, 16(sp) #time to restore them AGAIN
	lw a1, 20(sp)
	
	addi a0, s0, 0 #a0 = c
	addi a4, a1, 0 #a4 = n - n1
	addi a3, a0, 0 #a3 = &d[n1]
	addi a2, s1, 0 #a2 = n1
	addi a1, s2, 0 #a1 = d
	
	addi sp, sp, 12
	sw a0, 16(sp) #store again
	sw a1, 20(sp)
	sw a2, 24(sp)
	sw a3, 28(sp)
	sw a4, 32(sp)
	
	jal ra, merge #call merge
	
	lw a0, 16(sp) #time to restore them AGAIN
	lw a1, 20(sp)
	lw a2, 24(sp)
	lw a3, 28(sp)
	lw a4, 32(sp)
	
	addi a3, a1, 0 #using it quickly because I know it's safe.
	addi a1, a0, 0 #a1 = c
	addi a0, a3, 0 #a0 = d
	addi s1, s1, 0 #janky, n - n1 + n1 = n lol
	addi a2, s1, 0 #store n in a2
	addi a3, x0, 0 #just empty these.
	addi a4, x0, 0 
	
	jal ra, copy #call the last function, copy.
	 
end:
	lw ra, 0(sp) #reload the initial stores and add the words back to sp
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp,sp, 36
	li a7, 10 #exit
	ecall #the register a0 should contain the return value requried, however the psuedo code doesn't ask for any kind of print or return.