/* 
 * File:   vectorMath.h
 * Author: DHintz
 *
 * Created on 31 sierpnia 2016, 11:30
 */

#ifndef VECTORMATH_H
#define VECTORMATH_H
#include <math.h>
#include <msvec.fdf>

extern double _pi;

double vector_distance2D(DPoint3d* p1, DPoint3d* p2);
double vector_angle(DPoint3d* p0, DPoint3d* p1);

#endif /* VECTORMATH_H */

