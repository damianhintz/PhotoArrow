#include "mdlLine.h"

int element_isLine(int elemType) {
    switch (elemType) {
            //proste
        case LINE_ELM:
        case LINE_STRING_ELM:
        case SHAPE_ELM:
        case CURVE_ELM:
            //zlo�one
        case CMPLX_STRING_ELM:
        case CMPLX_SHAPE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int mdlLine_createFromSymbol(MSElementDescr* edP, ModelNumber modelRefP, MSElementUnion* elLineP, DPoint3d* shape, RotMatrix* matrixP) {
    DPoint3d psLine[2];
    DPoint3d vec;
    if (edP == NULL) return FALSE;
    vec.x = mdlCnv_masterUnitsToUors(1.0);
    vec.y = 0.0;
    vec.z = 0.0;
#if MSVERSION >= 0x790
    mdlRMatrix_multiplyPoint(&vec, matrixP);
#endif
    psLine[0] = *shape;
    psLine[1] = *shape;
#if MSVERSION >= 0x790
    mdlVec_addInPlace(&psLine[1], &vec);
#else
    mdlVec_addPoint(&psLine[1], &psLine[1], &vec);
#endif
    return SUCCESS == mdlLine_create(elLineP, &edP->el, psLine);
}

int mdlLine_fromElement(MSElementDescr* edP, ModelNumber modelRefP) {
    MSElementDescr* pComponent = NULL;
    if (edP == NULL) return FALSE;
    /* search for line elements */
    pComponent = edP->h.firstElem;
    while (pComponent) {
        MSElementUnion* el = &pComponent->el;
        int elemType = mdlElement_getType(el);
        if (LINE_ELM == elemType) mdlElement_add(el);
        pComponent = pComponent->h.next;
    }
    return TRUE;
}
