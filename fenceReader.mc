#include "fenceReader.h"

void fenceReader_init(LpFenceReader this) {
    if (this == NULL) return;
    this->startPoints = NULL;
    this->startPointsCount = 0;
    this->endPoints = NULL;
    this->endPointsCount = 0;
}

void fenceReader_free(LpFenceReader this) {
    if (this == NULL) return;
    if (this->startPoints != NULL) free(this->startPoints);
    this->startPointsSize = 0;
    this->startPointsCount = 0;
    if (this->endPoints != NULL) free(this->endPoints);
    this->endPointsSize = 0;
    this->endPointsCount = 0;
}

void fenceReader_summary(LpFenceReader this) {
    char _msg[256];
    if (this == NULL) return;
    sprintf(_msg, "start points: %d count, %d size", this->startPointsCount, this->startPointsSize);
    mdlLogger_info(_msg);
    sprintf(_msg, "end points: %d count, %d size", this->endPointsCount, this->endPointsSize);
    mdlLogger_info(_msg);
}

void fenceReader_allocStartPoints(LpFenceReader this, int n) {
    this->startPoints = (PhotoPoint*) calloc(n, sizeof (PhotoPoint));
    if (this->startPoints == NULL) {
        mdlLogger_err("allocStartPoints: no memory");
        return;
    }
    this->startPointsSize = n;
}

void fenceReader_allocEndPoints(LpFenceReader this, int n) {
    this->endPoints = (PhotoPoint*) calloc(n, sizeof (PhotoPoint));
    if (this->endPoints == NULL) {
        mdlLogger_err("allocEndPoints: no memory");
        return;
    }
    this->endPointsSize = n;
}

int fenceReader_addStartPoint(LpFenceReader this, char* name, DPoint3d* point) {
    int index = this->startPointsCount;
    PhotoPoint* photoP = &this->startPoints[index];
    if (index >= this->startPointsSize) {
        mdlLogger_err("addStartPoint: no room");
        return FALSE;
    }
    strcpy(photoP->name, name);
    photoP->point = *point;
    this->startPointsCount++;
    return TRUE;
}

int fenceReader_addEndPoint(LpFenceReader this, char* name, DPoint3d* point) {
    int index = this->endPointsCount;
    PhotoPoint* photoP = &this->endPoints[index];
    if (index >= this->endPointsSize) {
        mdlLogger_err("addStartPoint: no room");
        return FALSE;
    }
    strcpy(photoP->name, name);
    photoP->point = *point;
    this->endPointsCount++;
    return TRUE;
}

int fenceReader_load(LpFenceReader this, LpFence fenceP) {
    int i = 0;
    if (NULL == this) return FALSE;
    if (NULL == fenceP) return FALSE;
    mdlLogger_printExt("#", "startPoints");
    mdlLogger_printExt("#", "endPoints");

    fenceReader_allocStartPoints(this, fenceP->nSelected);
    fenceReader_allocEndPoints(this, fenceP->nSelected);
    fenceReader_summary(this);
    //Process selected ref elements
    for (i = 0; i < fenceP->nSelected; i++) {
        MSElementDescr* edP = NULL;
        ModelNumber fileNum = fenceP->modelNumbers[i];
        ULong filePos = fenceP->filePositions[i];
        int isRef = fileNum != MASTERFILE;
        int type;
        UInt32 level;
        char text[256];
        DPoint3d point;
        if (isRef == FALSE) continue; //skip reading master elements
        if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL)) continue; //skip unreadable element
        element_readAttributes(edP, fileNum, &type, &level, NULL, NULL, NULL);
        mdlSelect_removeElement(filePos, fileNum, TRUE);
        if (!element_isText(type)) continue; //skip elements other than texts
        if (!mdlText_readText(edP, text, &point)) continue;
        if (level == 60) { //second point of the photo
            //add point to list
            char pointString[256];
            //mdlLogger_appendExt(text, "endPoints");
            sprintf(pointString, "%.2f %.2f", point.x, point.y);
            //mdlLogger_appendExt(pointString, "endPoints");
            fenceReader_addEndPoint(this, text, &point);
        }
        if (level == 61) { //first point of the photo
            //add point to list
            char pointString[256];
            //mdlLogger_appendExt(text, "startPoints");
            sprintf(pointString, "%.2f %.2f", point.x, point.y);
            //mdlLogger_appendExt(pointString, "startPoints");
            fenceReader_addStartPoint(this, text, &point);
        }
        mdlElmdscr_freeAll(&edP);
    }
    fenceReader_summary(this);
    fenceReader_sort(this);
    return TRUE;
}

void fenceReader_sort(LpFenceReader this) {
    //void mdlUtil_quickSort(void* pFirst, int numEntries, int elementSize, MdlFunctionP compareFunc)
    mdlUtil_quickSort(this->startPoints, this->startPointsCount, sizeof (PhotoPoint), fenceReader_comparePhotoPoints);
    mdlUtil_quickSort(this->endPoints, this->endPointsCount, sizeof (PhotoPoint), fenceReader_comparePhotoPoints);
}

int fenceReader_comparePhotoPoints(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}
