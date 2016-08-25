#if !defined (H_MDL_FENCE)
#define H_MDL_FENCE
#include <msstate.fdf>
#include <mselmdsc.fdf>
#include <msview.fdf>
#include <msdarray.fdf>
#include <msselect.fdf>
#include <mslinkge.fdf>
#include <mselemen.fdf>
#include "..\def-v8.h"

#define C_FENCE_INSIDE 0
#define C_FENCE_OVERLAP 1
#define C_FENCE_CLIP 2
#define C_FENCE_VOID 3
#define C_FENCE_VOID_OVERLAP 4
#define C_FENCE_VOID_CLIP 5
#define C_FENCE_CLEAR 6

void mdlFence_reset(void);
void mdlFence_setMode(int mode, int view);
int mdlFence_deleteFunc(void* argP);

#endif