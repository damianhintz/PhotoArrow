/* 
 * File:   cmd.h
 * Author: damian
 *
 * Created on 27 sierpnia 2016, 20:54
 */

#ifndef CMD_H
#define CMD_H
#include <ditemlib.fdf>
#include <mdllib.fdf>
#include <mssystem.fdf>
#include <string.h>
#include <msstring.fdf>
#include <mscell.fdf>
#include <msinput.fdf>
#include <msreffil.fdf>
#include "main.h"
#include "fenceReader.h"
#include "arrowBuilder.h"
#include "app.h"
#include "ui.h"
#include "ui-cmd.h"

void command_loadPhotoPointsFromFence();
void command_loadArrowsFromFile();

void appConfig_setScale(int scale);
void appConfig_setLevel(int level);
int getRefCount();
int scanMasterFile();

#endif /* CMD_H */

