#this program counts the intructions add and lw 
.data 
	cntAdd: .asciiz "\nNumber of add in main: "
	cntLw: .asciiz  "\nNumber of lw in main:  "
	addSub: .asciiz "\nNumber of add in subprogram: "
	lwSub: .asciiz "\nNumber of lw in subprogram: "
	array: .word 1,2,3
.text
	main:
	la $a0, L1
	la $a1, L2
	jal counter
	
L1: add $t0, $t0, $t0 
	add $t1, $t1, $t0
	add $t1, $t1, $t0
	add $t2, $t2, $t1
	lw $t7, array($0)
	add $t3, $t3, $t2
	add $t3, $t3, $t2
	#return values
	move $t0, $v0
	move $t1, $v1
	#display text
	li $v0, 4
	la $a0, cntAdd
	syscall
	#display adds in main
	li $v0, 1
	move $a0, $t0
	syscall
	#display text
	li $v0, 4
	la $a0, cntLw
	syscall
	#display lw in main
	li $v0, 1
	move $a0, $t1
	syscall
	#clear return values 
	li $v0, 0
	li $v1,0
	#load the addreses in the subprogram
	la $a0, L3
	la $a1, L4
	jal counter

	move $t2, $v0
	move $t3, $v1
	#display text
	li $v0, 4
	la $a0, addSub
	syscall
	#show the number add in subprogram 
	li $v0, 1
	move $a0, $t2
	syscall
	#display text 
	li $v0, 4
	la $a0, lwSub
	syscall
	#show number of lw in subprogram 
	li $v0, 1
	move $a0, $t3
	syscall
	
	add $t7, $t6, $t6
	
	li $v0, 10
L2: syscall
#=========================================================================================================================
	
	 counter:
	L3:	addi $sp, $sp, -36 #allocate the mem
		sw $s7, 32($sp)
		sw $s6, 28($sp)
		sw $s5, 24($sp)
		sw $s4, 20($sp)
		sw $s3, 16($sp)
		sw $s2, 12($sp)
		sw $s1, 8($sp)
		sw $s0, 4($sp)
		sw $ra ,0 ($sp)
		
		addi $s0, $a0,0#initial address 
		addi $s1, $a1,0#last addres
		li $s5,0#number of add
		li $s7,0#number of lw
		li $s4,32
		sll $s4, $s4, 26    
		li $s6,35
		
		loop:
			bge $s0, $s1, return
			lw $s2, 0($s0)
			addi $s3, $s2, 0 
			srl $s3, $s3, 26 #right shift to check most 6 significant bits
			beqz $s3, checkAdd #check if it is zero or not 
			beq $s3,$s6, incLw #check if it is equal to 35 which is the opcode of lw   
			addi $s0,$s0,4#otherwise check the next instruction
			j loop
			
		checkAdd:
			addi $s3, $s2,0#restore the value s3
			sll $s3, $s3, 26 #shift left to check least 6 sig bits which func of r-type
			beq $s3,$s4, increase#If it is equal to 32 increase the num of add
			addi $s0,$s0,4#otherwise next instr
			j loop #return back
			 
		increase:
			addi $s5, $s5,1 #increase the number of add
			addi $s0,$s0,4
			j loop 
			
		incLw:
			addi $s7, $s7,1#increase number of lw 
			addi $s0,$s0,4
			j loop 
			
		return:
			addi $v0, $s5, 0#add
			addi $v1, $s7,0 #lw
			lw $ra ,0 ($sp)
		    lw $s0, 4($sp)
		    lw $s1, 8($sp)
		    lw $s2, 12($sp)
		    lw $s3, 16($sp)
		    lw $s4, 20($sp)
		    lw $s5, 24($sp)
		    lw $s6, 28($sp)
		    lw $s0, 32($sp)
		L4: addi $sp, $sp, 36
	    	jr $ra
		    
		
