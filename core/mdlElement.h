#if !defined (H_OBIEKT_DGN)
#define H_OBIEKT_DGN
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mselmdsc.fdf>
#include <msrmatrx.fdf>
#include <mdllib.fdf>
#include <mscell.fdf>
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <msmisc.fdf>
#include <mssystem.fdf>
#include <msscan.fdf>
#include <mswindow.fdf>
#include <msdialog.fdf>
#include <mselemen.fdf>
#include <msstring.fdf>
#include <ctype.h>
#include <msview.fdf>
#include <msscell.fdf>
#include <mstmatrx.fdf>
#include <msvec.fdf>
#include "..\def-v8.h"

int element_readAttributes(MSElementDescr *edP, ModelNumber modelRef, int* typeP, UInt32* levelP, UInt32* colorP, UInt32* weightP, Int32* styleP);

int obiektDgn_isSymbol(int elemType);
int obiektDgn_readSymbol(MSElementDescr *edP, char* name, DPoint3d* origin, ModelNumber modelRefP);
int obiektDgn_readSymbolAttributes(MSElementDescr* edP, ULong* levelP, UInt32* colorP, UInt32* weigthP, Int32* styleP);

int obiektDgn_jestObszarem(int elemType);
int obiektDgn_jestProsty(int elemType);
int obiektDgn_jestZlozony(int elemType);

int dgnCell_extractEllipse(MSElementDescr* edP, ModelNumber modelRefP, MSElementUnion* elipsa, double scale, DPoint3d* centerP, int* visible);
int dgnCell_extractRect(MSElementDescr* edP, ModelNumber modelRefP, MSElementUnion* prostokat, double scale, int* visible);

int obiektDgn_rysujPunktyNaOknie(DPoint3d* aPunkty, int nPunkty, double vZakres, int bDraw, int dialogId, int X, int W, int Y, int H, int bShow);
int obiektDgn_rysujPunktyNaWidoku(DPoint3d* aPunkty, int nPunkty, byte bParametry);

#endif
