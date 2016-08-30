/* 
 * File:   arrowBuilder.h
 * Author: DHintz
 *
 * Created on 25 sierpnia 2016, 12:40
 */

#ifndef ARROWBUILDER_H
#define ARROWBUILDER_H
#include "app.h"
#include "fenceReader.h"

typedef struct _photoArrow {
    char name[MAX_PHOTO_NAME];
    DPoint3d startPoint;
    DPoint3d endPoint;
} PhotoArrow, *LpPhotoArrow;

typedef struct _arrowBuilder {
    PhotoArrow* arrows;
    int arrowsCount;
    int maxArrows;
    int allCount;
    int missingArrows;
    int missingPhotos;
} ArrowBuilder, *LpArrowBuilder;

void arrowBuilder_init(LpArrowBuilder thisP, LpFenceReader readerP);
void arrowBuilder_free(LpArrowBuilder thisP);
void arrowBuilder_summary(LpArrowBuilder thisP);
void arrowBuilder_createArrows(LpArrowBuilder thisP, LpPhotoReader photosP, LpFenceReader readerP);
void arrowBuilder_addArrow(LpArrowBuilder thisP, char* photoName, DPoint3d* startPoint, DPoint3d* endPoint);
void arrowWriter_saveAll(LpArrowBuilder thisP);
int arrowBuilder_createArrowFromVector(MSElement* lineP, PhotoArrow* arrowP);
int arrowBuilder_createTextAtTheEndOfVector(MSElement* textP, PhotoArrow* arrowP);
int arrowBuilder_createReverseTextAtTheEndOfVector(MSElement* textP, PhotoArrow* arrowP);
double angle(DPoint3d* p0, DPoint3d* p1);

#endif /* ARROWBUILDER_H */

