# arrayCount.asm
  .data 
arrayA: .word 10, 0, 30, 22, 9, 17, 6, 9   # arrayA has 5 values
count:  .word 0            # dummy value

  .text
main:
    la $t0, arrayA
    la $t8, count
    add $t7, $zero, $zero # count of how many ints divisible
inputs: 
    beq $t0, $t8, read
    li $v0, 5
    syscall
    sw $v0, 0($t0)
    addi $t0, $t0, 4
    j inputs
   
    # code for reading in the user value X
read:
    la $t0, arrayA
    li $v0, 5
    syscall
    addi $t5, $v0, -1 # mask to check divisibility

    # code for counting multiples of X in arrayA
loop:
    beq $t0, $t8, print 
    lw  $t3, 0($t0) # current int in array
    and $t4, $t3, $t5
    bne $t4, $zero, else
    addi $t7, $t7, 1
    addi $t0, $t0, 4
    j loop
else:
    addi $t0, $t0, 4
    j loop

    # code for printing result
print:    
    li $v0, 1
    add $a0, $t7, $zero
    syscall

    # code for terminating program
    li  $v0, 10
    syscall
