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
#include "app.h"
#include "photoReader.h"
#include "fenceReader.h"
#include "arrowBuilder.h"
#include "ui.h"
#include "ui-cmd.h"

int command_loadFence();
void command_loadConfig();
void command_loadArrowsFromFile();
void command_photoSubdir(char* subdir);
void command_photoExt(char* ext);
void command_refStartLevel(int startLevel);
void command_refEndLevel(int endLevel);
void command_arrowLevel(int level);
void command_arrowFont(int font);
void command_arrowColor(int color);
void command_arrowStyle(int style);
void command_arrowWeight(int weight);
void command_arrowTextSize(double size);
void command_arrowMaxLength(double length);

#endif /* CMD_H */

