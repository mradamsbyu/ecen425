; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
next_available_tcb:
	DW	0
YK_running:
	DW	0
	ALIGN	2
YKInitialize:
	; >>>>> Line:	27
	; >>>>> { 
	jmp	L_yakc_1
L_yakc_2:
	; >>>>> Line:	29
	; >>>>> YKNewTask(YKIdleTask, (void *)&IdleTskStk[256], 100); 
	mov	al, 100
	push	ax
	mov	ax, (IdleTskStk+512)
	push	ax
	mov	ax, YKIdleTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	30
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	31
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	32
	; >>>>> YKTickNum = 0; 
	mov	word [YKTickNum], 0
	; >>>>> Line:	33
	; >>>>> YK_Depth = 0; 
	mov	word [YK_Depth], 0
	; >>>>> Line:	34
	; >>>>> FirstTime = 1; 
	mov	word [FirstTime], 1
	; >>>>> Line:	35
	; >>>>> depthMoreOne = 0; 
	mov	word [depthMoreOne], 0
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	jmp	L_yakc_2
	ALIGN	2
YKEnterMutex:
	; >>>>> Line:	44
	; >>>>> void YKEnterMutex(void) { 
	jmp	L_yakc_4
L_yakc_5:
	; >>>>> Line:	45
	; >>>>> disable_interrupts(); 
	call	disable_interrupts
	mov	sp, bp
	pop	bp
	ret
L_yakc_4:
	push	bp
	mov	bp, sp
	jmp	L_yakc_5
	ALIGN	2
YKExitMutex:
	; >>>>> Line:	48
	; >>>>> void YKExitMutex(void) { 
	jmp	L_yakc_7
L_yakc_8:
	; >>>>> Line:	49
	; >>>>> enable_interrupts(); 
	call	enable_interrupts
	mov	sp, bp
	pop	bp
	ret
L_yakc_7:
	push	bp
	mov	bp, sp
	jmp	L_yakc_8
	ALIGN	2
YKIdleTask:
	; >>>>> Line:	53
	; >>>>> { 
	jmp	L_yakc_10
L_yakc_11:
	; >>>>> Line:	54
	; >>>>> while  
	jmp	L_yakc_13
L_yakc_12:
	; >>>>> Line:	56
	; >>>>> ++YKIdleCount; 
	inc	word [YKIdleCount]
L_yakc_13:
	jmp	L_yakc_12
L_yakc_14:
	mov	sp, bp
	pop	bp
	ret
L_yakc_10:
	push	bp
	mov	bp, sp
	jmp	L_yakc_11
	ALIGN	2
YKNewTask:
	; >>>>> Line:	62
	; >>>>> { 
	jmp	L_yakc_16
L_yakc_17:
	; >>>>> Line:	65
	; >>>>> tcb_array[index].delay_counter = 0; 
	mov	ax, word [next_available_tcb]
	mov	word [bp-2], ax
	mov	ax, word [YKList]
	mov	word [bp-4], ax
	; >>>>> Line:	65
	; >>>>> tcb_array[index].delay_counter = 0; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 12
	mov	word [si], 0
	; >>>>> Line:	66
	; >>>>> tcb_array[index].id = next_available_tcb; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	mov	si, ax
	add	si, tcb_array
	mov	ax, word [next_available_tcb]
	mov	word [si], ax
	; >>>>> Line:	67
	; >>>>> tcb_array[index].priority = priority; 
	mov	al, byte [bp+8]
	xor	ah, ah
	push	ax
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	mov	dx, ax
	add	dx, tcb_array
	mov	si, dx
	add	si, 2
	pop	ax
	mov	word [si], ax
	; >>>>> Line:	68
	; >>>>> tcb_array[index].task = (void*)task; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 18
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	69
	; >>>>> tcb_array[index].pInst = (void*)(task); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 6
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	70
	; >>>>> tcb_array[index].pStck = (int*)(taskStack); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 4
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	71
	; >>>>> tcb_array[index].state = READY; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 8
	mov	word [si], 1
	; >>>>> Line:	72
	; >>>>> tcb_array[index].firstTime = 1; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 20
	mov	word [si], 1
	; >>>>> Line:	73
	; >>>>> next_available_tcb++; 
	inc	word [next_available_tcb]
	; >>>>> Line:	75
	; >>>>> if (index  
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_18
	; >>>>> Line:	75
	; >>>>> if (YK_run 
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	word [YKList], ax
L_yakc_18:
	; >>>>> Line:	77
	; >>>>> while (tempHead != 0) { 
	jmp	L_yakc_20
L_yakc_19:
	; >>>>> Line:	78
	; >>>>> if (priority < tempHead->priority) { 
	mov	si, word [bp-4]
	add	si, 2
	mov	al, byte [bp+8]
	xor	ah, ah
	cmp	ax, word [si]
	jge	L_yakc_22
	; >>>>> Line:	80
	; >>>>> if (YKList == tempHead) { 
	mov	ax, word [bp-4]
	cmp	ax, word [YKList]
	jne	L_yakc_23
	; >>>>> Line:	81
	; >>>>> YKList->prev = &(tcb_array[index]); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, word [YKList]
	add	si, 14
	mov	word [si], ax
	; >>>>> Line:	82
	; >>>>> tcb_array[index].next = YKList; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 16
	mov	ax, word [YKList]
	mov	word [si], ax
	; >>>>> Line:	83
	; >>>>> YKList = &(tcb_array[index]); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	word [YKList], ax
	jmp	L_yakc_24
L_yakc_23:
	; >>>>> Line:	86
	; >>>>> tcb_array[index].next = tempHead; 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, ax
	add	si, 16
	mov	ax, word [bp-4]
	mov	word [si], ax
	; >>>>> Line:	87
	; >>>>> tcb_array[index].prev = tempHead->prev; 
	mov	si, word [bp-4]
	add	si, 14
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	di, ax
	add	di, 14
	mov	ax, word [si]
	mov	word [di], ax
	; >>>>> Line:	88
	; >>>>> tempHead->prev->next = &(tcb_array[index]); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, word [bp-4]
	add	si, 14
	mov	si, word [si]
	add	si, 16
	mov	word [si], ax
	; >>>>> Line:	89
	; >>>>> tempHead->prev = &(tcb_array[index]); 
	mov	ax, word [bp-2]
	mov	cx, 22
	imul	cx
	add	ax, tcb_array
	mov	si, word [bp-4]
	add	si, 14
	mov	word [si], ax
L_yakc_24:
	; >>>>> Line:	91
	; >>>>> tempHead = 0; 
	mov	word [bp-4], 0
	jmp	L_yakc_25
L_yakc_22:
	; >>>>> Line:	95
	; >>>>> tempHead = tempHead->next; 
	mov	si, word [bp-4]
	add	si, 16
	mov	ax, word [si]
	mov	word [bp-4], ax
L_yakc_25:
L_yakc_20:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_yakc_19
L_yakc_21:
	; >>>>> Line:	98
	; >>>>> if (YK_run 
	mov	ax, word [YK_running]
	test	ax, ax
	je	L_yakc_26
	; >>>>> Line:	99
	; >>>>> YKScheduler(0); 
	xor	ax, ax
	push	ax
	call	YKScheduler
	add	sp, 2
L_yakc_26:
	mov	sp, bp
	pop	bp
	ret
L_yakc_16:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_17
	ALIGN	2
YKRun:
	; >>>>> Line:	106
	; >>>>> { 
	jmp	L_yakc_28
L_yakc_29:
	; >>>>> Line:	107
	; >>>>> if (YKList != &(tcb_array[0])) { 
	mov	ax, tcb_array
	cmp	ax, word [YKList]
	je	L_yakc_30
	; >>>>> Line:	108
	; >>>>> YK_running = 1; 
	mov	word [YK_running], 1
	; >>>>> Line:	109
	; >>>>> YKScheduler(0); 
	xor	ax, ax
	push	ax
	call	YKScheduler
	add	sp, 2
L_yakc_30:
	mov	sp, bp
	pop	bp
	ret
L_yakc_28:
	push	bp
	mov	bp, sp
	jmp	L_yakc_29
L_yakc_32:
	DB	"No running tasks! YKIdleTask() should at least be running",0xA,0
	ALIGN	2
YKScheduler:
	; >>>>> Line:	120
	; >>>>> { 
	jmp	L_yakc_33
L_yakc_34:
	; >>>>> Line:	124
	; >>>>> YKEnterMutex(); 
	mov	ax, word [YKList]
	mov	word [bp-2], ax
	mov	word [bp-4], L_yakc_32
	; >>>>> Line:	124
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	125
	; >>>>> while (currentTCB != 0) { 
	jmp	L_yakc_36
L_yakc_35:
	; >>>>> Line:	126
	; >>>>> if (currentTCB->state == RUNNING) { 
	mov	si, word [bp-2]
	add	si, 8
	cmp	word [si], 2
	jne	L_yakc_38
	; >>>>> Line:	127
	; >>>>> break; 
	jmp	L_yakc_37
	jmp	L_yakc_39
L_yakc_38:
	; >>>>> Line:	129
	; >>>>> else if (currentTCB->state == READY) { 
	mov	si, word [bp-2]
	add	si, 8
	cmp	word [si], 1
	jne	L_yakc_40
	; >>>>> Line:	130
	; >>>>> YKDispatcher(currentTCB, save_context); 
	push	word [bp+4]
	push	word [bp-2]
	call	YKDispatcher
	add	sp, 4
	; >>>>> Line:	131
	; >>>>> break; 
	jmp	L_yakc_37
L_yakc_40:
L_yakc_39:
	; >>>>> Line:	133
	; >>>>> ning 
	mov	si, word [bp-2]
	add	si, 16
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_36:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_35
L_yakc_37:
	; >>>>> Line:	135
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	mov	sp, bp
	pop	bp
	ret
L_yakc_33:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_34
	ALIGN	2
YKDispatcher:
	; >>>>> Line:	151
	; >>>>> { 
	jmp	L_yakc_42
L_yakc_43:
	; >>>>> Line:	158
	; >>>>> if(FirstTime) { 
	mov	ax, word [running_task]
	mov	word [bp-2], ax
	mov	word [bp-4], 0
	mov	si, word [bp+4]
	add	si, 20
	mov	ax, word [si]
	mov	word [bp-6], ax
	; >>>>> Line:	158
	; >>>>> if(FirstTime) { 
	mov	ax, word [FirstTime]
	test	ax, ax
	je	L_yakc_44
	; >>>>> Line:	159
	; >>>>> task->firstTime = 0; 
	mov	si, word [bp+4]
	add	si, 20
	mov	word [si], 0
	; >>>>> Line:	160
	; >>>>> FirstTime = 0; 
	mov	word [FirstTime], 0
	; >>>>> Line:	161
	; >>>>> ++YKCtxSwCount; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	162
	; >>>>> running_task = task; 
	mov	ax, word [bp+4]
	mov	word [running_task], ax
	jmp	L_yakc_45
L_yakc_44:
	; >>>>> Line:	166
	; >>>>> else if (running_task->state == BLOCKED) { 
	mov	si, word [running_task]
	add	si, 8
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_46
	; >>>>> Line:	167
	; >>>>> = 0) return; 
	mov	ax, word [bp+4]
	mov	word [running_task], ax
	; >>>>> Line:	168
	; >>>>> if (!(task->firstTime)) { 
	mov	si, word [bp+4]
	add	si, 20
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_47
	; >>>>> Line:	172
	; >>>>> } 
	jmp	L_yakc_48
L_yakc_47:
	; >>>>> Line:	174
	; >>>>> task->firstTime = 0; 
	mov	si, word [bp+4]
	add	si, 20
	mov	word [si], 0
	; >>>>> Line:	175
	; >>>>> task->state = RUNNING; 
	mov	si, word [bp+4]
	add	si, 8
	mov	word [si], 2
	; >>>>> Line:	176
	; >>>>> ++YKCtxSwCount; 
	inc	word [YKCtxSwCount]
L_yakc_48:
	jmp	L_yakc_49
L_yakc_46:
	; >>>>> Line:	181
	; >>>>> task->firstTime = 0; 
	mov	si, word [bp+4]
	add	si, 20
	mov	word [si], 0
	; >>>>> Line:	182
	; >>>>> ++YKCtxSwCount; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	183
	; >>>>> old_task->state = READY; 
	mov	si, word [bp-2]
	add	si, 8
	mov	word [si], 1
	; >>>>> Line:	184
	; >>>>> task->state = RUNNING; 
	mov	si, word [bp+4]
	add	si, 8
	mov	word [si], 2
	; >>>>> Line:	185
	; >>>>> running_task = task; 
	mov	ax, word [bp+4]
	mov	word [running_task], ax
L_yakc_49:
L_yakc_45:
	; >>>>> Line:	189
	; >>>>> if (enable) enable_interrupts(); 
	mov	ax, word [bp-6]
	test	ax, ax
	je	L_yakc_50
	; >>>>> Line:	189
	; >>>>> if (enable) enable_interrupts(); 
	call	enable_interrupts
L_yakc_50:
	; >>>>> Line:	205
	; >>>>> if (save_context) YKDispHandler(old_task, 
	mov	ax, word [bp+6]
	test	ax, ax
	je	L_yakc_51
	; >>>>> Line:	205
	; >>>>> if (save_context) YKDispHandler(old_task, 
	mov	si, word [bp+4]
	add	si, 4
	push	word [si]
	mov	si, word [bp+4]
	add	si, 6
	push	word [si]
	push	word [bp-2]
	call	YKDispHandler
	add	sp, 6
	jmp	L_yakc_52
L_yakc_51:
	; >>>>> Line:	209
	; >>>>> YKFirst(task->pInst, task->pStck); 
	mov	si, word [bp+4]
	add	si, 4
	push	word [si]
	mov	si, word [bp+4]
	add	si, 6
	push	word [si]
	call	YKFirst
	add	sp, 4
L_yakc_52:
	mov	sp, bp
	pop	bp
	ret
L_yakc_42:
	push	bp
	mov	bp, sp
	sub	sp, 6
	jmp	L_yakc_43
	ALIGN	2
YKDelayTask:
	; >>>>> Line:	236
	; >>>>> { 
	jmp	L_yakc_54
L_yakc_55:
	; >>>>> Line:	238
	; >>>>> if (count == 0) return; 
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_yakc_56
	; >>>>> Line:	238
	; >>>>> if (count == 0) return; 
	jmp	L_yakc_57
L_yakc_56:
	; >>>>> Line:	239
	; >>>>> running_task->delay_counter = count; 
	mov	si, word [running_task]
	add	si, 12
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	240
	; >>>>> running_task->state = BLOCKED; 
	mov	si, word [running_task]
	add	si, 8
	mov	word [si], 0
	; >>>>> Line:	243
	; >>>>> YKScheduler(1); 
	mov	ax, 1
	push	ax
	call	YKScheduler
	add	sp, 2
L_yakc_57:
	mov	sp, bp
	pop	bp
	ret
L_yakc_54:
	push	bp
	mov	bp, sp
	jmp	L_yakc_55
	ALIGN	2
YKEnterISR:
	; >>>>> Line:	250
	; >>>>> { 
	jmp	L_yakc_59
L_yakc_60:
	; >>>>> Line:	251
	; >>>>> ++YK_Depth; 
	inc	word [YK_Depth]
	mov	sp, bp
	pop	bp
	ret
L_yakc_59:
	push	bp
	mov	bp, sp
	jmp	L_yakc_60
	ALIGN	2
YKExitISR:
	; >>>>> Line:	256
	; >>>>> { 
	jmp	L_yakc_62
L_yakc_63:
	; >>>>> Line:	257
	; >>>>> --YK_Depth; 
	dec	word [YK_Depth]
	; >>>>> Line:	258
	; >>>>> if (YK_Depth == 0){ 
	mov	ax, word [YK_Depth]
	test	ax, ax
	jne	L_yakc_64
	; >>>>> Line:	259
	; >>>>> depthMoreOne = 0; 
	mov	word [depthMoreOne], 0
	; >>>>> Line:	260
	; >>>>> YKScheduler(0); 
	xor	ax, ax
	push	ax
	call	YKScheduler
	add	sp, 2
L_yakc_64:
	mov	sp, bp
	pop	bp
	ret
L_yakc_62:
	push	bp
	mov	bp, sp
	jmp	L_yakc_63
	ALIGN	2
YKTickHandler:
	; >>>>> Line:	267
	; >>>>> { 
	jmp	L_yakc_66
L_yakc_67:
	; >>>>> Line:	269
	; >>>>> ++YKTickNum; 
	mov	ax, word [YKList]
	mov	word [bp-2], ax
	; >>>>> Line:	269
	; >>>>> ++YKTickNum; 
	inc	word [YKTickNum]
	; >>>>> Line:	270
	; >>>>> while (currentTCB != 0) { 
	jmp	L_yakc_69
L_yakc_68:
	; >>>>> Line:	271
	; >>>>> if (currentTCB->task == YKIdleTask) return; 
	mov	si, word [bp-2]
	add	si, 18
	mov	ax, YKIdleTask
	cmp	ax, word [si]
	jne	L_yakc_71
	; >>>>> Line:	271
	; >>>>> if (currentTCB->task == YKIdleTask) return; 
	jmp	L_yakc_72
L_yakc_71:
	; >>>>> Line:	273
	; >>>>> if (currentTCB->delay_counter != 0) { 
	mov	si, word [bp-2]
	add	si, 12
	mov	ax, word [si]
	test	ax, ax
	je	L_yakc_73
	; >>>>> Line:	274
	; >>>>> --(currentTCB->delay_counter); 
	mov	si, word [bp-2]
	add	si, 12
	dec	word [si]
	; >>>>> Line:	275
	; >>>>> if (currentTCB->delay_counter == 0) { 
	mov	si, word [bp-2]
	add	si, 12
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_74
	; >>>>> Line:	276
	; >>>>> currentTCB->state = R 
	mov	si, word [bp-2]
	add	si, 8
	mov	word [si], 1
L_yakc_74:
L_yakc_73:
	; >>>>> Line:	279
	; >>>>> currentTCB = currentTCB->next; 
	mov	si, word [bp-2]
	add	si, 16
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_69:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_68
L_yakc_70:
L_yakc_72:
	mov	sp, bp
	pop	bp
	ret
L_yakc_66:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_67
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
YKIdleCount:
	TIMES	2 db 0
YKTickNum:
	TIMES	2 db 0
YK_Depth:
	TIMES	2 db 0
FirstTime:
	TIMES	2 db 0
tcb_array:
	TIMES	44 db 0
YKList:
	TIMES	2 db 0
running_task:
	TIMES	2 db 0
IdleTskStk:
	TIMES	512 db 0
depthMoreOne:
	TIMES	2 db 0
