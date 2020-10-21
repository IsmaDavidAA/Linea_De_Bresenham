;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;macros                                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aMayorYbMenor macro a, b        ;colocamos el mayor en aAux y el menor en bAux    
    local aMenor, fin
    push cx             ;
    push dx             ;
    mov cx, [a]                 
    mov dx, [b]                 
    cmp cx, dx                  
    ja fin                      
        xchg cx, dx             
    fin:                        
    mov [aAux], cx              
    mov [bAux], dx              
    pop dx              ;
    pop cx              ;
endm

pintar macro x, y               ;pintamos x, y
    push ax
    push cx
    push dx
    mov cx, [x]  ; columna  
    mov dx, [y]  ; fila
    mov al, 10   ; color verde
    mov ah, 0ch  ; poner pixel
    int 10h      
    pop dx
    pop cx
    pop ax  
endm
             

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
org 100h
inicio:
    mov ah, 0       ;Activamos el modo grafico
    mov al, 13h     ;
    int 10h         ;
    
    ;Para xD(Dx)------------------------------------------------------------
    aMayorYbMenor A_x, B_x;llevamos el mayor a aAux y menor a bAux
    mov bx, [aAux]        ; 
    mov cx, [bAux]        ;
    mov [D_x], bx         ;
    sub [D_x], cx         ;D_x = aAux - bAux
                        
                        
    ;Para yD(Dy)------------------------------------------------------------                    
    aMayorYbMenor A_y, B_y;llevamos el mayor a aAux y menor a bAux
    mov bx, [aAux]        ;
    mov cx, [bAux]        ;
    mov [D_y], bx         ;
    sub [D_y], cx         ;D_y = aAux - bAux
    
    ;Para D    ------------------------------------------------------------
    mov cx, [D_y]         ;
    mov ax, 2             ;
    mul cx                ;
    mov cx, [D_x]         ;
    sub ax, cx            ;
    mov [D], ax           ;D = 2*D_y - D_x
    
    ;Para incE  ------------------------------------------------------------          
    mov cx, 2             ;
    mov ax, [D_y]         ;
    mul cx                ;
    mov [incE], ax        ;incE = 2*D_y
    
    ;Para incNE ------------------------------------------------------------
    mov cx, 2             ;
    mov ax, [D_y]         ;
    mov bx, [D_x]         ;
    sub ax, bx            ;
    mul cx                ;
    mov [incNE], ax       ;incNE = 2*(D_y - D_x)
   
    ;Para tomar el punto mas a la izquierda
    mov bx, [A_x]         ;
    mov cx, [B_x]         ;
    cmp bx, cx            ;A_x, B_x
    ja  iniPuntoB         ;A_x > B_x
    jmp iniPuntoA         ;A_x <= B_x
                          
    iniPuntoB:            ; A_x > B_x
        mov cx, B_x       ;
        mov [x], cx       ;     x = B_x
        mov cx, B_y       ;
        mov [y], cx       ;     y = B_y
        mov cx, A_x       ;
        mov [xTope], cx   ;     xTope = A_x
        jmp seleccionado  ;
    
    iniPuntoA:            ; A_x <= B_x
        mov cx, A_x       ;
        mov [x], cx       ;     x = A_x
        mov cx, A_y       ;
        mov [y], cx       ;     y = A_y
        mov cx, B_x       ;
        mov [xTope], cx   ;     xTope = B_x
    
    seleccionado:         
                          ;
        mov ax, [y]       ;
        mov cx, [x]       ;
        mov bx, [xTope]   ;
        mov dx, [D]       ;
        
    ;Para determinar si y++ o y--
        push bx
        push cx                  
        mov bx, [A_y]     ;
        mov cx, [B_y]     ;
        cmp bx, cx        ;A_y, B_y
        ja  gocicloYdec     ;A_y > B_y
        jmp gocicloYinc     ;A_y <= B_y
    
    gocicloYdec:
        pop cx
        pop bx
        jmp cicloYdec    
    gocicloYinc:     
        pop cx
        pop bx
        jmp cicloYinc
    ;Para cuando Y--
    cicloYdec:
        cmp cx, bx        ;x, xTope
        ja fin            ;x > xTope ====>FIN
        inc cx            ;x++
        mov [x], cx       ;
        cmp dx, 0         ;D, 0
        jg ddNoEsMenorQue0;si D es positivo 
        je ddNoEsMenorQue0;si D es 0
            
            ;d < 0 ========> D = D + incE
            push ax       ;
            mov ax, [incE];
            add dx, ax    ;
            pop ax        ;
            jmp dcont     ;
            
            
            ;d >= 0  ========> D = D + incE
            ddNoEsMenorQue0:  
            push ax       ;
            mov ax,[incNE]
            add dx, ax
            pop ax
            dec ax        ;;;;;;;;;;y--
            mov [y], ax
        
        dcont:            
            pintar x, y   ;pintamos (x, y)
        jmp cicloYdec     ;
    
    ;Para cuando Y++    
    cicloYinc:
        cmp cx, bx        
        ja fin
        inc cx  
        mov [x], cx
        cmp dx, 0
        jg idNoEsMenorQue0
        je idNoEsMenorQue0
            push ax
            mov ax, [incE]
            add dx, ax
            pop ax
            jmp icont
        idNoEsMenorQue0:
            push ax
            mov ax, [incNE]
            add dx, ax
            pop ax
            inc ax        ;;;;;;;;;;y++
            mov [y], ax
        icont:     
            pintar x, y
        jmp cicloYinc        
    
fin:
int 20h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

A_x   dw 60    
A_y   dw 20
B_x   dw 10
B_y   dw 20

aAux  dw 0
bAux  dw 0 

D_x   dw 0
D_y   dw 0
D     dw 0
incE  dw 0
incNE dw 0
signo dw 0

xTope dw 0     
x     dw 0
y     dw 0                                    

