######################################################################################################################################
######							Feito por Vinícius Girotto						######
######################################################################################################################################

#Abra o Bitmap Display para a visualização do jogo
#Abra Keyboard Simulator para movimento o personagem
#Configure da seguinte forma:
#	Unit Width/Height in pixels = 4
#	Display Width/Height in Pixels = 512
#	Base address = 0x10040000 (heap)

.data
	#Alguns exemplos de cores
	yellow:   .word 0xF5F62E
	white:	  .word 0xFFFFFF
	blue: 	  .word 0x2E8CF6
	orange:   .word 0xF67F2E
	black:	  .word 0x00000
	gray:	  .word 0xC0C0C0
	red: 	  .word 0xFF0000
	dimgray:  .word 0x696969
	pos: .word 	#Para guardar a posição do personagem
	
.text
	j main
	
	set_tela: #Inicia todos os valores para a tela
		addi $t0, $zero, 65536 #65536 = (512*512)/4 pixels
		add $t1, $t0, $zero #Adicionar a distribuição de pixels ao endereco
		lui $t1, 0x1004 #Endereco base da tela no heap
		addi $t5, $zero, 64 #Posição inicial
		add $t0, $t1, $zero
		sw $t0, pos	
		
		jr $ra

	set_cores: #Salvar as cores em registradores
		lw $s0, black
		lw $s1, yellow
		lw $s2, orange
		lw $s3, red
		lw $s4, dimgray
		lw $s5, gray
		lw $s6, white
		jr $ra
		
	limpa_tela:	#Pintar de preto a tela e escrever P-Parar
		addi $t6, $zero, 0
		
		lw $t0, pos
		add $t0, $t0, -1540
		
		
		loop_tela:
			sw $s0, ($t0)
			add $t0, $t0, 4
			add $t6, $t6, 1
			blt $t6, 2300, loop_tela
			
			
		#Escreve P - PARAR
		add $t0, $t1, 61440
		
		#Primeira linha
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s4, 32($t0)
		sw $s4, 36($t0)
		sw $s4, 40($t0)
		sw $s4, 56($t0)
		sw $s4, 60($t0)
		sw $s4, 72($t0)
		sw $s4, 76($t0)
		sw $s4, 80($t0)
		sw $s4, 96($t0)
		sw $s4, 100($t0)
		sw $s4, 112($t0)
		sw $s4, 116($t0)
		sw $s4, 120($t0)
		#Segunda linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s4, 12($t0)
		sw $s4, 32($t0)
		sw $s4, 44($t0)
		sw $s4, 52($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 84($t0)
		sw $s4, 92($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 124($t0)
		#Terceira linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s4, 12($t0)
		sw $s4, 32($t0)
		sw $s4, 44($t0)
		sw $s4, 52($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 84($t0)
		sw $s4, 92($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 124($t0)
		#Quarta linha
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s4, 20($t0)
		sw $s4, 24($t0)
		sw $s4, 32($t0)
		sw $s4, 36($t0)
		sw $s4, 40($t0)
		sw $s4, 52($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 76($t0)
		sw $s4, 80($t0)
		sw $s4, 92($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 116($t0)
		sw $s4, 120($t0)
		#Quinta linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s4, 32($t0)
		sw $s4, 52($t0)
		sw $s4, 56($t0)
		sw $s4, 60($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 76($t0)
		sw $s4, 92($t0)
		sw $s4, 96($t0)
		sw $s4, 100($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 116($t0)
		#Sexta linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s4, 32($t0)
		sw $s4, 52($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 80($t0)
		sw $s4, 92($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 120($t0)
		#Setima linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s4, 32($t0)
		sw $s4, 52($t0)
		sw $s4, 64($t0)
		sw $s4, 72($t0)
		sw $s4, 84($t0)
		sw $s4, 92($t0)
		sw $s4, 104($t0)
		sw $s4, 112($t0)
		sw $s4, 124($t0)
		
		
		
		jr $ra
		


	desenha:	#Desenha o personagem
	
		lw $t0, pos	#Recebe a nova posição
			
		#Primeira linha
		add $t0, $t0, 24
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s4, 12($t0)
		sw $s4, 16($t0)
		sw $s4, 20($t0)
		#Segunda linha
		add $t0, $t0, 504
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s1, 16($t0)
		sw $s4, 20($t0)
		sw $s6, 24($t0)
		sw $s6, 28($t0)
		sw $s4, 32($t0)
		#Terceira linha
		add $t0, $t0, 508
		sw $s4, ($t0)
		sw $s1, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s1, 16($t0)
		sw $s4, 20($t0)
		sw $s6, 24($t0)
		sw $s6, 28($t0)
		sw $s6, 32($t0)
		sw $s6, 36($t0)
		sw $s4, 40($t0)
		#Quarta linha
		add $t0, $t0, 504
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s4, 12($t0)
		sw $s1, 16($t0)
		sw $s1, 20($t0)
		sw $s1, 24($t0)
		sw $s4, 28($t0)
		sw $s5, 32($t0)
		sw $s6, 36($t0)
		sw $s6, 40($t0)
		sw $s4, 44($t0)
		sw $s6, 48($t0)
		sw $s4, 52($t0)
		#Quinta linha
		add $t0, $t0, 508
		sw $s4, ($t0)
		sw $s1, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s1, 16($t0)
		sw $s4, 20($t0)
		sw $s1, 24($t0)
		sw $s1, 28($t0)
		sw $s4, 32($t0)
		sw $s5, 36($t0)
		sw $s6, 40($t0)
		sw $s6, 44($t0)
		sw $s4, 48($t0)
		sw $s6, 52($t0)	
		sw $s4, 56($t0)	
		#Sexta linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s1, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s1, 16($t0)
		sw $s1, 20($t0)
		sw $s4, 24($t0)
		sw $s1, 28($t0)
		sw $s1, 32($t0)
		sw $s4, 36($t0)
		sw $s5, 40($t0)
		sw $s6, 44($t0)
		sw $s6, 48($t0)
		sw $s6, 52($t0)	
		sw $s4, 56($t0)	
		#Setima linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s1, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s1, 16($t0)
		sw $s1, 20($t0)
		sw $s4, 24($t0)
		sw $s1, 28($t0)
		sw $s1, 32($t0)
		sw $s1, 36($t0)
		sw $s4, 40($t0)
		sw $s4, 44($t0)
		sw $s4, 48($t0)
		sw $s4, 52($t0)	
		sw $s4, 56($t0)	
		sw $s4, 60($t0)	
		#Oitava linha
		add $t0, $t0, 516
		sw $s4, ($t0)
		sw $s1, 4($t0)
		sw $s1, 8($t0)
		sw $s1, 12($t0)
		sw $s4, 16($t0)
		sw $s1, 20($t0)
		sw $s1, 24($t0)
		sw $s1, 28($t0)
		sw $s4, 32($t0)
		sw $s3, 36($t0)
		sw $s3, 40($t0)
		sw $s3, 44($t0)
		sw $s3, 48($t0)
		sw $s3, 52($t0)	
		sw $s3, 56($t0)	
		sw $s4, 60($t0)
		#Nona linha
		add $t0, $t0, 516
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s2, 12($t0)
		sw $s2, 16($t0)
		sw $s2, 20($t0)
		sw $s4, 24($t0)
		sw $s3, 28($t0)
		sw $s4, 32($t0)
		sw $s4, 36($t0)
		sw $s4, 40($t0)
		sw $s4, 44($t0)
		sw $s4, 48($t0)
		sw $s4, 52($t0)	
		#Decima linha
		add $t0, $t0, 512
		sw $s4, ($t0)
		sw $s2, 4($t0)
		sw $s2, 8($t0)
		sw $s2, 12($t0)
		sw $s2, 16($t0)
		sw $s2, 20($t0)
		sw $s2, 24($t0)
		sw $s4, 28($t0)
		sw $s3, 32($t0)
		sw $s3, 36($t0)
		sw $s3, 40($t0)
		sw $s3, 44($t0)
		sw $s3, 48($t0)
		sw $s4, 52($t0)	
		#Decima Primeira linha
		add $t0, $t0, 516
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s2, 8($t0)
		sw $s2, 12($t0)
		sw $s2, 16($t0)
		sw $s2, 20($t0)
		sw $s2, 24($t0)
		sw $s4, 28($t0)
		sw $s4, 32($t0)
		sw $s4, 36($t0)
		sw $s4, 40($t0)
		sw $s4, 44($t0)
		#Decima Segunda linha
		add $t0, $t0, 520
		sw $s4, ($t0)
		sw $s4, 4($t0)
		sw $s4, 8($t0)
		sw $s4, 12($t0)
		sw $s4, 16($t0)
		
		jr $ra		#Retorna pra função do jogo
				
		
	jogar:
		li $v0, 32		#Pequeno delay
		add $a0, $zero, 70
		syscall
		
		li $t2, 0xffff0000	#Lê a tecla
		lw $a1, ($t2)
		andi $t9, $a1, 0x0001	#Verifica se teve novo input
		beqz $t9, jogar
		
		lw $a1, 4($t2)	#Pega o input
		
		beq $a1, 112, fim	#Verifica se teclou pra parar o jogo
		
		move_left:			#Verificação de direções
			bne $a1, 97, move_down	#botão a
			lw $t0, pos
			add $t0, $t0, -12
			sw $t0, pos
			jr $ra
			
		move_down:
			bne $a1, 115, move_up #botão w
			lw $t0, pos
			add $t0, $t0, 1536
			sw $t0, pos
			jr $ra
			
		move_up:
			bne $a1, 119, move_right #botão d
			lw $t0, pos
			add $t0, $t0, -1536
			sw $t0, pos
			jr $ra
			
		move_right:
			bne $a1, 100, jogar #botão s
			lw $t0, pos
			add $t0, $t0, 12
			sw $t0, pos
			jr $ra	
			

	jogo:	#Onde ocorrem todos os processos do jogo
		jal limpa_tela
		jal desenha
		jal jogar
		j jogo

	main: #Seta valores iniciais e chama o jogo
		jal set_tela
		jal set_cores
		jal jogo
		
		fim:
