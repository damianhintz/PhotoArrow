#include "fenceReader.h"

void fence_init(LpFenceReader this) {
    if (this == NULL) return;
    this->masterCount = 0;
    this->refCount = 0;
    this->startPoints = (PhotoPoint*) calloc(MAX_POINTS, sizeof (PhotoPoint));
    this->startPointsCount = 0;
    this->endPoints = (PhotoPoint*) calloc(MAX_POINTS, sizeof (PhotoPoint));
    this->endPointsCount = 0;
}

void fence_free(LpFenceReader this) {
    if (this == NULL) return;
}

void fence_summary(LpFenceReader this) {
    char msg[256];
    if (this == NULL) return;
    sprintf(msg, "start points: %d count", this->startPointsCount);
    mdlLogger_info(msg);
    sprintf(msg, "end points: %d count", this->endPointsCount);
    mdlLogger_info(msg);
}

int fence_load(LpFenceReader this) {
    //int i = 0;
    if (NULL == this) return FALSE;
    //init fence
    mdlFence_fromUniverse(tcb->lstvw); //remember to set fence
    mdlState_startFenceCommand(fence_selectCurrentRefElement, NULL, NULL, NULL, 0, 0, FENCE_NO_CLIP);
    mdlLocate_init();
    mdlLocate_allowLocked(); //ref too
    //mdlLocate_normal(); //only master
    mdlSelect_freeAll();
    //selection
    if (SUCCESS == mdlFence_process(this));
    mdlFence_clear(FALSE);
    fence_sort(this);
    return TRUE;
}

int fence_selectCurrentRefElement(LpFenceReader this) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    if (fileNum != MASTERFILE) {
        fence_parseRef(this, edP, fileNum);
    } else {
        fence_parseMaster(this, edP, fileNum);
    }
    mdlElmdscr_freeAll(&edP);
    return SUCCESS;
}

int fence_parseRef(LpFenceReader this, MSElementDescr* edP, ModelNumber fileNum) {
    int type;
    UInt32 level;
    char text[256];
    DPoint3d point;
    element_readAttributes(edP, fileNum, &type, &level, NULL, NULL, NULL);
    if (!element_isText(type)) return FALSE; //skip elements other than texts
    if (!mdlText_readText(edP, text, &point)) return FALSE;
    if (strlen(text) > 8) return FALSE;
    if (level == 61) { //first point of the photo
        //fenceReader_addStartPoint(this, text, &point);
        int i = this->startPointsCount;
        
        PhotoPoint* photoP = &this->startPoints[i];
        if (i >= MAX_POINTS) return FALSE;
        strncpy(photoP->name, text, sizeof (photoP->name));
        photoP->point = point;
        this->startPointsCount++;
    }
    if (level == 60) { //second point of the photo
        //fenceReader_addEndPoint(this, text, &point);
        int i = this->endPointsCount;
        PhotoPoint* photoP = &this->endPoints[i];
        if (i >= MAX_POINTS) return FALSE;
        strncpy(photoP->name, text, sizeof (photoP->name));
        photoP->point = point;
        this->endPointsCount++;
    }
    //mdlSelect_addElement(filePos, fileNum, &edP->el, TRUE);
    this->refCount++;
    return TRUE;
}

void fence_parseMaster(LpFenceReader this, MSElementDescr* edP, ModelNumber fileNum) {
    this->masterCount++;
}

void fence_sort(LpFenceReader this) {
    //void mdlUtil_quickSort(void* pFirst, int numEntries, int elementSize, MdlFunctionP compareFunc)
    mdlUtil_quickSort(this->startPoints, this->startPointsCount, sizeof (PhotoPoint), fence_comparePoints);
    mdlUtil_quickSort(this->endPoints, this->endPointsCount, sizeof (PhotoPoint), fence_comparePoints);
}

int fence_comparePoints(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}
