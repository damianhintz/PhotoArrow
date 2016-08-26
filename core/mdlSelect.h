#if !defined (H_SELEKCJONOWANIE)
#define H_SELEKCJONOWANIE
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
#include <mselmdsc.fdf>
#include "..\def-v8.h"

typedef struct _ElementSelection {
    ModelNumber fileNum;
    ULong filePos;
} ElementSelection, *LpElementSelection;

typedef struct plikDgnSelekcja {
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

} PlikDgnSelekcja, *LpPlikDgnSelekcja;

int mdlSelection_init(PlikDgnSelekcja* argP);
int mdlSelection_free(PlikDgnSelekcja* argP);
int mdlSelection_summary(PlikDgnSelekcja* argP);
int mdlSelection_load(PlikDgnSelekcja* argP);
int mdlSelection_search(int (*plikDgn_selekcjaFunc)(ElementSelection* argP), void* argP);
int mdlSelection_count(ElementSelection* argP);

#endif
