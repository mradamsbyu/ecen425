# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "myinth.c"
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
# 2 "myinth.c" 2
extern int KeyBuffer;
static int tick = 0;

void vReset(void)
{
   exit(0);
}

void vTick(void)
{

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
