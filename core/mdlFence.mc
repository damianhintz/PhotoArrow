#include "mdlFence.h"
#include "..\app\mdlUtil.h"

/* mdlFence_reset */
void mdlFence_reset(void) {
    mdlState_startDefaultCommand();
}

/* mdlFence_setMode */
void mdlFence_setMode(int mode, int view) {
    tcb->fenvw = (short) view;

    switch (mode) {
        case C_FENCE_INSIDE:
            tcb->ext_locks.fenceVoid = 0;
            tcb->fbfdcn.fenceclip = 0;
            tcb->fbfdcn.overlap = 0;
            break;
        case C_FENCE_OVERLAP:
            tcb->ext_locks.fenceVoid = 0;
            tcb->fbfdcn.fenceclip = 0;
            tcb->fbfdcn.overlap = 1;
            break;
        case C_FENCE_CLIP:
            tcb->ext_locks.fenceVoid = 0;
            tcb->fbfdcn.fenceclip = 1;
            tcb->fbfdcn.overlap = 1;
            break;
        case C_FENCE_VOID:
            tcb->ext_locks.fenceVoid = 1;
            tcb->fbfdcn.fenceclip = 0;
            tcb->fbfdcn.overlap = 0;
            break;
        case C_FENCE_VOID_OVERLAP:
            tcb->ext_locks.fenceVoid = 1;
            tcb->fbfdcn.fenceclip = 0;
            tcb->fbfdcn.overlap = 1;
            break;
        case C_FENCE_VOID_CLIP:
            tcb->ext_locks.fenceVoid = 1;
            tcb->fbfdcn.fenceclip = 1;
            tcb->fbfdcn.overlap = 1;
            break;
        case C_FENCE_CLEAR:
        default:
            tcb->fence = 0;
            break;
    }
}

int mdlFence_deleteFunc(void* argP) {
    ULong filePos;
    ModelNumber modelRef;

    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &modelRef);

    if (filePos != 0xffffffff) {
        if (SUCCESS != mdlElmdscr_undoableDelete(NULL, filePos, FALSE)); //undoable delete failure
    } else; //element getFilePos failure

    return SUCCESS;
}
