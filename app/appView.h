#if !defined (H_APP_VIEW)
#define H_APP_VIEW
#include <msstate.fdf>
#include <mselmdsc.fdf>
#include <msview.fdf>
#include <msdarray.fdf>
#include <msselect.fdf>
#include <mslinkge.fdf>
#include <mselemen.fdf>
#include "..\def-v8.h"

typedef struct appViewObiekt {
    double vZakres; //poprawka do widoku (oddalenie widoku o vZakres metrow

    DPoint3d* aPunkty; //obszar do narysowania
    int nPunkty; //punkty obszaru

    DPoint3d* aPunktySkupienia; //punkty centralne na ktorych skupiany moze byc widok (np. w ramach dzialki moze byc kilka budynkow)
    int nPunktySkupienia;

    int bPomin;
    char sOpis[256];

} AppViewObiekt, *LpAppViewObiekt;

typedef struct appView {
    AppViewObiekt* aObiekty;
    int nObiekty;
    int nBiezacy;
    int nObiektyMax;
    int bView;

} AppView, *LpAppView;

/* Interfejs klasy appView */

int appView_inicjuj(AppView* avP);
int appView_zwolnij(AppView* avP);
int appView_wyczysc(AppView* avP);
int appView_gotowy(AppView* avP);

#endif
