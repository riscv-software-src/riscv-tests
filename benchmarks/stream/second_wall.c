/* A Fortran-callable gettimeofday routine to give access
   to the wall clock timer.

   This subroutine may need to be modified slightly to get
   it to link with Fortran on your computer.
*/

#include <sys/time.h>
/* int gettimeofday(struct timeval *tp, struct timezone *tzp); */

double second()
{
/* struct timeval { long	tv_sec;	
	    long	tv_usec;	};

struct timezone { int	tz_minuteswest;
	     int	tz_dsttime;	 };	*/

	struct timeval tp;
	struct timezone tzp;
	int i;

	i = gettimeofday(&tp,&tzp);
	return ( (double) tp.tv_sec + (double) tp.tv_usec * 1.e-6 );
}
