#include "appView.h"
#include "mdlUtil.h"
#include "..\core\mdlElement.h"

int appViewObiekt_inicjuj(AppViewObiekt* oP) {
    if (oP == NULL)
        return FALSE;

    oP->aPunkty = NULL;
    oP->nPunkty = 0;
    oP->vZakres = 0.0;
    strcpy(oP->sOpis, "");

    return TRUE;
}

int appViewObiekt_zwolnij(AppViewObiekt* oP) {
    if (oP == NULL)
        return FALSE;

    if (oP->aPunkty != NULL)
        free(oP->aPunkty);

    return TRUE;
}

int appView_inicjuj(AppView* avP) {
    int i = 0;

    if (avP == NULL)
        return FALSE;

    avP->bView = FALSE;
    avP->nBiezacy = -1;
    avP->nObiektyMax = 1024;
    avP->nObiekty = 0;
    avP->aObiekty = (AppViewObiekt*) calloc(avP->nObiektyMax, sizeof (AppViewObiekt));

    if (avP->aObiekty == NULL)
        return FALSE;

    for (i = 0; i < avP->nObiektyMax; i++)
        appViewObiekt_inicjuj(&avP->aObiekty[i]);

    return TRUE;
}

int appView_gotowy(AppView* avP) {
    //return avP->nBiezacy >= 0 && avP->nBiezacy < avP->nObiekty;
    return avP->nBiezacy >= 0 && avP->nObiekty > 0;
}
