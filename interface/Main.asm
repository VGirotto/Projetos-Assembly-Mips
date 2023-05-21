#	Feito por Vinícius Girotto	#
#
#
#	Intruções:
#		É NECESSÁRIO para o funcionamento do programa que os arquivos estejam salvos num endereço com 28 caracteres, 
#		sem contar o nome do arquivo e a barra anterior. Siga conforme já foi feito nos nomes das variáveis.
#		Coloquei uma contagem de três vezes até 9 mais 1 para exemplificar os 28 caracteres.
#
#		A função de salvar não está funcionando, retornando "erro" ao apertar o botão "k". Infelizmente não tive
#		tempo de corrigir, mas todas as imagens usadas nesse projeto, inclusive as letras, foram feitas usando um programa
#		para desenho que eu mesmo fiz em MIPS, que enviei junto na pasta(tela.asm). Nesse programa a função salvar funciona.
#
#		Não esqueça de abrir o Keyboard and Display MMIO para navegar com o cursor usando awsd.
#
#		As especificações da tela do Bitmap display são: 	2x2 / 512x512 / heap
#
#		É preciso ter na mesma pasta todos os arquivos prontos de tiles e letras pro programa funcionar como esperado.
#
#	Botões:
#	0 = Batatinhas	1 = Hulk	2 = Sapo	3 = Nyan Cat	4 = Suco
#	5 = Gameboy	6 = Flor	7 = Cogumelo	8 = Carinha	9 = Charmander
#	q = Apagar	k = salvar
#

.eqv cont $t6
.eqv contPos $t7

.data
	pos:		.word 0
	
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
	end2:		.asciiz "/home/vinicius/Interface/pA/tiles04.txt"	#Char 36 é trocado
	msg2:		.asciiz "Você quer abrir um arquivo já salvo? Digite 's' para sim."
	quantEnd:	.word 28	#Tamanho do endereço. É necessário que continue sendo 28
	end3:		.asciiz "/home/vinicius/Interface/pA/letrasA.txt"	#Char 35 é trocado
	msg:		.asciiz "Qual será o nome do arquivo? Use apenas 7 letras."
	end:		.asciiz "/home/vinicius/Interface/pA/"
				#1234567891234567891234567891
	aux2:		.asciiz
	aux3:		.asciiz
	palavra:	.asciiz
	aux:		.asciiz
	.align 2
	vetor:		.space 163904

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
	lw $t4, white
	li $t6, 0
	loopInicial:
		sw $t4, ($t3)
		addi $t3, $t3, 4
		addi $t6, $t6, 1
		blt $t6, 40992, loopInicial #loop
	
	
	inicial:
		#Inicia valores
		li $t1, 0x10040000
		move $t2, $t1
		sw $t1, pos
		li contPos, 1
	
	#Pintar interface
	lw $t4, blue
	addi $t1, $t1, 640
	
	jal interface1	
	
		li $v0, 1
		li $a0, 10
		syscall	
		
	jogo:	#Onde ocorrem todos os processos do jogo
		li $t6, 0
		move $t1, $t2	#t1 assume a primeira posição do mapa
		la $t3, vetor
		#addi $t3, $t3, 128	#Gambiarra
		jal limpa_tela
		jal desenha
		jal jogar
		j jogo
	
	limpa_tela:
		li $t9, 0 
		
		limpa_tela2:
			la $s5, 4($t3)
			la $s6, 8($t3)
			la $s7, 12($t3)
			
			lw $s0, ($t3)
			sw $s0, ($t1)	#pinta a tela com as cores guardadas no vetor
			addi $t1, $t1, 4	#tela
			
			lw $s0, ($s5)
			sw $s0, ($t1)	#pinta a tela com as cores guardadas no vetor
			addi $t1, $t1, 4	#tela
			
			lw $s0, ($s6)
			sw $s0, ($t1)	#pinta a tela com as cores guardadas no vetor
			addi $t1, $t1, 4	#tela
			
			lw $s0, ($s7)
			sw $s0, ($t1)	#pinta a tela com as cores guardadas no vetor
			addi $t1, $t1, 4	#tela
			
			addi $t3, $t3, 16	#vetor
			addi $t9, $t9, 1
		blt $t9, 40, limpa_tela2
		
		addi $t1, $t1, 	384	
		addi $t6, $t6, 1
		blt $t6, 256, limpa_tela #loop
		
		jr $ra
		
	desenha:
		lw $t0, pos	#Recebe a posição atual e pinta o cursor		
		lw $s0, dimgray
		li $t6, 0
		
		loopCursor:
		sw $s0, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		blt $t6, 16, loopCursor #loop
		
		addi $t0, $t0, 960
		li $t6, 0
		loopCursor1:
		sw $s0, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		blt $t6, 16, loopCursor1 #loop
		
		addi $t0, $t0, 960
		li $t6, 0
		loopCursor2:
		sw $s0, ($t0)
		addi $t0, $t0, 60
		sw $s0, ($t0)
		addi $t6, $t6, 1
		addi $t0, $t0, 964
		blt $t6, 12, loopCursor2 #loop

		li $t6, 0
		loopCursor3:
		sw $s0, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		blt $t6, 16, loopCursor3 #loop
		
		addi $t0, $t0, 960
		li $t6, 0
		loopCursor4:
		sw $s0, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1
		blt $t6, 16, loopCursor4 #loop
		
		jr $ra
	
	jogar:		
		li $t3, 0xffff0000	#Lê a tecla
		lw $t5, ($t3)
		andi $t4, $t5, 0x0001	#Verifica se teve novo input
		beqz $t4, jogar
		
		
		lw $t5, 4($t3)	#Pega o input
		
		move_left:			#Verificação de direções
			bne $t5, 97, move_down	#botão a
			lw $t0, pos
			addi $t0, $t0, -64
			addi contPos, contPos, -16
			sw $t0, pos
			jr $ra
			
		move_down:
			bne $t5, 115, move_up #botão s
			lw $t0, pos
			addi $t0, $t0, 16384
			addi contPos, contPos, 2560
			sw $t0, pos
			jr $ra
			
		move_up:
			bne $t5, 119, move_right #botão w
			lw $t0, pos
			addi $t0, $t0, -16384
			addi contPos, contPos, -2560
			sw $t0, pos
			jr $ra
			
		move_right:
			bne $t5, 100, botK #botão d
			lw $t0, pos
			addi $t0, $t0, 64
			addi contPos, contPos, 16
			sw $t0, pos
			jr $ra
			
		botK:
			bne $t5, 107, bot0				
			j salvar
			
		bot0:
			bne $t5, 48, bot1	
			la $t8, end2
			li $s7, 48
			sb $s7, 34($t8)
			
			j abrir256
			
		bot1:
			bne $t5, 49, bot2
			la $t8, end2
			li $s7, 49
			sb $s7, 34($t8)
	
			j abrir256
			
			
		bot2:
			bne $t5, 50, bot3
			la $t9, end2
			li $s7, 50
			sb $s7, 34($t9)
			
			j abrir256
			
		bot3:
			bne $t5, 51, bot4
			la $t9, end2
			li $s7, 51
			sb $s7, 34($t9)

			j abrir256
			
		bot4:
			bne $t5, 52, bot5
			la $t9, end2
			li $s7, 52
			sb $s7, 34($t9)
			j abrir256
			
		bot5:
			bne $t5, 53, bot6
			la $t9, end2
			li $s7, 53
			sb $s7, 34($t9)
			j abrir256
			
		bot6:
			bne $t5, 54, bot7
			la $t9, end2
			li $s7, 54
			sb $s7, 34($t9)
			j abrir256
			
		bot7:
			bne $t5, 55, bot8
			la $t9, end2
			li $s7, 55
			sb $s7, 34($t9)
			j abrir256
			
		bot8:
			bne $t5, 56, bot9
			la $t9, end2
			li $s7, 56
			sb $s7, 34($t9)
			j abrir256
			
		bot9:
			bne $t5, 57, apagar
			la $t9, end2
			li $s7, 57
			sb $s7, 34($t9)
			j abrir256
		
		apagar:
			bne $t5, 113, jogar
			
			lw $t4, white
			
			li $s7, 1
			la $t3, vetor
			li $s6, 0
			
			white256:			
			beq contPos, $s7, apagar256
			addi $s7, $s7, 1
			addi $t3, $t3, 4
			j white256
			
			apagar256:			
			li $t6, 0
			
			white2256:	
			sw $t4, ($t3)
			addi $t3, $t3, 4
			addi $t6, $t6, 1
			
			blt $t6, 16, white2256 #loop
			
			addi $t3, $t3, 576
			addi $s6, $s6, 1
			blt $s6, 16, apagar256
			
			j jogo
		

	
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
				li $t8, 49	#1 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor2:
				lw $t8, blue
				bne $t8, $t4, cor3
				li $t8, 50	#2 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor3:
				lw $t8, yellow
				bne $t8, $t4, cor4
				li $t8, 51	#3 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor4:
				lw $t8, green
				bne $t8, $t4, cor5
				li $t8, 52	#4 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor5:
				lw $t8, orange
				bne $t8, $t4, cor6
				li $t8, 53	#5 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor6:
				lw $t8, red
				bne $t8, $t4, cor7
				li $t8, 54	#6 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor7:
				lw $t8, brown
				bne $t8, $t4, cor8
				li $t8, 55	#7 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor8:
				lw $t8, pink
				bne $t8, $t4, cor9
				li $t8, 56	#8 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			cor9:
				lw $t8, purple
				bne $t8, $t4, corQ
				li $t8, 57	#9 em ascii
				sb $t8, ($s2)
			
				j loopSalvar
				
			corQ:
				lw $t8, white
				bne $t8, $t4, corP
				li $t8, 113	#q em ascii
				sb $t8, ($s2)
			
				j loopSalvar
			
			corP:
				lw $t8, LimeGreen
				bne $t8, $t4, erro
				li $t8, 112	#p em ascii
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
			blt cont, 40976, loopCores #loop
	
			# Write to file just opened
 			li   $v0, 15       # system call for write to file
 			move $a0, $s3      # file descriptor 
 			la   $a1, aux   # address of buffer from which to write
 			li   $a2, 81952       # hardcoded buffer length
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
		li $a2, 81920
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
			blt $t6, 40960, loopInicial2 #loop
			
			#fechar arquivo
			move $a0, $s3
			li $v0, 16
			syscall
	
		j inicial
		
	abrir16:
		li $v0, 13
		la $a0, end3
		li $a1, 0	#Abre para leitura
		syscall
		move $s4, $v0
		
		li $v0, 14	#Faz a leitura
		move $a0, $s4
		la $a1, aux3
		li $a2, 128
		syscall
		
		
		
		la $t8, aux3
		
		li $s6, 0
		escreve:
		li $t6, 0
		inter:	
			lb $t9, ($t8)
			subi $t9, $t9, 48
			
			bne $t9, 0, a2brir1
			lw $t4, black
			j a2breCor
			
			a2brir1:
			bne $t9, 1, a2brir2
			lw $t4, gray
			j a2breCor
			
			a2brir2:
			bne $t9, 2, a2brir3
			lw $t4, blue
			j a2breCor
			
			a2brir3:
			bne $t9, 3, a2brir4
			lw $t4, yellow
			j a2breCor
			
			a2brir4:
			bne $t9, 4, a2brir5
			lw $t4, green
			j a2breCor
			
			a2brir5:
			bne $t9, 5, a2brir6
			lw $t4, orange
			j a2breCor
			
			a2brir6:
			bne $t9, 6, a2brir7
			lw $t4, red
			j a2breCor
			
			a2brir7:
			bne $t9, 7, a2brir8
			lw $t4, brown
			j a2breCor
			
			a2brir8:
			bne $t9, 8, a2brir9
			lw $t4, pink
			j a2breCor
			
			a2brir9:
			bne $t9, 9, a2brirP
			lw $t4, purple
			j a2breCor
			
			a2brirP:
			bne $t9, 64, a2brirQ
			lw $t4, LimeGreen
			j a2breCor
			
			a2brirQ:
			lw $t4, white
		
			a2breCor:
			sw $t4, ($t1)
			addi $t1, $t1, 4		
			addi $t8, $t8, 2
			addi $t6, $t6, 1
			blt $t6, 8, inter #loop
			
			addi $t1, $t1, 992
			addi $s6, $s6, 1
			blt $s6, 8, escreve
			
			#fechar arquivo
			move $a0, $s4
			li $v0, 16
			syscall
		
		
		jr $ra
		
		
		abrir256:	
		li $v0, 13
		la $a0, end2
		li $a1, 0	#Abre para leitura
		syscall
		move $s4, $v0
		
		li $v0, 14	#Faz a leitura
		move $a0, $s4
		la $a1, aux3
		li $a2, 512
		syscall
		
		
		
		la $t8, aux3
		
		li $s6, 0
		escreve256:
		li $t6, 0
		inter256:	
			lb $t9, ($t8)
			subi $t9, $t9, 48
			
			bne $t9, 0, a256brir1
			lw $t4, black
			j a256breCor
			
			a256brir1:
			bne $t9, 1, a256brir2
			lw $t4, gray
			j a256breCor
			
			a256brir2:
			bne $t9, 2, a256brir3
			lw $t4, blue
			j a256breCor
			
			a256brir3:
			bne $t9, 3, a256brir4
			lw $t4, yellow
			j a256breCor
			
			a256brir4:
			bne $t9, 4, a256brir5
			lw $t4, green
			j a256breCor
			
			a256brir5:
			bne $t9, 5, a256brir6
			lw $t4, orange
			j a256breCor
			
			a256brir6:
			bne $t9, 6, a256brir7
			lw $t4, red
			j a256breCor
			
			a256brir7:
			bne $t9, 7, a256brir8
			lw $t4, brown
			j a256breCor
			
			a256brir8:
			bne $t9, 8, a256brir9
			lw $t4, pink
			j a256breCor
			
			a256brir9:
			bne $t9, 9, a256brirP
			lw $t4, purple
			j a256breCor
			
			a256brirP:
			bne $t9, 64, a256brirQ
			lw $t4, LimeGreen
			j a256breCor
			
			a256brirQ:
			lw $t4, white
		
			a256breCor:
			#sw $t4, ($t1)
			#addi $t1, $t1, 4		
			addi $t8, $t8, 2
			addi $t6, $t6, 1
			
			bne $t6, 1, pinta2256
			bne $s6, 0, pinta2256
			li $s7, 1
			la $t3, vetor
			
			pinta256:			
			beq contPos, $s7, pinta2256
			addi $s7, $s7, 1
			addi $t3, $t3, 4
			j pinta256
			
			pinta2256:	

				
			sw $t4, ($t3)
			addi $t3, $t3, 4
			
			blt $t6, 16, inter256 #loop
			
			addi $t3, $t3, 576
			addi $s6, $s6, 1
			blt $s6, 16, escreve256
			
			#fechar arquivo
			move $a0, $s4
			li $v0, 16
			syscall
					
		
		j jogo
		
		interface1:		
	
			li $s6, 0		
			
			interfaceAzul:			
			li $t6, 0
			
			interfaceBlue:	

			sw $t4, ($t1)
			addi $t1, $t1, 4
			addi $t6, $t6, 1
			
			blt $t6, 96, interfaceBlue #loop
			
			addi $t1, $t1, 640
			addi $s6, $s6, 1
			blt $s6, 256, interfaceAzul	
	
		subi $t1, $t1, 262080
		
		#Primeira linha
		
		addi $t1, $t1, 2048
		
		la $t9, end3
		li $s7, 65		#A
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 80		#P
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 65		#A
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 71		#G
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 65		#A
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 50		#DOIS PONTOS
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8128
		la $t9, end3
		
		la $t9, end3
		li $s7, 81		#Q
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 224
		addi $t1, $t1, 2048
		
		
		la $t9, end3
		
		la $t9, end3
		li $s7, 83		#S
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 65		#A
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 76		#L
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 86		#V
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 65		#A
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 50		#DOIS PONTOS
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8128
		la $t9, end3
		
		la $t9, end3
		li $s7, 75		#K
		sb $s7, 34($t9)
		
		jal abrir16
		
		
		#Terceira linha
		subi $t1, $t1, 224
		addi $t1, $t1, 8192
		
		la $t9, end3
		li $s7, 84		#T
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 73		#I
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		li $s7, 76		#L
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 69		#E
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		li $s7, 83		#S
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 69		#E
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 84		#T
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 8160
		la $t9, end3
		
		la $t9, end3
		li $s7, 83		#S
		sb $s7, 34($t9)
		
		jal abrir16
		
		subi $t1, $t1, 224
		addi $t1, $t1, 2048
		
		la $t9, end2
		li $s7, 48		#tile 0
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 16192
		
		la $t9, end2
		li $s7, 49		#tile 1
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 192
		addi $t1, $t1, 16384
		
		la $t9, end2
		li $s7, 50		#tile 2
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 16192
		
		la $t9, end2
		li $s7, 51		#tile 3
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 192
		addi $t1, $t1, 16384
		
		la $t9, end2
		li $s7, 52		#tile 4
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 16192
		
		la $t9, end2
		li $s7, 53		#tile 5
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 192
		addi $t1, $t1, 16384
		
		la $t9, end2
		li $s7, 54		#tile 6
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 16192
		
		la $t9, end2
		li $s7, 55		#tile 7
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 192
		addi $t1, $t1, 16384
		
		la $t9, end2
		li $s7, 56		#tile 8
		sb $s7, 34($t9)
		
		jal abrirImg
		
		subi $t1, $t1, 16192
		
		la $t9, end2
		li $s7, 57		#tile 9
		sb $s7, 34($t9)
		
		jal abrirImg	
				
		
		j jogo
		
		

		abrirImg:	
		li $v0, 13
		la $a0, end2
		li $a1, 0	#Abre para leitura
		syscall
		move $s4, $v0
		
		li $v0, 14	#Faz a leitura
		move $a0, $s4
		la $a1, aux3
		li $a2, 512
		syscall
		
		
		la $t8, aux3
		
		li $s6, 0
		ImgInicio:
		li $t6, 0
		PegaCores:	
			lb $t9, ($t8)
			subi $t9, $t9, 48
			
			bne $t9, 0, pega1
			lw $t4, black
			j pegaCor
			
			pega1:
			bne $t9, 1, pega2
			lw $t4, gray
			j pegaCor
			
			pega2:
			bne $t9, 2, pega3
			lw $t4, blue
			j pegaCor
			
			pega3:
			bne $t9, 3, pega4
			lw $t4, yellow
			j pegaCor
			
			pega4:
			bne $t9, 4, pega5
			lw $t4, green
			j pegaCor
			
			pega5:
			bne $t9, 5, pega6
			lw $t4, orange
			j pegaCor
			
			pega6:
			bne $t9, 6, pega7
			lw $t4, red
			j pegaCor
			
			pega7:
			bne $t9, 7, pega8
			lw $t4, brown
			j pegaCor
			
			pega8:
			bne $t9, 8, pega9
			lw $t4, pink
			j pegaCor
			
			pega9:
			bne $t9, 9, pegaP
			lw $t4, purple
			j pegaCor
			
			pegaP:
			bne $t9, 64, pegaQ
			lw $t4, LimeGreen
			j pegaCor
			
			pegaQ:
			lw $t4, white
		
			pegaCor:
			addi $t8, $t8, 2
			addi $t6, $t6, 1
				
			sw $t4, ($t1)
			addi $t1, $t1, 4
			
			blt $t6, 16, PegaCores #loop
			
			addi $t1, $t1, 960
			addi $s6, $s6, 1
			blt $s6, 16, ImgInicio
			
			#fechar arquivo
			move $a0, $s4
			li $v0, 16
			syscall
					
		
		jr $ra

