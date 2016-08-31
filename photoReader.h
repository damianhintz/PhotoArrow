/* 
 * File:   photoReader.h
 * Author: DHintz
 *
 * Created on 29 sierpnia 2016, 10:24
 */

#ifndef PHOTOREADER_H
#define PHOTOREADER_H
#include "app.h"
#include "core.h"

typedef struct _photoReader {
    FindFileInfo* files;
    int filesCount;
} PhotoReader, *LpPhotoReader;

void photoReader_init(LpPhotoReader thisP);
void photoReader_free(LpPhotoReader thisP);
void photoReader_summary(LpPhotoReader thisP);

int photoReader_findPhotos(LpPhotoReader thisP, char* subdir, char* extPhoto);
int photoReader_parsePhotoName(LpPhotoReader thisP, int photoIndex, char* photoName);

#endif /* PHOTOREADER_H */

