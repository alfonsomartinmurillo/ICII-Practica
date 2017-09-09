;
; Bucle_Escalar_2.s
;
; Bucle DAXPY con instrucciones escalares:
; Y=Y+a*X donde X e Y son vectores y a es un escalar. 
; En este caso, desenrollamos el còdigo escalar tres veces. Es decir, en cada iteración se procesarán
; las posiciones del vector de 3 en 3.
; Los vectores no tienen porque ser múltiplo de 3.
; 
; asumo que el vector tiene como mínimo tres posiciones que procesar


           .data
;Escalar a

a:         .double 1595

;Escalar tamaño vector

lvec: .double 512 

;vector x

x:         .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
           .double 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
           .double 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
           .double 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
           .double 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
           .double 50, 51, 52, 53, 54, 55, 56, 57, 58, 59
           .double 60, 61, 62, 63

;vector y

y:         .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100

z:         .space 512   ;Vector Z


           .text
principal: 
            addi r1,r0,x     ;Cálculo de dirección. r1 contiene la direccion del vector x
            addi r2,r0,y     ;Cálculo de dirección. r2 contiene la direccion del vector y 
            ld f0,a(r0)	    ;f0 contiene el valor de a, que vamos a aplicar en la fórmula
            addi r20,r0,#16 ;Usado en el control de posiciones pendientes 
            addi r4,r1,512   ;64 elementos son 512 bytes. r4 me indica hasta cuando debo de leer
            ;límite del vector. r4 va 
bucle3:  
            ;importante, al ser doble precisión, ocupan dos registros. Por tanto nos referimos a los registros
            ;como F0, F2, F4 ...
            
            ;carga de i, i+1 e i+2
            ld f2,0(r1) ;carga X(i)
            ld f8,8(r1) ;carga X(i+1)
            ld f14,16(r1) ;carga X(i+2)
            
            ;Multiplicaciones de los 3 elementos.
            multd f4,f2,f0 ; a*X(i)
            multd f10,f8,f0 ; a*X(i+1)
            multd f16,f14,f0 ; a*X(i+2)
            
            ;Cargas de y, y+1 e i+2
            
            ld f6, 0(r2) ; carga de Y(i)
            ld f12, 8(r2) ; carga de Y(i)
            ld f18, 16(r2) ; carga de Y(i)
            
            ;suma de Y=Y(i)+a*X(i)
            addd f6,f6,f4 ;suma de Y=Y(i)+a*X(i)
            addd f12,f12,f10 ;suma de Y=Y(i+1)+a*X(i+1)
            addd f18,f18,f16 ;suma de Y=Y(i+2)+a*X(i+2)
            
            ;almacenamientos
            sd 0(r2),f6 ;almaceno el nuevo valor para el vector y
            sd 8(r2),f12 ;almaceno el nuevo valor para el vector y+1
            sd 16(r2),f18 ;almaceno el nuevo valor para el vector y+2
            
            ;desplazar punteros de vectores
            addi r1,r1,#24 ;Me muevo tres posiciones. Al ser doble precisión, 24 bytes
            addi r2,r2,#24 ;Me muevo tres posiciones. Al ser doble precisión, 24 bytes
            ;Identificar cuantas posiciones me quedan por cargar

comprobar:  
            sub r6,r4,r1 ; r6 me almacena la memoria que me queda por procesar. =0 no debo continuar.
            
            ;fin programa
            beqz r6,fin ;Si no me quedan mas posiciones por procesar (r6=0), finalizo el programa. 
            
            sgt r7,r6,r20 ;r7 me dice si me quedan 3 o mas posiciones de vector.
            
            ;Me quedan mas de 3 posiciones, por tanto, repito bucle3
            bnez r7,bucle3 
            
            ;en caso contrario realizo la carga de una posición y vuelvo a comprobar
            ld f2,0(r1) ;carga X(i)
            multd f4,f2,f0 ; a*X(i)
            ld f6, 0(r2) ; carga de Y(i)
            addd f6,f6,f4 ;suma de Y=Y(i)+a*X(i)
            sd 0(r2),f6 ;almaceno el nuevo valor para el vector y
            ;desplazar punteros de vectores
            addi r1,r1,#8 ;Me muevo tres posiciones. Al ser doble precisión, 24 bytes
            addi r2,r2,#8 ;Me muevo tres posiciones. Al ser doble precisión, 24 bytes
            j comprobar
            
            
            
fin:        trap 6 ;Fin de Programa
 