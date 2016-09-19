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

Public cmdName void cmd_arrowLevel(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("photoarrow arrow level {level}");
        return;
    }
    command_arrowLevel(level);
}

Public cmdName void cmd_arrowFont(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_FONT {
    int font = -1;
    if (1 != sscanf(unparsedP, "%d", &font)) {
        mdlLogger_info("photoarrow arrow font {font}");
        return;
    }
    command_arrowFont(font);
}

Public cmdName void cmd_arrowColor(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_COLOR {
    int color;
    if (1 != sscanf(unparsedP, "%d", &color)) {
        mdlLogger_info("photoarrow arrow color {color}");
        return;
    }
    command_arrowColor(color);
}

Public cmdName void cmd_arrowTextSize(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_TEXTSIZE {
    double size;
    if (1 != sscanf(unparsedP, "%f", &size)) {
        mdlLogger_info("photoarrow arrow textSize {size}");
        return;
    }
    command_arrowTextSize(size);
}

Public cmdName void cmd_arrowStyle(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_STYLE {
    int style;
    if (1 != sscanf(unparsedP, "%d", &style)) {
        mdlLogger_info("photoarrow arrow style {style}");
        return;
    }
    command_arrowStyle(style);
}
Public cmdName void cmd_arrowWeight(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_WEIGHT {
    int weight;
    if (1 != sscanf(unparsedP, "%d", &weight)) {
        mdlLogger_info("photoarrow arrow weight {weight}");
        return;
    }
    command_arrowWeight(weight);
}

Public cmdName void cmd_arrowMaxLength(char* unparsedP) cmdNumber CMD_PHOTOARROW_ARROW_MAXLENGTH {
    double length;
    if (1 != sscanf(unparsedP, "%f", &length)) {
        mdlLogger_info("photoarrow arrow maxLength {length}");
        return;
    }
    command_arrowMaxLength(length);
}

Public cmdName void cmd_photoReferences(char* unparsedP) cmdNumber CMD_PHOTOARROW_LOAD_ARROWS {
    command_loadArrowsFromFile();
}
