; Hello World - Escreve mensagem armazenada na memoria na tela



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

logojogo : string ".:ENDURO ICMC:."	; Poe "\0" automaticamente no final da string
str_putword : string "Digite a palavra desejada: "	; Poe "\0" automaticamente no final da string
str_input_char: string "Digite uma letra: "
str_youlose: string "Voce perdeu!"
str_youwin: string "Voce ganhou!"
str_game_or_exit: string "Tecle (j) para jogar ou (s) para sair!"
str_clearscreen : string " "
myword: var #41
str_out: var #41




; ------ Programa Principal -----------

main:

	;tela inicial
	;call LimpaTela
	loadn r0, #1177  ;poiscao antiga do carro
	loadn r1, #1177  ;posicao nova do carro
	call DesenhaCarro
	
	loadn r5, #0
	loadn r6, #1000

	
	Loop:


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
	
	
	inc r5
	cmp r5, r6
	jne Loop

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
  loadn r4, #255  ;usado no final 
  
  inchar r1        ;caractere estara em r1
  
  ;compara direita
  cmp r1, r2   ;esquerda
  jeq ControlaCarro_Esquerda
  
  ;compar esquerda
  cmp r1, r3   ;direita
  jeq ControlaCarro_Direita
  
  ;se nao for esquerda é lixo
  ;nao desenhamos e montemos a posicao antiga
  ;r1 tem lixo
  ;logo
  ;posicao atual e antiga 
  ;é o mesmo valor em r0 e r1
  mov r1, r0
  call DesenhaCarro
  
  jmp ControlaCarro_FIM
  
  
  
  
  
ControlaCarro_Esquerda:
 mov r1, r0
 dec r1
 call DesenhaCarro  ;r0->pos antiga, r1 -> atual
 mov r0, r1         ;a posicao atual sera a antiga
 jmp ControlaCarro_FIM
 
 
 
 ControlaCarro_Direita:
 mov r1, r0
 inc r1
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
  
  loadn r0, #2000
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
    
;**************FIM DO ENDURO*****************  
