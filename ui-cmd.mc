#include "cmd.h"

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PHOTOARROW_START {
    mdlLogger_info("photoarrow: START");
    command_loadFence();
    mdlLogger_info("photoarrow: END");
    //return;
}

Public cmdName void cmd_photoHelp(char* unparsedP) cmdNumber CMD_PHOTOARROW_PHOTO_SUBDIR {
    int endLevel = -1;
    if (1 != sscanf(unparsedP, "%d", &endLevel)) {
        mdlLogger_err("photoarrow ref fence start");
        return;
    }
}

Public cmdName void cmd_refStartLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_STARTLEVEL {
    int endLevel = -1;
    if (1 != sscanf(unparsedP, "%d", &endLevel)) {
        mdlLogger_err("photoarrow ref startLevel {level}");
        return;
    }
    command_refStartLevel(endLevel);
}

Public cmdName void cmd_refEndLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_ENDLEVEL {
    int endLevel = -1;
    if (1 != sscanf(unparsedP, "%d", &endLevel)) {
        mdlLogger_err("photoarrow ref endLevel {level}");
        return;
    }
    command_refEndLevel(endLevel);
}

Public cmdName void cmd_photoConfigScale(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_COLOR {
    int scale = -1;
    if (1 != sscanf(unparsedP, "%d", &scale)) {
        mdlLogger_info("photoarrow config scale {percent}");
        return;
    }
    //app_setScale(scale);
    return;
}

Public cmdName void cmd_photoConfigLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("photoarrow config level {level}");
        return;
    }
    //app_setLevel(level);
    return;
}

Public cmdName void cmd_photoReferences(char* unparsedP) cmdNumber CMD_PHOTOARROW_LOADARROWS {
    command_loadArrowsFromFile();
    return;
}
