/* 
 * File:   main.mc
 * Author: DHintz
 *
 * Created on 22 sierpnia 2016, 13:06
 */

#include "main.h"
#include "ui.h"

int main(int argc, char** argv) {
    char fileName[MAXFILELENGTH];
    char mdlDir[MAXDIRLENGTH];

    mdlApp_setPath(argv[0]);
    mdlApp_getFileAndMdl(fileName, mdlDir);
    mdlApp_setNumber();

    loadCui();
    if (argc < 3) loadGui();

    return (EXIT_SUCCESS);
}
