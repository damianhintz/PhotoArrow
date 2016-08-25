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

int appView_zwolnij(AppView* avP) {
    if (avP == NULL)
        return FALSE;

    if (avP->aObiekty != NULL) {
        int i = 0;

        for (i = 0; i < avP->nObiekty; i++)
            appViewObiekt_zwolnij(&avP->aObiekty[i]);

        free(avP->aObiekty);
    }

    return TRUE;
}

int appView_wyczysc(AppView* avP) {
    int i = 0;

    if (avP == NULL)
        return FALSE;

    for (i = 0; i < avP->nObiekty; i++)
        appViewObiekt_zwolnij(&avP->aObiekty[i]);

    avP->nObiekty = 0;
    avP->nBiezacy = -1;

    return TRUE;
}

int appView_dodajObiekt(AppView* avP, DPoint3d* aPunkty, int nPunkty) {
    int nIndeks = 0;
    int i = 0;

    if (avP == NULL)
        return FALSE;

    nIndeks = avP->nObiekty;

    if (nIndeks >= avP->nObiektyMax)
        return FALSE;

    avP->aObiekty[nIndeks].aPunkty = (DPoint3d*) calloc(nPunkty, sizeof (DPoint3d));

    if (avP->aObiekty[nIndeks].aPunkty == NULL)
        return FALSE;

    for (i = 0; i < nPunkty; i++)
        avP->aObiekty[nIndeks].aPunkty[i] = aPunkty[i];

    avP->aObiekty[nIndeks].nPunkty = nPunkty;

    avP->nObiekty++;

    return TRUE;
}

int appView_dodajObiektZakres(AppView* avP, DPoint3d* aPunkty, int nPunkty, double vZakres) {
    int nIndeks = 0;
    int i = 0;

    if (avP == NULL)
        return FALSE;

    nIndeks = avP->nObiekty;

    if (nIndeks >= avP->nObiektyMax)
        return FALSE;

    avP->aObiekty[nIndeks].aPunkty = (DPoint3d*) calloc(nPunkty, sizeof (DPoint3d));

    if (avP->aObiekty[nIndeks].aPunkty == NULL)
        return FALSE;

    for (i = 0; i < nPunkty; i++)
        avP->aObiekty[nIndeks].aPunkty[i] = aPunkty[i];

    avP->aObiekty[nIndeks].nPunkty = nPunkty;
    avP->aObiekty[nIndeks].vZakres = vZakres;

    avP->nObiekty++;

    return TRUE;
}

int appView_pokaz(AppView* avP, int X, int W, int Y, int H) {
    //char msg[256];

    int nIndeks = 0;

    if (avP == NULL)
        return FALSE;

    if (avP->nObiekty < 1) //musi byc conajmniej jeden obiekt do narysowania
    {
        //mdlUtil_wypiszInfo ("brak obiektow");
        return FALSE;
    }

    nIndeks = avP->nBiezacy;

    if (avP->nBiezacy < 0 || avP->nBiezacy >= avP->nObiekty) {
        mdlLogger_info("indeks poza zakresem");
        return FALSE;
    }

    //sprintf (msg, "%d/%d (%d) %d punkty", avP->nBiezacy, avP->nObiekty, avP->nObiektyMax, avP->aObiekty[nIndeks].nPunkty);
    //mdlUtil_wypiszInfo (msg);

    //appView_rysuj (avP->aObiekty[nIndeks].aPunkty, avP->aObiekty[nIndeks].nPunkty, TRUE, 1, X, W, Y, H, TRUE);
    obiektDgn_rysujPunktyNaOknie(avP->aObiekty[nIndeks].aPunkty, avP->aObiekty[nIndeks].nPunkty, avP->aObiekty[nIndeks].vZakres, TRUE, 1, X, W, Y, H, TRUE);

    return TRUE;
}

int appView_nastepny(AppView* avP) {
    if (avP == NULL)
        return FALSE;

    if (++(avP->nBiezacy) >= avP->nObiekty)
        appView_pierwszty(avP);

    return TRUE;
}

int appView_poprzedni(AppView* avP) {
    if (avP == NULL)
        return FALSE;

    if (--(avP->nBiezacy) < 0)
        appView_ostatni(avP);

    return TRUE;
}

int appView_pierwszty(AppView* avP) {
    if (avP == NULL)
        return FALSE;

    avP->nBiezacy = 0;

    return TRUE;
}

int appView_ostatni(AppView* avP) {
    if (avP == NULL)
        return FALSE;

    avP->nBiezacy = avP->nObiekty - 1;

    return TRUE;
}

int appView_gotowy(AppView* avP) {
    //return avP->nBiezacy >= 0 && avP->nBiezacy < avP->nObiekty;
    return avP->nBiezacy >= 0 && avP->nObiekty > 0;
}
