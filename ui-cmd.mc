//#include <mselmdsc.h>
#include <cmdlist.h>
#include <msdialog.fdf>
#include <msparse.fdf>
#include <ditemlib.fdf>
#include <mdllib.fdf>
#include <mssystem.fdf>
#include <string.h>
#include <msstring.fdf>
#include <mscell.fdf>
#include <msinput.fdf>
#include <msreffil.fdf>
#include "ui.h"
#include "ui-cmd.h"
#include "main.h"
#include "fenceReader.h"
#include "arrowBuilder.h"
#include "app\mdlLogger.h"

int _precyzja = -1;
char _msg[256];

void appConfig_setScale(int scale);
void appConfig_setLevel(int level);
int getRefCount();
int scanMasterFile();
int dgnText_dodajCentymetry(MSElementDescr* edP, int dodajCentymetry, char* staryText, char* nowyText);

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PHOTOARROW_INIT {
    mdlLogger_info("photoarrow: init");
    photoPoints_loadFromFence();
    return;
}

void photoPoints_loadFromFence() {
    Fence fence;
    int photos;
    FenceReader reader;
    ArrowBuilder builder;
    fence_init(&fence);
    fence_load(&fence);
    sprintf(_msg, "photoarrow: %d master, %d ref", fence.masterCount, fence.refCount);
    mdlLogger_info(_msg);
    
    if (fence.refCount == 0) {
        mdlDialog_openAlert(
                "Brak pliku referencyjnego lub nie zawiera on widocznych danych. "
                "Program zostanie przerwany. Attach reference file or display it!");
        return;
    }
    photos = mdlLogger_findPhotos();
    sprintf(_msg, "%d photo files", photos);
    mdlLogger_info(_msg);
    
    fenceReader_init(&reader);
    fenceReader_load(&reader, &fence);
    
    arrowBuilder_init(&builder, &reader);
    arrowBuilder_load(&builder, &reader);
    arrowBuilder_summary(&builder);
    arrowWriter_saveAll(&builder);
    
    arrowBuilder_free(&builder);
    fenceReader_free(&reader);
    fence_free(&fence);
    mdlLogger_info("photoarrow: end");
    return;
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
        ULong fileNum = fileNums[i];
        if (fileNum == MASTERFILE) masterCount++;
        else refCount++;
        //if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL)) ;
        //mdlSelection_addKierunek(fileNums[i], offsets[i]);
    }
    mdlSystem_stopBusyCursor();
    sprintf(_msg, "photoarrow: %d master, %d ref", masterCount, refCount);
    mdlLogger_info(_msg);
    mdlLogger_info("photoarrow: end");
    return TRUE;
}

int mdlSelection_addKierunek(ModelNumber fileNum, ULong filePos) {
    //NumerPlikuDgn numerPliku = MASTERFILE;
    MSElementDescr* edP = NULL;
    int typObiektu;
    int masterCount = 0, refCount = 0;
    if (0 == mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL));
    if (fileNum == MASTERFILE) masterCount++;
    else refCount++;
    //if (!obiektDgn_wczytajAtrybuty(edP, fileNum, &typObiektu, NULL, NULL, NULL, NULL)) return FALSE;
    //if (obiektDgn_jestTekstem(typObiektu)) argP->nTeksty++;
    //else if (obiektDgn_jestSymbolem(typObiektu)) argP->nSymbole++;
    //else if (obiektDgn_jestObszarem(typObiektu)) argP->nObszary++;
    //else argP->nInneObiekty++;
    //argP->nObiekty++;
    mdlElmdscr_freeAll(&edP);
    return TRUE;
}

Public cmdName void cmd_photoHelp(char* unparsedP) cmdNumber CMD_PHOTOARROW_HELP {
    mdlLogger_info("photoarrow help/about");
    mdlLogger_info("photoarrow v1.0-beta");
    //dgnView_skanujMasterFile(centymetry);
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
    int okSlots = getRefCount(); //int references = mdlRefFile_getRefCount();
    char msg[256];
    sprintf(msg, "photoarrow references: %d ok slot[s]", okSlots);
    mdlLogger_info(msg);
    return;
}

int getRefCount() {
    int paramFileFound;
    int slot = 1;
    int okSlots = 0;
    int badSlots = 0;
    //int mdlRefFile_getParameters(void *param, int paramName, int refSlot);
    while (mdlRefFile_getParameters(&paramFileFound, REFERENCE_FILENOTFOUND, slot) != MDLERR_BADSLOT) {
        if (paramFileFound) okSlots++;
        else badSlots++;
        slot++;
    }
    return okSlots;
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
    FILE* file = NULL;
    char staryTekst[512], nowyTekst[512];

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
    sprintf(msg, "photoarrow: init");
    mdlLogger_info(msg);
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
            /*if (dgnText_dodajCentymetry(edP, centymetry, staryTekst, nowyTekst)) {
                teksty++;
                sprintf(msg, "%s\t%s", staryTekst, nowyTekst);
                file = mdlFile_logWrite(msg, file, FALSE);
            } else {
                sprintf(msg, "%s\tTO NIE JEST WYSOKOŚĆ", staryTekst);
                file = mdlFile_logWrite(msg, file, FALSE);
            }*/
            mdlElmdscr_freeAll(&edP);
        }
    } while (status == BUFF_FULL);
    //file = mdlFile_logWrite("KONIEC", file, TRUE);
    sprintf(msg, "photoarrow: %d/%d", teksty, obiekty);
    mdlLogger_info(msg);
    mdlView_updateSingle(tcb->lstvw);
    return SUCCESS;
}

int dgnText_dodajCentymetry(MSElementDescr* edP, int centymetry, char* staryTekst, char* nowyTekst) {
    MSElement el;
    char text[256], newText[256], format[256], c;
    double metryTekstu = 0.0;
    double metry = centymetry / 100.0;
    int i = 0, czyZnakLiczbowy = 0, liczbaKropek = 0, length = 0, ostatniaKropka = 0;
    int precyzja = _precyzja;
    if (TEXT_ELM != mdlElement_getType(&edP->el)) return FALSE; //To nie jest tekst
    if (SUCCESS != mdlText_extract(NULL, NULL, NULL, NULL, text, NULL, NULL, NULL, NULL, NULL, &edP->el)) return FALSE;
    length = strlen(text);
    if (length >= 256) return FALSE;
    strcpy(staryTekst, text);
    strcpy(nowyTekst, text);
    for (i = 0; i < length; i++) {
        c = text[i];
        if (c == ',') {
            c = '.';
            text[i] = c; //Zamienić przecinki na kropki
        }
        if (c == '.') {
            liczbaKropek++;
            ostatniaKropka = i; //Zapamiętujemy położenie ostatniej kropki, aby wyznaczyć później precyzję zaokrąglenia
        }
        czyZnakLiczbowy = (c >= '0' && c <= '9') || c == '.' || c == ' ';
        if (!czyZnakLiczbowy) return FALSE; //Nie ruszać tekstów zawierających litery
    }
    if (liczbaKropek != 1) return FALSE; //To musi być liczba zmiennoprzecinkowa
    if (1 != sscanf(text, "%f", &metryTekstu)) return FALSE; //To nie jest liczba
    metryTekstu += metry;
    if (_precyzja < 0) { //Automatyczne określenie precyzji
        precyzja = 0;
        for (i = ostatniaKropka + 1; i < length; i++) {
            c = text[i];
            czyZnakLiczbowy = c >= '0' && c <= '9';
            if (c >= '0' && c <= '9') {
                precyzja++;
            }
        }
        //precyzja = length - ostaniaKropka - 1;
    } else {
        precyzja = _precyzja;
    }
    sprintf(format, "%%.%df", precyzja); //Zaokrąglenie do centymetrów
    sprintf(newText, format, metryTekstu);
    if (SUCCESS != mdlText_create(&el, &edP->el, newText, NULL, NULL, NULL, NULL, NULL)) return FALSE;
    //mdlElement_rewrite(&el, &edP->el, mdlElmdscr_getFilePos(edP));
    strcpy(nowyTekst, newText);
    return TRUE;
}
