;
; Bucle_Escalar_1.s
;
; Bucle DAXPY con instrucciones escalares:
; Y=Y+a*X donde X e Y son vectores y a es un escalar. 
; Lo primero de lo que debo disponer es de dos vectores almacenados en memoria. 
;
;
;

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
            addi r4,r1,512   ;64 elementos son 512 bytes. r4 me indica hasta cuando debo de leer
            ;límite del vector. r4 va 
bucle:  
            ;importante, al ser doble precisión, ocupan dos registros. Por tanto nos referimos a los registros
            ;como F0, F2, F4
            ld f2,0(r1) ;carga X(i)
            multd f4,f2,f0 ; en f4 almaceno la multiplicación entre f0 y f2, que representa a*X(i)
            ld f6, 0(r2) ; carga de Y(i)
            addd f6,f6,f4 ;suma de Y=Y(i)+a*X(i)
            sd 0(r2),f6 ;almaceno el nuevo valor para el vector y
            addi r1,r1,8 ;Me muevo a la siguiente posición del vector x. Al ser doble precisión, 8 bytes
            addi r2,r2,8 ;Me muevo a la siguiente posición del vector y. Al ser doble precisión, 8 bytes
            sgt r5,r1,r4 ;si r1 > r4 significa que ya no debo de leer más. 
            beqz r5,bucle ; si r5=0 significa que r1 todavía no ha superado a r4, y queda información por procesar
            
            trap 6 ;Fin de Programa
 