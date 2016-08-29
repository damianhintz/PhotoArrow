#if !defined (H_MDL_LOGGER)
#define H_MDL_LOGGER
#include <tcb.h>
#include <mdl.h>
#include <mswindow.fdf>
#include <msdialog.fdf>
#include <mssystem.fdf>
#include <mselemen.fdf>
#include <msoutput.fdf>
#include <mslocate.fdf>
#include <string.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mslinkge.fdf>
#include <msparse.fdf>
#include <msrsrc.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include "def-v8.h"
#define C_MAX_ROW_LENGTH 4096

void mdlLogger_info(char* text);
void mdlLogger_err(char* text);
void mdlLogger_output(char* msg);

void mdlLogger_append(char* line);
void mdlLogger_appendExt(char* line, char* ext);
void mdlLogger_print(char* line);
void mdlLogger_printExt(char* line, char* ext);

int mdlLogger_selectFile(char* workFileP, char* titleP, char* extP);
int mdlLogger_alert(char* msg);

#endif
