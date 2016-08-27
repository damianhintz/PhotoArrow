#include <cmdlist.h>
#include <msdialog.fdf>
#include <msparse.fdf>
#include "cmd.h"

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PHOTOARROW_INIT {
    mdlLogger_info("photoarrow: init");
    command_loadPhotoPointsFromFence();
    return;
}

Public cmdName void cmd_photoHelp(char* unparsedP) cmdNumber CMD_PHOTOARROW_HELP {
    mdlLogger_info("photoarrow help/about");
    mdlLogger_info("photoarrow v1.0-beta");
    return;
}

Public cmdName void cmd_photoConfigScale(char* unparsedP) cmdNumber CMD_PHOTOARROW_CONFIG_SCALE {
    int scale = -1;
    if (1 != sscanf(unparsedP, "%d", &scale)) {
        mdlLogger_info("photoarrow config scale {percent}");
        return;
    }
    //app_setScale(scale);
    return;
}

Public cmdName void cmd_photoConfigLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_CONFIG_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("photoarrow config level {level}");
        return;
    }
    //app_setLevel(level);
    return;
}

Public cmdName void cmd_photoReferences(char* unparsedP) cmdNumber CMD_PHOTOARROW_REFERENCES {
    //int okSlots = getRefCount(); //int references = mdlRefFile_getRefCount();
    //char msg[256];
    //sprintf(msg, "photoarrow references: %d ok slot[s]", okSlots);
    //mdlLogger_info(msg);
    command_loadArrowsFromFile();
    return;
}

void appConfig_setScale(int scale) {
    //_precyzja = precyzja;
}

void appConfig_setLevel(int level) {

}

int scanMasterFile() {
    char msg[512];
    MSElementDescr *edP;
    ULong scanBuf[1024], eofPos, filePos, realPos, level;
    int scanWords, status, i, numAddr, type;
    ExtScanlist scanList;
    int teksty = 0;
    int obiekty = 0;
    
    mdlScan_initScanlist(&scanList);
    mdlScan_noRangeCheck(&scanList);
    mdlScan_setDrawnElements(&scanList);
    mdlScan_viewRange(&scanList, tcb->lstvw, 0);

    scanList.scantype = ELEMTYPE | NESTCELL;
    scanList.extendedType = FILEPOS;

    eofPos = mdlElement_getFilePos(FILEPOS_EOF, NULL);
    filePos = 0L;
    realPos = 0L;

    /* tylko MASTERFILE */
    mdlScan_initialize(0, &scanList);
    do {
        status = mdlScan_file(scanBuf, &scanWords, sizeof (scanBuf), &filePos);
        numAddr = scanWords / sizeof (short);
        for (i = 0; i < numAddr; i++) {
            if (scanBuf[i] >= eofPos) break;
            if (scanBuf[i] < realPos) continue;
            if (mdlElmdscr_read(&edP, scanBuf[i], 0, FALSE, &realPos) == 0) continue;
            //obiekty++;
            //if (!mdlElement_isVisible(&edP->el)) continue; //Element nie jest widoczny
            //if (!mdlElement_isEffectivelyVisible(&edP->el, MASTERFILE, tcb->lstvw)) continue; //Element nie jest widoczny
            if (!element_readAttributes(edP, MASTERFILE, &type, &level, NULL, NULL, NULL)) continue;
            obiekty++;
            if (!element_isText(type)) continue; //To nie jest tekst
            teksty++;
            mdlElmdscr_freeAll(&edP);
        }
    } while (status == BUFF_FULL);
    sprintf(msg, "photoarrow: %d/%d", teksty, obiekty);
    mdlLogger_info(msg);
    mdlView_updateSingle(tcb->lstvw);
    return SUCCESS;
}

int mdlSelection_searchKierunki() {
    ULong* offsets;
    ModelNumber* fileNums;
    int nSelected = 0, i = 0;
    int masterCount = 0, refCount = 0;
    mdlSystem_startBusyCursor();
    mdlSelect_freeAll(); //Unselect elements
    mdlSelect_allElements(); //Select all elements
    if (SUCCESS != mdlSelect_returnPositions(&offsets, &fileNums, &nSelected)) return FALSE;
    mdlSelect_freeAll();
    for (i = 0; i < nSelected; i++) {
        ModelNumber fileNum = fileNums[i];
        if (fileNum == MASTERFILE) masterCount++;
        else refCount++;
        //if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL)) ;
        //mdlSelection_addKierunek(fileNums[i], offsets[i]);
    }
    mdlSystem_stopBusyCursor();
    //sprintf(_msg, "photoarrow: %d master, %d ref", masterCount, refCount);
    //mdlLogger_info(_msg);
    mdlLogger_info("photoarrow: end");
    return TRUE;
}

int mdlSelection_addKierunek(ModelNumber fileNum, ULong filePos) {
    MSElementDescr* edP = NULL;
    //int typObiektu;
    int masterCount = 0, refCount = 0;
    if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL));
    if (fileNum == MASTERFILE) masterCount++;
    else refCount++;
    mdlElmdscr_freeAll(&edP);
    return TRUE;
}
