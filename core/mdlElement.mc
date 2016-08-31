#include "mdlElement.h"
#include "mdlGeom.h"

int element_readAttributes(MSElementDescr *edP,
        ModelNumber modelRef,
        int* typeP,
        UInt32* levelP,
        UInt32* colorP,
        UInt32* weightP,
        Int32* styleP) {
    int status = TRUE, type;
    UInt32 level;
    if (edP == NULL) return FALSE;
    type = mdlElement_getType(&edP->el);
    if (typeP != NULL) *typeP = type;
    mdlElement_getProperties(&level, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &edP->el);
    if (colorP != NULL) mdlElement_getSymbology(colorP, weightP, styleP, &edP->el);
#if MSVERSION >= 0x790
    {
        ULong kod;
        if (SUCCESS == mdlLevel_getCode(&kod, modelRef, level)) {
            if (levelP != NULL) *levelP = kod;
            status = TRUE;
        } else status = FALSE;
    }
#else
    if (levelP != NULL) *levelP = level;
#endif
    return status;
}

int obiektDgn_jestProsty(int elemType) {
    switch (elemType) {
        case LINE_ELM:
        case LINE_STRING_ELM:
        case SHAPE_ELM:
        case CURVE_ELM:
            //case ARC_ELM: tory moga byc robione lukiem ale trzeba uzyc mdlArc_extract
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_jestZlozony(int elemType) {
    switch (elemType) {
        case CMPLX_SHAPE_ELM:
        case CMPLX_STRING_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_isSymbol(int elemType) {
    switch (elemType) {
        case CELL_HEADER_ELM:
        case SHARED_CELL_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_jestObszarem(int elemType) {
    switch (elemType) {
        case LINE_STRING_ELM:
        case SHAPE_ELM:
        case CURVE_ELM:
        case CMPLX_STRING_ELM:
        case CMPLX_SHAPE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_readSymbol(MSElementDescr *edP, char* name, DPoint3d* origin, ModelNumber modelRefP) {
    MSWChar cellName[MAX_CELLNAME_LENGTH];
    int status = ERROR;
    int type = mdlElement_getType(&edP->el);

    switch (type) {
        case CELL_HEADER_ELM:

#if MSVERSION >= 0x790
            status = mdlCell_extract(origin, NULL, NULL, NULL, cellName, MAX_CELLNAME_LENGTH, &edP->el);
            if (status == SUCCESS) {
                if (name != NULL)
                    wcstombs(name, cellName, MAX_CELLNAME_LENGTH);
            }
#else
            status = mdlCell_extract(origin, NULL, NULL, NULL, cellName, &edP->el);
            if (name != NULL)
                strcpy(name, cellName);
#endif

            break;
        case SHARED_CELL_ELM:
        {
            SCOverride* override = NULL;

#if MSVERSION >= 0x790
            status = mdlSharedCell_extract(origin, NULL, NULL, NULL, override, cellName, MAX_CELLNAME_LENGTH, &edP->el, modelRefP);
            if (status == SUCCESS) {
                if (name != NULL)
                    wcstombs(name, cellName, MAX_CELLNAME_LENGTH);
            }
#else
            status = mdlSharedCell_extract(origin, NULL, NULL, NULL, cellName, override, &edP->el, modelRefP);
            if (name != NULL)
                strcpy(name, cellName);
#endif

        }
            break;
        default:
            break;
    }

    return status == SUCCESS;
}

int obiektDgn_readSymbolAttributes(MSElementDescr* edP, ULong* levelP, UInt32* colorP, UInt32* weigthP, Int32* styleP) {
    MSElementDescr* pComponent = NULL;

    if (edP == NULL)
        return FALSE;

    if (levelP != NULL) {
#if MSVERSION >= 0x790

        BitMask* mask;

        mdlBitMask_create(&mask, FALSE);

        if (SUCCESS == mdlElmdscr_getUsedLevels(mask, edP))
            *levelP = mdlBitMask_getNumValidBits(mask);
        else
            *levelP = 0;

        mdlBitMask_free(&mask);

#endif
    }

    pComponent = edP->h.firstElem;

    while (pComponent) {
        mdlElement_getSymbology(colorP, weigthP, styleP, &pComponent->el);
        pComponent = pComponent->h.next;

        return TRUE;
    }

    return FALSE;
}

int mdlElem_offset(MSElementDescr* edP, ModelNumber modelRefP, ULong filePos, DPoint3d* offset, Transform* tMatrix) {
    //mdlElement_offset  (&edP->el, &edP->el, &offset);

    mdlTMatrix_getIdentity(tMatrix);
    mdlTMatrix_setTranslation(tMatrix, offset);
    mdlTMatrix_translate(tMatrix, NULL, offset->x, offset->y, offset->z);
    mdlElmdscr_transform(edP, tMatrix);

#if MSVERSION >= 0x790
    filePos = mdlElmdscr_getFilePos(edP);
#endif

    mdlElmdscr_rewrite(edP, edP, filePos);
    mdlView_updateSingle(tcb->lstvw);

    return SUCCESS;
}

int mdlElem_tekstAdd(DPoint3d* punkt, char* tekst) {
    MSElement el;
    TextSizeParam size;

    size.mode = TXT_BY_TILE_SIZE;
    size.size.height = mdlCnv_masterUnitsToUors(0.5);
    size.size.width = mdlCnv_masterUnitsToUors(0.5);
    size.aspectRatio = 1;

    if (SUCCESS == mdlText_create(&el, NULL, tekst, punkt, &size, NULL, NULL, NULL)) {
        mdlElement_add(&el);
        return TRUE;
    }

    return FALSE;
}

/* dgnCell_extractEllipse - utworzenie pomniejszonej elipsy z celki */
int dgnCell_extractEllipse(MSElementDescr* edP, ModelNumber modelRefP, MSElementUnion* elipsa, double scale, DPoint3d* centerP, int* visible) {
    MSElementDescr* pComponent = NULL;
    int bElipsa = FALSE;
    DPoint3d startEndPts[2];
    double start;
    double sweep;
    double axis1;
    double axis2;
    RotMatrix rotMatrix;
    DPoint3d center;
    //int fillMode = 0; //not filled

    if (edP == NULL)
        return FALSE;

    pComponent = edP->h.firstElem;

    while (pComponent) {
        MSElementUnion* el = &pComponent->el;
        int elemType = mdlElement_getType(el);

        if (ELLIPSE_ELM == elemType) {
            if (SUCCESS != mdlArc_extract(startEndPts, &start, &sweep, &axis1, &axis2, &rotMatrix, &center, el)) {
                return FALSE;
            }

            axis1 -= scale;
            axis2 -= scale;

            if (centerP != NULL)
                *centerP = center;

            if (SUCCESS != mdlEllipse_create(elipsa, NULL, &center, axis1, axis2, &rotMatrix, 0)) {
                return FALSE;
            }

            bElipsa = TRUE;

            if (visible != NULL) {
                //ULong levelID;
#if MSVERSION >= 0x790
                *visible = mdlElement_isVisible(el);
#endif
                //mdlElement_getProperties (&levelID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, el);
                //*visible = !mdlLevel_isHidden (modelRefP, levelID);
            }

            return TRUE;
        }

        pComponent = pComponent->h.next;
    }

    return bElipsa;
}

int mdlElem_obliczZakres(DPoint3d* minp, DPoint3d* maxp, DPoint3d* pts, int numpts) {
    int i;

    minp->x = pts[0].x;
    minp->y = pts[0].y;
    minp->z = pts[0].z;
    maxp->x = 0;
    maxp->y = 0;
    maxp->z = 0;

    for (i = 0; i < numpts; i++) {
        if (pts[i].x < minp->x)
            minp->x = pts[i].x;

        if (pts[i].x > maxp->x)
            maxp->x = pts[i].x;

        if (pts[i].y < minp->y)
            minp->y = pts[i].y;

        if (pts[i].y > maxp->y)
            maxp->y = pts[i].y;

        if (pts[i].z < minp->z)
            minp->z = pts[i].z;

        if (pts[i].z > maxp->z)
            maxp->z = pts[i].z;
    }

    return TRUE;
}

int obiektDgn_rysujPunktyNaOknie(DPoint3d* aPunkty, int nPunkty, double vZakres, int bDraw, int dialogId, int X, int W, int Y, int H, int bShow) {
    DialogBox* dbP;
    BSIRect rP;
    RGBColorDef colorP;

    DPoint3d minp, maxp, origin, center, delta, viewRange[2];
    RotMatrix rMatrix;

    double activeZ;
    int i, x1, y1, x2 = 0, y2 = 0; //wspolrzedne punktu w ukladzie okna programu
    int dx = 3; //bufor 3 pikseli aby punkty nie wychodzily poza granice

    //ustawiamy parametry rysowania w oknie z uwzglednieniem bufora
    rP.origin.x = X - 3;
    rP.origin.y = Y - 3;
    rP.corner.x = X + W + 3;
    rP.corner.y = Y + H + 3;

    colorP.red = 0;
    colorP.green = 0;
    colorP.blue = 0;

    //obliczamy zakres obiektu
    mdlElem_obliczZakres(&minp, &maxp, aPunkty, nPunkty);

    //poprawki do widoku
    minp.x -= vZakres;
    minp.y -= vZakres;
    maxp.x += vZakres;
    maxp.y += vZakres;

    //pobieramy parametry biezacego widoku
    mdlView_getParameters(&origin, &center, &delta, &rMatrix, &activeZ, tcb->lstvw);

    //wyswietlamy w biezacym widoku obiekt
    if (bShow) {
        viewRange[0].x = minp.x - dx;
        viewRange[0].y = minp.y - dx;
        viewRange[1].x = maxp.x + dx;
        viewRange[1].y = maxp.y + dx;
        viewRange[0].z = viewRange[1].z = 0.0;

        mdlView_setArea(tcb->lstvw, viewRange, &viewRange[0], activeZ, activeZ - 1, NULL);
        mdlView_getParameters(&origin, &center, &delta, &rMatrix, &activeZ, tcb->lstvw);
    }

    if (bDraw == FALSE)
        return TRUE;

    dbP = mdlDialog_find(dialogId, NULL);

    if (dbP == NULL)
        return FALSE;

    //rysowanie obiektu w oknie programu

    mdlWindow_rectClear(dbP, &rP, NULL);
    mdlWindow_rectFillByRGB(dbP, &rP, &colorP, 0, NULL);
    mdlWindow_lineStyleSet(dbP, 0, mdlWindow_fixedColorIndexGet(dbP, GREEN_INDEX), 0, 0);

    for (i = 0; i < nPunkty; i++) {
        //przeliczamy wspolrzedne punktu na uklad okna programu
        x1 = (long) (X + W * ((aPunkty[i].x - minp.x) / (delta.x)));
        y1 = (long) ((Y + H) - H * ((aPunkty[i].y - minp.y) / (delta.y)));

        if (i == 0) //na pierwszym punkcie rysujemy czerwony okrag (wiekszy niz inne)
        {
            DPoint2d po;
            po.x = x1;
            po.y = y1;
            mdlWindow_lineStyleSet(dbP, 0, mdlWindow_fixedColorIndexGet(dbP, RED_INDEX), 0, 0);
            mdlWindow_ellipseDraw(dbP, &po, 3, 3, 0, NULL);
            x2 = x1;
            y2 = y1;
        } else //na innych punktach rysujemy troche mniejsze okregi
        {
            DPoint2d po;
            po.x = x1;
            po.y = y1;
            mdlWindow_lineStyleSet(dbP, 0, mdlWindow_fixedColorIndexGet(dbP, RED_INDEX), 0, 0);
            mdlWindow_ellipseDraw(dbP, &po, 1, 1, 0, NULL);
        }

        //rysujemy linie od punktu biezacego do poprzedniego
        mdlWindow_lineStyleSet(dbP, 0, mdlWindow_fixedColorIndexGet(dbP, GREEN_INDEX), 0, 0);
        mdlWindow_lineDraw(dbP, x2, y2, x1, y1, NULL);

        //zapamietujemy biezacy punkt
        x2 = x1;
        y2 = y1;
    }

    if (mdlView_updateSingle(tcb->lstvw));

    return TRUE;
}

int obiektDgn_rysujPunktyNaWidoku(DPoint3d* aPunkty, int nPunkty, byte bParametry) {
    int bKwadraty = FALSE, bKropki = TRUE, bZakres = FALSE, bKierunek = FALSE;
    DPoint3d p1, p2, pA, pB, p12;
    DPoint2d punkt;
    Point2d pX, pY, pZ;
    //DVec3d vec1, vecA, vecB;
    DPoint3d vec1, vecA, vecB;
    int i;

    Dpoint3d max, min;
    DPoint3d punkty[5];

    double r = mdlCnv_masterUnitsToUors(0.1);
    MSWindow* vwP = mdlWindow_viewWindowGet(tcb->lstvw);

    MSElementDescr* edPrange;

    max = aPunkty[0];
    min = aPunkty[0];
    pZ.x = pZ.y = 0;

    //rysowanie
    for (i = 0; i < nPunkty; i++) {
        p1 = aPunkty[i];

        if (bKropki) {
            if (i > 0)
                p2 = aPunkty[i - 1];
            else
                p2 = aPunkty[nPunkty - 1];

            if (p1.x > max.x)
                max.x = p1.x;
            if (p1.y > max.y)
                max.y = p1.y;
            if (p1.x < min.x)
                min.x = p1.x;
            if (p1.y < min.y)
                min.y = p1.y;

            //oblicz wektor prostej dw�ch kolejnych punkt�w i go znormalizuj
            mdlVec_computeNormal(&vec1, &p2, &p1);
            //skalowanie wektora prostej
            //mdlVec_scaleToLengthInPlace (&vec1, mdlCnv_masterUnitsToUors (0.5));
            mdlVec_scale(&vec1, &vec1, mdlCnv_masterUnitsToUors(0.5));

            //obliczenie punktu na prostej
            mdlVec_addPoint(&p12, &p1, &vec1);

            //obliczenie wektor�w prostopad�ych do wektora prostej
            vecA.x = vec1.y;
            vecA.y = -vec1.x;
            vecA.z = 0.0;
            vecB.x = -vec1.y;
            vecB.y = vec1.x;
            vecB.z = 0.0;

            //skalowanie obliczonych wektor�w prostopad�ych
            //mdlVec_scaleToLengthInPlace (&vecA, mdlCnv_masterUnitsToUors (0.25));
            mdlVec_scale(&vecA, &vecA, mdlCnv_masterUnitsToUors(0.25));
            //mdlVec_scaleToLengthInPlace (&vecB, mdlCnv_masterUnitsToUors (0.25));
            mdlVec_scale(&vecB, &vecB, mdlCnv_masterUnitsToUors(0.25));

            //obliczanie punkt�w prostopad�ych do punktu na prostej
            mdlVec_addPoint(&pA, &p12, &vecA);
            mdlVec_addPoint(&pB, &p12, &vecB);

            //konwertujemy obliczone punktu do uk�adu lokalnego widoku
            //zamiana wspolrzednych punktu (IN UORS) na wspolrzedne widoku (x w prawo, y w d�)
            //wzgledem okna widoku (lewy, g�rny naro�nik)
            if (SUCCESS != mdlView_pointToScreen(&pX, &pA, tcb->lstvw, VIEW_INLOCALCOORDS))
                continue;
            if (SUCCESS != mdlView_pointToScreen(&pY, &pB, tcb->lstvw, VIEW_INLOCALCOORDS))
                continue;
            if (SUCCESS != mdlView_pointToScreen(&pZ, &p1, tcb->lstvw, VIEW_INLOCALCOORDS))
                continue;

            punkt.x = pZ.x;
            punkt.y = pZ.y;

            //rysuj tekst dla x, y, z (kolor)
            //rysuj odleglosc miedzy punktami
            //rysuj pole, obwod (w srodku - centroid), numer

            mdlWindow_ellipseDraw(vwP, &punkt, 3.0, 3.0, 0.0, NULL);
        }

        if (bKwadraty) {
            punkty[0].x = p1.x - r;
            punkty[0].y = p1.y - r;

            punkty[1].x = p1.x + r;
            punkty[1].y = p1.y - r;

            punkty[2].x = p1.x + r;
            punkty[2].y = p1.y + r;

            punkty[3].x = p1.x - r;
            punkty[3].y = p1.y + r;

            punkty[4].x = p1.x - r;
            punkty[4].y = p1.y - r;

            if (SUCCESS == mdlElmdscr_createFromVertices(
                    &edPrange, /* <= line string or complex chain */
                    NULL, /* => template element (or NULL) */
                    punkty, /* => vertices */
                    5, /* => number of vertices */
                    TRUE, /* => TRUE for closed */
                    0)) /* => fill mode (if closed) */ {
                mdlElmdscr_add(edPrange);
                mdlElmdscr_displayInView(edPrange, MASTERFILE, NORMALDRAW, vwP);
            }
        }

        //mdlWindow_lineDraw (vwP, punkt.x, punkt.y, punkt.x+1, punkt.y+1, NULL);

        if (bKropki && bKierunek) {
            // wsp�rz�dnych target, base
            mdlVec_computeNormal(&pA, &pA, &p1);
            //mdlVec_scaleToLengthInPlace (&pA, 7);
            mdlVec_scale(&pA, &pA, 7);

            pX.x = (long) (pZ.x + pA.x);
            pX.y = (long) (pZ.y + pA.y);

            //rysowanie kierunku prostej

            //mdlWindow_lineDraw (vwP, pZ.x, pZ.y, pX.x, pX.y, NULL);
            mdlWindow_lineDraw(vwP, pZ.x, pZ.y, pY.x, pY.y, NULL);
        }
    }

    if (bKropki && bZakres) {
        punkty[0].x = min.x;
        punkty[0].y = min.y;

        punkty[1].x = max.x;
        punkty[1].y = min.y;

        punkty[2].x = max.x;
        punkty[2].y = max.y;

        punkty[3].x = min.x;
        punkty[3].y = max.y;

        punkty[4].x = min.x;
        punkty[4].y = min.y;

        if (SUCCESS == mdlElmdscr_createFromVertices(
                &edPrange, /* <= line string or complex chain */
                NULL, /* => template element (or NULL) */
                punkty, /* => vertices */
                5, /* => number of vertices */
                TRUE, /* => TRUE for closed */
                0)) /* => fill mode (if closed) */ {
            //
            mdlElmdscr_displayInView(edPrange, MASTERFILE, NORMALDRAW, vwP);
        }
    }
    return TRUE;
}
