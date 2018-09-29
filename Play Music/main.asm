.include "musica.asm"

.text 
	la $t0, musica	#Carrega o vetor de bytes que está no arquivo importado
	lb $t1, ($t0)
	
	add $t2, $zero, 50	#Número do primeiro instrumento a tocar
	
	loop:
		li $v0, 31
		
		add $a0, $zero, $t1	#Define os parâmetros do som e toca
		addi $a1, $zero, 700
		add $a2, $zero, $t2
		addi $a3, $zero, 70
		syscall
		
		li $v0, 32		#Sleep
		addi $a0, $zero, 200
		syscall
		
		li $v0, 42		#O instrumento é escolhido aleatoriamente
		li $a1, 115
		syscall
		move $t2, $a0
		
		add $t0, $t0, 1	#Percorrer o arquivo
		lb $t1, ($t0)
		bne $t1, -1, loop	#Toca enquanto não encontrar o -1 
