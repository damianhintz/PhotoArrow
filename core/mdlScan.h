#if !defined (H_SKANOWANIE_DGN)
#define H_SKANOWANIE_DGN
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mssystem.fdf>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <mselemen.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <msmisc.fdf>
#include <scanner.h>
#include <msscan.fdf>
#include <msselect.fdf>
#include <msview.fdf>
#include "..\def-v8.h"

/* Sekcja DGN - wczytywanie pliku do pamieci */
typedef struct plikDgnObiekt {
    int filepos;
    int filenum;

} PlikDgnObiekt;

/* plikDgnSkanowanie - skanowanie pliku dgn */
typedef struct plikDgnSkanowanie {
    int nObiekty;
    int nInneObiekty;
    int bSelekcjonowanie;

    int bTeksty;
    int nTeksty;
    void* aTeksty;

    int bSymbole;
    int nSymbole;
    void* aSymbole;

    int bLinie;
    int bLinie;
    void* aLinie;

    int bObszary;
    int nObszary;
    void* aObszary;

} PlikDgnSkanowanie, *LpPlikSkanowanie;

int plikDgnSkanowanie_inicjuj(PlikDgnSkanowanie* argP);
int plikDgnSkanowanie_zwolnij(PlikDgnSkanowanie* argP);
int plikDgnSkanowanie_wczytaj(PlikDgnSkanowanie* argP);
int plikDgnSkanowanie_wypisz(PlikDgnSkanowanie* argP);

int plikDgn_skanujObiekty(int bTeksty, int bSymbole, int bLinie, int bObszary);
int plikDgn_skanujTeksty();
int plikDgn_skanujSymbole();
int plikDgn_skanujLinie();
int plikDgn_skanujObszary();

int plikDgn_skanujPlik(int (*plikDgn_skanujPlikFunc)(MSElementDescr* edP, void* vargP), void* argP);
int plikDgn_skanujPlikPolicz(MSElementDescr* edP, void* vargP);

#endif
