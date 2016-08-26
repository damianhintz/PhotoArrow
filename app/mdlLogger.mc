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

int photoReader_findPhotos() {
    char photosDirectory[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    char ext[MAXEXTENSIONLENGTH];
    FindFileInfo* files = NULL;
    int countFiles = 0, index = 0;
    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, ext);
    mdlFile_buildName(photosDirectory, dev, dir, "DOKUMENTACJA_FOTOGRAFICZNA", "\\*.jpg");
    mdlLogger_info(photosDirectory);
    //int mdlFile_findFiles(FindFileInfo** out, int* nFiles, char const* spec, int attributeFilter);
    if (SUCCESS != mdlFile_findFiles(&files, &countFiles, photosDirectory, FF_NORMAL)) {
        mdlLogger_info("findPhotos: failed with error code");
        return 0;
    }
    for (index = 0; index < countFiles; index++) {
        FindFileInfo* fileP = &files[index];
        char* fileName = fileP->name;
        char photoName[64];
        photoReader_parsePhotoName(fileName, photoName);
        //mdlLogger_info(fileName);
        //000000000 - 0000-000 - *.jpg
        //mdlLogger_info(photoName);
    }
    free(files);
    return countFiles;
}

int photoReader_parsePhotoName(char* fileName, char* photoName) {
    int firstDash = 0; //Find first dash -
    int secondDash = 0; //Find second dash -
    int startPhoto = 0, endPhoto = 0;
    int index = 0, nameLength = strlen(fileName);
    //000000000 - 0000-000 - *.jpg
    for (index = 0; index < nameLength; index++) {
        char c = fileName[index];
        if (c == '-') {
            firstDash = index;
            break; //we found first dash
        }
    }
    secondDash = firstDash;
    for (index = firstDash + 1; index < nameLength; index++) {
        char c = fileName[index];
        if (c == '-') {
            secondDash = index;
            break; //we found second dash
        }
    }
    //search for right number
    for (index = secondDash + 1; index < nameLength; index++) {
        char c = fileName[index];
        if (c < '0' || c > '9') {
            break; //this is the end of digits
        }
        endPhoto = index; //update end index
    }
    //search for left number
    for (index = secondDash - 1; index >= 0; index--) {
        char c = fileName[index];
        if (c < '0' || c > '9') {
            break; //this is the end of digits
        }
        startPhoto = index; //update start index
    }
    for (index = startPhoto; index <= endPhoto; index++) {
        int i = index - startPhoto;
        photoName[i] = fileName[index];
    }
    photoName[index - startPhoto] = '\0';
    return strlen(photoName);
}
