#include "arrowBuilder.h"

void arrowBuilder_init(LpArrowBuilder this, LpFenceReader reader) {
    if (this == NULL) return;
    if (reader == NULL) return;
    this->arrowsSize = reader->startPointsCount > reader->endPointsCount ?
            reader->startPointsCount : reader->endPointsCount;
    this->arrows = (PhotoArrow*) calloc(this->arrowsSize, sizeof (PhotoArrow));
    this->arrowsCount = 0;
}

void arrowBuilder_free(LpArrowBuilder this) {
    free(this->arrows);
}

void arrowBuilder_summary(LpArrowBuilder this) {
    char msg[256];
    sprintf(msg, "arrows: %d count, %d size", this->arrowsCount, this->arrowsSize);
    mdlLogger_info(msg);
}

void arrowBuilder_addArrow(LpArrowBuilder this, LpPhotoPoint startPoint, LpPhotoPoint endPoint) {
    int index = this->arrowsCount;
    PhotoArrow* arrowP = &this->arrows[index];
    if (index >= this->arrowsSize) return; //no room
    if (strcmp(startPoint->name, endPoint->name) != 0) return; //
    strcpy(arrowP->name, startPoint->name);
    arrowP->startPoint = startPoint->point;
    arrowP->endPoint = endPoint->point;
    this->arrowsCount++;
}

void arrowBuilder_load(LpArrowBuilder this, LpFenceReader reader) {
    int i = 0;
    for (i = 0; i < reader->startPointsCount; i++) {
        PhotoPoint* startPointP = &reader->startPoints[i];
        PhotoPoint* endPointP = arrowBuilder_binarySearch(startPointP, reader->endPoints, reader->endPointsCount);
        if (endPointP == NULL) {
            mdlLogger_err(startPointP->name);
            continue; //no end point
        }
        //build arrow from points
        arrowBuilder_addArrow(this, startPointP, endPointP);
    }
}

PhotoPoint* arrowBuilder_binarySearch(PhotoPoint* key, PhotoPoint* points, long count) {
    //void* bsearch (void *key, void *base, size_t members, size_t sizeMember, int (*compareFunc)(void *, void *))
    PhotoPoint* result = bsearch(key, points, count, sizeof (PhotoPoint), arrowBuilder_comparePhotoPoints);
    return result;
}

int arrowBuilder_comparePhotoPoints(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}

void arrowWriter_saveAll(LpArrowBuilder this) {
    int i;
    for (i = 0; i < this->arrowsCount; i++) {
        //save arrow as line string (scale it to 80%)
        PhotoArrow* arrowP = &this->arrows[i];
        MSElement* lineP, *textP;
        ULong font = 3;
        double height = 0.50;
        double rotation = 45.0;
        DPoint3d points[2];
        points[0] = arrowP->startPoint;
        points[1] = arrowP->endPoint;
        if (SUCCESS != mdlLine_create(lineP, NULL, points)) continue;
        mdlElement_add(lineP);
        //add photo name
        if (!mdlText_createFromPoint(textP, &points[1], arrowP->name, font, height, rotation)) continue;
        mdlElement_add(textP);
    }
    mdlLogger_info("arrows added to file");
    //int mdlLine_create(MSElement* pElementOut, MSElement* pElementIn, DPoint3d* points);
    //int mdlLineString_create(MSElement* out, MSElement* in, DPoint3d* points, int numVerts);
}