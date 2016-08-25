#if !defined (H_OGRODZENIE)
#define H_OGRODZENIE
#include <stdlib.h>
#include <msmisc.fdf>
#include <mselmdsc.fdf>
//mdlElmdscr_read
#include <msselect.fdf>
//mdlSelect_returnPositions
#include <mslocate.fdf>
//mdlLocate_init
#include <msvar.fdf>
//tcb
#include <msstate.fdf>
//mdlState_startFenceCommand
#include <mselemen.fdf>
//mdlElement_getFilePos
#include "def-v8.h"
#include "core\mdlText.h"

typedef struct _fence {
    ULong* filePositions;
    ModelNumber* modelNumbers;
    int nSelected;
    int masterCount;
    int refCount;
} Fence, *LpFence;

void fence_init(LpFence fenceP);
void fence_free(LpFence fenceP);
int fence_load(LpFence fenceP);
int fence_selectCurrentRefElement(LpFence fenceP);

#endif
