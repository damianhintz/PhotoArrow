#include "mdlUtil.h"

char* mdlUtil_trimRight(char* p, char c) {
    char* end;
    int len;

    len = strlen(p);

    while (*p && len) {
        end = p + len - 1;
        if (c == *end)
            *end = 0;
        else
            break;
        len = strlen(p);
    }
    return p;
}

void mdlUtil_readInt(char* wiersz, int* value) {
    int i = 0;
    char* charP;
    char row[1024];

    strcpy(row, wiersz);
    charP = strtok(row, "=");

    while (charP != NULL) {
        if (i++ == 1) {
            sscanf(charP, "%d", value);
            break;
        }
        charP = strtok(NULL, "=");
    }
}

void mdlUtil_readString(char* wiersz, char* value) {
    int i = 0;
    char* charP;
    char row[1024];

    strcpy(row, wiersz);
    charP = strtok(row, "=");

    while (charP != NULL) {
        if (i++ == 1) {
            strcpy(value, charP);
            break;
        }
        charP = strtok(NULL, "=");
    }
}

void mdlUtil_readDouble(char* wiersz, double* value) {
    int i = 0;
    char* charP;
    char row[1024];

    strcpy(row, wiersz);
    charP = strtok(row, "=");

    while (charP != NULL) {
        if (i++ == 1) {
            sscanf(charP, "%f", value);
            break;
        }
        charP = strtok(NULL, "=");
    }
}
