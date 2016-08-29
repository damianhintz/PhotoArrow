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
#include <cmdlist.h>
#include <msdialog.fdf>
#include <msparse.fdf>
#include "main.h"
#include "photoReader.h"
#include "fenceReader.h"
#include "arrowBuilder.h"
#include "ui.h"
#include "ui-cmd.h"

int command_loadPhotoPointsFromFence();
void command_loadArrowsFromFile();
void command_configScale(int scale);
void command_configLevel(int level);

#endif /* CMD_H */

