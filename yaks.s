
enable_interrupts:
	sti	
	ret

disable_interrupts:
	cli
	ret

YKFirst:
	push bp
	mov bp, sp
	mov sp, word[bp+6]
	call word[bp+4]
	iret			;Program should NEVER Execute this Statement.
				;Use it as a Debugging Point
	
YKDispHandler:
	
	push bp
	mov bp, sp
	
	pushf
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	mov si, word [bp+4]	;TCB Location
	add si, 4		;TCB->STACK Location
	mov [si], sp		;SP OF OLD TASK IS UPDATED
	add si, 2		;TCB->IP Location
	call GetIP
	add ax, 11
	mov [si], ax
	mov sp, word[bp+8]
	call word[bp+6]
	
	add sp, 2			;USED AS JUNK, SO JUST GETTING RID OF IT
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	mov sp, bp
	pop bp
	ret

GetIP:
	push bp
	mov bp, sp
	
	mov ax, word[bp+2]
	
	mov sp, bp
	pop bp
	ret

