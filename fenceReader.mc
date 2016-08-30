#include "fenceReader.h"

void fenceReader_init(LpFenceReader thisP) {
    if (thisP == NULL) return;
    thisP->maxCount = 0;
    thisP->masterCount = 0;
    thisP->refCount = 0;
    thisP->startPoints = NULL;
    thisP->startPointsCount = 0;
    thisP->endPoints = NULL;
    thisP->endPointsCount = 0;
}

void fenceReader_free(LpFenceReader thisP) {
    if (thisP == NULL) return;
    if (thisP->startPoints != NULL) {
        free(thisP->startPoints);
        thisP->startPoints = NULL;
    }
    if (thisP->endPoints != NULL) {
        free(thisP->endPoints);
        thisP->endPoints = NULL;
    }
}

void fenceReader_summary(LpFenceReader thisP) {
    char msg[256];
    if (thisP == NULL) return;
    sprintf(msg, "master elements: %d count", thisP->masterCount);
    mdlLogger_info(msg);
    sprintf(msg, "ref elements: %d count", thisP->refCount);
    mdlLogger_info(msg);
    sprintf(msg, "start points: %d count (level %d)", thisP->startPointsCount, _refStartLevel);
    mdlLogger_info(msg);
    sprintf(msg, "end points: %d count (level %d)", thisP->endPointsCount, _refEndLevel);
    mdlLogger_info(msg);
}

int fenceReader_count(LpFenceReader thisP) {
    //mdlLogger_info("fenceReader: counting ref elements");
    //init fence
    //mdlFence_fromUniverse(tcb->lstvw); //remember to set fence
    mdlState_startFenceCommand(fence_countRefElement, NULL, NULL, NULL, 0, 0, FENCE_NO_CLIP);
    mdlLocate_init();
    mdlLocate_allowLocked(); //ref too
    //mdlLocate_normal(); //only master
    mdlSelect_freeAll();
    //selection
    mdlFence_process(thisP);
    //mdlFence_clear(FALSE);
    return TRUE;
}

int fence_countRefElement(LpFenceReader thisP) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    if (fileNum != MASTERFILE) {
        thisP->maxCount++;
    }
    mdlElmdscr_freeAll(&edP);
    return SUCCESS;
}

int fenceReader_load(LpFenceReader thisP) {
    //mdlLogger_info("fenceReader: loading ref elements from user fence");
    //init fence
    thisP->startPoints = (PhotoPoint*) calloc(thisP->maxCount, sizeof (PhotoPoint));
    thisP->endPoints = (PhotoPoint*) calloc(thisP->maxCount, sizeof (PhotoPoint));
    //mdlFence_fromUniverse(tcb->lstvw); //remember to set fence
    mdlState_startFenceCommand(fence_selectCurrentRefElement, NULL, NULL, NULL, 0, 0, FENCE_NO_CLIP);
    mdlLocate_init();
    mdlLocate_allowLocked(); //ref too
    //mdlLocate_normal(); //only master
    mdlSelect_freeAll();
    //selection
    mdlFence_process(thisP);
    //mdlFence_clear(FALSE);
    fence_sort(thisP);
    //fence_summary(thisP);
    return TRUE;
}

int fence_selectCurrentRefElement(LpFenceReader thisP) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    if (fileNum != MASTERFILE) {
        fence_parseRef(thisP, edP, fileNum);
    } else {
        fence_parseMaster(thisP, edP, fileNum);
    }
    mdlElmdscr_freeAll(&edP);
    return SUCCESS;
}

int fence_parseRef(LpFenceReader thisP, MSElementDescr* edP, ModelNumber fileNum) {
    int type;
    UInt32 level;
    char text[256];
    DPoint3d point;
    element_readAttributes(edP, fileNum, &type, &level, NULL, NULL, NULL);
    if (!element_isText(type)) return FALSE; //skip elements other than texts
    if (!mdlText_readText(edP, text, &point)) return FALSE;
    if (strlen(text) > MAX_PHOTO_NAME) return FALSE; //photo name is too big
    if (level == _refStartLevel) { //first point of the photo
        PhotoPoint* photoP = NULL;
        int i = thisP->startPointsCount;
        if (i >= thisP->maxCount) return FALSE;
        photoP = &thisP->startPoints[i];
        strncpy(photoP->name, text, sizeof (photoP->name));
        photoP->point = point;
        thisP->startPointsCount++;
    }
    if (level == _refEndLevel) { //second point of the photo
        PhotoPoint* photoP = NULL;
        int i = thisP->endPointsCount;
        if (i >= thisP->maxCount) return FALSE;
        photoP = &thisP->endPoints[i];
        strncpy(photoP->name, text, sizeof (photoP->name));
        photoP->point = point;
        thisP->endPointsCount++;
    }
    thisP->refCount++;
    return TRUE;
}

void fence_parseMaster(LpFenceReader thisP, MSElementDescr* edP, ModelNumber fileNum) {
    thisP->masterCount++;
}

PhotoPoint* fenceReader_searchStartName(LpFenceReader thisP, char* photoName, DPoint3d* foundP) {
    PhotoPoint point;
    PhotoPoint* foundPoint = NULL;
    if (thisP == NULL) return FALSE;
    if (photoName == NULL) return FALSE;
    strncpy(point.name, photoName, MAX_PHOTO_NAME);
    foundPoint = fenceReader_binarySearch(&point, thisP->startPoints, thisP->startPointsCount);
    if (foundPoint != NULL && foundP != NULL) *foundP = foundPoint->point;
    return foundPoint;
}

int fenceReader_searchEndName(LpFenceReader thisP, char* photoName, DPoint3d* foundP) {
    PhotoPoint point;
    PhotoPoint* foundPoint = NULL;
    if (thisP == NULL) return FALSE;
    if (photoName == NULL) return FALSE;
    strncpy(point.name, photoName, MAX_PHOTO_NAME);
    foundPoint = fenceReader_binarySearch(&point, thisP->endPoints, thisP->endPointsCount);
    if (foundPoint != NULL && foundP != NULL) *foundP = foundPoint->point;
    return foundPoint != NULL;
}

PhotoPoint* fenceReader_binarySearch(PhotoPoint* key, PhotoPoint* points, long count) {
    //void* bsearch (void *key, void *base, size_t members, size_t sizeMember, int (*compareFunc)(void *, void *))
    PhotoPoint* result = bsearch(key, points, count, sizeof (PhotoPoint), fenceReader_comparePhotos);
    return result;
}

int fenceReader_comparePhotos(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}

void fence_sort(LpFenceReader thisP) {
    if (thisP == NULL) return;
    //void mdlUtil_quickSort(void* pFirst, int numEntries, int elementSize, MdlFunctionP compareFunc)
    mdlUtil_quickSort(thisP->startPoints, thisP->startPointsCount, sizeof (PhotoPoint), fence_comparePoints);
    mdlUtil_quickSort(thisP->endPoints, thisP->endPointsCount, sizeof (PhotoPoint), fence_comparePoints);
}

int fence_comparePoints(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}
