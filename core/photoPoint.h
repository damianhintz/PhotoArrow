/* 
 * File:   photoPoint.h
 * Author: DHintz
 *
 * Created on 31 sierpnia 2016, 12:33
 */

#ifndef PHOTOPOINT_H
#define PHOTOPOINT_H
#include <math.h>
#include <msvec.fdf>
#define MAX_PHOTO_NAME 32

typedef struct _photoPoint {
    char name[MAX_PHOTO_NAME];
    DPoint3d point;
    int used;
} PhotoPoint, *LpPhotoPoint;

#endif /* PHOTOPOINT_H */

