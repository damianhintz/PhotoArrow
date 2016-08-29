#if !defined (H_MDL_APP)
#define H_MDL_APP
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mssystem.fdf>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <mselemen.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <mswindow.fdf>
#include <msdialog.fdf>
#include <mssystem.fdf>
#include <mstypes.h>
#include <stdio.h>
#include <stdlib.h>
#include "def-v8.h"

extern char g_appPath[MAXFILELENGTH];
extern char g_appDir[MAXDIRLENGTH];
extern char g_appName[MAXNAMELENGTH];
extern char g_iniPath[MAXFILELENGTH];

int mdlApp_setNumber ();
int mdlApp_getFileAndMdl (char* fileName, char* mdlDir);
int mdlApp_setPath    (char* appPath);
int mdlApp_getIniPath (char* iniPath);
int mdlApp_getExtPath (char* extPath, char* extP);

void mdlApp_setOpis  (DialogBox* dbP, char* opis);
void mdlApp_setOpis2 (DialogBox* dbP, char* opis, int id);
void mdlApp_setTitle (DialogBox* dbP);

#endif
