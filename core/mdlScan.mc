#include "mdlScan.h"
#include "mdlElement.h"
#include "mdlText.h"
#include "..\app\mdlUtil.h"

int plikDgn_skanujPlik(int (*plikDgn_skanujPlikFunc)(MSElementDescr* edP, void* argP), void* argP) {
    //char  msg[256];
    ULong scanBuf[256];
    int scanSize = sizeof scanBuf;
    int status;
#if MSVERSION >= 0x790
    ULong eofBlock;
#else
    int eofBlock, eofByte;
#endif
    Scanlist scanList;

    if (plikDgn_skanujPlikFunc == NULL)
        return FALSE;

    mdlScan_initScanlist(&scanList);
    mdlScan_noRangeCheck(&scanList);

    scanList.extendedType = FILEPOS | ITERATEFUNC;

    /* 0 - MASTERFILE, 1, 2,... - pliki referencyjne */
    mdlScan_initialize(MASTERFILE, &scanList);

    scanSize = sizeof (scanBuf) / sizeof (short);

    mdlSystem_startBusyCursor();

#if MSVERSION >= 0x790
    status = mdlScan_extended(scanBuf, &scanSize, &eofBlock, plikDgn_skanujPlikFunc, argP);
#else
    status = mdlScan_extended(scanBuf, &scanSize, &eofBlock, &eofByte, plikDgn_skanujPlikFunc, argP);
#endif

    mdlSystem_stopBusyCursor();

    return status == SUCCESS;
}

int plikDgn_skanujPlikPolicz(MSElementDescr* edP, void* vargP) {
    PlikDgnSkanowanie* argP = (PlikDgnSkanowanie*) vargP;
    ModelNumber numerPliku = MASTERFILE; //skanujemy tylko plik g��wny
    int typObiektu;

    if (element_readAttributes(edP, numerPliku, &typObiektu, NULL, NULL, NULL, NULL)) {
        if (element_isText(typObiektu))
            argP->nTeksty++;
        else
            if (obiektDgn_isSymbol(typObiektu))
            argP->nSymbole++;
        else
            if (obiektDgn_jestObszarem(typObiektu))
            argP->nObszary++;
        else
            argP->nInneObiekty++;

        argP->nObiekty++;
    }

    return SUCCESS;
}

int plikDgnSkanowanie_inicjuj(PlikDgnSkanowanie* argP) {
    if (argP == NULL)
        return FALSE;

    argP->nObiekty = 0;
    argP->nInneObiekty = 0;

    argP->nTeksty = 0;
    argP->nSymbole = 0;
    argP->nObszary = 0;

    return TRUE;
}

int plikDgnSkanowanie_zwolnij(PlikDgnSkanowanie* argP) {
    if (argP == NULL)
        return FALSE;

    return TRUE;
}

int plikDgnSkanowanie_wczytaj(PlikDgnSkanowanie* argP) {
    if (argP == NULL)
        return FALSE;

    /* wczytaj atrybuty do pamieci */
    if (!plikDgn_skanujPlik(plikDgn_skanujPlikPolicz, argP)) {
        return FALSE;
    }
    if (SUCCESS == mdlView_updateSingle(tcb->lstvw));

    return TRUE;
}

int plikDgnSkanowanie_wypisz(PlikDgnSkanowanie* argP) {
    //char msg[256];

    if (argP == NULL)
        return FALSE;

    //sprintf(msg, "skanowanie: teksty %d, symbole %d, obszary %d, inne %d",
    //        argP->nTeksty, argP->nSymbole, argP->nObszary, argP->nInneObiekty);
    //mdlLogger_info(msg);

    return TRUE;
}
