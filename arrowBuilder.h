/* 
 * File:   arrowBuilder.h
 * Author: DHintz
 *
 * Created on 25 sierpnia 2016, 12:40
 */

#ifndef ARROWBUILDER_H
#define ARROWBUILDER_H
#include "fenceReader.h"

typedef struct _photoArrow {
    char name[256];
    DPoint3d startPoint;
    DPoint3d endPoint;
} PhotoArrow, *LpPhotoArrow;

typedef struct _arrowBuilder {
    PhotoArrow* arrows;
    int arrowsCount;
    int arrowsSize;
} ArrowBuilder, *LpArrowBuilder;

void arrowBuilder_init(LpArrowBuilder this, LpFenceReader reader);
void arrowBuilder_free(LpArrowBuilder this);
void arrowBuilder_summary(LpArrowBuilder this);
void arrowBuilder_load(LpArrowBuilder this, LpFenceReader reader);
void arrowBuilder_addArrow(LpArrowBuilder this, LpPhotoPoint startPoint, LpPhotoPoint endPoint);
PhotoPoint* arrowBuilder_binarySearch(PhotoPoint* key, PhotoPoint* points, long count);
int arrowBuilder_comparePhotoPoints(LpPhotoPoint p1, LpPhotoPoint p2);
void arrowWriter_saveAll(LpArrowBuilder this);

#endif /* ARROWBUILDER_H */

