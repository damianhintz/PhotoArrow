#include "cmd.h"

void command_loadPhotoPointsFromFence() {
    FenceReader fence;
    //int photos;
    ArrowBuilder builder;
    fence_init(&fence);
    fence_load(&fence);
    fence_summary(&fence);
    //sprintf(_msg, "photoarrow: %d master, %d ref", fence.masterCount, fence.refCount);
    //mdlLogger_info(_msg);
    if (fence.refCount == 0) {
        mdlDialog_openAlert(
                "Brak pliku referencyjnego lub nie zawiera on widocznych danych. "
                "Program zostanie przerwany. Attach reference file or display it!");
        return;
    }
    //photos = photoReader_findPhotos();
    //sprintf(_msg, "%d photo files", photos);
    //mdlLogger_info(_msg);

    arrowBuilder_init(&builder, &fence);
    arrowBuilder_load(&builder, &fence);
    arrowBuilder_summary(&builder);
    arrowWriter_saveAll(&builder);

    arrowBuilder_free(&builder);
    fence_free(&fence);
    mdlLogger_info("photoarrow: end");
    return;
}

void command_loadArrowsFromFile() {
    char row[256];
    char msg[256];
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
        //p[0].x = 0;
        //p[0].y = 0;
        //p[1].x = 10000;
        //p[1].y = 10000;
        //sprintf(msg, "%f %f %f %f %s", p[0].x, p[0].y, p[1].x, p[1].y, photoName);
        //mdlLogger_info(msg);
        if (SUCCESS != mdlLine_create(&lineP, NULL, p)) continue;
        mdlElement_add(&lineP);
        //break;
    }
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