#include "fence.h"

void fence_init(LpFence this) {
    if (this == NULL) return;
    this->nSelected = 0;
    this->filePositions = NULL;
    this->modelNumbers = NULL;
    this->masterCount = 0;
    this->refCount = 0;
}

void fence_free(LpFence this) {
    if (this == NULL) return;
    if (this->filePositions != NULL) free(this->filePositions);
    if (this->modelNumbers != NULL) free(this->modelNumbers);
    fence_init(this);
}

int fence_load(LpFence this) {
    int i = 0;
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
    if (SUCCESS != mdlSelect_returnPositions(&this->filePositions, &this->modelNumbers, &this->nSelected)) {
        return FALSE; //no fence
    }
    mdlFence_clear(FALSE);
    return TRUE;
}

int fence_selectCurrentRefElement(LpFence this) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    int isRef = FALSE;
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    isRef = fileNum != MASTERFILE;
    if (isRef) {
        mdlSelect_addElement(filePos, fileNum, &edP->el, TRUE);
        this->refCount++;
    } else {
        this->masterCount++;
    }
    mdlElmdscr_freeAll(&edP);
    return SUCCESS;
}
