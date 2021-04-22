.data
	nums: .word 12
	elems: .word 5,9,4,-10,2,3,7,-100,6,0,8,9
	cach: .asciiz " "
	ktt: .asciiz "Khong tim thay so trong day"
	enter: .asciiz "\nNhap so can tim trong day: "
	answer2: .asciiz "Vi tri cua so "
	answer2.1: .asciiz " trong day sau khi sap xep la: "
	answer1: .asciiz "Mang sau khi sap xep la: "
.text
main:
	la $a1, nums #a1: address nums
	la $a2, elems #a2: address array
	lw $s0, 0($a1) #s0=nums
	addi $s1, $s0, -1 #s1:high
	addi $s2, $0, 0 #s2=low
	jal quickSort
	jal answercaua
	jal search
	jal answercaub
	j endfind
endfind:
	li $v0, 10
	syscall
search:
	addi $s5, $0, 0
	la $a2, elems
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, enter
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $s1, $v0, 0 #s1: so can tim
	addi $t1, $0, 0 #t1: leftsearch
	addi $t2, $s0, -1 #t2: rightsearch
	jal counter
	#addi $s4, $s4, -1
	search1:
	slt $t6, $s4, $s5 #t6=1 if const<counter->counter<=const khi t6=0
	beq $t6, 1, nofind
	slt $t3, $t2, $t1
	beq $t3, 1, nofind
	sub  $t3, $t2, $t1
	beq $t3, 0, finish
	srl $t3, $t3, 1 #t3: mid 
	add $t3, $t3, $t1
	mul $t9, $t3, 4
	add $t9, $t9, $a2
	lw $s2, 0($t9) #s2=arr[mid]
	sub $t4, $s1, $s2
	beq $t4, 0, endsearch
	
	addi $s5, $s5, 1
	slt $t5, $s1, $s2 #t5=1 if socantim<arr[mid]
	beq $t5, 1, searchleft
	j searchright
finish:
	add $t3, $t1, $0
	mul $t9, $t3, 4
	add $t9, $t9, $a2
	lw $s2, 0($t9) #s2=arr[mid]
	sub $t4, $s1, $s2
	beq $t4, 0, endsearch
	j nofind	
counter:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $s4, $0, 0
	addi $s6, $s0, 0
	j loopcounter
	loopcounter:
	srl $s6, $s6, 1
	addi $s4, $s4, 1
	beq $s6, 1, breakloopcounter
	j loopcounter
	breakloopcounter:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
nofind: 
	la $a0, ktt
	li $v0, 4
	syscall
	j endfind 
	
endsearch:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
searchright:
	addi $t1, $t3, 1
	addi $t2, $t2, 0
	j search1
searchleft: 
	
	add $t1, $t1, 0
	add $t2, $t3, -1
	j search1
quickSort:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s5, 4($sp)
	sw $s7, 8($sp)
	slt $t0, $s2, $s1 #t0=1 if low<high
	beq $t0, 0, end
	jal partition
	add $s7, $0, $s1 #s7:high'
	addi $s1, $s4, -1
	addi $s5, $s4, 1 #s5=low'=pi+1
	jal quickSort
	add $s1, $s7, $0
	addi $s2, $s5, 0
	jal quickSort
end:
	lw $ra, 0($sp)
	lw $s5, 4($sp)
	lw $s7, 8($sp)
	addi $sp, $sp, 12
	jr $ra
partition: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	mul $t9, $s1, 4
	add $t9, $t9, $a2
	lw $s3, 0($t9) #s3:pivot
	
	add $t1, $0, $s2 #t1: left
	add $t2, $0, $s1 #t2=right
	addi $t2, $t2, -1
	Loop:
		Left:
		slt $t3, $t2,$t1 #t3=1 if right<left->break
		beq $t3, 1, Right
		addi $t9, $0, 0
		mul $t9, $t1, 4
		add $t9, $t9, $a2
		lw $t4, 0($t9) #t4=arr[left]
		slt $t3, $t4, $s3#t3=1 if pivot<arr[left]
		beq $t3, 0, Right
		addi $t1, $t1, 1
		j Left
		Right: 
		slt $t3, $t2, $t1 #t3=1 if right<left
		beq $t3, 1, breakright
		addi $t9, $0, 0
		mul $t9, $t2, 4
		add $t9, $a2, $t9
		lw $t4, 0($t9) #t4=arr[right]
		slt $t3, $t4, $s3 #t3=1 if arr[right]<pivot
		bne $t3, 0, breakright
		addi $t2, $t2, -1
		j Right
		breakright:
		slt $t3, $t2, $t1
		beq $t3, 1, breakLoop
		jal swap #swap(arr[t1], arr[t2])
		addi $t1, $t1, 1
		addi $t2, $t2, -1
		j Loop
		breakLoop:
		addi $t2, $s1, 0 
		jal swap
		addi $s4, $t1, 0 #s4: pi 
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
				
swap:
	addi $sp, $sp, -4
	sw $ra,0($sp)
	
	
	addi $t9, $0, 0
	mul $t9, $t1, 4
	add $t9, $a2,$t9
	mul $t8, $t2, 4
	add $t8, $a2, $t8
	
	lw $t7, 0($t9)
	lw $t6, 0($t8)
	
	sw $t7, 0($t8)
	sw $t6, 0($t9)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
answercaua:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t7, $0, 0 #t7=i
	la $a0, answer1
	li $v0, 4
	syscall
	Loopa:
	 slt $t8, $t7, $s0 #t8=1 if t7<nums
	 beq $t8, 0, exit 
	 lw  $a0, 0($a2)
	 li $v0, 1
	 syscall
	 la $a0,cach
	 li $v0,4
	 syscall
	 addi $t7, $t7, 1
	 addi $a2, $a2, 4
	 j Loopa	 
	exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
answercaub:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, answer2
	li $v0, 4
	syscall
	addi $a0, $s1, 0
	li $v0, 1
	syscall
	la $a0, answer2.1
	li $v0, 4
	syscall
	add $a0, $t3, $0
	li $v0, 1
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
