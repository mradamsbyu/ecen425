#ifndef yakk
#define yakk

#include <stdint.h>

#define NULL 0
#define IDLE_TASK_SIZE 256
#define IDLE_TASK_PRIORITY 100
#define MAX_TASKS 1


extern int YK_running;
extern int YKCtxSwCount;
extern int YKIdleCount;
extern int YKTickNum;
extern int YK_Depth;
extern int FirstTime;

enum State {
	BLOCKED,
	READY,
	RUNNING,
};

//typedef void func(void);
struct taskblock;
typedef struct taskblock* TCBptr;
typedef struct taskblock
{
	int* pStck; 			//0
	void(*pInst);			//2
	int id;					//4	
	int priority;			//6
	enum State    state;
	char		context;
	int	delay_counter;
	TCBptr	prev; //points to next higher priority task
	TCBptr next; //Points to next lower priority task
	//CONTEXT
	void(*task)(void);	//Beginning of Function
	int firstTime;
} TCB;



extern TCB tcb_array[MAX_TASKS + 1];
extern int next_available_tcb;

extern TCBptr YKList;
extern TCBptr running_task;
extern TCBptr old_task;

extern void YKDispHandler();

void YKInitialize(void);       // Initializes all required kernel data structures
void YKEnterMutex(void);       //Disables interrupts
void YKExitMutex(void);        //Enables interrupts
void YKIdleTask(void);         //Kernel's idle task
void YKNewTask(void(*task)(void), void *taskStack, unsigned char priority);  //Creates a new task
void YKRun(void);              //Starts actual execution of user code
void YKScheduler(int dispatcher_type);         //Determines the highest priority ready task
void YKDispatcher(TCBptr task, int save_context);       //Begins or resumes execution of the next task
void YKDelayTask(unsigned count);
void YKEnterISR(void);
void YKExitISR(void);
void YKTickHandler(void);


#endif
