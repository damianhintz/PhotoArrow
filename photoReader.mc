#include "photoReader.h"

void photoReader_init(LpPhotoReader thisP) {
    thisP->files = NULL;
    thisP->filesCount = 0;
}

void photoReader_free(LpPhotoReader thisP) {
    if (thisP->files != NULL) free(thisP->files);
}

void photoReader_summary(LpPhotoReader thisP) {
    char msg[256];
    int index = 0;
    for (index = 0; index < thisP->filesCount; index++) {
        //char photoName[64];
        //photoReader_parsePhotoName(thisP, index, photoName);
        //mdlLogger_info(photoName);
    }
    sprintf(msg, "photoReader: %d files (*.jpg)", thisP->filesCount);
    mdlLogger_info(msg);
}

int photoReader_findPhotos(LpPhotoReader thisP, char* subdir) {
    char photosDirectory[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    char ext[MAXEXTENSIONLENGTH];

    if (thisP == NULL) return FALSE;
    if (subdir == NULL) return FALSE;

    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, ext);
    mdlFile_buildName(photosDirectory, dev, dir, subdir, "\\*.jpg");

    //int mdlFile_findFiles(FindFileInfo** out, int* nFiles, char const* spec, int attributeFilter);
    if (SUCCESS != mdlFile_findFiles(&thisP->files, &thisP->filesCount, photosDirectory, FF_NORMAL)) {
        mdlLogger_err("photoReader: findPhotos failed (*.jpg)");
        mdlLogger_err(photosDirectory);
        return FALSE;
    }
    mdlLogger_info(photosDirectory);
    return thisP->filesCount;
}

// mdlLogger_info(fileName);
// 000000000 - 0000-000 - *.jpg

int photoReader_parsePhotoName(LpPhotoReader thisP, int photoIndex, char* photoName) {
    FindFileInfo* fileP = NULL;
    char* fileName = NULL;
    int nameLength;
    int firstDash = 0; //Find first dash -
    int secondDash = 0; //Find second dash -
    int startPhoto = 0, endPhoto = 0, index = 0;
    if (photoIndex >= thisP->filesCount) return FALSE;
    if (photoName == NULL) return FALSE;
    fileP = &thisP->files[photoIndex];
    fileName = fileP->name;
    nameLength = strlen(fileName);
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
    //copy name
    for (index = startPhoto; index <= endPhoto; index++) {
        int i = index - startPhoto;
        if (i >= MAX_PHOTO_NAME) {
            photoName[MAX_PHOTO_NAME - 1] = '\0';
            return FALSE;
        }
        photoName[i] = fileName[index];
    }
    photoName[index - startPhoto] = '\0'; //end of name mark
    return strlen(photoName);
}
