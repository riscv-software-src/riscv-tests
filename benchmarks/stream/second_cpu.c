#include <sys/param.h>
#include <sys/types.h>
#include <sys/times.h>
#include <time.h>

double second()
{
    long sec;
    double secx;
    struct tms realbuf;

    times(&realbuf);
    secx = ( realbuf.tms_stime + realbuf.tms_utime ) / (float) CLK_TCK;
    return ((double) secx);
}
