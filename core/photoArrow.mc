#include "photoArrow.h"

void photoArrow_normalizeLength(PhotoArrow* arrowP, double maxLength) {
    DPoint3d normal, normalMax;
    mdlVec_computeNormal(&normal, &arrowP->endPoint, &arrowP->startPoint);
    mdlVec_scale(&normalMax, &normal, maxLength);
    //update arrow end point
    arrowP->endPoint = arrowP->startPoint;
    arrowP->endPoint.x += normalMax.x;
    arrowP->endPoint.y += normalMax.y;
    arrowP->endPoint.z = 0.0;
}
