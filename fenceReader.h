/* 
 * File:   fenceReader.h
 * Author: DHintz
 *
 * Created on 25 sierpnia 2016, 11:06
 */
#include "fence.h"

#ifndef FENCEREADER_H
#define FENCEREADER_H

typedef struct _photoPoint {
    char name[256];
    DPoint3d point;
    int state; //free, used
} PhotoPoint, *LpPhotoPoint;

typedef struct _fenceReader {
    PhotoPoint* startPoints;
    int startPointsCount;
    int startPointsSize;
    PhotoPoint* endPoints;
    int endPointsCount;
    int endPointsSize;
    //PhotoArrow* arrows;
    //int arrowsCount;
} FenceReader, *LpFenceReader;

void fenceReader_init(LpFenceReader this);
void fenceReader_free(LpFenceReader this);
int fenceReader_load(LpFenceReader this, LpFence fenceP);
int fenceReader_addStartPoint(LpFenceReader this, char* name, DPoint3d* point);
int fenceReader_addEndPoint(LpFenceReader this, char* name, DPoint3d* point);
int fenceReader_comparePhotoPoints(LpPhotoPoint p1, LpPhotoPoint p2);

#endif /* FENCEREADER_H */
