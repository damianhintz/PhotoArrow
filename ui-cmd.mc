#include "cmd.h"

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PHOTOARROW_START {
    mdlLogger_info("photoarrow: START");
    command_loadPhotoPointsFromFence();
    mdlLogger_info("photoarrow: END");
    return;
}

Public cmdName void cmd_photoHelp(char* unparsedP) cmdNumber CMD_PHOTOARROW_HELP {
    mdlLogger_info("photoarrow help/about");
    mdlLogger_info("photoarrow v1.0-beta");
    return;
}

Public cmdName void cmd_photoConfigScale(char* unparsedP) cmdNumber CMD_PHOTOARROW_CONFIG_SCALE {
    int scale = -1;
    if (1 != sscanf(unparsedP, "%d", &scale)) {
        mdlLogger_info("photoarrow config scale {percent}");
        return;
    }
    //app_setScale(scale);
    return;
}

Public cmdName void cmd_photoConfigLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_CONFIG_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("photoarrow config level {level}");
        return;
    }
    //app_setLevel(level);
    return;
}

Public cmdName void cmd_photoReferences(char* unparsedP) cmdNumber CMD_PHOTOARROW_REFERENCES {
    //int okSlots = getRefCount(); //int references = mdlRefFile_getRefCount();
    //char msg[256];
    //sprintf(msg, "photoarrow references: %d ok slot[s]", okSlots);
    //mdlLogger_info(msg);
    command_loadArrowsFromFile();
    return;
}

void command_configScale(int scale) {
    //_precyzja = precyzja;
}

void command_configLevel(int level) {

}
