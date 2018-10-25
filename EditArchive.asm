#	Feito por Vinícius Girotto
#
#  Esse programa abre um arquivo e deixa maiúsculas as palavras "while", "else", "if", "void", "return", "char", "float", "for" e "int"

.data
	arquivo: .asciiz "/home/vinicius/Unifesp/4° Semestre/AOC/arquivo.c"		#caminho do arquivo que será editado
	leitura: .asciiz

.text

	#abrir arquivo
	li $v0, 13
	la $a0, arquivo
	li $a1, 0	#abre para leitura
	syscall
	move $s0, $v0	#Identificador do arquivo está em s0
	
	#ler arquivo
	li $v0, 14
	move $a0, $s0
	la $a1, leitura
	li $a2, 1000
	syscall
	move $s5, $v0	#s5 armazena quantos carcteres foram lidos
	move $s4, $s5	#s4 também
	
	#apenas para visualização no console
	li $v0, 4
	la $a0, leitura	#printa tudo lido
	syscall
	
	la $s1, leitura	#seta variável
	
	#fechar arquivo
	move $a0, $s0
	li $v0, 16
	syscall
	
			
	jal main	#Chama o main
	
	#abrir arquivo
	li $v0, 13
	la $a0, arquivo
	li $a1, 1	#abre pra escrever
	syscall
	move $s0, $v0	#Identificador do arquivo está em s0
	
	#escreve no arquivo
	li $v0, 15
	move $a0, $s0
	la $a1, leitura
	add $a2, $zero, $s4
	syscall
	
	#apenas para visualização no console
	li $v0, 4	
	la $a0, leitura	#printa tudo editado
	syscall
	
	#fechar arquivo
	move $a0, $s0
	li $v0, 16
	syscall
	
	#encerra
	li $v0, 10
	syscall	
	
	main:
		li $t8, 1
		bgt $s5, 0, compara	#se s5 ainda tiver elementos continua verificando
		jr $ra	#volta pra onde chamou o main
		
		compara:
			lb $t1, ($s1)	#pega o código ascii do elemento na posição de s1
			
			letra_c:
				bne $t1, 99, letra_e	#verifica se o elemento é a letra c
				move $s7, $s1		#s7 pega o conteúdo de s1
				#é a letra certa
				
				addi $s7, $s7, 1	#usando s7, vai percorrendo o resto da palavra sem perder o endereço da primeira letra (está em s1)
				lb $t7, ($s7)
				bne $t7, 104, letra_e	#verifica se é 'h'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 97, letra_e	#verifica se é 'a'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 114, letra_e	#verifica se é 'r'
				
				#é a palavra 'Char'
				li $t8, 67
				sb $t8, ($s1)	#escreve C
				li $t8, 72
				sb $t8, 1($s1)	#escreve H
				li $t8, 65
				sb $t8, 2($s1)	#escreve A
				li $t8, 82
				sb $t8, 3($s1)	#escreve R
				
				addi $t8, $zero, 4
				
				j proximo
				
			letra_e:
				bne $t1, 101, letra_f
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 108, letra_f	#verifica se é 'l'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 115, letra_f	#verifica se é 's'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 101, letra_f	#verifica se é 'e'
				
				#é a palavra 'else'
				li $t8, 69
				sb $t8, ($s1)	#escreve E
				li $t8, 76
				sb $t8, 1($s1)	#escreve L
				li $t8, 83
				sb $t8, 2($s1)	#escreve S
				li $t8, 69
				sb $t8, 3($s1)	#escreve E
				
				addi $t8, $zero, 4
				
				j proximo
			
			letra_f:
				bne $t1, 102, letra_i
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 111, letra_f2	#verifica se é 'o'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 114, letra_f2	#verifica se é 'r'
				
				#é a palavra 'for'
				li $t8, 70
				sb $t8, ($s1)	#escreve F
				li $t8, 79
				sb $t8, 1($s1)	#escreve O
				li $t8, 82
				sb $t8, 2($s1)	#escreve R
				
				addi $t8, $zero, 3
				
				j proximo
				
				letra_f2:		#verifica float
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 108, letra_i	#verifica se é 'l'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 111, letra_i	#verifica se é 'o'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 97, letra_i	#verifica se é 'a'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 116, letra_i	#verifica se é 't'
				
				#é a palavra 'for'
				li $t8, 70
				sb $t8, ($s1)	#escreve F
				li $t8, 76
				sb $t8, 1($s1)	#escreve L
				li $t8, 79
				sb $t8, 2($s1)	#escreve O
				li $t8, 65
				sb $t8, 3($s1)	#escreve A
				li $t8, 84
				sb $t8, 4($s1)	#escreve T
				
				addi $t8, $zero, 5
				
				j proximo
			
			letra_i:
				bne $t1, 105, letra_r
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 110, letra_i2	#verifica se é 'n'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 116, letra_i2	#verifica se é 't'
				
				#é a palavra 'INT'
				li $t8, 73
				sb $t8, ($s1)	#escreve I
				li $t8, 78
				sb $t8, 1($s1)	#escreve N
				li $t8, 84
				sb $t8, 2($s1)	#escreve T
				
				addi $t8, $zero, 3
				
				j proximo
				
				letra_i2:
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 102, letra_r	#verifica se é 'f'
				
				#é a palavra 'IF'
				li $t8, 73
				sb $t8, ($s1)	#escreve I
				li $t8, 70
				sb $t8, 1($s1)	#escreve F
				
				addi $t8, $zero, 2
				
				j proximo
			
			letra_r:
				bne $t1, 114, letra_v
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 101, letra_v	#verifica se é 'e'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 116, letra_v	#verifica se é 't'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 117, letra_v	#verifica se é 'u'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 114, letra_v	#verifica se é 'r'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 110, letra_v	#verifica se é 'n'
				
				#é a palavra 'RETURN'
				li $t8, 82
				sb $t8, ($s1)	#escreve R
				li $t8, 69
				sb $t8, 1($s1)	#escreve E
				li $t8, 84
				sb $t8, 2($s1)	#escreve T
				li $t8, 85
				sb $t8, 3($s1)	#escreve U
				li $t8, 82
				sb $t8, 4($s1)	#escreve R
				li $t8, 78
				sb $t8, 5($s1)	#escreve N
				
				addi $t8, $zero, 6
				
				j proximo
			
			letra_v:
				bne $t1, 118, letra_w
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 111, letra_w	#verifica se é 'o'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 105, letra_w	#verifica se é 'i'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 100, letra_w	#verifica se é 'd'
				
				
				#é a palavra 'VOID'
				li $t8, 86
				sb $t8, ($s1)	#escreve V
				li $t8, 79
				sb $t8, 1($s1)	#escreve O
				li $t8, 73
				sb $t8, 2($s1)	#escreve I
				li $t8, 68
				sb $t8, 3($s1)	#escreve D
				
				addi $t8, $zero, 4
				
				j proximo
			
			letra_w:
				bne $t1, 119, proximo
				move $s7, $s1
				#é a letra certa
				
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 104, proximo	#verifica se é 'h'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 105, proximo	#verifica se é 'i'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 108, proximo	#verifica se é 'l'
				addi $s7, $s7, 1
				lb $t7, ($s7)
				bne $t7, 101, proximo	#verifica se é 'e'
				
				#é a palavra 'Char'
				li $t8, 87
				sb $t8, ($s1)	#escreve W
				li $t8, 72
				sb $t8, 1($s1)	#escreve H
				li $t8, 73
				sb $t8, 2($s1)	#escreve I
				li $t8, 76
				sb $t8, 3($s1)	#escreve L
				li $t8, 69
				sb $t8, 4($s1)	#escreve E
				
				addi $t8, $zero, 5
				
			proximo:
				add $s1, $s1, $t8
				sub $s5, $s5, $t8
				
			j main
