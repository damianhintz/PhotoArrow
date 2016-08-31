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
#include "app.h"
#include "core.h"
#include "photoReader.h"

typedef struct _fenceReader {
    int maxCount;
    int masterCount;
    int refCount;
    PhotoPoint* startPoints;
    int startPointsCount;
    PhotoPoint* endPoints;
    int endPointsCount;
} FenceReader, *LpFenceReader;

void fenceReader_init(LpFenceReader thisP);
void fenceReader_free(LpFenceReader thisP);
void fenceReader_summary(LpFenceReader thisP);
int fenceReader_count(LpFenceReader thisP);
int fence_countRefElement(LpFenceReader thisP);
int fenceReader_load(LpFenceReader thisP);
int fence_selectCurrentRefElement(LpFenceReader thisP);
int fence_parseRef(LpFenceReader thisP, MSElementDescr* edP, ModelNumber fileNum);
void fence_parseMaster(LpFenceReader thisP, MSElementDescr* edP, ModelNumber fileNum);

PhotoPoint* fenceReader_searchStartName(LpFenceReader thisP, char* photoName, DPoint3d* foundP);
int fenceReader_searchEndName(LpFenceReader thisP, char* photoName, DPoint3d* foundP);
PhotoPoint* fenceReader_binarySearch(LpPhotoPoint key, PhotoPoint* points, long count);
int fenceReader_comparePhotos(LpPhotoPoint p1, LpPhotoPoint p2);

void fence_sort(LpFenceReader thisP);
int fence_comparePoints(LpPhotoPoint p1, LpPhotoPoint p2);

#endif
