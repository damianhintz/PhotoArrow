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

Public cmdName void cmd_photoSubdir(char* unparsedP) cmdNumber CMD_PHOTOARROW_PHOTO_SUBDIR {
    char ext[256];
    if (1 != sscanf(unparsedP, "%s", ext)) {
        mdlLogger_err("photoarrow photo subdir {name}");
        return;
    }
    command_photoSubdir(ext);
}

Public cmdName void cmd_photoExt(char* unparsedP) cmdNumber CMD_PHOTOARROW_PHOTO_EXT {
    char ext[256];
    if (1 != sscanf(unparsedP, "%s", ext)) {
        mdlLogger_err("photoarrow photo ext {pattern}");
        return;
    }
    command_photoExt(ext);
}

Public cmdName void cmd_refStartLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_STARTLEVEL {
    int ext = -1;
    if (1 != sscanf(unparsedP, "%d", &ext)) {
        mdlLogger_err("photoarrow ref startLevel {level}");
        return;
    }
    command_refStartLevel(ext);
}

Public cmdName void cmd_refEndLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_REF_ENDLEVEL {
    int ext = -1;
    if (1 != sscanf(unparsedP, "%d", &ext)) {
        mdlLogger_err("photoarrow ref endLevel {level}");
        return;
    }
    command_refEndLevel(ext);
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
