
enable_interrupts:
	sti	
	ret

disable_interrupts:
	cli
	ret

YKSecond:
	push bp
	mov bp, sp
	pushf
	push cs
	push word [ipLabelFirst]

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds

	mov si, word[old_task]
	mov [si], sp	
	mov si, word[running_task]
	mov sp, [si]
		
	iret

	ipLabelFirst: DW Label2

Label2:
	mov sp, bp
	pop bp
	ret

YKFirst:
	;push bp
	;mov bp, sp

	mov si, word[running_task]
	mov sp, [si]
	mov ax, 0x200
	add si, 2
	mov si, [si]
	
	push ax
	push cs
	push si
	iret			

YKISR:
	mov si, word[old_task]
	mov [si], sp
	mov si, word[running_task]
	mov sp, [si]	;move the new sp to the sp register			
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret		; this assumes that the top of the stack is ip, cs, flags. iret atomically pops those three and returns instruction control to the new ip
	
YKDispHandler:
	
	push bp
	mov bp, sp

	pushf
	push cs
	push word [ipLabel]	

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
		
;save old sp and get new sp
	mov si, word[old_task]
	mov [si], sp
	mov si, word[running_task]
	mov sp, [si]

	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret

	ipLabel: DW Label1

Label1:
	mov sp, bp
	pop bp
	ret









;GetIP:
;	push bp
;	mov bp, sp
	
;	mov ax, word[bp+2]
	
;	mov sp, bp
;	pop bp
;	ret

