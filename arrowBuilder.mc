#include "arrowBuilder.h"

void arrowBuilder_init(LpArrowBuilder thisP, LpFenceReader reader) {
    if (thisP == NULL) return;
    if (reader == NULL) return;
    thisP->arrows = (PhotoArrow*) calloc(MAX_ARROWS, sizeof (PhotoArrow));
    thisP->arrowsCount = 0;
}

void arrowBuilder_free(LpArrowBuilder this) {
    free(this->arrows);
}

void arrowBuilder_summary(LpArrowBuilder this) {
    char msg[256];
    sprintf(msg, "arrows: %d count", this->arrowsCount);
    mdlLogger_info(msg);
}

void arrowBuilder_addArrow(LpArrowBuilder this, LpPhotoPoint startPoint, LpPhotoPoint endPoint) {
    int index = this->arrowsCount;
    PhotoArrow* arrowP = &this->arrows[index];
    if (index >= MAX_ARROWS) return; //no room
    if (strcmp(startPoint->name, endPoint->name) != 0) return; //
    strncpy(arrowP->name, startPoint->name, sizeof (arrowP->name));
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
    char msg[256];
    FILE* file;
    char fileName[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    //char ext[MAXEXTENSIONLENGTH];
    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, NULL);
    mdlFile_buildName(fileName, dev, dir, name, "arrows");
    
    file = mdlTextFile_open(fileName, TEXTFILE_WRITE);
    if (file == NULL) return;
    
    //MSElement* lineP = NULL, *textP = NULL;
    for (i = 0; i < this->arrowsCount; i++) {
        //save arrow as line string (scale it to 80%)
        PhotoArrow* arrowP = &this->arrows[i];
        sprintf(msg, "%.2f %.2f %.2f %.2f %s",
                arrowP->startPoint.x, arrowP->startPoint.y,
                arrowP->endPoint.x, arrowP->endPoint.y,
                arrowP->name);
        //mdlLogger_info(msg);
        mdlTextFile_putString(msg, file, TEXTFILE_DEFAULT); //TEXTFILE_NO_NEWLINE
        //DPoint3d points[2];
        //points[0] = arrowP->startPoint;
        //points[1] = arrowP->endPoint;
        //if (SUCCESS != mdlLine_create(lineP, NULL, points)) continue;
        //mdlElement_add(lineP);
        //if (arrowBuilder_createTextAtTheEndOfVector(textP, arrowP->name, &arrowP->startPoint, &arrowP->endPoint)) {
        //    mdlElement_add(textP);
        //} else {
        //    mdlLogger_info("arrowBuilder: error");
        //}
    }
    mdlTextFile_close(file);
    mdlLogger_info("arrows added to file");
    
    //int mdlLine_create(MSElement* pElementOut, MSElement* pElementIn, DPoint3d* points);
    //int mdlLineString_create(MSElement* out, MSElement* in, DPoint3d* points, int numVerts);
}

int arrowBuilder_createTextAtTheEndOfVector(MSElement* textP, char* text, DPoint3d* startPoint, DPoint3d* endPoint) {
    ULong font = 1;
    double height = 2.0;
    double rotation = angle(startPoint, endPoint);
    int just = TXTJUST_LB;
    RotMatrix rotMatrix;
    TextParam param;
    TextSizeParam size;

    param.font = font;
    param.just = just;

    size.mode = TXT_BY_TILE_SIZE;
    size.size.height = mdlCnv_masterUnitsToUors(height);
    size.size.width = mdlCnv_masterUnitsToUors(height);
    size.aspectRatio = 1;

    mdlRMatrix_fromAngle(&rotMatrix, rotation);
    //mdlRMatrix_fromAngle(&rotMatrix, ((rotation * 3.14159265) / 180.0));

    if (strlen(text) == 0) return FALSE;
    if (SUCCESS != mdlText_create(textP, NULL, text, endPoint, &size, &rotMatrix, &param, NULL)) {
        return FALSE;
    }
    return TRUE;
}

// Returns the angle of the vector from p0 to p1, relative to the positive X-axis.
// The angle is normalized to be in the range [ -Pi, Pi ].
// <param name="p0">The start-point</param>
// <param name="p1">The end-point</param>
// Returns the normalized angle (in radians) that p0-p1 makes with the positive X-axis.

double angle(DPoint3d* p0, DPoint3d* p1) {
    double dx = p1->x - p0->x;
    double dy = p1->y - p0->y;
    return atan2(dy, dx);
}
