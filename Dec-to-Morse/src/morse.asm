.data
 
entre:  .asciiz "Entre com a string numerica: \n"
saida:  .asciiz "A string em codigo Morse eh: "
 
zero:   .asciiz "- - - - -"
um:     .asciiz ". - - - -"
dois:   .asciiz ". . - - -"
tres:   .asciiz ". . . - -"
quatro: .asciiz ". . . . -"
cinco:  .asciiz ". . . . ."
seis:   .asciiz "- . . . ."
sete:   .asciiz "- - . . ."
oito:   .asciiz "- - - . ."
nove:   .asciiz "- - - - ."
espaco: .asciiz " "
 
string: .space 300
 
 
.globl main
.text
 
main:
    
    la $a0, entre
    li $v0, 4
    syscall
 
    li    $v0, 8               
    la    $a0, string
    li    $a1, 300
    syscall
    
    move $s0, $a0
 
    li    $v0, 4                        
    la    $a0, saida
    syscall
    
    loop:
 
    lb $t1, 0($s0)       
    beqz $t1, exit  
    addi $s0, $s0, 1
    
    li $t2, 48
    beq $t1, $t2, zerom
    addi $t2, $t2, 1
    beq $t1, $t2, umm
    addi $t2, $t2, 1
    beq $t1, $t2, doism
    addi $t2, $t2, 1
    beq $t1, $t2, tresm
    addi $t2, $t2, 1
    beq $t1, $t2, quatrom
    addi $t2, $t2, 1
    beq $t1, $t2, cincom
    addi $t2, $t2, 1
    beq $t1, $t2, seism
    addi $t2, $t2, 1
    beq $t1, $t2, setem
    addi $t2, $t2, 1
    beq $t1, $t2, oitom
    addi $t2, $t2, 1
    beq $t1, $t2, novem
    li $t2, 32
    beq $t1, $t2, espac
 
j loop # volta para o loop
    
 
    
umm:
la    $a0, um
li    $v0, 4                        
syscall
 
la    $a0, espaco
li    $v0, 4                        
syscall                            
 
j loop
 
zerom:
la    $a0, zero
li    $v0, 4                        
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
doism:
 
la    $a0, dois
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
tresm:
la    $a0, tres
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
quatrom:
la    $a0, quatro
li    $v0, 4
syscall
 
li    $v0, 4                        
la    $a0, espaco
syscall
 
j loop
 
cincom:
la    $a0, cinco
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
seism:
la    $a0, seis
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
setem:
la    $a0, sete
li    $v0, 4
 
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
oitom:
la    $a0, oito
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
j loop
 
novem:
la    $a0, nove
li    $v0, 4
syscall
 
la    $a0, espaco
li    $v0, 4
syscall
 
espac:
j loop
 
 
 
exit:
li $v0, 10
syscall