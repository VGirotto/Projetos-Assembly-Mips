.data
	msg1:	.asciiz "Digite um numero:\n"
	msg2:	.asciiz "O fatorial do número digitado é:\n"
	
.text
	li $v0, 4	#Printa a mensagem 1
	la $a0, msg1
	syscall
	
	li $v0, 5	#Lê o número
	syscall
	move $a1, $v0	#a1 armazena o valor digitado
	
	jal fatorial	#Chama a função fatorial
	
	mul $a1, $a1, $s0	#última multiplicação
	
	li $v0, 4
	la $a0, msg2	#Printa a mensagem 2
	syscall
	
	li $v0, 1		#Printa a resposta
	move $a0, $a1
	syscall
	
	li $v0, 10	#Encerra o programa
	syscall
	
	fatorial:
		subi $sp, $sp, 8	#Aloca espaço na pilha e empilha
		sw $a1, 4($sp)
		sw $ra, 0($sp)
		beq $a1, 1, base	#Se chegou no valor 1, pula para o caso base
		sub $a1, $a1, 1		#Subtrai 1 e chama a função fatorial de novo
		jal fatorial
		
		mul $a1, $a1, $s0	#Multiplica o valor anterior com o atual
		
	base:
		lw $s0, 4($sp)	#Caso base, desempilha e volta na recursão
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra