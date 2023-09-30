# arrayFunction.asm
       .data 
array: .word 8, 2, 1, 6, 9, 7, 3, 5, 0, 4
newl:  .asciiz "\n"

       .text
main:
	# Print the original content of array
	la   $a0, array         # setup the parameter(s)
	li   $a1, 10    
    jal  printArray         # call the printArray function
    
	# Ask the user for two indices
	li   $v0, 5         	# System call code for read_int
	syscall           
	addi $t0, $v0, 0    	# first user input in $t0
 
	li   $v0, 5         	# System call code for read_int
	syscall           
	addi $t1, $v0, 0    	# second user input in $t1

	# Call the findMin function
	la   $a0, array
    sll  $t0, $t0, 2        # setup the parameter(s)
 	sll  $t1, $t1, 2
    add  $a1, $a0, $t1
    add  $a0, $a0, $t0
    jal findMin             # call the function

	# Print the min item
    addi $t8, $v0, 0
    lw   $t3, 0($t8)    # place the min item in $t3 for printing

	# Print an integer followed by a newline
	li   $v0, 1   		# system call code for print_int
    addi $a0, $t3, 0    # print $t3
    syscall       		# make system call

	li   $v0, 4   		# system call code for print_string
    la   $a0, newl    	# 
    syscall       		# print newline

	#Calculate and print the index of min item
    la   $a0, array
    sub  $t3, $t8, $a0
    srl  $t3, $t3, 2    # Place the min index in $t3 for printing	

	# Print the min index
	# Print an integer followed by a newline
	li   $v0, 1   		# system call code for print_int
    addi $a0, $t3, 0    # print $t3
    syscall       		# make system call
	
	li   $v0, 4   		# system call code for print_string
    la   $a0, newl    	# 
    syscall       		# print newline
	
	# End of main, make a syscall to "exit"
	li   $v0, 10   		# system call code for exit
	syscall	       		# terminate program
	

#######################################################################
###   Function printArray   ### 
#Input: Array Address in $a0, Number of elements in $a1
#Output: None
#Purpose: Print array elements
#Registers used: $t0, $t1, $t2, $t3
#Assumption: Array element is word size (4-byte)
printArray:
	addi $t1, $a0, 0	# $t1 is the pointer to the item
	sll  $t2, $a1, 2	# $t2 is the offset beyond the last item
	add  $t2, $a0, $t2 	# $t2 is pointing beyond the last item
l1:	
	beq  $t1, $t2, e1
	lw   $t3, 0($t1)	# $t3 is the current item
	li   $v0, 1   		# system call code for print_int
    addi $a0, $t3, 0   	# integer to print
    syscall       		# print it
	addi $t1, $t1, 4
	j    l1				# Another iteration
e1:
	li   $v0, 4   		# system call code for print_string
    la   $a0, newl    	# 
    syscall       		# print newline
	jr   $ra			# return from this function


#######################################################################
###   Student Function findMin   ### 
#Input: Lower Array Pointer in $a0, Higher Array Pointer in $a1
#Output: $v0 contains the address of min item 
#Purpose: Find and return the minimum item 
#              between $a0 and $a1 (inclusive)
#Registers used: $t0, $t1, $t2, $t3 
#Assumption: Array element is word size (4-byte), $a0 <= $a1
findMin:
    lw $t0, 0($a0)       # store the minimum in range in $t0
    addi $t1, $a0, 0     # store the address of the minimum in $t1
loop:
    beq $a0, $a1, findMinExit
    lw  $t2, 0($a0)
    slt $t3, $t2, $t0
    beq $t3, $zero, loopContinue
    addi $t0, $t2, 0
    addi $t1, $a0, 0 
loopContinue:
    addi $a0, $a0, 4
    j loop
findMinExit:    
    addi $v0, $t1, 0 
	jr $ra			# return from this function
