#       CSE 3666 Lab 3: remove spaces

        .data
        # allocating space for both strings
str:    .space  128
res:    .space  128

        .globl  main

        .text
main:
        # load address of strings 
        la      s0, str
        la      s1, res



        # we do not need LA pseudoinstructions from now on

        # read a string into str
        addi    a0, s0, 0 
        addi    a1, x0, 120
        addi    a7, x0, 8
        ecall

        # str's addres is already in s0
        # copy res's address to a1
        addi    a1, s1, 0

        addi    x1, s0, 0
        addi    x2, s1, 0

loop:
        lb      x3, 0(x1) #load the current character from str
        addi    x1, x1, 1 #move to the next character in str
        beq     x3, x0, finish #check if the current character is NUL
        li      t0, ' ' #load the ASCII code for space
        bne     x3, t0, char #check if the current character is not a space
        beq    x0, x0, loop #if it is a space, jump back to the top of loop
char:
        sb      x3, 0(x2) # store the current character in res
        addi    x2, x2, 1 #move to the next position in res
        beq    x0, x0, loop #jump back to the start of loop

finish:
        # set x4 to 0 (NUL)
        addi    x4, x0, 0
        # store x4 in the next position after the last character in res
        sb      x4, 0(x2)
        # print the res string
        addi    a0, s1, 0
        addi    a1, x0, 120
        addi    a7, x0, 4
        ecall

exit:   addi    a7, x0, 10
        ecall