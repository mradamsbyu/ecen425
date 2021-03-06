# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"
# 1 "yakk.h" 1



# 1 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 1 3 4
# 9 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 3 4
# 1 "/usr/include/stdint.h" 1 3 4
# 25 "/usr/include/stdint.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 375 "/usr/include/features.h" 3 4
# 1 "/usr/include/sys/cdefs.h" 1 3 4
# 392 "/usr/include/sys/cdefs.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 393 "/usr/include/sys/cdefs.h" 2 3 4
# 376 "/usr/include/features.h" 2 3 4
# 399 "/usr/include/features.h" 3 4
# 1 "/usr/include/gnu/stubs.h" 1 3 4
# 10 "/usr/include/gnu/stubs.h" 3 4
# 1 "/usr/include/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/gnu/stubs.h" 2 3 4
# 400 "/usr/include/features.h" 2 3 4
# 26 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/bits/wchar.h" 1 3 4
# 22 "/usr/include/bits/wchar.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 23 "/usr/include/bits/wchar.h" 2 3 4
# 27 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 28 "/usr/include/stdint.h" 2 3 4
# 36 "/usr/include/stdint.h" 3 4
typedef signed char int8_t;
typedef short int int16_t;
typedef int int32_t;

typedef long int int64_t;







typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;

typedef unsigned int uint32_t;



typedef unsigned long int uint64_t;
# 65 "/usr/include/stdint.h" 3 4
typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef int int_least32_t;

typedef long int int_least64_t;






typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;

typedef unsigned long int uint_least64_t;
# 90 "/usr/include/stdint.h" 3 4
typedef signed char int_fast8_t;

typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
# 103 "/usr/include/stdint.h" 3 4
typedef unsigned char uint_fast8_t;

typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
# 119 "/usr/include/stdint.h" 3 4
typedef long int intptr_t;


typedef unsigned long int uintptr_t;
# 134 "/usr/include/stdint.h" 3 4
typedef long int intmax_t;
typedef unsigned long int uintmax_t;
# 10 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 2 3 4
# 5 "yakk.h" 2







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


struct taskblock;
typedef struct taskblock* TCBptr;
typedef struct taskblock
{
 int* pStck;
 void(*pInst);
 int id;
 int priority;
 enum State state;
 char context;
 int delay_counter;
 TCBptr prev;
 TCBptr next;

 void(*task)(void);
 int firstTime;
} TCB;



extern TCB tcb_array[1 + 1];
extern int next_available_tcb;

extern TCBptr YKList;
extern TCBptr running_task;
extern TCBptr old_task;

extern void YKDispHandler();

void YKInitialize(void);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKIdleTask(void);
void YKNewTask(void(*task)(void), void *taskStack, unsigned char priority);
void YKRun(void);
void YKScheduler(int dispatcher_type);
void YKDispatcher(TCBptr task, int save_context);
void YKDelayTask(unsigned count);
void YKEnterISR(void);
void YKExitISR(void);
void YKTickHandler(void);
# 2 "yakc.c" 2
# 1 "yaku.h" 1
# 3 "yakc.c" 2
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 4 "yakc.c" 2





TCB tcb_array[1 + 1];
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
int IdleTskStk[256];
int depthMoreOne;


void disable_interrupts();
void enable_interrupts();
void save_context();
void restore_context();



void YKInitialize(void)
{

 YKNewTask(YKIdleTask, (void *)&IdleTskStk[256], 100);
 YKCtxSwCount = 0;
 YKIdleCount = 0;
 YKTickNum = 0;
 YK_Depth = 0;
 FirstTime = 1;
 depthMoreOne = 0;






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

 while (tempHead != 0) {
  if (priority < tempHead->priority) {

   if (YKList == tempHead) {
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
   tempHead = 0;

  }
  else {
   tempHead = tempHead->next;
  }
 }
 if (YK_running) {
  YKScheduler(2);
 }


}

void YKRun(void)
{
 if (YKList != &(tcb_array[0])) {
  YK_running = 1;
  YKScheduler(0);

 }



}

void YKScheduler(int dispatcher_type)
{
 TCBptr currentTCB = YKList;

 YKEnterMutex();
 while (currentTCB != 0) {
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
# 150 "yakc.c"
}


extern void YKDispHandler();
extern void YKFirst();
extern void YKISR();
extern void YKSecond();

void YKDispatcher(TCBptr task, int dispatcher_type)
{
 int bool_return = 0;
 int enable = task->firstTime;

 old_task = running_task;

 if(FirstTime) {
  task->firstTime = 0;
  FirstTime = 0;

  running_task = task;

 }
 else if (running_task->state == BLOCKED) {
  running_task = task;
  if (!(task->firstTime)) {
   task->firstTime = 0;



  }
  else {
   task->firstTime = 0;
   task->state = RUNNING;


  }
 }
 else {
  task->firstTime = 0;

  old_task->state = READY;
  task->state = RUNNING;
  running_task = task;

 }



 if (dispatcher_type == 2) {
  printString("block dispatch\n");
  if(enable){
   YKSecond();
  }
  else{
   YKDispHandler();
  }
 }
 else if (dispatcher_type == 0) {
  YKFirst();
 }
 else {
  YKISR();
 }



}

void YKDelayTask(unsigned count)
{

 if (count == 0) return;
 running_task->delay_counter = count;
 running_task->state = BLOCKED;


 YKScheduler(2);



}

void YKEnterISR()
{
 ++YK_Depth;

}

void YKExitISR()
{
 --YK_Depth;
 if (YK_Depth == 0){
  depthMoreOne = 0;
  YKScheduler(1);
 }
}



void YKTickHandler()
{
 TCBptr currentTCB = YKList;
 ++YKTickNum;
 while (currentTCB != 0) {
  if (currentTCB->task == YKIdleTask) return;

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
