		.model small
		.stack 256
		
		.data  
RES  DB 10 DUP ('$')
                   
welcome db 'Nadeen Nagy :  - project #2',10,13,'$'
line db '-------------------------------------',10,13,'$' 
N  dw 10,13,'Total # of packets is ','$'
result   dw 10,13,'The # of transmissions is ','$'   

filesize  dd  100000  ;32 bit
packetsize dw 1000   ;16 bit
;N dw ?    ;total number of packets to be sent N=filesize/packetsize    

;ax has total number of packets sent 5alas
;bx has number of trasmissions

two db 2 
oldax dw ? 
oldax2 dw ?

		.code
start:
		mov ax, @data 
		mov ds, ax
  
  	mov ah,09h
	lea dx,welcome 
	mov dx, offset welcome 
	int 21h   
	
	mov ah,09h
	lea dx,line 
	mov dx, offset line 
	int 21h                                      
	
	lea dx,filesize  
	mov ax,word ptr [filesize] 
	mov dx,word ptr [filesize +2] 
	mov bx,packetsize
	;aad
	div bx         ;to get number of packets  
	cmp dx,0000h
	jz  noremainder
	inc ax             ;if there is remainder increase number pf packets by one
noremainder: mov N,ax       ; N  contain number of packets in hex
   
	
  	    ;;;;;;;;;;;;  
  	    
	beginloop:
	mov ax,1
	mov bx,1
	 
	loop11:
	cmp ax,N 
	jl  loop22
	mov result,bx 
	mov ax,result
    
    LEA SI,RES  
     CALL HEX2DEC  
     
      LEA DX,RES
    MOV AH,9
    INT 21H   
    
      MOV AH,4CH
    INT 21H      ;to terminate program
    
    loop22:
    cmp ax,40h ;64  dec
    jge elseif1 
    mov oldax,ax
    mul two 
    add ax,oldax
	inc bx 
	jp loop11
	
	
	elseif1:
	cmp ax,80h ;128 dec  
	je  elseif2
	mov oldax2,ax 
	inc ax
	add ax,oldax2
	inc bx  
	jp loop11
	
	elseif2:
	sub N,ax
	jp beginloop
	   
	   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   HEX2DEC PROC NEAR
    MOV CX,0
    MOV BX,10
   
LOOP1: MOV DX,0
       DIV BX
       ADD DL,30H
       PUSH DX
       INC CX
       CMP AX,9
       JG LOOP1
     
       ADD AL,30H
       MOV [SI],AL
     
LOOP2: POP AX
       INC SI
       MOV [SI],AL
       LOOP LOOP2
       RET
HEX2DEC ENDP    
	
	end start   