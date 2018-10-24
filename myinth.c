#include "clib.h"
extern int KeyBuffer;
static int tick = 0;

void vReset(void)
{
   exit(0);	//Ctrl R
}

void vTick(void)
{
	//AUTOMATICALLY 10k Insts, Can be Changed  with t n command
	printString("\nTICK ");
	printUInt(++tick);
	printString("\n");
}

void vKeyboard(void)
{
	int loop_tick;   
	if((char)KeyBuffer == 'd'){
		printString("\nDELAY KEY PRESSED\n");
		 	loop_tick = 0;
			while(loop_tick < 5000){
				++loop_tick;
			}

		printString("\nDELAY COMPLETE\n");
   }
   else{
		printString("\nKEYPRESS (");
		printChar((char)KeyBuffer);
		printString(") IGNORED\n");
   }
}
