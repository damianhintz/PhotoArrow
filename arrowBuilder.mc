#include "arrowBuilder.h"

void arrowBuilder_init(LpArrowBuilder thisP, LpFenceReader readerP) {
    if (thisP == NULL) return;
    if (readerP == NULL) return;
    thisP->maxArrows = readerP->refCount;
    thisP->arrows = (PhotoArrow*) calloc(readerP->refCount, sizeof (PhotoArrow));
    thisP->arrowsCount = 0;
}

void arrowBuilder_free(LpArrowBuilder thisP) {
    free(thisP->arrows);
}

void arrowBuilder_summary(LpArrowBuilder thisP) {
    char msg[256];
    sprintf(msg, "arrows: %d count", thisP->arrowsCount);
    mdlLogger_info(msg);
}

void arrowBuilder_addArrow(LpArrowBuilder thisP, LpPhotoPoint startPoint, LpPhotoPoint endPoint) {
    int index = thisP->arrowsCount;
    PhotoArrow* arrowP = &thisP->arrows[index];
    if (index >= thisP->maxArrows) return; //no room
    if (strcmp(startPoint->name, endPoint->name) != 0) return; //
    strncpy(arrowP->name, startPoint->name, sizeof (arrowP->name));
    arrowP->startPoint = startPoint->point;
    arrowP->endPoint = endPoint->point;
    thisP->arrowsCount++;
}

void arrowBuilder_load(LpArrowBuilder thisP, LpFenceReader readerP) {
    int i = 0;
    mdlLogger_info("arrowBuilder: building arrows from photos");
    for (i = 0; i < readerP->startPointsCount; i++) {
        PhotoPoint* startPointP = &readerP->startPoints[i];
        PhotoPoint* endPointP = arrowBuilder_binarySearch(startPointP, readerP->endPoints, readerP->endPointsCount);
        if (endPointP == NULL) {
            mdlLogger_err(startPointP->name);
            continue; //no end point
        }
        //build arrow from points
        arrowBuilder_addArrow(thisP, startPointP, endPointP);
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
    mdlLogger_info("arrowWriter: saving arrows to file");
    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, NULL);
    mdlFile_buildName(fileName, dev, dir, name, "arrows");

    file = mdlTextFile_open(fileName, TEXTFILE_WRITE);
    if (file == NULL) return;
    for (i = 0; i < this->arrowsCount; i++) {
        MSElement line, text;
        //save arrow as line string (scale it to 80%)
        PhotoArrow* arrowP = &this->arrows[i];
        sprintf(msg, "%.2f %.2f %.2f %.2f %s",
                arrowP->startPoint.x, arrowP->startPoint.y,
                arrowP->endPoint.x, arrowP->endPoint.y,
                arrowP->name);
        mdlTextFile_putString(msg, file, TEXTFILE_DEFAULT); //TEXTFILE_NO_NEWLINE

        if (arrowBuilder_createArrowFromVector(&line, arrowP)) {
            mdlElement_add(&line);
        }
        if (arrowBuilder_createTextAtTheEndOfVector(&text, arrowP)) {
            mdlElement_add(&text);
        }
    }
    mdlTextFile_close(file);
}

int arrowBuilder_createArrowFromVector(MSElement* lineP, PhotoArrow* arrowP) {
    DPoint3d points[6];
    DPoint3d normal, left, right, middle, first, last;
    mdlVec_computeNormal(&normal, &arrowP->endPoint, &arrowP->startPoint);
    mdlVec_scale(&normal, &normal, mdlCnv_masterUnitsToUors(1));
    first = arrowP->startPoint;
    last = arrowP->endPoint;
    middle.z = 0;
    middle.y = last.y - normal.y * 2;
    middle.x = last.x - normal.x * 2;
    left.z = 0;
    left.y = middle.y + normal.x;
    left.x = middle.x - normal.y;
    right.z = 0;
    right.y = middle.y - normal.x;
    right.x = middle.x + normal.y;
    points[0] = first;
    points[1] = middle;
    points[2] = left;
    points[3] = last;
    points[4] = right;
    points[5] = middle;
    //int mdlLineString_create(MSElement* out, MSElement* in, DPoint3d* points, int numVerts);
    //int mdlLine_create(MSElement* pElementOut, MSElement* pElementIn, DPoint3d* points);
    return SUCCESS == mdlLineString_create(lineP, NULL, points, 6);
}

int arrowBuilder_createTextAtTheEndOfVector(MSElement* textP, PhotoArrow* arrowP) {
    ULong font = 1;
    double height = 2.0;
    double rotation = angle(&arrowP->startPoint, &arrowP->endPoint);
    //int just = TXTJUST_LB; //left bottom
    int just = TXTJUST_LC; //left center
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
    if (strlen(arrowP->name) == 0) return FALSE;

    return SUCCESS == mdlText_create(textP, NULL, arrowP->name, &arrowP->endPoint, &size, &rotMatrix, &param, NULL);
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
