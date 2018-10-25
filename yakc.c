#include "yakk.h"
#include "yaku.h"
#include "clib.h"

#define FIRST_DISPATCH 0
#define ISR_DISPATCH 1
#define BLOCK_DISPATCH 2

TCB tcb_array[MAX_TASKS + 1];
int next_available_tcb = 0;

TCBptr YKList;
TCBptr running_task;
TCBptr old_task;
int YK_running = 0;
int YKCtxSwCount;
int YKIdleCount;
int YKTickNum;
int YK_Depth;
int FirstTime;
int IdleTskStk[IDLE_TASK_SIZE];
int depthMoreOne;	//BOOLEAN FLAG TO CHECK IF DEPTH IS HIGHER THAN 1


void disable_interrupts();
void enable_interrupts();
void save_context();
void restore_context();
//int* getStackPtr();
//int* getInstructionPtr();

void YKInitialize(void)
{

	YKNewTask(YKIdleTask, (void *)&IdleTskStk[IDLE_TASK_SIZE], IDLE_TASK_PRIORITY);
	YKCtxSwCount = 0;
	YKIdleCount = 0;
	YKTickNum = 0;
	YK_Depth = 0;
	FirstTime = 1;
	depthMoreOne = 0;
	//Initialize all that is necessary to be ready for other services:
	//Initialize registers
	//Initialize an array of TCB structs, including space in each one to 				store task's context
	//Create and initialize YKIdleTask with priority zero and add it to the 			TCB array at index zero
	//Initialize the global marker that represents the next available TCB 				index to one
	//Initialize a linked list for the TCBs to be stored in priority order 			with a head and a tail
}

void YKEnterMutex(void) {
	disable_interrupts();
}

void YKExitMutex(void) {
	enable_interrupts();
}

void YKIdleTask(void)
{
	while (1)
	{
		++YKIdleCount;
		--YKIdleCount;
		++YKIdleCount;
		//read disassemble and ensure there are at least four instruction here
	}
}

void YKNewTask(void(*task)(void), void *taskStack, unsigned char priority)
{
	int index = next_available_tcb;
	TCBptr tempHead = YKList;
	tcb_array[index].delay_counter = 0;
	tcb_array[index].id = next_available_tcb;
	tcb_array[index].priority = priority;
	tcb_array[index].task = (void*)task;
	tcb_array[index].pInst = (void*)(task);
	tcb_array[index].pStck = (int*)(taskStack);
	tcb_array[index].state = READY;
	tcb_array[index].firstTime = 1;
	next_available_tcb++;

	if (index == 0) YKList = &(tcb_array[index]);

	while (tempHead != NULL) {
		if (priority < tempHead->priority) {	//LOCATION FOR NEW TASK IS FOUND

			if (YKList == tempHead) {		//SPECIAL CASE TO MODIFY HEAD
				YKList->prev = &(tcb_array[index]);
				tcb_array[index].next = YKList;
				YKList = &(tcb_array[index]);
			}
			else {
				tcb_array[index].next = tempHead;
				tcb_array[index].prev = tempHead->prev;
				tempHead->prev->next = &(tcb_array[index]);
				tempHead->prev = &(tcb_array[index]);
			}
			tempHead = NULL;
			//break;
		}
		else {
			tempHead = tempHead->next;
		}
	}
	if (YK_running) {
		YKScheduler(BLOCK_DISPATCH);
	}

	//MAYBE:EXIT MUTEX
}

void YKRun(void)
{
	if (YKList != &(tcb_array[0])) { //If idle task is not at the head of list (ie there are user-defined tasks)
		YK_running = 1;
		YKScheduler(FIRST_DISPATCH);

	}
	// Tells kernel to begin execution of tasks
	//    -If at least one user-defined task exists,
	//            Cause Scheduler to Run
}

void YKScheduler(int dispatcher_type)        //Determines the highest priority ready taskvoid YKScheduler(void)
{
	TCBptr currentTCB = YKList;

	YKEnterMutex();
	while (currentTCB != NULL) {
		if (currentTCB->state == RUNNING) {
			break;
		}
		else if (currentTCB->state == READY) {
			++YKCtxSwCount;
			YKDispatcher(currentTCB, dispatcher_type);
			break;
		}
		currentTCB = currentTCB->next;
	}
	YKExitMutex();
	//printString("No running tasks! YKIdleTask() should at least be running\n");

	//Determines the highest priority ready task
	//    -If "Current Task" = Highest Priority Ready Task, Return
	//    -Else, Call Dispatcher
	//    MUST be called in ALL Kernel Code which could change the State of ANY Task - Before Returning to Task Code

	//PARAMETER IDEAS: Task Name or ID of Highest Priority Ready Task
}

//extern call_function(int*, int*);
extern void YKDispHandler();
extern void YKFirst();
extern void YKISR();
extern void YKSecond();

void YKDispatcher(TCBptr task, int dispatcher_type)
{
	int bool_return = 0;
	int enable = task->firstTime;

	old_task = running_task;

	if(FirstTime) {		//FIRST TIME
		task->firstTime = 0;
		FirstTime = 0;
		//++YKCtxSwCount;
		running_task = task;
		//bool_return = 2;save_context
	}
	else if (running_task->state == BLOCKED) {
		running_task = task;	//SETS NEW RUNNING TASK
		if (!(task->firstTime)) {
			task->firstTime = 0;
			//++YKCtxSwCount;
			//bool_return = 2;
			//bool_return = 1;
		}
		else {
			task->firstTime = 0;
			task->state = RUNNING;
			//++YKCtxSwCount;
			//bool_return = 3;
		}
	}
	else {	
		task->firstTime = 0;
		//++YKCtxSwCount;
		old_task->state = READY;
		task->state = RUNNING;
		running_task = task;
		//bool_return = 3;
	}

	//if (enable) enable_interrupts();
	
	if (dispatcher_type == BLOCK_DISPATCH) {
		printString("block dispatch\n");
		if(enable){
			YKSecond();
		}
		else{
			YKDispHandler(); 
		}
	}
	else if (dispatcher_type == FIRST_DISPATCH) {
		YKFirst();	
	}
	else {
		YKISR();
	}

	
	
}

void YKDelayTask(unsigned count)
{
	//MAYBE: SAVE CONTEXT
	if (count == 0) return;
	running_task->delay_counter = count;
	running_task->state = BLOCKED;			//BLOCKS DELAYED TASK
	
	//MAYBE: SAVE CONTEXT										//PRINT STRING HERE
	YKScheduler(BLOCK_DISPATCH);
	//MAYBE: RESTORE CONTEXT
	//CALLS SPECIAL SCHEDULER AND SAVES CONTEXT
	//MAYBE: RESTORE CONTEXT AND GO BACK TO FUNCTION
}

void YKEnterISR()
{
	++YK_Depth;
	//if (YK_Depth > 1) depthMoreOne = 1;
}

void YKExitISR()
{
	--YK_Depth;
	if (YK_Depth == 0){ //&& depthMoreOne) {	//ONLY RUN SCHEDULER IF DEPTH WAS EVER BIGGER THAN 1
		depthMoreOne = 0;
		YKScheduler(ISR_DISPATCH);
	}
}

//CALLED BY TICK ISR
//May also call a user tick handler if the user code requires actions to be taken on each clock tick
void YKTickHandler()
{
	TCBptr currentTCB = YKList;
	++YKTickNum;
	while (currentTCB != NULL) {
		if (currentTCB->task == YKIdleTask) return;	//MIGHT NEED TO CHANGE THIS IN THE FUTURE. 
													//BUT IDLE TASK SHOULDN'T HAVE A DELAY RIGHT NOW
		if (currentTCB->delay_counter != 0) {
			--(currentTCB->delay_counter);
			if (currentTCB->delay_counter == 0) {
				currentTCB->state = READY;
				printString("Set to ready\n");
			}
		}
		currentTCB = currentTCB->next;
	}
}
