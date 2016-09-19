#include "cmd.h"

int command_loadFence() {
    PhotoReader photos;
    FenceReader reader;
    ArrowBuilder builder;
    //load photos
    photoReader_init(&photos);
    if (!photoReader_findPhotos(&photos, _photoSubdir, _photoExt)) {
        char msg[256];
        sprintf(msg, "Brak katalogu %s lub nic nie zawiera (%s). "
                "Program zostanie przerwany!", _photoSubdir, _photoExt);
        mdlDialog_openAlert(msg);
        return FALSE;
    };
    photoReader_summary(&photos);
    //load fence
    fenceReader_init(&reader);
    fenceReader_count(&reader);
    fenceReader_load(&reader);
    fenceReader_summary(&reader);
    if (reader.refCount == 0) {
        mdlDialog_openAlert(
                "Brak pliku referencyjnego, nie zawiera on widocznych danych lub nie ustawiono ogrodzenia. "
                "Program zostanie przerwany!");
        return FALSE;
    }
    //build arrows
    arrowBuilder_init(&builder, &reader);
    arrowBuilder_createArrows(&builder, &photos, &reader);
    arrowWriter_saveAll(&builder);
    arrowBuilder_summary(&builder);
    //free resources
    arrowBuilder_free(&builder);
    fenceReader_free(&reader);
    photoReader_free(&photos);
    return TRUE;
}

void command_loadConfig() {
    char row[256];
    FILE* file;
    //mdlLogger_info("photoarrow config load");
    mdlLogger_info(_configPath);
    file = mdlTextFile_open(_configPath, TEXTFILE_READ);
    if (file == NULL) return;
    while (NULL != mdlTextFile_getString(row, 256, file, TEXTFILE_DEFAULT)) {
        if (strncmp(row, "#", 1) == 0) continue; //skip keyin
        //void mdlInput_sendKeyin(char* stringP, int literal, int position, char* taskIdP);
        mdlInput_sendKeyin(row, 0, 0, NULL);
        //mdlLogger_info(row);
    }
    mdlTextFile_close(file);
    //mdlLogger_info("photoarrow config loaded");
}

void command_photoSubdir(char* subdir) {
    char msg[256];
    if (subdir == NULL) return;
    strcpy(_photoSubdir, subdir);
    sprintf(msg, "command_photoSubdir: %s", _photoSubdir);
    mdlLogger_info(msg);
}

void command_photoExt(char* ext) {
    char msg[256];
    if (ext == NULL) return;
    strcpy(_photoExt, ext);
    sprintf(msg, "command_photoExt: %s", _photoExt);
    mdlLogger_info(msg);
}

void command_refStartLevel(int startLevel) {
    char msg[256];
    _refStartLevel = startLevel;
    sprintf(msg, "command_refStartLevel: %d", _refStartLevel);
    mdlLogger_info(msg);
}

void command_refEndLevel(int endLevel) {
    char msg[256];
    _refEndLevel = endLevel;
    sprintf(msg, "command_refEndLevel: %d", _refEndLevel);
    mdlLogger_info(msg);
}

void command_arrowLevel(int level) {
    char msg[256];
    _arrowLevel = level;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowLevel, ACTIVEPARAM_LEVEL);
    sprintf(msg, "command_arrowLevel: %d", _arrowLevel);
    mdlLogger_info(msg);
}

void command_arrowFont(int font) {
    char msg[256];
    _arrowFont = font;
    sprintf(msg, "command_arrowFont: %d", _arrowFont);
    mdlLogger_info(msg);
}

void command_arrowColor(int color) {
    char msg[256];
    _arrowColor = color;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowColor, ACTIVEPARAM_COLOR);
    sprintf(msg, "command_arrowColor: %d", _arrowColor);
    mdlLogger_info(msg);
}

void command_arrowStyle(int style) {
    char msg[256];
    _arrowStyle = style;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowStyle, ACTIVEPARAM_LINESTYLE);
    sprintf(msg, "command_arrowStyle: %d", _arrowStyle);
    mdlLogger_info(msg);
}

void command_arrowWeight(int weight) {
    char msg[256];
    _arrowWeight = weight;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowWeight, ACTIVEPARAM_LINEWEIGHT);
    sprintf(msg, "command_arrowWeight: %d", _arrowWeight);
    mdlLogger_info(msg);
}

void command_arrowTextSize(double size) {
    char msg[256];
    _arrowTextSize = size;
    sprintf(msg, "command_arrowTextSize: %.2f", _arrowTextSize);
    mdlLogger_info(msg);
}

void command_arrowMaxLength(double length) {
    char msg[256];
    _arrowMaxLength = length;
    sprintf(msg, "command_arrowMaxLength: %.2f", _arrowMaxLength);
    mdlLogger_info(msg);
}

void command_loadArrowsFromFile() {
    char row[256];
    FILE* file;
    char fileName[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    //char ext[MAXEXTENSIONLENGTH];
    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, NULL);
    mdlFile_buildName(fileName, dev, dir, name, "arrows");
    mdlLogger_info("photoarrow: loadArrowsFromFile end");
    file = mdlTextFile_open(fileName, TEXTFILE_READ);
    if (file == NULL) return;
    while (NULL != mdlTextFile_getString(row, 256, file, TEXTFILE_DEFAULT)) {
        DPoint3d p[2];
        char photoName[32];
        MSElement lineP;
        if (strncmp(row, "#", 1) == 0) continue;
        sscanf(row, "%f %f %f %f %s", &p[0].x, &p[0].y, &p[1].x, &p[1].y, photoName);
        p[0].z = 0;
        p[1].z = 0;
        if (SUCCESS != mdlLine_create(&lineP, NULL, p)) continue;
        mdlElement_add(&lineP);
    }
    mdlTextFile_close(file);
    mdlLogger_info("photoarrow: loadArrowsFromFile end");
}

/*
@Description  Updates the reference file in all views.
@Param	modelRef    IN  modelRef for reference to update
@Param	displayMode IN  one of the display modes defined in mdl.h. Most commonly used are NORMALDRAW, ERASE, and HILITE.
@Return       SUCCESS, or MDLERR_BADMODELREF if the modelRef is not valid.
@Remarks      The display mode definitions are included in msdefs.h. 
 */

/*
int getRefCount() {
    int paramFileFound;
    ModelNumber slot = 1;
    int okSlots = 0;
    int badSlots = 0;
    //int mdlRefFile_getParameters(void *param, int paramName, int refSlot);
    //StatusInt mdlRefFile_getParameters(void *param, int paramName, DgnModelRefP modelRef);
    while (mdlRefFile_getParameters(&paramFileFound, REFERENCE_FILENOTFOUND, slot) != MDLERR_BADSLOT) {
        if (paramFileFound) okSlots++;
        else badSlots++;
        slot++;
    }
    return okSlots;
}
 */

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
