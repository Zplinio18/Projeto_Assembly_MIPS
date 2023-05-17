.data
soma_imprime: .asciiz "Soma: "
	
.text

j MAIN

ZERAVETOR:	  
	move $t0, $a0
	addi $t1, $t0, 80
	li $t2, 0
	
	loopZera:
	bge $t0, $t1, saiDoZera
	li $v0, 1
	sw $t2, 0($t0) 
	
	addi $t0, $t0, 4
	j loopZera
	saiDoZera:
	jr $ra

TROCA:
	beq $a0, $a1, naotroca
	lw $t0, 0($s4)
    	lw $t1, 0($s5)
    	move $t2, $t0
    	move $t0, $t1
    	move $t1, $t2 
    
    	sw $t0, 0($s4)
    	sw $t1, 0($s5)
	jr $ra
	naotroca:
		jr $ra

VALORALEATORIO: 
	mul $t0, $a0, $a1 # coloca a * b em t0
    	add $t1, $t0, $a2 # a * b + c
   	div $t1, $a3      # (a * b + c) / d
   	mfhi $t2          # coloca o resto em $t2
    	sub $v0, $t2, $s0 # (a * b + c) % d - e
	jr $ra

INICIALIZAVETOR:
	#SALVANDO VALORES
	addi $sp, $sp, -20
	sw $ra, 12($sp) #salvando valor do endereço
	sw $a0, 0($sp) #salvando o vetor
	sw $a1, 4($sp) #salvando o tamanho 
	sw $a2, 8($sp) #salvando oultimo valor
	sw $s0, 16($sp)
	
	
	bgt $a1, $zero, inicializa #se o tamanho for maior que 0 ele vai inicializar
	#CASO BASE
	move $v0, $zero
	lw $ra, 12($sp)
	addi $sp, $sp, 20
	jr $ra
	#CASO RECURSIVO
	inicializa: 
		#PREPARANDO PARAMETROS PARA CHAMAR VALORALEATORIO
		lw $a0, 8($sp) #atribuindo o ultimo valor para a0
		li $a1, 47
		li $a2, 97
		li $a3, 337
		li $s0, 3
		jal VALORALEATORIO
		move $t0, $v0 #resultado do valor aleatorio 
		#SALVANDO VALOR ALEATORIO NO VET[TAMANHO-1]
		lw $a0, 0($sp) #voltando o vetor
		lw $a1, 4($sp) #voltando o tamanho
		addi $a1, $a1, -1 
		sll $t1, $a1, 2
		add $t2, $t1, $a0 #t2 recebe endereço de a0(vetor) na posição t1
		sw $t0, 0($t2)
		#CHAMANDO RECURSIVAMENTE
		move $a2, $t0
		jal INICIALIZAVETOR
		add $v0, $v0, $a2
		#VOLTANDO TODOS OS VALORES
		lw $ra, 12($sp) #salvando valor do endereço
		lw $a0, 0($sp) #salvando o vetor
		lw $a1, 4($sp) #salvando o tamanho 
		lw $a2, 8($sp) #salvando oultimo valor
		lw $s0, 16($sp)
		addi $sp, $sp, 20
		jr $ra
		
IMPRIMEVETOR:
	move $t0, $a0
	addi $t1, $t0, 80
	
	loop:
	bge $t0, $t1, saiDaImpressao
	li $v0, 1
	lw $a0, 0($t0) 
	syscall
	
	li $v0, 11
      	li $a0, 32
      	syscall
	
	addi $t0, $t0, 4
	j loop
	saiDaImpressao:
	li $v0, 11
	li $a0, 10
	syscall
	jr $ra

ORDENAVETOR:
	#SALVANDO VALORES
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	move $s0, $zero #i=0
	move $s1, $a1 #n-1
	
	Loop1: 
		bge $s0, $s1,Final1 #se o i >= tamanho acaba o loop
		move $s2, $s0
		addi $s3, $s0, 1
	Loop2:
		slt $t0, $s3, $s1 #verifica se j < n
		beq $t0, $zero, Final2 # se j >= n acaba o loop
		sll $t1, $s3, 2
		add $t1, $t1, $a0
		sll $t2, $s2, 2
		add $t2, $t2, $a0
		lw $t1, 0($t1)
		lw $t2, 0($t2)
		bge $t1, $t2, else #se vetj for maior ou igual a vetmin acaba o for
		move $s2, $s3
		else:
			addi $s3, $s3, 1#j++
			j Loop2 
		
	Final2:
		beq $s2, $s0, else2 #se min for igual o i vai pro else 
		sll $t0, $s2, 2
		add $s4, $a0, $t0
		sll $t0, $s0, 2
		add $s5, $a0, $t0
		jal TROCA
		else2:
			addi $s0, $s0,1#i++
			j Loop1
	Final1:
		#ACABA A FUNCAO ORDENA
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		
MAIN: 
	addi $sp,$sp, -80
	move $s0,$sp
	move $a0, $s0
	li $a1, 20
	li $a2, 71
	jal INICIALIZAVETOR
	move $s1, $v0 #atribuindo o soma com o valor do inicia vetor
	
	move $a0, $s0
	li $a1, 80
	jal IMPRIMEVETOR
	
	
	move $a0, $s0
	li $a1, 20
	jal ORDENAVETOR
	
	move $a0, $s0
	li $a1, 80
	jal IMPRIMEVETOR

	
	move $a0, $s0
	addi $a1, $s0, 80
	jal ZERAVETOR
	
	move $a0, $s0
	li $a1, 80
	jal IMPRIMEVETOR
	
	li $v0, 4
	la $a0, soma_imprime
	syscall
	li $v0, 1
	move $a0, $s1
	syscall	
	addi $sp, $sp, 80

