#if !defined (H_APP)
#define H_APP
#include <math.h>
#include <rscdefs.h>
#include <cmdclass.h>
#include <dlogbox.h>
#include <dlogids.h>
#include <keys.h>
#include <msdialog.fdf>
#include <mswindow.fdf>
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
#include "app\mdlUtil.h"
#include "app\mdlLogger.h"
#include "app\appView.h"
#include "ui.h"

extern char _appPath[MAXFILELENGTH];
extern char _appDir[MAXDIRLENGTH];
extern char _appName[MAXNAMELENGTH];
extern char _iniPath[MAXFILELENGTH];
extern char _configPath[MAXFILELENGTH];
extern char _photoSubdir[MAXFILELENGTH];
extern char _photoExt[MAXFILELENGTH];
extern int _refStartLevel;
extern int _refEndLevel;
extern int _arrowLevel;
extern int _arrowFont;
extern int _arrowColor;
extern int _arrowStyle;
extern int _arrowWeight;
extern double _arrowTextSize;
extern double _arrowMaxLength;

int app_loadGui();
int app_loadCui();
void app_setPath(char* appPath);
int mdlApp_getIniPath(char* iniPath);
int mdlApp_getExtPath(char* extPath, char* extP);
int mdlApp_getFileAndMdl(char* fileName, char* mdlDir);

#endif