#include "photoArrow.h"

void photoArrow_normalizeLength(PhotoArrow* arrowP) {
    DPoint3d normal, normalMax;
    mdlVec_computeNormal(&normal, &arrowP->endPoint, &arrowP->startPoint);
    mdlVec_scale(&normalMax, &normal, mdlCnv_masterUnitsToUors(_arrowMaxLength));
    //update arrow end point
    arrowP->endPoint = arrowP->startPoint;
    arrowP->endPoint.x += normalMax.x;
    arrowP->endPoint.y += normalMax.y;
    arrowP->endPoint.z = 0.0;
}
