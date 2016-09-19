#include "app.h"

char _appPath[MAXFILELENGTH];
char _appDir[MAXDIRLENGTH];
char _appName[MAXNAMELENGTH];
char _iniPath[MAXFILELENGTH];
char _configPath[MAXFILELENGTH];
char _devName[MAXNAMELENGTH];
char _photoSubdir[MAXFILELENGTH];
char _photoExt[MAXFILELENGTH];
int _refStartLevel = 7;
int _refEndLevel = 47;
int _arrowLevel = 7;
int _arrowFont = 1;
int _arrowColor = 0;
int _arrowStyle = 0;
int _arrowWeight = 1;
double _arrowTextSize = 2.0;
double _arrowMaxLength = 20.0;

void app_setPath(char* appPath) {
    char ext[MAXEXTENSIONLENGTH];
    strcpy(_appPath, appPath);
    mdlFile_parseName(_appPath, _devName, _appDir, _appName, ext);
    mdlFile_buildName(_iniPath, _devName, _appDir, _appName, "ini");
    mdlFile_buildName(_configPath, _devName, _appDir, _appName, "config");
    mdlFile_buildName(_appDir, _devName, _appDir, NULL, NULL);
}

int mdlApp_getExtPath(char* extPath, char* extP) {
    mdlFile_buildName(extPath, NULL, _appDir, _appName, extP);
    return TRUE;
}

int mdlApp_getIniPath(char* iniPath) {
    if (iniPath != NULL) {
        strcpy(iniPath, _iniPath);
        return TRUE;
    }
    return FALSE;
}

int mdlApp_getFileAndMdl(char* fileName, char* mdlDir) {
    ModelNumber modelRef;
    StatusInt status;
    char fileNameLocal[MAXFILELENGTH];
    char* var = NULL;
    modelRef = MASTERFILE;
#if MSVERSION >= 0x790
    if (SUCCESS == (status = mdlModelRef_getFileName(modelRef, fileName, sizeof fileNameLocal))) {
        if (NULL != (var = mdlSystem_expandCfgVar("$(MSDIR)mdlapps\\"))) {
            strcpy(mdlDir, var);
            free(var);
        }
    }
#endif
    return TRUE;
}
