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

void photoArrow_normalizeName(PhotoArrow* arrowP) {
    char* name = arrowP->name;
    int length = strlen(name), index;
    //trimLeft(arrowP->name, '-');
    if (length < 2) return; //too small
    if (name[0] != '-') return; //it is not a dash
    //move all characters to the left by 1
    for (index = 0; index < length; index++) {
        name[index] = name[index + 1];
    }
}
