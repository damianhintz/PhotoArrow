#include <rscdefs.h>
#include <cmdclass.h>

#define CT_NONE 0
#define CT_MAIN 1
#define CT_MENU 11
#define CT_PHOTO 21
#define CT_REF 22
#define CT_ARROW 23
#define CT_CONFIG 24

Table CT_MAIN =
{
    {1, CT_MENU, INHERIT, NONE, "photoarrow"},
};

Table CT_MENU =
{
    {0, CT_NONE, INHERIT, NONE, "start"},
    {1, CT_PHOTO, INHERIT, NONE, "photo"},
    {2, CT_CONFIG, INHERIT, NONE, "config"},
    {3, CT_REF, INHERIT, NONE, "ref"},
    {4, CT_ARROW, INHERIT, NONE, "arrow"},
    {9, CT_NONE, INHERIT, NONE, "references"},
};

Table CT_PHOTO =
{
    {1, CT_NONE, INHERIT, NONE, "subdir"},
    {2, CT_NONE, INHERIT, NONE, "ext"},
};

Table CT_REF =
{
    {1, CT_NONE, INHERIT, NONE, "fence"},
    {2, CT_NONE, INHERIT, NONE, "level"},
};

Table CT_ARROW =
{
    {1, CT_NONE, INHERIT, NONE, "size"},
    {2, CT_NONE, INHERIT, NONE, "font"},
    {3, CT_NONE, INHERIT, NONE, "color"},
    {4, CT_NONE, INHERIT, NONE, "level"},
};

Table CT_CONFIG =
{
    {1, CT_NONE, INHERIT, NONE, "load"},
    {2, CT_NONE, INHERIT, NONE, "scale"},
    {3, CT_NONE, INHERIT, NONE, "level"},
};
