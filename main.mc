/* 
 * File:   main.mc
 * Author: DHintz
 *
 * Created on 22 sierpnia 2016, 13:06
 */

#include "main.h"
#include "cmd.h"

int main(int argc, char** argv) {
    app_setPath(argv[0]);
    app_loadCui();
    if (argc < 3) app_loadGui();
    command_loadConfig();
    return (EXIT_SUCCESS);
}
