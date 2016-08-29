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
#include "core.h"
#include "app.h"
//#define MAX_POINTS 10000

typedef struct _photoPoint {
    char name[32];
    DPoint3d point;
} PhotoPoint, *LpPhotoPoint;

typedef struct _fenceReader {
    int maxCount;
    int masterCount;
    int refCount;
    PhotoPoint* startPoints;
    int startPointsCount;
    //int startPointsSize;
    PhotoPoint* endPoints;
    int endPointsCount;
    //int endPointsSize;
} FenceReader, *LpFenceReader;

void fence_init(LpFenceReader this);
void fence_free(LpFenceReader this);
void fence_summary(LpFenceReader this);
int fence_count(LpFenceReader this);
int fence_countRefElement(LpFenceReader this);
int fence_load(LpFenceReader this);
int fence_selectCurrentRefElement(LpFenceReader this);
int fence_parseRef(LpFenceReader this, MSElementDescr* edP, ModelNumber fileNum);
void fence_parseMaster(LpFenceReader this, MSElementDescr* edP, ModelNumber fileNum);
void fence_sort(LpFenceReader this);
int fence_comparePoints(LpPhotoPoint p1, LpPhotoPoint p2);

#endif
