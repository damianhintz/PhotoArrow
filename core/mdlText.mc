#include "mdlText.h"

int element_isText(int elemType) {
    switch (elemType) {
        case TEXT_ELM:
        case TEXT_NODE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int mdlText_readText(MSElementDescr* edP, char* textP, DPoint3d* originP) {
    int status = ERROR;
    if (edP == NULL) return FALSE;
    switch (mdlElement_getType(&edP->el)) {
        case TEXT_ELM:
        {
            status = mdlText_extract(NULL, originP, NULL, NULL, textP, NULL, NULL, NULL, NULL, NULL, &edP->el);
        }
            break;
        case TEXT_NODE_ELM:
        {
            char buffer[512];

#if MSVERSION >= 0x790
            if (SUCCESS != (status = mdlTextNode_extract(originP, NULL, NULL, NULL, NULL, NULL, NULL, edP)))
                break;
#else
            if (SUCCESS != (status = mdlTextNode_extract(originP, NULL, NULL, NULL, NULL, NULL, &edP->el)))
                break;
#endif
            mdlText_extractStringsFromDscr(buffer, sizeof buffer, edP);
            if (textP != NULL) sscanf(buffer, "%s", textP);
        }
            break;
        default:
            break;
    }
    return status == SUCCESS;
}

int mdlText_readTextPoints(MSElementDescr *edP, DPoint3d* aPunkty, int* nPunktyP) {
    int type = mdlElement_getType(&edP->el);
    int status = ERROR;
    *nPunktyP = 0;
    switch (type) {
        case TEXT_ELM:
        {
            if (SUCCESS != (status = mdlText_extractShape(aPunkty, NULL, &edP->el, FALSE, tcb->lstvw)))
                break;
            *nPunktyP = 5;
        }
            break;
        case TEXT_NODE_ELM:
        {
#if MSVERSION >= 0x790
            if (SUCCESS != (status = mdlTextNode_extractShape(aPunkty, NULL, edP, FALSE, tcb->lstvw)))
                break;
#else
            if (SUCCESS != (status = mdlTextNode_extractShape(aPunkty, NULL, &edP->el, FALSE, tcb->lstvw)))
                break;
#endif
            *nPunktyP = 5;
        }
            break;
        default:
            break;
    }
    return status;
}

int mdlText_createFromPoint(MSElement* el, DPoint3d* point, char* text, ULong font, double height, double rotation) {
    int just = TXTJUST_LB;
    RotMatrix rotMatrix;
    TextParam param;
    TextSizeParam size;

    param.font = font;
    param.just = just;

    size.mode = TXT_BY_TILE_SIZE;
    size.size.height = mdlCnv_masterUnitsToUors(height);
    size.size.width = mdlCnv_masterUnitsToUors(height);
    size.aspectRatio = 1;

    mdlRMatrix_fromAngle(&rotMatrix, ((rotation * 3.14159265) / 180.0));

    if (strlen(text) == 0) return FALSE;
    return SUCCESS == mdlText_create(el, NULL, text, point, &size, &rotMatrix, &param, NULL);
}
