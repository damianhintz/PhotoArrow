/* 
 * File:   mdlLine.h
 * Author: DHintz
 *
 * Created on 25 sierpnia 2016, 14:06
 */

#ifndef MDLLINE_H
#define MDLLINE_H
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mselmdsc.fdf>
#include <msrmatrx.fdf>
#include <mdllib.fdf>
#include <mscell.fdf>
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <msmisc.fdf>
#include <mssystem.fdf>
#include <msscan.fdf>
#include <mswindow.fdf>
#include <msdialog.fdf>
#include <mselemen.fdf>
#include <msstring.fdf>
#include <ctype.h>
#include <msview.fdf>
#include <msscell.fdf>
#include <mstmatrx.fdf>
#include <msvec.fdf>
#include "..\def-v8.h"

int element_isLine(int elemType);
int mdlLine_createFromSymbol(MSElementDescr* edP, ModelNumber modelRefP, MSElementUnion* elLineP, DPoint3d* shape, RotMatrix* matrixP);
int mdlLine_fromElement(MSElementDescr* edP, ModelNumber modelRefP);

#endif /* MDLLINE_H */

