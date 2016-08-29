#include "mdlLogger.h"

void mdlLogger_info(char* text) {
    mdlDialog_dmsgsPrint(text);
    mdlLogger_append(text);
    return;
}

void mdlLogger_err(char* text) {
    mdlLogger_info(text);
    mdlLogger_appendExt(text, "err");
    return;
}

void mdlLogger_output(char* msg) {
    mdlOutput_command(msg);
    return;
}

void mdlLogger_append(char* line) {
    mdlLogger_appendExt(line, "log");
}

void mdlLogger_appendExt(char* line, char* ext) {
    FILE* file;
    char logname[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    char ext2[MAXEXTENSIONLENGTH];

    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, ext2);
    mdlFile_buildName(logname, dev, dir, name, ext);

    if ((file = mdlTextFile_open(logname, TEXTFILE_APPEND)) != NULL) {
        mdlTextFile_putString(line, file, TEXTFILE_DEFAULT); //TEXTFILE_NO_NEWLINE
        mdlTextFile_close(file);
    }
}

void mdlLogger_print(char* line) {
    mdlLogger_printExt(line, "log");
}

void mdlLogger_printExt(char* line, char* ext) {
    FILE* file;
    char logname[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    char ext2[MAXEXTENSIONLENGTH];

    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, ext2);
    mdlFile_buildName(logname, dev, dir, name, ext);

    if ((file = mdlTextFile_open(logname, TEXTFILE_WRITE)) != NULL) {
        mdlTextFile_putString(line, file, TEXTFILE_DEFAULT); //TEXTFILE_NO_NEWLINE
        mdlTextFile_close(file);
    }
}

int mdlLogger_selectFile(char* workFileP, char* titleP, char* extP) {
    int actionCanceled;
    actionCanceled = mdlDialog_fileOpen(workFileP, /* returned file name*/
            0L, /* dlogbox rsc file handle */
            0L, /* dlogbox resource */
            NULL, /* suggested file name P*/
            extP, /* File Filter P*/
            NULL, /* Default Dir P*/
            titleP); /* Dialog Title */
    return actionCanceled == FALSE;
}

int mdlLogger_alert(char* msg) {
    if (ACTIONBUTTON_OK == mdlDialog_openAlert(msg)) return TRUE;
    else return FALSE;
}
