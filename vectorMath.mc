#include "vectorMath.h"

double _pi = 3.14159265;

double vector_distance2D(DPoint3d* p1, DPoint3d* p2) {
    double dx = p1->x - p2->x;
    double dy = p1->y - p2->y;
    return sqrt(dx * dx + dy * dy);
}

// Returns the angle of the vector from p0 to p1, relative to the positive X-axis.
// The angle is normalized to be in the range [ 0, 2*Pi ].
// <param name="p0">The start-point</param>
// <param name="p1">The end-point</param>
// Returns the normalized angle (in radians) that p0-p1 makes with the positive X-axis.

double vector_angle(DPoint3d* p0, DPoint3d* p1) {
    double dx = p1->x - p0->x;
    double dy = p1->y - p0->y;
    double rot = atan2(dy, dx) + 2 * _pi;
    while (rot > 2 * _pi) rot -= 2 * _pi;
    return rot;
}
