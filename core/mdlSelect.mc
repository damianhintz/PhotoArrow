#include "mdlSelect.h"
#include "mdlElement.h"
#include "..\app\mdlUtil.h"

int mdlSelection_init(PlikDgnSelekcja* this) {
    if (this == NULL) return FALSE;
    this->nObiekty = 0;
    this->nInneObiekty = 0;
    this->nTeksty = 0;
    this->nSymbole = 0;
    this->nObszary = 0;
    return TRUE;
}

int mdlSelection_free(PlikDgnSelekcja* this) {
    if (this == NULL) return FALSE;
    return TRUE;
}

int mdlSelection_summary(PlikDgnSelekcja* this) {
    //char msg[256];
    if (this == NULL) return FALSE;
    //sprintf(msg, "skanowanie: teksty %d, symbole %d, obszary %d, inne %d",
    //    this->nTeksty, this->nSymbole, this->nObszary, this->nInneObiekty);
    //mdlLogger_info(msg);
    return TRUE;
}

int mdlSelection_load(PlikDgnSelekcja* this) {
    if (this == NULL) return FALSE;
    if (!mdlSelection_search(mdlSelection_count, this)) return FALSE;
    if (SUCCESS == mdlView_updateSingle(tcb->lstvw));
    return TRUE;
}

int mdlSelection_search(int (*plikDgn_selekcjaFunc)(ElementSelection* argP), void* argP) {
    ULong* offsets;
    ModelNumber* fileNums;
    int nSelected = 0, i = 0;
    mdlSystem_startBusyCursor();
    mdlSelect_freeAll(); //Unselect elements
    mdlSelect_allElements(); //Select all elements
    if (SUCCESS != mdlSelect_returnPositions(&offsets, &fileNums, &nSelected)) return FALSE;
    mdlSelect_freeAll();
    for (i = 0; i < nSelected; i++) {
        ElementSelection select;
        select.fileNum = fileNums[i];
        select.filePos = offsets[i];
        plikDgn_selekcjaFunc(&select);
        
    }
    mdlSystem_stopBusyCursor();
    //mdlLogger_info("-KONIEC-");
    return TRUE;
}

int mdlSelection_count(ElementSelection* argP) {
    //PlikDgnSelekcja* argP = (PlikDgnSelekcja*) vargP;
    //NumerPlikuDgn numerPliku = MASTERFILE;
    MSElementDescr* edP = NULL;
    ModelNumber fileNum = argP->fileNum;
    ULong filePos = argP->filePos;
    int typObiektu;
    if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL)) ;
    if (!element_readAttributes(edP, fileNum, &typObiektu, NULL, NULL, NULL, NULL)) return FALSE;
    //if (obiektDgn_jestTekstem(typObiektu)) argP->nTeksty++;
    //else if (obiektDgn_jestSymbolem(typObiektu)) argP->nSymbole++;
    //else if (obiektDgn_jestObszarem(typObiektu)) argP->nObszary++;
    //else argP->nInneObiekty++;
    //argP->nObiekty++;
    mdlElmdscr_freeAll(&edP);
    return TRUE;
}
