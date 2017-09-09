;
; Bucle_Vectorial.s
;
; Bucle DAXPY realizado con una mezcla de instrucciones vectoriales y escalares
; Y=Y+a*X donde X e Y son vectores y a es un escalar. 
; Lo primero de lo que debo disponer es de dos vectores almacenados en memoria. 

           .data
;Escalar a
a:         .double 1595


;vector x

x:         .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
           .double 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
           .double 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
           .double 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
           .double 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
           .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
           .double 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
           .double 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
           .double 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
           .double 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
           .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
           .double 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
           .double 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
           .double 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
           .double 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
           .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
           .double 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
           .double 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
           .double 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
           .double 40, 41, 42, 43, 44, 45, 46, 47, 48, 49


;vector y

y:         .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
           .double 100, 100, 100, 100, 100, 100, 100, 100, 100, 100


           .text
           
; Comienza el código

principal: 
            addi r1,r0,x     ; Cálculo de dirección. r1 contiene la direccion del vector x
            addi r2,r0,y     ; Cálculo de dirección. r2 contiene la direccion del vector y 
            ld f0,a(r0)	    ; f0 contiene el valor de a, que vamos a aplicar en la fórmula
            addi r4,r1,#1600   ;bytes ocupados por los vectores. r4 me indica hasta cuando debo de leer
            
            
;Gestiono la primera sección. Al procesar un vector de 200 posiciones, de 64 a 64, la sección libre es de 8


;64+64+64+8=200

            addi r5,r0,#8 ; Total de elementos de primera sección a procesar
            movi2s VLR,r5 ; Actualizo VLR con la longitud en elementos de la primera sección
            multi r5,r5,#8 ; Actualizo r5 para que disponga del total en BYTES de la sección

;Cargo vectores y realizo cálculos
bucle:  
            lv V1,r1 ; Carga de elementos de vector x
            lv V2,r2 ; Carga de elementos de vector y
            multsv v1,v1,f0 ;Multiplico x*a y acumulo en x
            addv v2,v2,v1 ; Y=Y+a*X
            sv r2,v2 ; almaceno la información calculada de Y

;Muevo el cursor sobre los vectores en base a las posiciones tratadas
            addi r1,r1,r5 
            addi r2,r2,r5

;restauro el nuevo valor de la sección (VLR=64)
            multi r5,MVL,#8
            movi2s VLR,MVL
            
; Compruebo si he tratado todos los elementos, e itero en caso contrario

            sub r3,r4,r1  
            bnez r3,bucle ; Itero, en el caso de que sigan quedando posiciones por procesar    
            trap 6 ;Fin de Programa
 