####	Feito por Vinícius Girotto
#
#
#	Nesse projeto você pode escolher a pasta que salvará os arquivos, desde que altere a variável quantEnd com o tamanho do endereço
#
#	As configurações da tela para o Bitmap Display são:	32x32 / 256x256 / heap
#	Essas configurações foram usadas para desenhar as letras(por isso o fundo azul) em 16x16. Para desenhar as imagens é preciso alterar
#	alguns valores pelo código, para ter o tamanho 16x16 e o fundo branco.
#
#	Não esqueça de abrir o Keyboard and Display MMIO para navegar com o cursor usando awsd.
#
#	Botões:
#	0 = preto	1 = cinza	2 = azul	3 = amarelo	4 = verde
#	5 = laranja	6 = vermelho	7 = marrom	8 = Rosa	9 = roxo
#	q = Apagar/branco	k = salvar
#

.eqv cont $t6
.eqv contPos $t7

.data
	pos:		.word 0
	vetor:		.space 256
	yellow:   	.word 0xFFFF00
	white:		.word 0xFFFFFF
	blue: 		.word 0x2E8CF6
	orange: 	.word 0xF67F2E
	black:	  	.word 0x000000
	gray:	  	.word 0xC0C0C0
	red: 	  	.word 0xFF0000
	dimgray:  	.word 0x696969
	green:	  	.word 0x008000
	brown:	  	.word 0x8B4513
	pink:	  	.word 0xFF1493
	purple:	  	.word 0x800080
	LimeGreen:	.word 0x3CB371
	msg2:		.asciiz "Você quer abrir um arquivo já salvo? Digite 's' para sim."
	quantEnd:	.word 28	#Troque aqui a quantidade de caracteres do endereço da pasta onde serão salvos os arquivos
	msg:		.asciiz "Qual será o nome do arquivo? Use apenas 7 letras."
	end:		.asciiz "/home/vinicius/Interface/pA/"
	aux2:		.asciiz
	palavra:	.asciiz
	aux:		.asciiz

.text
#512x512 / 2x2
	#Desenho 16x16: 256*256 / 32*32
	#Desenho 8x8: 128*128 / 16*16
	
	#Pergunta o nome do arquivo
	li $v0, 4
	la $a0, msg
	syscall
	
	li $v0, 11	# \n
	li $a0, 10
	syscall
	
	#Salva o nome do arquivo
	la $a0, palavra
	li $a1, 8
	li $v0, 8
	syscall
	
	li $v0, 11	# \n
	li $a0, 10
	syscall
	
	li $t5, 0	#Zera contadores para o loop
	lw $t1, quantEnd
	
	loop:	#Colocar o nome digitado no endereço do arquivo
		lb $t0, palavra($t5)
		sb $t0, end($t1)
		addi $t5, $t5, 1
		addi $t1, $t1, 1
		blt $t5, $a1, loop
		
	#Escrever ".txt"
	subi $t1, $t1, 1
	li $t0, 46
	sb $t0, end($t1)
	addi $t1, $t1, 1
	
	li $t0, 116
	sb $t0, end($t1)
	addi $t1, $t1, 1
	
	li $t0, 120
	sb $t0, end($t1)
	addi $t1, $t1, 1
	
	li $t0, 116
	sb $t0, end($t1)
	
	li $v0, 11	# \n
	li $a0, 10
	syscall
	
	#Pergunta se quer abrir um arquivo
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 11	# \n
	li $a0, 10
	syscall
	
	li $v0, 12
	syscall
	move $t6, $v0
	
	li $v0, 11	# \n
	li $a0, 10
	syscall
	
	beq $t6, 115, abrir	#Se quer abrir, vá para a label abrir
	
	
	la $t3, vetor
	lw $t4, blue		# Seleciona cor do background
	li $t6, 0
	loopInicial:
		sw $t4, ($t3)
		addi $t3, $t3, 4
		addi $t6, $t6, 1
		blt $t6, 64, loopInicial #loop
	
	
	inicial:
		#Inicia valores
		li $t1, 0x10040000
		move $t2, $t1
		sw $t1, pos
		li contPos, 1
		
		
	jogo:	#Onde ocorrem todos os processos do jogo
		li $t6, 0
		move $t1, $t2	#t1 assume a primeira posição do mapa
		la $t3, vetor
		jal limpa_tela
		jal desenha
		jal jogar
		j jogo
	
	limpa_tela:
		lw $s0, ($t3)
		sw $s0, ($t1)	#pinta a tela com as cores guardadas no vetor
		addi $t1, $t1, 4
		addi $t3, $t3, 4	
		addi $t6, $t6, 1
		blt $t6, 64, limpa_tela #loop
		
		jr $ra
		
	desenha:
		lw $s0, dimgray
		lw $t0, pos	#Recebe a posição atual e pinta o cursor
		sw $s0, ($t0)
		
		#Pinta os pixels que estão no arquivo
		
		jr $ra
	
	jogar:
		li $v0, 32		#Pequeno delay
		add $a0, $zero, 10
		syscall
		
		li $t3, 0xffff0000	#Lê a tecla
		lw $t5, ($t3)
		andi $t4, $t5, 0x0001	#Verifica se teve novo input
		beqz $t4, jogar
		
		lw $t5, 4($t3)	#Pega o input
		
		move_left:			#Verificação de direções
			bne $t5, 97, move_down	#botão a
			lw $t0, pos
			addi $t0, $t0, -4
			addi contPos, contPos, -1
			sw $t0, pos
			jr $ra
			
		move_down:
			bne $t5, 115, move_up #botão s
			lw $t0, pos
			addi $t0, $t0, 32
			addi contPos, contPos, 8
			sw $t0, pos
			jr $ra
			
		move_up:
			bne $t5, 119, move_right #botão w
			lw $t0, pos
			addi $t0, $t0, -32
			addi contPos, contPos, -8
			sw $t0, pos
			jr $ra
			
		move_right:
			bne $t5, 100, botK #botão d
			lw $t0, pos
			addi $t0, $t0, 4
			addi contPos, contPos, 1
			sw $t0, pos
			jr $ra
			
		botK:
			bne $t5, 107, bot0				
			j salvar
			
		bot0:
			bne $t5, 48, bot1
			lw $s0, black
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot1:
			bne $t5, 49, bot2
			lw $s0, gray
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot2:
			bne $t5, 50, bot3
			lw $s0, blue
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot3:
			bne $t5, 51, bot4
			lw $s0, yellow
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot4:
			bne $t5, 52, bot5
			lw $s0, green
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot5:
			bne $t5, 53, bot6
			lw $s0, orange
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot6:
			bne $t5, 54, bot7
			lw $s0, red
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot7:
			bne $t5, 55, bot8
			lw $s0, brown
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot8:
			bne $t5, 56, bot9
			lw $s0, pink
			li cont, 1
			la $t3, vetor
			j pinta
			
		bot9:
			bne $t5, 57, botP
			lw $s0, purple
			li cont, 1
			la $t3, vetor
			j pinta
			
		botP:
			bne $t5, 112, apagar
			lw $s0, LimeGreen
			li cont, 1
			la $t3, vetor
			j pinta
		
		apagar:
			bne $t5, 113, jogar
			lw $s0, white
			li cont, 1
			la $t3, vetor
			j pinta
		
		pinta:			
			beq contPos, cont, pinta2
			addi cont, cont, 1
			addi $t3, $t3, 4
			j pinta
			pinta2:			
				sw $s0, ($t3)
				
			jr $ra
	
		salvar:	
			#Abrir arquivo
			li $v0, 13
			la $a0, end
			li $a1, 1
			syscall
			move $s3, $v0
						
			#Percorrer vetor
			la $t3, vetor
			li cont, 0
			la $s2, aux
			
			loopCores:
			lw $t4, ($t3)
			
			cor0:
				lw $t8, black
				bne $t8, $t4, cor1
				li $t8, 48	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor1:
				lw $t8, gray
				bne $t8, $t4, cor2
				li $t8, 49	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor2:
				lw $t8, blue
				bne $t8, $t4, cor3
				li $t8, 50	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor3:
				lw $t8, yellow
				bne $t8, $t4, cor4
				li $t8, 51	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor4:
				lw $t8, green
				bne $t8, $t4, cor5
				li $t8, 52	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor5:
				lw $t8, orange
				bne $t8, $t4, cor6
				li $t8, 53	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor6:
				lw $t8, red
				bne $t8, $t4, cor7
				li $t8, 54	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor7:
				lw $t8, brown
				bne $t8, $t4, cor8
				li $t8, 55	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor8:
				lw $t8, pink
				bne $t8, $t4, cor9
				li $t8, 56	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor9:
				lw $t8, purple
				bne $t8, $t4, corQ
				li $t8, 57	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			corQ:
				lw $t8, white
				bne $t8, $t4, corP
				li $t8, 113	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
			
			corP:
				lw $t8, LimeGreen
				bne $t8, $t4, erro
				li $t8, 112	#0 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
		
			erro:
				li $v0, 1
				li $a0, 99999
				syscall
				li $v0, 10
				syscall
			
			
		loopSalvar:
			addi $s2, $s2, 1	#printa um espaço
			li $t8, 32
			sb $t8, ($s2)
			addi $s2, $s2, 1			
			addi cont, cont, 1
			addi $t3, $t3, 4
			blt cont, 64, loopCores #loop
	
			# Write to file just opened
 			li   $v0, 15       # system call for write to file
 			move $a0, $s3      # file descriptor 
 			la   $a1, aux   # address of buffer from which to write
 			li   $a2, 128       # hardcoded buffer length
 			syscall            # write to file
		
		
			# Close the file 
  			li   $v0, 16       # system call for close file
  			move $a0, $s3      # file descriptor to close
 			syscall            # close file
 			
 			li $v0, 10
 			syscall	#Encerrar o programa
 			
 	abrir:
 		#Abrir arquivo e iniciar vetor
	
		li $v0, 13
		la $a0, end
		li $a1, 0	#Abre para leitura
		syscall
		move $s3, $v0
		
		li $v0, 14	#Faz a leitura
		move $a0, $s3
		la $a1, aux2
		li $a2, 128
		syscall
	
		la $t3, vetor
		li $t6, 0
		la $t8, aux2
		loopInicial2:	
			lb $t9, ($t8)
			subi $t9, $t9, 48
			
			bne $t9, 0, abrir1
			lw $t4, black
			j abreCor
			
			abrir1:
			bne $t9, 1, abrir2
			lw $t4, gray
			j abreCor
			
			abrir2:
			bne $t9, 2, abrir3
			lw $t4, blue
			j abreCor
			
			abrir3:
			bne $t9, 3, abrir4
			lw $t4, yellow
			j abreCor
			
			abrir4:
			bne $t9, 4, abrir5
			lw $t4, green
			j abreCor
			
			abrir5:
			bne $t9, 5, abrir6
			lw $t4, orange
			j abreCor
			
			abrir6:
			bne $t9, 6, abrir7
			lw $t4, red
			j abreCor
			
			abrir7:
			bne $t9, 7, abrir8
			lw $t4, brown
			j abreCor
			
			abrir8:
			bne $t9, 8, abrir9
			lw $t4, pink
			j abreCor
			
			abrir9:
			bne $t9, 9, abrirP
			lw $t4, purple
			j abreCor
			
			abrirP:
			bne $t9, 64, abrirQ
			lw $t4, LimeGreen
			j abreCor
			
			abrirQ:
			lw $t4, white
		
			abreCor:
			sw $t4, ($t3)
			addi $t3, $t3, 4
			addi $t6, $t6, 1
			addi $t8, $t8, 2
			blt $t6, 64, loopInicial2 #loop
			
			#fechar arquivo
			move $a0, $s3
			li $v0, 16
			syscall
	
		j inicial
		
