#if !defined (H_MDL_UTIL)
#define H_MDL_UTIL
#include <msdialog.fdf>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <msoutput.fdf>

#define C_MAX_LEN_MSG 512
#define N_MDL_UTIL 128

char* mdlUtil_trimRight(char* p, char c);
void mdlUtil_readDouble(char* wiersz, double* value);
void mdlUtil_readInt(char* wiersz, int* value);
void mdlUtil_readString(char* wiersz, char* value);

#endif
