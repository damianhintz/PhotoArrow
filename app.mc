#include "app.h"

char _appPath[MAXFILELENGTH];
char _appDir[MAXDIRLENGTH];
char _appName[MAXNAMELENGTH];
char _iniPath[MAXFILELENGTH];
char _devName[MAXNAMELENGTH];
int _refStartLevel = 7;
int _refEndLevel = 47;

/* mdlApp_setNumber */
int mdlApp_setNumber() {
    VersionNumber versionNumber;

    //versionNumber.release = C_ID_RELEASE;
    //versionNumber.major = C_ID_MAJOR;
    //versionNumber.minor = C_ID_MINOR;
    //versionNumber.subMinor = C_ID_SUBMINOR;

#if MSVERSION >= 0x790
    mdlSystem_setMdlAppVersionNumber(NULL, &versionNumber);
#endif

    return TRUE;
}

/* mdlApp_getFileAndMdl */
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

int mdlApp_setPath(char* appPath) {
    char ext[MAXEXTENSIONLENGTH];

    strcpy(_appPath, appPath);

    mdlFile_parseName(_appPath, _devName, _appDir, _appName, ext);
    mdlFile_buildName(_iniPath, _devName, _appDir, _appName, "ini");
    mdlFile_buildName(_appDir, _devName, _appDir, NULL, NULL);

    return TRUE;
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

/* mdlApp_setOpis */
void mdlApp_setOpis(DialogBox* dbP, char* opis) {
    char msg[128];

    sprintf(msg, "%s - %s", C_ID_APPTITLE, opis);
    mdlWindow_titleSet(dbP, msg);
}

void mdlApp_setOpis2(DialogBox* dbP, char* opis, int id) {
    char msg[128];

    sprintf(msg, "%s - %s (%ld)", C_ID_APPTITLE, opis, id);
    mdlWindow_titleSet(dbP, msg);
}

/* mdlApp_setTitle */
void mdlApp_setTitle(DialogBox* dbP) {
    char msg[128];
    ModelNumber modelRef;
    BoolInt is3D = FALSE;

    modelRef = MASTERFILE;

#if MSVERSION >= 0x790 
    is3D = mdlModelRef_is3D(modelRef);
#endif

    sprintf(msg, "(%dD)", is3D ? 3 : 2);
    mdlApp_setOpis(dbP, msg);
}
