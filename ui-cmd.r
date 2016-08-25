#include <rscdefs.h>
#include <cmdclass.h>

#define CT_NONE 0
#define CT_MAIN 1
#define CT_MENU 11
#define CT_CONFIG 12

Table CT_MAIN =
{
    {1, CT_MENU, INHERIT, NONE, "photoarrow"},
};

Table CT_MENU =
{
    {0, CT_NONE, INHERIT, NONE, "init"},
    {1, CT_NONE, INHERIT, NONE, "help"},
    {2, CT_CONFIG, INHERIT, NONE, "config"},
    {3, CT_NONE, INHERIT, NONE, "references"},
};

Table CT_CONFIG =
{
    {1, CT_NONE, INHERIT, NONE, "scale"},
    {2, CT_NONE, INHERIT, NONE, "level"},
};
