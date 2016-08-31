#include "mdlGeom.h"
#include "mdlElement.h"

int mdlGeom_obliczCentroid(DPoint3d* aPunkty, int nPunkty, DPoint3d* punktP) {
    int i = 0;
    double x = 0.0, y = 0.0;

    if (aPunkty == NULL || punktP == NULL)
        return FALSE;

    if (nPunkty == 0)
        return FALSE;

    for (i = 0; i < nPunkty; i++) {
        x += aPunkty[i].x;
        y += aPunkty[i].y;
    }

    punktP->x = x / nPunkty;
    punktP->y = y / nPunkty;
    punktP->z = 0.0;

    return TRUE;
}

/* mdlGeom_zawieraPunkt - czy punkt jest wewn�trz obszaru punkt�w */
int mdlGeom_zawieraPunkt(DPoint3d* punktP, DPoint3d* aPunkty, int nPunkty) {
    if (punktP == NULL || aPunkty == NULL)
        return FALSE;

    return 1 == mdlPolygon_pointInside((double*) punktP, (double*) aPunkty, nPunkty, TRUE, 3, 0.01);
}

int mdlGeom_przecinajaObszary(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2) {
    int i;

    if (aPunkty1 == NULL || aPunkty2 == NULL)
        return FALSE;

    for (i = 0; i < nPunkty1; i++) {
        if (mdlGeom_zawieraPunkt(&aPunkty1[i], aPunkty2, nPunkty2)) {
            return TRUE;
        }
    }

    for (i = 0; i < nPunkty2; i++) {
        if (mdlGeom_zawieraPunkt(&aPunkty2[i], aPunkty1, nPunkty1)) {
            return TRUE;
        }
    }

    return FALSE;
}

DPoint3d* mdlGeom_pobierzPunkty(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    DPoint3d aPunkty[MAX_VERTICES];
    DPoint3d* aPunktyP = NULL;
    int nPunkty = 0;

    if (nPunktyP != NULL) {
        *nPunktyP = 999;

        if (edP == NULL)
            *nPunktyP = 1;
        if (nPunktyP == NULL)
            *nPunktyP = 3;
    }

    if (edP == NULL || nPunktyP == NULL)
        return NULL;

    if (SUCCESS == mdlLinear_extract(aPunkty, &nPunkty, &edP->el, modelRefP)) {
        int i = 0;
        int i1 = 0;
        int i2 = nPunkty;

        /* CURVE_ELM krzywa ma punkty ukryte na poczatku i koncu */
        if (CURVE_ELM == mdlElement_getType(&edP->el)) {
            i1 += 2;
            i2 -= 2;

            nPunkty -= 4;
        }

        *nPunktyP = nPunkty;
        aPunktyP = (DPoint3d*) calloc(nPunkty, sizeof (DPoint3d));

        if (aPunktyP) {
            for (i = i1; i < i2; i++) {
                aPunktyP[i - i1] = aPunkty[i];
            }
        }
    }

    return aPunktyP;
}

DPoint3d* mdlGeom_pobierzPunktyKompleksu(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    DPoint3d* aPunkty = NULL;
    DPoint3d* aPunktyTemp = NULL;
    int nPunktyTemp = 0;
    int nPunktyKompleksuP = 0;
    MSElementDescr* pComponent = NULL;

    if (edP == NULL || nPunktyP == NULL)
        return NULL;

    if (!mdlGeom_obliczPunktyKompleksu(edP, modelRefP, &nPunktyKompleksuP))
        return NULL;

    pComponent = edP->h.firstElem;
    *nPunktyP = 0;
    aPunkty = (DPoint3d*) calloc(nPunktyKompleksuP + 1, sizeof (DPoint3d));

    if (aPunkty == NULL)
        return NULL;

    while (pComponent) {
        int elemType = mdlElement_getType(&pComponent->el);

        if (obiektDgn_jestProsty(elemType)) {
            aPunktyTemp = NULL;
            nPunktyTemp = 0;
            aPunktyTemp = mdlGeom_pobierzPunkty(pComponent, modelRefP, &nPunktyTemp);

            if (aPunktyTemp != NULL) {
                int i = 0;
                for (i = 0; i < nPunktyTemp; i++)
                    aPunkty[(*nPunktyP)++] = aPunktyTemp[i];
                free(aPunktyTemp);
            }
        }
        pComponent = pComponent->h.next;
    }

    return aPunkty;
}

int mdlGeom_obliczPunktyKompleksu(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    DPoint3d* aPunktyTemp = NULL;
    int nPunktyTemp = 0;
    MSElementDescr* pComponent = NULL;

    if (edP == NULL || nPunktyP == NULL)
        return FALSE;

    pComponent = edP->h.firstElem;
    *nPunktyP = 0;

    while (pComponent) {
        int elemType = mdlElement_getType(&pComponent->el);

        if (obiektDgn_jestProsty(elemType)) {
            aPunktyTemp = NULL;
            nPunktyTemp = 0;
            aPunktyTemp = mdlGeom_pobierzPunkty(pComponent, modelRefP, &nPunktyTemp);

            if (aPunktyTemp) {
                (*nPunktyP) += nPunktyTemp;
                free(aPunktyTemp);
            }
        }
        pComponent = pComponent->h.next;
    }

    return TRUE;
}

DPoint3d* mdlGeom_pobierzPunktyWszystkie(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    if (obiektDgn_jestZlozony(mdlElement_getType(&edP->el))) {
        return mdlGeom_pobierzPunktyKompleksu(edP, modelRefP, nPunktyP);
    } else {
        return mdlGeom_pobierzPunkty(edP, modelRefP, nPunktyP);
    }
}

/* geo_Porownaj */
int mdlGeom_porownaj(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja) {
    int i, j;
    int takieSame = TRUE;
    int n = 0;
    //if (nPunkty1 != nPunkty2)
    //	return FALSE;

    for (i = 0; i < nPunkty1; i++) {
        int jest = FALSE;

        for (j = 0; j < nPunkty2; j++) {
            if (mdlVec_distance(&aPunkty1[i], &aPunkty2[j]) < fTolerancja) {
                jest = TRUE;
                n++;
                break;
            }
        }

        if (jest == FALSE) {
            takieSame = FALSE;
            break;
        }
    }

    return takieSame;
}

/* geo_Porownaj */
int geo_PorownajN(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja) {
    int i, j;
    int n = 0;

    for (i = 0; i < nPunkty1; i++) {
        for (j = 0; j < nPunkty2; j++) {
            if (mdlVec_distance(&aPunkty1[i], &aPunkty2[j]) < fTolerancja) {
                n++;
                break;
            }
        }
    }

    return n > 1;
}

/* geo_Identyczne */
int geo_Identyczne(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2, double fTolerancja) {
    int i;

    if (nPunkty1 != nPunkty2) {
        return FALSE;
    }

    for (i = 0; i < nPunkty1; i++) {
        double dist = 0.0;
        if ((dist = mdlVec_distance(&aPunkty1[i], &aPunkty2[i])) > fTolerancja) {
            return FALSE;
        }
    }

    return TRUE;
}

/* geo_Przylegaja */
int geo_Przylegaja(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2) {
    int i;
    int n = 0;

    for (i = 0; i < nPunkty1; i++) {
        if (mdlGeom_zawieraPunkt(&aPunkty1[i], aPunkty2, nPunkty2)) {
            n++;
        }
    }

    return n > 1;
}

int geo_Przecinaja(DPoint3d* aPunkty1, int nPunkty1, DPoint3d* aPunkty2, int nPunkty2) {
    int i;

    for (i = 0; i < nPunkty1; i++) {
        if (mdlGeom_zawieraPunkt(&aPunkty1[i], aPunkty2, nPunkty2)) {
            return TRUE;
        }
    }

    for (i = 0; i < nPunkty2; i++) {
        if (mdlGeom_zawieraPunkt(&aPunkty2[i], aPunkty1, nPunkty1)) {
            return TRUE;
        }
    }

    return FALSE;
}

double GeoDir(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk) {
    DPoint3d a, b;
    mdlVec_subtractPoint(&a, pk, pi);
    mdlVec_subtractPoint(&b, pj, pi);
    //angle = acos(v1�v2)
    mdlVec_computeNormal(&a, pk, pi); //p3-p1 i norm
    mdlVec_computeNormal(&b, pj, pi); //p3-p1 i norm
    //return GeoMul(&a, &b);
    return (acos(mdlVec_dotProduct(&a, &b)) * 180) / 3.1415;
}

int scan_checkElement3(DPoint3d* pts, int numpts) {
    DPoint3d *p1, *p2, *p3;
    int i;
    double angle, dist12, dist23, lensum;

    if (pts != NULL && numpts > 3) {
        p1 = &pts[0];
        p2 = &pts[1];
        p3 = &pts[2];

        angle = fabs(GeoDir(p1, p2, p3));
        dist12 = mdlVec_distance(p1, p2);
        dist23 = mdlVec_distance(p2, p3);

        lensum = dist12;

        for (i = 2; i < numpts; i++) {
            p1 = &pts[i - 2];
            p2 = &pts[i - 1];
            p3 = &pts[i - 0];

            angle = fabs(GeoDir(p1, p2, p3));
            dist12 = mdlVec_distance(p1, p2);
            dist23 = mdlVec_distance(p2, p3);

            if (angle < 1.0) {
                //punkty sa na prostej
                lensum += dist23;
            } else {
                //zalamanie budynku
                if (lensum < mdlCnv_masterUnitsToUors(4.0))
                    return TRUE;

                lensum = dist12;
            }
        }
    }
    return FALSE;
}

int scan_checkElement(DPoint3d* pts, int numpts, int* a, int* b) {
    DPoint3d *p1, *p2, *p3;
    int i, j;
    double angle, lensum;
    int pZal[MAX_VERTICES]; //zalamania
    int nZal;

    if (pts != NULL && numpts > 3) {
        nZal = 0;

        /* pierwsze zalamanie moze byc na samym poczatku, miedzy n;0;1 */
        p1 = &pts[numpts - 1];
        p2 = &pts[0];
        p3 = &pts[1];

        angle = fabs(GeoDir(p1, p2, p3));

        if (angle > 1.0)
            pZal[nZal++] = 0;

        for (i = 2; i < numpts; i++) {
            p1 = &pts[i - 2];
            p2 = &pts[i - 1];
            p3 = &pts[i - 0];

            angle = fabs(GeoDir(p1, p2, p3));

            if (angle > 1.0) //zalamanie
                pZal[nZal++] = i - 1;
        }

        /* sprawdzanie zalaman 0;1 1;2 n-1;n */
        for (i = 1; i < nZal; i++) {
            lensum = 0.0;
            for (j = pZal[i - 1] + 1; j <= pZal[i]; j++) {
                lensum += mdlVec_distance(&pts[j - 1], &pts[j]);
            }

            if (lensum < mdlCnv_masterUnitsToUors(4.0)) {
                *a = pZal[i - 1];
                *b = pZal[i];
                return TRUE;
            }
        }

        /* teraz trzeba sprawdzic jeszcze zalamanie miedzy n i 0 */
        /* odleglosc od zalamania 0 do punktu 0 */
        lensum = 0.0;
        for (j = pZal[nZal - 1] + 1; j < numpts; j++) {
            lensum += mdlVec_distance(&pts[j - 1], &pts[j]);
        }
        /* odleglosc od zalamania n do punktu 0 */
        for (j = 1; j <= pZal[0]; j++) {
            lensum += mdlVec_distance(&pts[j - 1], &pts[j]);
        }

        if (lensum < mdlCnv_masterUnitsToUors(4.0)) {
            *a = pZal[0];
            *b = pZal[nZal - 1];
            return TRUE;
        }
    }
    return FALSE;
}

double mdlGeom_Intersect(MSElementDescr* edPewid, MSElementDescr* edPbud, ModelNumber modelRefP) {
    MSElementDescr* edPint;
    double tolerancja = 1.0;
    int status;
    double perimeter = 0.0;
    double nachodzenie = 0.0;

    DPoint3d* a_budPunkty = NULL;
    int n_budPunkty;
    double f_budPole;

    DPoint3d* a_intPunkty;
    int n_intPunkty;
    double f_intPole;

    tolerancja = mdlCnv_masterUnitsToUors(0.10);

    /* budynek powinien nie miec w srodku komorki adres */
    a_budPunkty = mdlGeom_pobierzPunktyWszystkie(edPbud, modelRefP, &n_budPunkty);

    /* oblicz pole budynku */
    if (SUCCESS == mdlMeasure_polygonArea(&f_budPole, &perimeter, a_budPunkty, n_budPunkty)) {
        /* oblicz pole nachodzenia budynku na ewidencje */
        if (SUCCESS == (status = mdlElmdscr_intersectShapes(&edPint, NULL, edPbud, edPewid, tolerancja))) {
            a_intPunkty = mdlGeom_pobierzPunktyWszystkie(edPint, modelRefP, &n_intPunkty);

            if (SUCCESS == mdlMeasure_polygonArea(&f_intPole, &perimeter, a_intPunkty, n_intPunkty)) {
                nachodzenie = f_intPole * 100.0 / f_budPole;
            } else {
                nachodzenie = -1.0; //nie mozna obliczyc pola nachodzenia
            }
            mdlElmdscr_freeAll(&edPint);
        } else {
            if (status == MDLERR_NULLSOLUTION) {
                nachodzenie = 0.0;
            } else {
                nachodzenie = -1.0;
            }
        }
    } else {
        nachodzenie = -1.0; //nie mozna obliczyc pola budynku
    }
    return nachodzenie;
}

/* iloczyn dwoch wektorow */
double mdlGeom_Mul2D(DPoint3d* p1, DPoint3d* p2) {
    return p1->x * p2->y - p2->x * p1->y;
}

/* ronica dwoch wektorow */
DPoint3d mdlGeom_Dif2D(DPoint3d* p1, DPoint3d* p2) {
    DPoint3d p3;
    p3.x = p1->x - p2->x;
    p3.y = p1->y - p2->y;
    return p3;
}

/* oblicz kat w stopniach miedzy trzema punktami */
double mdlGeom_Dir2D(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk) {
    DPoint3d a, b;
    double zi, zj, zk;

    zi = pi->z;
    zj = pj->z;
    zk = pk->z;

    pi->z = pj->z = pk->z = 0.0;

    mdlVec_subtractPoint(&a, pk, pj);
    mdlVec_subtractPoint(&b, pi, pj);

    mdlVec_computeNormal(&a, pk, pj); //p3-p1 i norm
    mdlVec_computeNormal(&b, pi, pj); //p3-p1 i norm

    pi->z = zi;
    pj->z = zj;
    pk->z = zk;

    //a*b = |a|*|b|*cos (angle a,b)
    //acos -> [0,PI]
    return fabs((acos(mdlVec_dotProduct(&a, &b)) * 180) / 3.1415);
}

/* w lewo czy w prawo */
double mdlGeom_Dir3P(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk) {
    DPoint3d a, b;

    mdlVec_subtractPoint(&a, pk, pi);
    mdlVec_subtractPoint(&b, pj, pi);

    return mdlGeom_Mul2D(&a, &b);
}

double mdlGeom_Min(double x, double y) {
    return x < y ? x : y;
}

double mdlGeom_Max(double x, double y) {
    return x > y ? x : y;
}

int mdlGeom_GeoOn(DPoint3d* pi, DPoint3d* pj, DPoint3d* pk) {
    if (mdlGeom_Min(pi->x, pj->x) <= pk->x && pk->x <= mdlGeom_Max(pi->x, pj->x) && mdlGeom_Min(pi->y, pj->y) <= pk->y && pk->y <= mdlGeom_Max(pi->y, pj->y))
        return TRUE;
    else
        return FALSE;
}

/* czy odcinki p1,p2 i p2,p4 przecinaja sie */
int mdlGeom_Int4P(DPoint3d* p1, DPoint3d* p2, DPoint3d* p3, DPoint3d* p4) {
    double d1 = mdlGeom_Dir3P(p3, p4, p1);
    double d2 = mdlGeom_Dir3P(p3, p4, p2);
    double d3 = mdlGeom_Dir3P(p1, p2, p3);
    double d4 = mdlGeom_Dir3P(p1, p2, p4);

    double e = 0.001;

    int d10 = (d1 > -e && d1 < e);
    int d20 = (d2 > -e && d2 < e);
    int d30 = (d3 > -e && d3 < e);
    int d40 = (d4 > -e && d4 < e);

    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
        return TRUE;
    } else
        if (d10 && mdlGeom_GeoOn(p3, p4, p1))
        return TRUE;
    else
        if (d20 && mdlGeom_GeoOn(p3, p4, p2))
        return TRUE;
    else
        if (d30 && mdlGeom_GeoOn(p1, p2, p3))
        return TRUE;
    else
        if (d40 && mdlGeom_GeoOn(p1, p2, p4))
        return TRUE;
    else
        return FALSE;
}

int mdlElem_jestInt(DPoint3d* a, DPoint3d* b, DPoint3d* c) {
    double ab = mdlCnv_uorsToMasterUnits(mdlVec_distance(a, b));
    double ac = mdlCnv_uorsToMasterUnits(mdlVec_distance(a, c));
    double bc = mdlCnv_uorsToMasterUnits(mdlVec_distance(b, c));

    return ac <= ab && bc <= ab;
}

int mdlGeom_ObliczWektor(DPoint3d* a, DPoint3d* b, DPoint3d* c, DPoint3d* v, double f_tol) {
    DPoint3d n1, n2;

    mdlVec_computeNormal(&n1, a, b);
    mdlVec_computeNormal(&n2, c, b);

    //mdlVec_scaleInPlace (&n1, f_tol);
    //mdlVec_scaleInPlace (&n2, f_tol);

    mdlVec_scale(&n1, &n1, f_tol);
    mdlVec_scale(&n2, &n2, f_tol);

    //mdlVec_addInPlace (&n1, &n2);
    mdlVec_addPoint(v, &n1, &n2);

    return TRUE;
}

/* otwarty ksztalt */
int mdlGeom_SkalujKsztalt(DPoint3d* aPunkty, int nPunkty, double f_tol) {
    DPoint3d aWektory[MAX_VERTICES];
    DPoint3d* a = NULL;
    DPoint3d* b = NULL;
    DPoint3d* c = NULL;
    int i = 0;

    if (aPunkty == NULL || nPunkty < 3)
        return FALSE;

    a = &aPunkty[nPunkty - 1];
    b = &aPunkty[0];
    c = &aPunkty[1];

    mdlGeom_ObliczWektor(a, b, c, &aWektory[0], f_tol);

    for (i = 2; i < nPunkty; i++) {
        a = &aPunkty[i - 2];
        b = &aPunkty[i - 1];
        c = &aPunkty[i - 0];

        mdlGeom_ObliczWektor(a, b, c, &aWektory[i - 1], f_tol);
    }

    a = &aPunkty[nPunkty - 2];
    b = &aPunkty[nPunkty - 1];
    c = &aPunkty[0];

    mdlGeom_ObliczWektor(a, b, c, &aWektory[nPunkty - 1], f_tol);

    for (i = 0; i < nPunkty; i++) {
        //mdlVec_addInPlace (&aPunkty[i], &aWektory[i]);
        mdlVec_addPoint(&aPunkty[i], &aPunkty[i], &aWektory[i]);
    }
    return TRUE;
}
