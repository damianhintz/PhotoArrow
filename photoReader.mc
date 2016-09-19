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
    sprintf(msg, "photoReader: %d files (%s)", thisP->filesCount, _photoExt);
    mdlLogger_info(msg);
}

int photoReader_findPhotos(LpPhotoReader thisP, char* subdir, char* extPhoto) {
    char photosDirectory[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    char ext[MAXEXTENSIONLENGTH];

    if (thisP == NULL) return FALSE;
    if (subdir == NULL) return FALSE;
    if (extPhoto == NULL) return FALSE;

    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, ext);
    sprintf(ext, "\\%s", extPhoto);
    mdlFile_buildName(photosDirectory, dev, dir, subdir, ext);

    //int mdlFile_findFiles(FindFileInfo** out, int* nFiles, char const* spec, int attributeFilter);
    if (SUCCESS != mdlFile_findFiles(&thisP->files, &thisP->filesCount, photosDirectory, FF_NORMAL)) {
        mdlLogger_err("photoReader: findPhotos failed (*.jpg)");
        mdlLogger_err(photosDirectory);
        return FALSE;
    }
    mdlLogger_info(photosDirectory);
    return thisP->filesCount;
}

int photoReader_parsePhotoName(LpPhotoReader thisP, int photoIndex, char* photoName) {
    FindFileInfo* fileP = NULL;
    char* fileName = NULL;
    int nameLength;
    int firstDash = 0; //Find first dash -
    int secondDash = 0; //Find second dash -
    int startPhoto = 0, endPhoto = 0, index = 0;
    if (thisP == NULL) return FALSE;
    if (photoIndex < 0) return FALSE; //Index is too small
    if (photoIndex >= thisP->filesCount) return FALSE; //Index is too big
    if (photoName == NULL) return FALSE;
    fileP = &thisP->files[photoIndex];
    fileName = fileP->name;
    nameLength = strlen(fileName);
    //000000000 - 0000-000 - *.jpg
    //find first dash
    for (index = 0; index < nameLength; index++) {
        char c = fileName[index];
        if (c == '-') {
            firstDash = index;
            break; //we found first dash
        }
    }
    secondDash = firstDash;
    //find second dash
    for (index = firstDash + 1; index < nameLength; index++) {
        char c = fileName[index];
        if (c == '-') {
            secondDash = index;
            break; //we found second dash
        }
    }
    //search for right number
    endPhoto = secondDash;
    for (index = secondDash + 1; index < nameLength; index++) {
        char c = fileName[index];
        if (!isalnum(c)) {
            break;
        }
        endPhoto = index; //update end index
    }
    //search for left number
    startPhoto = secondDash;
    for (index = secondDash - 1; index >= 0; index--) {
        char c = fileName[index];
        if (!isalnum(c)) {
            break;
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
