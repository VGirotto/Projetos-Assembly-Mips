######################################################################################################################################
######							Feito por Vinícius Girotto						######
######################################################################################################################################

#Abra o Bitmap Display do Mars para a visualização do jogo
#Configure da seguinte forma:
#	Unit Width/Height in pixels = 32
#	Display Width/Height in Pixels = 256
#	Base address = 0x10000000 (global data)

.data	
	jogar: .asciiz "Em qual dessas posições você quer jogar? Digite apenas o número\n"
	invalida: .asciiz "Você não pode jogar nessa posição\n"
	posicao: .asciiz "Posição "
	pula_linha: .asciiz "\n"
	msg_velha: .asciiz "Deu velha! Ninguém ganhou."
	vencedor: .asciiz "O vencedor é o player "
	.align 3
	livre: .word
	

.text
	main:
	
		jal cores		#jal chama as funções tendo um link pra retorno
		jal define_fundo
		jal desenha_tabuleiro
		jal armazena_pos
		
		jogo:			#Loop de jogadas e verificação de vitória
		jal verifica_vitoria
		j jogada_player1
		jogo2:
		jal verifica_vitoria
		j jogada_player2
	
	
	cores:
	addi $s0, $zero, 0x696969 #Cinza
	addi $s1, $zero, 0xFF0000 #Vermelho
	addi $s2, $zero, 0x6495ED #Azul
	addi $s3, $zero, 0x000000 #Preto
	jr $ra
	
	define_fundo:
	addi $t1, $zero, 64	#mapa possui 64 quadrados
	add $t2, $zero, $t1
	lui $t2, 0x1000		#posição inicial dos dados para serem pintados
	jr $ra
	
	desenha_tabuleiro:
	sw $s0, 8($t2)	#Primeiras duas linhas
	sw $s0, 20($t2)	
	sw $s0, 40($t2)	
	sw $s0, 52($t2)	
	sw $s0, 64($t2) #Terceira linha
	sw $s0, 68($t2)
	sw $s0, 72($t2)
	sw $s0, 76($t2)
	sw $s0, 80($t2)
	sw $s0, 84($t2)
	sw $s0, 88($t2)
	sw $s0, 92($t2)
	sw $s0, 104($t2) #Quarta e quinta linhas
	sw $s0, 116($t2)
	sw $s0, 136($t2)
	sw $s0, 148($t2)
	sw $s0, 160($t2) #Sexta linha
	sw $s0, 164($t2)
	sw $s0, 168($t2)
	sw $s0, 172($t2)
	sw $s0, 176($t2)
	sw $s0, 180($t2)
	sw $s0, 184($t2)
	sw $s0, 188($t2)
	sw $s0, 200($t2) #Sétima e oitava linhas
	sw $s0, 212($t2)
	sw $s0, 232($t2)
	sw $s0, 244($t2)
	jr $ra
	
	armazena_pos:
		la $t0, livre	#Define todas as cores iniciais do vetor para preto
		sw $s3, 0($t0)
		sw $s3, 4($t0)
		sw $s3, 8($t0)
		sw $s3, 12($t0)
		sw $s3, 16($t0)
		sw $s3, 20($t0)
		sw $s3, 24($t0)
		sw $s3, 28($t0)
		sw $s3, 32($t0)
	
	jogada_player1:
		la $a0, pula_linha	#Mensagem para escolher jogada	
		li $v0, 4
		syscall	
		la $a0, jogar
		li $v0, 4
		syscall
		
		escolher_jogada1:
		jal printa_posicoes
		
		li $v0, 5	#Lê a posição escolhida
		syscall
		move $t6, $v0
		
		addi $t7, $zero, 1	#Marca qual jogador é(1)
		
		bgt $t6, 9, jogada_invalida	#Verifica se o número digitado é válido
		blt $t6, 1, jogada_invalida
		
		#Verifica se pode jogar na posição escolhida
		move $t9, $t6
		subi $t9, $t9, 1
		mul $t9, $t9, 4
		la $t8, 0($t0)		#Pega o endereço de t0
		add $t8, $t8, $t9	#Desloca pelos endereços de t0
		lw $s7, 0($t8)		#Pega o conteúdo no endereço desejado
		
		bne $s7, $s3, jogada_invalida	#Verifica se a posição escolhida está livre
		
		jal pinta_cor
		
		j jogo2
			
		
	jogada_player2:
		la $a0, pula_linha	#Mensagem para escolher jogada		
		li $v0, 4
		syscall	
		la $a0, jogar
		li $v0, 4
		syscall
		
		escolher_jogada2:
		jal printa_posicoes
		
		li $v0, 5	#Lê a posição escolhida
		syscall
		move $t6, $v0
		
		addi $t7, $zero, 2	#Marca qual jogador é(2)
		
		bgt $t6, 9, jogada_invalida	#Verifica se o número digitado é válido
		blt $t6, 1, jogada_invalida
		
		#verificar se pode jogar na posição escolhida
		move $t9, $t6
		subi $t9, $t9, 1
		mul $t9, $t9, 4
		la $t8, 0($t0)		#Pega o endereço de t0
		add $t8, $t8, $t9	#Desloca pelos endereços de t0
		lw $s7, 0($t8)		#Pega o conteúdo no endereço desejado	
		
		bne $s7, $s3, jogada_invalida	#Verifica se a posição escolhida está livre
		
		jal pinta_cor
		
		j jogo
	
	printa_posicoes:
		pos1:
			lw $t5, 0($t0)	
			bne $s3, $t5, pos2	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 1
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall		
		
		pos2:
			lw $t5, 4($t0)	
			bne $s3, $t5, pos3	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 2
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos3:
			lw $t5, 8($t0)	
			bne $s3, $t5, pos4	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 3
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos4:
			lw $t5, 12($t0)	
			bne $s3, $t5, pos5	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 4
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos5:
			lw $t5, 16($t0)	
			bne $s3, $t5, pos6	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 5
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos6:
			lw $t5, 20($t0)	
			bne $s3, $t5, pos7	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 6
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos7:
			lw $t5, 24($t0)	
			bne $s3, $t5, pos8	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 7
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos8:
			lw $t5, 28($t0)	
			bne $s3, $t5, pos9	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 8
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
		
		pos9:
			lw $t5, 32($t0)	
			bne $s3, $t5, nao9	#Verifica se é diferente de preto
			
			la $a0, posicao		#Printa a posição
			li $v0, 4
			syscall
			addi $a0, $zero, 9
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
			
		nao9:	
		jr $ra
		
		pinta_cor:
		pos_1:
			bne $t6, 1, pos_2	#Verifica se é essa posição
			
			bne $t7, 1, jog1_2
			
			sw $s1, 0($t2)	#Pinta de vermelho
			sw $s1, 4($t2)
			sw $s1, 32($t2)
			sw $s1, 36($t2)
			sw $s1, 0($t0)
			jr $ra
			
			jog1_2:
			sw $s2, 0($t2)	#Pinta de azul
			sw $s2, 4($t2)
			sw $s2, 32($t2)
			sw $s2, 36($t2)
			sw $s2, 0($t0)
			jr $ra
		
		pos_2:
			bne $t6, 2, pos_3	#Verifica se é essa posição
			
			bne $t7, 1, jog2_2
			
			sw $s1, 12($t2)	#Pinta de vermelho
			sw $s1, 16($t2)
			sw $s1, 44($t2)
			sw $s1, 48($t2)
			sw $s1, 4($t0)
			jr $ra
			
			jog2_2:
			sw $s2, 12($t2)	#Pinta de azul
			sw $s2, 16($t2)
			sw $s2, 44($t2)
			sw $s2, 48($t2)
			sw $s2, 4($t0)
			jr $ra
			
		pos_3:
			bne $t6, 3, pos_4	#Verifica se é essa posição
			
			bne $t7, 1, jog3_2
			
			sw $s1, 24($t2)	#Pinta de vermelho
			sw $s1, 28($t2)
			sw $s1, 56($t2)
			sw $s1, 60($t2)
			sw $s1, 8($t0)
			jr $ra
			
			jog3_2:
			sw $s2, 24($t2)	#Pinta de azul
			sw $s2, 28($t2)
			sw $s2, 56($t2)
			sw $s2, 60($t2)
			sw $s2, 8($t0)
			jr $ra
		
		
		pos_4:
			bne $t6, 4, pos_5	#Verifica se é essa posição
			
			bne $t7, 1, jog4_2
			
			sw $s1, 96($t2)	#Pinta de vermelho
			sw $s1, 100($t2)
			sw $s1, 128($t2)
			sw $s1, 132($t2)
			sw $s1, 12($t0)
			jr $ra
			
			jog4_2:
			sw $s2, 96($t2)	#Pinta de azul
			sw $s2, 100($t2)
			sw $s2, 128($t2)
			sw $s2, 132($t2)
			sw $s2, 12($t0)
			jr $ra
		
		
		pos_5:
			bne $t6, 5, pos_6	#Verifica se é essa posição
			
			bne $t7, 1, jog5_2
			
			sw $s1, 108($t2)	#Pinta de vermelho
			sw $s1, 112($t2)
			sw $s1, 140($t2)
			sw $s1, 144($t2)
			sw $s1, 16($t0)
			jr $ra
			
			jog5_2:
			sw $s2, 108($t2)	#Pinta de azul
			sw $s2, 112($t2)
			sw $s2, 140($t2)
			sw $s2, 144($t2)
			sw $s2, 16($t0)
			jr $ra
		
		
		pos_6:
			bne $t6, 6, pos_7	#Verifica se é essa posição
			
			bne $t7, 1, jog6_2
			
			sw $s1, 120($t2)	#Pinta de vermelho
			sw $s1, 124($t2)
			sw $s1, 152($t2)
			sw $s1, 156($t2)
			sw $s1, 20($t0)
			jr $ra
			
			jog6_2:
			sw $s2, 120($t2)	#Pinta de azul
			sw $s2, 124($t2)
			sw $s2, 152($t2)
			sw $s2, 156($t2)
			sw $s2, 20($t0)
			jr $ra
		
		
		pos_7:
			bne $t6, 7, pos_8	#Verifica se é essa posição
			
			bne $t7, 1, jog7_2
			
			sw $s1, 192($t2)	#Pinta de vermelho
			sw $s1, 196($t2)
			sw $s1, 224($t2)
			sw $s1, 228($t2)
			sw $s1, 24($t0)
			jr $ra
			
			jog7_2:
			sw $s2, 192($t2)	#Pinta de azul
			sw $s2, 196($t2)
			sw $s2, 224($t2)
			sw $s2, 228($t2)
			sw $s2, 24($t0)
			jr $ra
		
		
		pos_8:
			bne $t6, 8, pos_9	#Verifica se é essa posição
			
			bne $t7, 1, jog8_2
			
			sw $s1, 204($t2)	#Pinta de vermelho
			sw $s1, 208($t2)
			sw $s1, 236($t2)
			sw $s1, 240($t2)
			sw $s1, 28($t0)
			jr $ra
			
			jog8_2:
			sw $s2, 204($t2)	#Pinta de azul
			sw $s2, 208($t2)
			sw $s2, 236($t2)
			sw $s2, 240($t2)
			sw $s2, 28($t0)
			jr $ra
		
		
		pos_9:		
			bne $t7, 1, jog9_2
			
			sw $s1, 216($t2)	#Pinta de vermelho
			sw $s1, 220($t2)
			sw $s1, 248($t2)
			sw $s1, 252($t2)
			sw $s1, 32($t0)
			jr $ra
			
			jog9_2:
			sw $s2, 216($t2)	#Pinta de azul
			sw $s2, 220($t2)
			sw $s2, 248($t2)
			sw $s2, 252($t2)
			sw $s2, 32($t0)
			jr $ra
			
		verifica_vitoria:
			addi $s6, $s6, 1	#Contador
		
			#Diagonais
			lw $t4, 0($t0)
			lw $t8, 16($t0)
			lw $t9, 32($t0)
			beq $s3, $t4, d2	#Verifica se é diferente de preto
			bne $t4, $t8, d2	# 1 == 5
			beq $t4, $t9, fim	# 1 == 9
			
			d2:
			lw $t4, 8($t0)
			lw $t8, 16($t0)
			lw $t9, 24($t0)
			beq $s3, $t4, h1	#Verifica se é diferente de preto
			bne $t4, $t8, h1	# 3 == 5
			beq $t4, $t9, fim	# 3 == 7
			
			h1:
			lw $t4, 0($t0)
			lw $t8, 4($t0)
			lw $t9, 8($t0)
			beq $s3, $t4, h2	#Verifica se é diferente de preto
			bne $t4, $t8, h2	# 1 == 2
			beq $t4, $t9, fim	# 1 == 3
			
			h2:
			lw $t4, 12($t0)
			lw $t8, 16($t0)
			lw $t9, 20($t0)
			beq $s3, $t4, h3	#Verifica se é diferente de preto
			bne $t4, $t8, h3	# 4 == 5
			beq $t4, $t9, fim	# 4 == 6
			
			h3:
			lw $t4, 24($t0)
			lw $t8, 28($t0)
			lw $t9, 32($t0)
			beq $s3, $t4, v1	#Verifica se é diferente de preto
			bne $t4, $t8, v1	# 7 == 8
			beq $t4, $t9, fim	# 7 == 9
			
			v1:
			lw $t4, 0($t0)
			lw $t8, 12($t0)
			lw $t9, 24($t0)
			beq $s3, $t4, v2	#Verifica se é diferente de preto
			bne $t4, $t8, v2	# 1 == 4
			beq $t4, $t9, fim	# 1 == 7
			
			v2:
			lw $t4, 4($t0)
			lw $t8, 16($t0)
			lw $t9, 28($t0)
			beq $s3, $t4, v3	#Verifica se é diferente de preto
			bne $t4, $t8, v3	# 2 == 5
			beq $t4, $t9, fim	# 2 == 8
			
			v3:
			lw $t4, 8($t0)
			lw $t8, 20($t0)
			lw $t9, 32($t0)
			beq $s3, $t4, velha	#Verifica se é diferente de preto
			bne $t4, $t8, velha	# 3 == 6
			beq $t4, $t9, fim	# 3 == 9
			
			velha:
			beq $s6, 9, fim_velha
			
			jr $ra
			
		jogada_invalida:
			la $a0, pula_linha		
			li $v0, 4
			syscall	
			la $a0, invalida	#Printa mensagem de jogada inválida
			li $v0, 4
			syscall
			la $a0, jogar
			li $v0, 4
			syscall
			
			beq $t7, 1, escolher_jogada1
			j escolher_jogada2
			
		fim_velha:
			la $a0, msg_velha		#Printa que deu velha
			li $v0, 4
			syscall
			li $v0, 10		#Encerra o jogo
			syscall		
			
		fim:

			la $a0, vencedor		#Printa o vencedor
			li $v0, 4
			syscall
			add $a0, $zero, $t7
			li $v0, 1
			syscall
			la $a0, pula_linha		
			li $v0, 4
			syscall	
