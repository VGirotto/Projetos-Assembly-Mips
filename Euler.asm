#Feito por Vinícius Girotto
#Esse programa gera uma aproximação para o número de euler
#Um exemplo para manipular float em MIPS

.data
	num0: .double 0.0
	num1: .double 1.0
	msg: .asciiz "\nO resultado final é:\n"
	
.text
	l.d $f0, num1
	l.d $f2, num1
	l.d $f6, num1
	l.d $f8, num0
	l.d $f10, num1
	l.d $f14, num1
	li $t0, 0
	
	j main
	
	zero:
		add.d $f0, $f8, $f6
		jr $ra
	
	fatorial:
		c.eq.d $f2, $f8		#Se f2 é igual a 0, pula para a label zero
		bc1t zero
		
		c.eq.d $f2, $f6	#Se f2 é igual a 1, pula para a label um
		bc1t um	
		
		sub.d $f2, $f2, $f6	#Subtrai 1 de f2
		
		um:
		mul.d $f0, $f0, $f2
		
		c.eq.d $f2, $f6		#Se f2 é igual a 1, encerra
		bc1t encerra
		
		j fatorial
		
		encerra:
			jr $ra
		
	main:
			
		jal fatorial
		
		div.d $f4, $f6, $f0 # 1 dividido pelo resultado do fatorial
		add.d $f14, $f14, $f4	#Soma o resultado
		
		addi $t0, $t0, 1
		add.d $f10, $f10, $f6	#Adiciona 1 em f5
		add.d $f2, $f8, $f10	#Dá o valor inicial do fatorial
		add.d $f0, $f8, $f10

		blt $t0, 10, main	#Verifica se foi de 0 a 9	
		
		li $v0, 4
		la $a0, msg	#Printa msg de resultado
		syscall
		
		li $v0, 3		#Printa a resposta
		mov.d $f12, $f14
		syscall
		
		
