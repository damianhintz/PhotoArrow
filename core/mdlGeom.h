#if !defined (H_MDL_GEOM)
#define H_MDL_GEOM
#include <mdl.h>
#include <basetype.h>
#include <mselems.h>
#include <msmisc.fdf>
#include <msregion.fdf>
#include <mselemen.fdf>
#include <stdio.h>
#include <stdlib.h>
#include <msvec.fdf>
#include <math.h>
#include <mdllib.fdf>
#include <mdlerrs.h>
#include <mselmdsc.fdf>
#include "..\def-v8.h"

int mdlGeom_zawieraPunkt(DPoint3d* punktP, DPoint3d* aPunkty, int nPunkty);
int mdlGeom_przecinajaObszary(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2);
int mdlGeom_obliczCentroid(DPoint3d* aPunkty, int nPunkty, DPoint3d* punktP);
DPoint3d* mdlGeom_pobierzPunkty(MSElementDescr* edP, ModelNumber filenum, int* nPunktyP);
DPoint3d* mdlGeom_pobierzPunktyKompleksu(MSElementDescr* edP, ModelNumber filenum, int* nPunktyP);
int mdlGeom_obliczPunktyKompleksu(MSElementDescr* edP, ModelNumber filenum, int* nPunktyP);
DPoint3d* mdlGeom_pobierzPunktyWszystkie(MSElementDescr* edP, ModelNumber filenum, int* nPunktyP);

int mdlGeom_porownaj(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja);
int geo_Identyczne(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja);
int geo_Przylegaja(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2);
int geo_PorownajN(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja);
int geo_Przecinaja(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2);

double mdlGeom_Intersect(MSElementDescr* edPewid, MSElementDescr* edPbud, ModelNumber modelRefP);

double mdlGeom_Min(double x, double y);
double mdlGeom_Max(double x, double y);
DPoint3d mdlGeom_Dif2D(DPoint3d* p1, DPoint3d* p2);
int mdlGeom_GeoOn(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk);
double mdlGeom_Dir2D(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk);
double mdlGeom_Dir3P(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk);
int mdlGeom_Int4P(DPoint3d* p1, DPoint3d* p2, DPoint3d* p3, DPoint3d* p4);

int mdlGeom_jestInt(DPoint3d* a, DPoint3d* b, DPoint3d* c);
int mdlGeom_SkalujKsztalt(DPoint3d* aPunkty, int nPunkty, double f_tol);

#endif
