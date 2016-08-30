#if !defined (H_CORE)
#define H_CORE
#include "core\mdlElement.h"
#include "core\mdlGeom.h"
#include "core\mdlFence.h"
#include "core\mdlScan.h"
#include "core\mdlSelect.h"
#include "core\mdlText.h"
#include "core\mdlLine.h"

#if MSVERSION >= 0x790
#include <msdgnmodelref.fdf>
#include <msfilutl.h>
#include <msmodel.fdf>
#include <mstxtfil.h>
#include <leveltable.fdf>
#include <bitmask.fdf>
typedef DgnModelRefP ModelNumber;
#else
typedef int ModelNumber;
typedef char MSWChar;
typedef long Int32;
typedef short Int16;
typedef unsigned long UInt32;
typedef unsigned short UInt16;
#define MAX_CELLNAME_LENGTH 512
#endif

#endif