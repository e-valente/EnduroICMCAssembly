;Jogo Enduro
;Emanuel Valente - emanuelvalente@gmail.com
;Código atualizado em https://github.com/lbull/EnduroICMCAssembly



; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho						0100 0000
; 1280 roxo							0101 0000
; 1537 teal							0110 0000
; 1793 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2561 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3839 branco						1111 0000



jmp main

logojogo : string "ICMC ENDURO"	; Poe "\0" automaticamente no final da string
str_score : string "Score: "	; Poe "\0" automaticamente no final da string
str_lives: string "Lives:  "
str_car: string  "{ { {"
str_youlose: string "Voce perdeu!"
str_youwin: string "Voce ganhou!"
str_game_or_exit: string "Tecle (j) para jogar ou (s) para sair!"
str_clearscreen : string " "
myword: var #41
str_out: var #41




; ------ Programa Principal -----------

main:
	call LimpaTela
	;primeiro os caracteres
	;estáticos
	loadn r1, #logojogo
	loadn r0, #66
	loadn r2, #512  ;verde
	call ImprimeString    ;imprime logo do jogo
	loadn r2, #0
	loadn r1, #0
	loadn r1, #str_lives
	loadn r0, #266
	call ImprimeString    ;imprime lives
	loadn r1, #str_car   ;carros da vida (lives)
	loadn r0, #273
	loadn r2, #2304      ;vermelho
	call ImprimeString    ;imprime vidas
	loadn r2, #0
	loadn r1, #str_score
	loadn r0, #346
	call ImprimeString    ;imprime score (string)
	;tela inicial
	;call LimpaTela
	loadn r0, #1177  ;poiscao antiga do carro
	loadn r1, #1177  ;posicao nova do carro
	call DesenhaCarro
	
	;desenha carros aleatorios
	;na pista (fix it!)
	;desenha carro principal
	loadn r4, #'{'
	loadn r5, #512 ;verde
	add r4, r4, r5 ;carro verde
	loadn r1, #175 ;faixa da esquerda
        outchar r4, r1 ;imprime carro
	
	loadn r4, #'{'
	loadn r5, #1280 ;roxo
	add r4, r4, r5 ;carro roxo
	loadn r1, #773 ;faixa da esquerda
        outchar r4, r1	;imprime carro
        
        loadn r4, #'{'
        loadn r5, #2816 ;amarelo
	add r4, r4, r5 ;carro amarelo
	loadn r1, #580 ;faixa da direita
        outchar r4, r1	;imprime carro
        
        loadn r4, #'{'
        loadn r5, #256 ;marrom
	add r4, r4, r5 ;carro marrom
	loadn r1, #60 ;faixa da direita
        outchar r4, r1	;imprime carro

	;*****LOOP PRINCIPAL DO JOGO
	;configura loop
	loadn r5, #0     ;de zero
	loadn r6, #1000   ;até n
	
	
	Main_Loop:


	call Delay
	call ControlaCarro
	call FaixasEstado0
	call FaixasEstado1
	call FaixasDoMeioEstado0
	call FaixasDoMeioEstado1
	call ControlaCarro
	
	call Delay
	call FaixasDoMeioEstado0
	call FaixasEstado0
	call ControlaCarro
	call FaixasEstado2
	call FaixasDoMeioEstado2
	call ControlaCarro
	
	call Delay
	call FaixasEstado0
	call FaixasDoMeioEstado0
	call FaixasEstado1
	call FaixasDoMeioEstado3
	call ControlaCarro
	
	
	call Delay
	call ControlaCarro
	call FaixasEstado0
	call FaixasEstado2
	call FaixasDoMeioEstado0
	call FaixasDoMeioEstado1
	call ControlaCarro
	
	
	call Delay
	call ControlaCarro
	call FaixasEstado0
	call FaixasEstado1
	call FaixasDoMeioEstado0
	call FaixasDoMeioEstado2
	call ControlaCarro
	
	call Delay
	call ControlaCarro
	call FaixasEstado0
	call FaixasEstado2
	call FaixasDoMeioEstado0
	call FaixasDoMeioEstado3
	call ControlaCarro
	
	;atualiza impressao do score
	push r0
	push r6
	mov r0, r5
	loadn r1, #353
	call PrintInteger
	pop r6
	pop r0
	
	
	inc r5
	cmp r5, r6
	jne Main_Loop
	
	;***** FIM DO LOOP PRINCIPAL DO JOGO

  halt
	
;Desenha carro estado 0
DesenhaCarro:  
;recebe em r0 a posicao antiga (será apagada)
;r1 a posicao atual 
;retorna em r7 a posicao atual

  
  push r2
  push r3
  push r4
  push r5
  push r6
 
 ;************* novo - teste fronteiras
 ;esquerda
 ;loadn r2, #49  ;***(colocar um vetor e comparar a posicao)
 ;dec r1
 
 loadn r6, #1
 ;call Compara_Posicoes_Esquerda
 ;cmp r6, r7
 ;cmp r1, r2
 ;inc r1
 ;apagamos a posicao antiga
 loadn r4, #' '
 outchar r4, r0
 
  
  ;desenha carro principal
  loadn r4, #'{'
  loadn r5, #2304 ;vermelho
  add r4, r4, r5 ;carro vermelho
  
  ;loadn r6, #1177  ;posicao inicial do carro
  outchar r4, r1
  mov r7, r6   ;retorna em r7 a posicao do carro
  
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2

  rts
  
;************* Controla carro
ControlaCarro:  ;recebe em r0 a posicao atual do carro

  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r1,#0
  loadn r2, #'a'  ; esquerda
  loadn r3, #'d' ;direita
  loadn r4, #'w' ;frente
  loadn r5, #'s' ;tras
  loadn r6, #40  ;usado pra incrementar/decrementar frente/tras
  
  inchar r1        ;caractere estara em r1
  
  ;compara direita
  cmp r1, r2   ;esquerda
  jeq ControlaCarro_Esquerda
  
  ;compara esquerda
  cmp r1, r3   ;direita
  jeq ControlaCarro_Direita
  
   ;compara com frente
  cmp r1, r4   ;frente
  jeq ControlaCarro_Frente
  
   ;compara com tras
  cmp r1, r5   ;tras
  jeq ControlaCarro_Tras
  
  
  ;se nao for esquerda é lixo
  ;nao desenhamos e montemos a posicao antiga
  ;r1 tem lixo
  ;logo
  ;posicao atual e antiga 
  ;é o mesmo valor em r0 e r1
  mov r1, r0
  call DesenhaCarro
  
  jmp ControlaCarro_FIM
  
  
  
  
;r0 posisao atual  
ControlaCarro_Esquerda:

  ;testa fronteira esquerda
  call TesteFronteiraPistaEsquerda ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida
  push r6
  loadn r6, #1
  cmp r7, r6
  pop r6
  jeq ControlaCarro_FIM
  ;fim do teste de fronteira esquerda
 
 mov r1, r0
 dec r1
 call DesenhaCarro  ;r0->pos antiga, r1 -> atual
 mov r0, r1         ;a posicao atual sera a antiga
 jmp ControlaCarro_FIM
 
 
 ControlaCarro_Direita:
 ;testa fronteira direita
  call TesteFronteiraPistaDireita;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida
  push r6
  loadn r6, #1
  cmp r7, r6
  pop r6
  jeq ControlaCarro_FIM
  ;fim do teste de fronteira direita
  
 mov r1, r0
 inc r1
 call DesenhaCarro  ;r0->pos antiga, r1 -> atual
 mov r0, r1         ;a posicao atual sera a antiga
 jmp ControlaCarro_FIM
 
 
 ControlaCarro_Frente:
  ;testa fronteira frente (cima)
  call TesteFronteiraPistaCima ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida
  push r6
  loadn r6, #1
  cmp r7, r6
  pop r6
  jeq ControlaCarro_FIM
  ;fim do teste de fronteira cima
  
 mov r1, r0
 sub r1, r1, r6      ;decrementa 40 posicoes (anda pra frente)
 call DesenhaCarro  ;r0->pos antiga, r1 -> atual
 mov r0, r1         ;a posicao atual sera a antiga
 jmp ControlaCarro_FIM
 
 
 ControlaCarro_Tras:
 
 ;testa fronteira baixo
  call TesteFronteiraPistaBaixo ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida
  push r6
  loadn r6, #1
  cmp r7, r6
  pop r6
  jeq ControlaCarro_FIM
  ;fim do teste de fronteira baixo
  
 mov r1, r0
 add r1, r1, r6      ;inccrementa 40 posicoes (anda pra tras)
 call DesenhaCarro  ;r0->pos antiga, r1 -> atual
 mov r0, r1         ;a posicao atual sera a antiga
 jmp ControlaCarro_FIM
 
 
ControlaCarro_FIM:
 
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
    
  rts

   

;*******************ROTINA DE DELAY	
Delay:
  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  
  loadn r0, #400
  loadn r1, #0
  
  Delay_Loop:
  inc r1
  cmp r1, r0
  jne Delay_Loop
  
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

rts
  
;*****************ESTADOS DA FAIXA
;*********ESTADO 0 zero (Apaga as faixas)************
FaixasEstado0:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

;*********Apaga faixas do canto esquerdo*******    
  loadn r0, #' '
  loadn r1, #10 ;posicao inicial
  loadn r2, #40 ;incremento
  loadn r3, #1210 ;limite
  
  

FaixasEstado0_Loop1:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado0_Loop1
  

;*********Apaga faixas do canto direito*******    
  loadn r1, #24 ;posicao inicial
  loadn r2, #40 ;incremento
  loadn r3, #1224 ;limite  
FaixasEstado0_Loop2:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado0_Loop2
  

  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
  	
;************ESTADO 1 - DESENHA faixas utilizando primeira linha	
FaixasEstado1:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

;*********DESENHA faixas do canto esquerdo*******    
  loadn r0, #'~'
  loadn r1, #10 ;posicao inicial
  loadn r2, #80 ;incremento
  loadn r3, #1210 ;limite
  loadn r4, #3072 ;azul
  add r0, r0, r4 ; beiradas da estrada sao azuis
  
  

FaixasEstado1_Loop1:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado1_Loop1
  

;*********DESENHA faixas do canto direito*******    
  loadn r1, #24 ;posicao inicial
  loadn r2, #80 ;incremento
  loadn r3, #1224 ;limite  
FaixasEstado1_Loop2:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado1_Loop2

  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
  
;************ESTADO 2 - DESENHA faixas utilizando segunda linha	  
FaixasEstado2:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

;*********DESENHA faixas do canto esquerdo*******    
  loadn r0, #'~'
  loadn r1, #50 ;posicao inicial
  loadn r2, #80 ;incremento
  loadn r3, #1250 ;limite
  loadn r4, #3072 ;azul
  add r0, r0, r4 ; beiradas da estrada sao azuis
  
  

FaixasEstado2_Loop1:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado2_Loop1
  

;*********DESENHA faixas do canto direito*******    
  loadn r1, #64 ;posicao inicial
  loadn r2, #80 ;incremento
  loadn r3, #1264 ;limite  
FaixasEstado2_Loop2:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jne FaixasEstado2_Loop2
 
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
  
  
;*********ESTADO 0 zero (Apaga as faixas)************
FaixasDoMeioEstado0:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7



;********* Contorle das faixas do meio 
;*********Apaga faixas do canto esquerdo*******    
  loadn r0, #' '
  loadn r1, #17 ;posicao inicial
  loadn r2, #40 ;incremento
  loadn r3, #1200 ;limite  
FaixasDoMeioEstado0_Loop1:  
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jle FaixasDoMeioEstado0_Loop1
  

  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
  	  
   
;*********DESENHA faixas do meio*******    
FaixasDoMeioEstado1:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  
  loadn r0, #'~'
  loadn r1, #17 ;posicao inicial
  loadn r2, #160 ;incremento
  loadn r3, #1200 ;limite  
  loadn r4, #2816 ;amarelo
  add r0, r0, r4 ; faixas amarelas
  
FaixasDoMeioEstado1_Loop:
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jle FaixasDoMeioEstado1_Loop
  
  
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
;************* 2o estado das faixas do meio 
FaixasDoMeioEstado2:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  
  loadn r0, #'~'
  loadn r1, #57 ;posicao inicial
  loadn r2, #160 ;incremento
  loadn r3, #1200 ;limite  
  loadn r4, #2816 ;amarelo
  add r0, r0, r4 ; faixas amarelas
  
FaixasDoMeioEstado2_Loop:
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jle FaixasDoMeioEstado2_Loop
  
  
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts
  
FaixasDoMeioEstado3:

  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  
  loadn r0, #'~'
  loadn r1, #97 ;posicao inicial
  loadn r2, #160 ;incremento
  loadn r3, #1200 ;limite  
  loadn r4, #2816 ;amarelo
  add r0, r0, r4 ; faixas amarelas
  
FaixasDoMeioEstado3_Loop:
 
  outchar r0, r1
  add r1, r1, r2
  cmp r1, r3
  jle FaixasDoMeioEstado3_Loop
  
  
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0

  rts  
  
;************************IMPRIME STRING*********************************

ImprimeString:  ;r1->posicao inicial da string, r0-> posicao inicial da tela, r2-> constante para cor devolve r6 com ultima posicao impressa

  push r0 ;backup nos registradores
  push r1
  push r2
  push r3
  push r4
  
  ;copia cor para registrador r4
  mov r4, r2
  
  loadn r2, #'\0'  ;usado na comparacao
  
  
ImprimeString_Loop:

  loadi r3, r1      ; r3 <= conteudo da primeira posicao do vetor
  cmp r3, r2 ;compara conteudo de r3 e r2
  jeq ImprimeString_Sai  ;igual \0 => sai da rotina
  add r3, r3, r4         ;soma constante para cor
  outchar r3, r0	;imprime r3 na posicao r0
  inc r0		;incrementa a posicao da tela de 1
  inc r1		;incrementa a posicao da string de 1
  
  jmp ImprimeString_Loop
  
  
ImprimeString_Sai:


  mov r6, r0 ;grava a ultima posicao da tela em r6
  
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  
  rts    
	  
PrintInteger: ;ro-> numero r1->posicao; retorna r6 número de digitos do numero 

  ;empilha (=protege) o estado atual dos registradores
  push r0	;empilho r0 (numero a ser impresso)
  push r1	;empilho r1 (posicao do video)
  push r2	;empilha r2, pois será usado para guardarmos o 
		;frame da pilha
  push r3	;empilha r3, pois será usado como variavel 
		;auxiliar (operacao mod e durante a conversao pra ascii)
  push r4	;empilha r4, pois será usado como variavel auxiliar que 
		;conterá o valor atualizado após a operacao mod
  push r5       ;empilha r5, que o conteudo de sp atual  para ser comparado com frame 
   
   
   ;se o numero for zero imprimimos e retornamos
   loadn r2, #0
   cmp r0, r2        
   jne PrintInteger_Init
   loadn r3, #48    ;ascii	
   add r2, r2, r3
   outchar r2, r1   ;imprime o zero na posicao r1
   ;imprimi só uma posicao 
   ;entao retorna 1 em r6
   loadn r6, #1
   
   pop r5
   pop r4
   pop r3
   pop r2
   pop r1
   pop r0
  
   rts  
   
   
   
   
PrintInteger_Init:  
  ;copia conteudo de sp para r2 para termos o controle da pilha
  ;r2 terá o status da pilha antes da execucao da subrotina
  ;ou seja, usaremos para saber o estado da pilha antes de 
  ;empilharmos os digitos. Uma outra maneira seria ter uma 
  ;variavel pra controlar o status da pilha (pelos pushes e pops).
  ;Da maneira aqui descrita é mais elegante, pois sp incrementa/decrementa 
  ;automatico qdo demos push/pop
  mov r2, sp	;copia conteudo de sp em r2
  loadn r6, #0
  
Loop_Compare:

  loadn r3, #0		;r3 conterá zero, pois será comparado com o 
			;numero a ser impresso a cada iteracao do loop
  cmp r0, r3		;r0==r3?
  jeq Loop_PrintInteger ;acabamos de empilhar os digitos?, 
			;se sim, chamamos o bloco para imprimir
  
  ;se houver mais digitos a serem impressos 
  ;continua aqui embaixo para empilharmos
  
  loadn r3, #10		; r3 conterá 10 para ser usado na 
			;operacao "mode" (resto da divisao)
  mod r4, r0, r3	;r4 = r0%r3 => r4 = numero%10. R4 conterá o resto da divisao, que sera o digito atual da iteracao.
  div r0, r0, r3	;r0 = r0/r3 divide nosso numero de entrada por 10 (ex: 541 => 54,1 => 54 (int)) pra buscar o proximo digito
			;Note que a cada iteracao nosso numero vai diminuindo de um algarismo
  loadn r3, #48		;r3=48, pois devera somado ao digito pra conversao ascii
  add r4, r4, r3	;atualiza o conteudo apontado por r4 é tal que r4 = r4 + r3 => r4 = r4 + 48
  push r4		;Empilha nosso digito (conteudo de r4). Esse push guardará os digitos da direita para esquerda
  
  jmp Loop_Compare	;retorna ao inicio do label para "buscar" 
			;mais digitos
  
  
Loop_PrintInteger:
  
  mov r5, sp		;Precisamos saber o estado da pilha (qtos digitos foram empilhados) 
			;r5 terá o conteudo de sp para ser comparado 
			;com frame (r2) (estado inicial)
  cmp r5, r2		;sp == frame?, ou seja, acabaram os digitos da 
			;pilha? (pilha chegou a seu estado inicial?)
  jeq Exit_PrintInteger ;se acabaram sai da subrotina, senao imprime
  
  pop r4		;retira o digito da pilha: a ordem é do mais significativo (da "esquerda") pra o menos
		
  outchar r4, r1	;imprime o digito que esta armazenado em r4 na posicao armazenada em r1
  inc r6
  
  inc r1		;increenta a posicao do video pra imprimir
  jmp Loop_PrintInteger ;continua o loop até acabarem os digitos
 
 Exit_PrintInteger:

  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  
  rts 	  

 
  
  
TesteFronteiraPistaEsquerda:  ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida



	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4
	push r5
	push r6

	
	dec r0
	loadn r3, #10  ;pos_ini
	loadn r4, #40  ;mod
	
	mod r5, r0, r4
	cmp r5, r3
	jeq TesteFronteiraPistaEsquerda_Ret1  ;chegou na fronteira
	jmp TesteFronteiraPistaEsquerda_Ret0
	
TesteFronteiraPistaEsquerda_Ret1:  ;chegou na fronteira	
	loadn r7, #1
	jmp TesteFronteiraPistaEsquerda_FIM

TesteFronteiraPistaEsquerda_Ret0:  ;chegou na fronteira	
	loadn r7, #0
	jmp TesteFronteiraPistaEsquerda_FIM	
	
TesteFronteiraPistaEsquerda_FIM:	


	pop r6
	pop r5
	pop r4
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts

;*******************Teste de fronteira para pista da direita****************************	
TesteFronteiraPistaDireita:  ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida



	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4
	push r5
	push r6

	
	inc r0
	loadn r3, #24 ;pos_ini
	loadn r4, #40  ;mod
	
	mod r5, r0, r4
	cmp r5, r3
	jeq TesteFronteiraPistaDireita_Ret1  ;chegou na fronteira
	jmp TesteFronteiraPistaDireita_Ret0
	
TesteFronteiraPistaDireita_Ret1:  ;chegou na fronteira	
	loadn r7, #1
	jmp TesteFronteiraPistaDireita_FIM

TesteFronteiraPistaDireita_Ret0:  ;chegou na fronteira	
	loadn r7, #0
	jmp TesteFronteiraPistaDireita_FIM	
	
TesteFronteiraPistaDireita_FIM:	


	pop r6
	pop r5
	pop r4
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts	
	
	
	
;*******************Teste de fronteira para pista de cima ****************************		
TesteFronteiraPistaCima:  ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida



	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4
	push r5
	push r6

	
	loadn r1, #40
	
	sub r0, r0, r1
	loadn r3, #10  ;pos_ini
	
	;menor
	cmp r0, r3
	jle TesteFronteiraPistaCima_Ret1
	
	
	;posicao normal
	jmp TesteFronteiraPistaCima_Ret0
	
	
TesteFronteiraPistaCima_Ret1:  ;chegou na fronteira	
	loadn r7, #1
	jmp TesteFronteiraPistaCima_FIM

TesteFronteiraPistaCima_Ret0:  ;chegou na fronteira	
	loadn r7, #0
	jmp TesteFronteiraPistaCima_FIM	
	
TesteFronteiraPistaCima_FIM:	


	pop r6
	pop r5
	pop r4
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts

;*******************Teste de fronteira para baixo ****************************		
TesteFronteiraPistaBaixo:  ;r0-> posicao do carro; retorno em r7 1->fronteira 0->posicao permitida



	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4
	push r5
	push r6

	
	loadn r1, #40
	
	add r0, r0, r1
	loadn r3, #1199  ;pos_ini
	
	;maior
	cmp r0, r3
	jeg TesteFronteiraPistaBaixo_Ret1
	
	
	;posicao normal
	jmp TesteFronteiraPistaBaixo_Ret0
	
	
TesteFronteiraPistaBaixo_Ret1:  ;chegou na fronteira	
	loadn r7, #1
	jmp TesteFronteiraPistaBaixo_FIM

TesteFronteiraPistaBaixo_Ret0:  ;chegou na fronteira	
	loadn r7, #0
	jmp TesteFronteiraPistaBaixo_FIM	
	
TesteFronteiraPistaBaixo_FIM:	


	pop r6
	pop r5
	pop r4
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts
		
;******************LIMPA TELA
LimpaTela:	

	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	
	loadn r0, #0		; Posicao inicial
	loadn r1, #1200		;posicao final
	loadn r2, #' '	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadi r3, r2	; r3 <- Conteudo da MEMORIA enderecada por r2

	
LimpaTela_Loop:	

	cmp r0, r1	;chegou ao fim da tela? posicao 1199, caso sim, sai
	jeq LimpaTela_Sai
	outchar r3, r0
	inc r0
	jmp LimpaTela_Loop
	
	
	
LimpaTela_Sai:	
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts

;**************FIM DO ENDURO*****************  
