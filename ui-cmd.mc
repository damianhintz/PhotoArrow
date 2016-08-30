#include "cmd.h"

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PHOTOARROW_START {
    mdlLogger_info("photoarrow: START");
    command_loadFence();
    mdlLogger_info("photoarrow: END");
}

Public cmdName void cmd_loadConfig(char* unparsedP) cmdNumber CMD_PHOTOARROW_LOAD_CONFIG {
    //mdlLogger_info("photoarrow: START");
    command_loadConfig();
    //mdlLogger_info("photoarrow: END");
}

Public cmdName void cmd_photoHelp(char* unparsedP) cmdNumber CMD_PHOTOARROW_PHOTO_SUBDIR {
    char subdir[256];
    if (1 != sscanf(unparsedP, "%s", subdir)) {
        mdlLogger_err("photoarrow photo subdir {name}");
        return;
    }
}

Public cmdName void cmd_refStartLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_STARTLEVEL {
    int subdir = -1;
    if (1 != sscanf(unparsedP, "%d", &subdir)) {
        mdlLogger_err("photoarrow ref startLevel {level}");
        return;
    }
    command_refStartLevel(subdir);
}

Public cmdName void cmd_refEndLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_ENDLEVEL {
    int subdir = -1;
    if (1 != sscanf(unparsedP, "%d", &subdir)) {
        mdlLogger_err("photoarrow ref endLevel {level}");
        return;
    }
    command_refEndLevel(subdir);
}

Public cmdName void cmd_photoConfigScale(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_COLOR {
    int scale = -1;
    if (1 != sscanf(unparsedP, "%d", &scale)) {
        mdlLogger_info("photoarrow config scale {percent}");
        return;
    }
}

Public cmdName void cmd_photoConfigLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("photoarrow config level {level}");
        return;
    }
}

Public cmdName void cmd_photoReferences(char* unparsedP) cmdNumber CMD_PHOTOARROW_LOAD_ARROWS {
    command_loadArrowsFromFile();
}
