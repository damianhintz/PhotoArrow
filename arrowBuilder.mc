#include "arrowBuilder.h"
#include "photoReader.h"

void arrowBuilder_init(LpArrowBuilder thisP, LpFenceReader readerP) {
    if (thisP == NULL) return;
    if (readerP == NULL) return;
    thisP->maxArrows = readerP->refCount;
    thisP->arrows = (PhotoArrow*) calloc(readerP->refCount, sizeof (PhotoArrow));
    thisP->arrowsCount = 0;
    thisP->allCount = 0;
    thisP->missingArrows = 0;
    thisP->missingPhotos = 0;
    thisP->duplicateArrows = 0;
}

void arrowBuilder_free(LpArrowBuilder thisP) {
    if (thisP->arrows != NULL) free(thisP->arrows);
}

void arrowBuilder_summary(LpArrowBuilder thisP) {
    char msg[256];
    sprintf(msg, "arrowWriter: %d/%d arrow[s] added (level %d)",
            thisP->arrowsCount, thisP->allCount, _arrowLevel);
    mdlLogger_info(msg);
    sprintf(msg, "arrowWriter: %d missing arrow[s], %d missing photo file[s]",
            thisP->missingArrows, thisP->missingPhotos);
    mdlLogger_info(msg);
    sprintf(msg, "arrowWriter: %d duplicate arrow[s]", thisP->duplicateArrows);
    mdlLogger_info(msg);
}

void arrowBuilder_addArrow(LpArrowBuilder thisP, char* photoName, DPoint3d* startPoint, DPoint3d* endPoint) {
    PhotoArrow* arrowP = NULL;
    double length, lengthInMeters, maxLength;
    int index = thisP->arrowsCount;
    if (index >= thisP->maxArrows) return; //no room
    arrowP = &thisP->arrows[index];
    strncpy(arrowP->name, photoName, sizeof (arrowP->name));
    arrowP->startPoint = *startPoint;
    arrowP->endPoint = *endPoint;
    thisP->arrowsCount++;
    length = vector_distance2D(&arrowP->startPoint, &arrowP->endPoint);
    lengthInMeters = mdlCnv_uorsToMasterUnits(length);
    if (lengthInMeters < _arrowMaxLength) return; //length ok
    maxLength = mdlCnv_masterUnitsToUors(_arrowMaxLength);
    photoArrow_normalizeLength(arrowP, maxLength);
    photoArrow_normalizeName(arrowP);
}

void arrowBuilder_createArrows(LpArrowBuilder thisP, LpPhotoReader photosP, LpFenceReader readerP) {
    int i = 0;
    //mdlLogger_info("arrowBuilder: building arrows from photos");
    for (i = 0; i < photosP->filesCount; i++) {
        PhotoPoint* startP;
        DPoint3d startPoint, endPoint;
        char photoName[MAX_PHOTO_NAME];
        int photoLength = photoReader_parsePhotoName(photosP, i, photoName);
        thisP->allCount++;
        if (photoLength == 0) {
            char msg[256];
            sprintf(msg, "arrowBuilder: invalid arrow photo name %s", photosP->files[i].name);
            mdlLogger_err(msg);
            thisP->missingArrows++;
            continue;
        }
        //searching for photo
        //mdlLogger_info(photoName);
        startP = fenceReader_searchStartName(readerP, photoName, &startPoint);
        if (startP == NULL) {
            char msg[256];
            sprintf(msg, "arrowBuilder: missing arrow start point %s", photoName);
            mdlLogger_err(msg);
            thisP->missingArrows++;
            continue; //no start point
        }
        if (!fenceReader_searchEndName(readerP, photoName, &endPoint)) {
            char msg[256];
            sprintf(msg, "arrowBuilder: missing arrow end point %s", photoName);
            mdlLogger_err(msg);
            thisP->missingArrows++;
            continue; //no end point
        }
        startP->used = TRUE;
        //build arrow from points
        arrowBuilder_addArrow(thisP, photoName, &startPoint, &endPoint);
    }
    //Search for missing photos by arrow start point
    for (i = 0; i < readerP->startPointsCount; i++) {
        char msg[256];
        PhotoPoint* pointP = &readerP->startPoints[i];
        if (pointP->used) continue;
        thisP->missingPhotos++;
        sprintf(msg, "arrowBuilder: missing photo file %s", pointP->name);
        mdlLogger_err(msg);
    }
    //Search for duplicate arrows
    for (i = 1; i < readerP->startPointsCount; i++) {
        char msg[256];
        PhotoPoint* firstP = &readerP->startPoints[i - 1];
        PhotoPoint* secondP = &readerP->startPoints[i];
        if (strcmp(firstP->name, secondP->name) != 0) continue;
        thisP->duplicateArrows++;
        sprintf(msg, "arrowBuilder: duplicate arrow %s", firstP->name);
        mdlLogger_err(msg);
    }
}

void arrowWriter_saveAll(LpArrowBuilder thisP) {
    int i;
    char msg[256];
    FILE* file;
    char fileName[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    //char ext[MAXEXTENSIONLENGTH];
    //mdlLogger_info("arrowWriter: saving arrows to file");
    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, NULL);
    mdlFile_buildName(fileName, dev, dir, name, "arrows");

    file = mdlTextFile_open(fileName, TEXTFILE_WRITE);
    if (file == NULL) return;
    for (i = 0; i < thisP->arrowsCount; i++) {
        MSElement line, text;
        //save arrow as line string (scale it to 80%)
        PhotoArrow* arrowP = &thisP->arrows[i];
        double rotation = vector_angle(&arrowP->startPoint, &arrowP->endPoint);
        sprintf(msg, "%.2f %.2f %.2f %.2f %s",
                arrowP->startPoint.x, arrowP->startPoint.y,
                arrowP->endPoint.x, arrowP->endPoint.y,
                arrowP->name);
        mdlTextFile_putString(msg, file, TEXTFILE_DEFAULT); //TEXTFILE_NO_NEWLINE

        if (arrowBuilder_createArrowFromVector(&line, arrowP)) {
            mdlElement_add(&line);
        }
        if (rotation > _pi / 2.0 && rotation < _pi * 1.5) {
            if (arrowBuilder_createReverseTextAtTheEndOfVector(&text, arrowP)) {
                mdlElement_add(&text);
            }
        } else {
            if (arrowBuilder_createTextAtTheEndOfVector(&text, arrowP)) {
                mdlElement_add(&text);
            }
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
    //char msg[256];
    ULong font = _arrowFont;
    double height = _arrowTextSize;
    double width = _arrowTextSize;
    double rotation = vector_angle(&arrowP->startPoint, &arrowP->endPoint);
    //int just = TXTJUST_LB; //left bottom
    int just = TXTJUST_LC; //left center
    RotMatrix rotMatrix;
    TextParam param;
    TextSizeParam size;

    param.font = font;
    param.just = just;

    size.mode = TXT_BY_TILE_SIZE;
    size.size.height = mdlCnv_masterUnitsToUors(height);
    size.size.width = mdlCnv_masterUnitsToUors(width);
    size.aspectRatio = 1;

    mdlRMatrix_fromAngle(&rotMatrix, rotation);
    if (strlen(arrowP->name) == 0) return FALSE;
    return SUCCESS == mdlText_create(textP, NULL, arrowP->name, &arrowP->endPoint, &size, &rotMatrix, &param, NULL);
}

int arrowBuilder_createReverseTextAtTheEndOfVector(MSElement* textP, PhotoArrow* arrowP) {
    int length = strlen(arrowP->name);
    ULong font = _arrowFont;
    double height = _arrowTextSize;
    double width = _arrowTextSize;
    double rotation = vector_angle(&arrowP->startPoint, &arrowP->endPoint);
    double reverse;
    //int just = TXTJUST_LB; //left bottom
    int just = TXTJUST_LC; //left center
    RotMatrix rotMatrix;
    TextParam param;
    TextSizeParam size;
    DPoint3d normal, startPoint, first, last;

    if (length == 0) return FALSE;

    mdlVec_computeNormal(&normal, &arrowP->endPoint, &arrowP->startPoint);
    mdlVec_scale(&normal, &normal, mdlCnv_masterUnitsToUors(width));
    first = arrowP->startPoint;
    last = arrowP->endPoint;
    startPoint.z = 0;
    startPoint.y = last.y + normal.y * length;
    startPoint.x = last.x + normal.x * length;

    param.font = font;
    param.just = just;

    size.mode = TXT_BY_TILE_SIZE;
    size.size.height = mdlCnv_masterUnitsToUors(height);
    size.size.width = mdlCnv_masterUnitsToUors(width);
    size.aspectRatio = 1;

    reverse = rotation;
    rotation += _pi; //reverse angle vector by adding 180 degrees
    if (rotation > 2 * _pi) rotation -= 2 * _pi; //normalize angle
    mdlRMatrix_fromAngle(&rotMatrix, rotation);
    return SUCCESS == mdlText_create(textP, NULL, arrowP->name, &startPoint, &size, &rotMatrix, &param, NULL);
}
