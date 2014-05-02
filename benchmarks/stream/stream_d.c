/*
# include <stdio.h>
# include <math.h>
# include <float.h>
# include <limits.h>
# include <sys/time.h>
*/
/*  Set THREAD_NBR macro equal to the number of threads if a multithreaded OpenMP run */
/*  Set to 1 if a single-CPU run */
#include "util.h"
#define THREAD_NBR 1

#if defined(THREAD_NBR)
  #if THREAD_NBR > 1
    # include <omp.h> 
    #define THREADING_ON 1
    #define SET_THREADS omp_set_num_threads(THREAD_NBR);printf("\nRunning with %d OpenMP threads\n",THREAD_NBR);
  #else
    #define THREADING_ON 0
    #define SET_THREADS ;
  #endif
#else
  #define THREAD_NBR 1
  #define THREADING_ON 0
  #define SET_THREADS ;
#endif
/*
 * Program: Stream
 * Programmer: Joe R. Zagar
 * Revision: 4.0-BETA, October 24, 1995
 * Original code developed by John D. McCalpin
 * OpenMP directives inserted by C. Shereda, LLNL, August 2001
 *
 * This program measures memory transfer rates in MB/s for simple 
 * computational kernels coded in C.  These numbers reveal the quality
 * of code generation for simple uncacheable kernels as well as showing
 * the cost of floating-point operations relative to memory accesses.
 *
 * INSTRUCTIONS:
 *
 *	1) Stream requires a good bit of memory to run.  Adjust the
 *          value of 'N' (below) to give a 'timing calibration' of 
 *          at least 20 clock-ticks.  This will provide rate estimates
 *          that should be good to about 5% precision.
 */

# define N 10000
# define NTIMES	10
# define OFFSET	0

/*
 *	3) Compile the code with full optimization.  Many compilers
 *	   generate unreasonably bad code before the optimizer tightens
 *	   things up.  If the results are unreasonably good, on the
 *	   other hand, the optimizer might be too smart for me!
 *
 *         Try compiling with:
 *               cc -O stream_d.c second.c -o stream_d -lm
 *
 *         This is known to work on Cray, SGI, IBM, and Sun machines.
 *
 *
 *	4) Mail the results to mccalpin@cs.virginia.edu
 *	   Be sure to include:
 *		a) computer hardware model number and software revision
 *		b) the compiler flags
 *		c) all of the output from the test case.
 * Thanks!
 *
 */


# ifndef MIN
# define MIN(x,y) ((x)<(y)?(x):(y))
# endif
# ifndef MAX
# define MAX(x,y) ((x)>(y)?(x):(y))
# endif

static double	a[N+OFFSET],
		b[N+OFFSET],
		c[N+OFFSET];



static double	bytes[4] = {
    2 * sizeof(double) * N,
    2 * sizeof(double) * N,
    3 * sizeof(double) * N,
    3 * sizeof(double) * N
    };


void
thread_entry(int cid, int nc)
{
  while (cid !=0) {
    //clogMem(1<<16, 64>>2, 1<<7);
  }
}

int
main()
    {
    int			quantum, checktick();
    int			BytesPerWord;
    register int	j, k;
    double		scalar, t, times[4][NTIMES];

    /* --- SETUP --- determine precision and check timing --- */

    BytesPerWord = sizeof(double);

    /* Set up number of threads, if OpenMP is to be used */
    if( THREADING_ON ){
       SET_THREADS;
    }


/* It is assumed here and in all omp parallel for's in this program 
   that your OpenMP-compatible compiler automatically privatizes 
   the loop counter j */
#if THREADING_ON
#pragma omp parallel for
#endif
    /* Get initial value for system clock. */
    for (j=0; j<N; j++) {
	a[j] = 1.0;
	b[j] = 2.0;
	c[j] = 0.0;
	}



#if THREADING_ON
#pragma omp parallel for
#endif
    for (j = 0; j < N; j++)
	a[j] = 2.0E0 * a[j];
    
    /*	--- MAIN LOOP --- repeat test cases NTIMES times --- */

    scalar = 3.0;
    for (k=0; k<NTIMES; k++)
	{

#if THREADING_ON
#pragma omp parallel for
#endif
	for (j=0; j<N; j++)
	    c[j] = a[j];
#if THREADING_ON
#pragma omp parallel for
#endif
	for (j=0; j<N; j++)
	    b[j] = scalar*c[j];
#if THREADING_ON
#pragma omp parallel for
#endif
	for (j=0; j<N; j++)
	    c[j] = a[j]+b[j];
#if THREADING_ON
#pragma omp parallel for
#endif
	for (j=0; j<N; j++)
	    a[j] = b[j]+scalar*c[j];
	}
    
    return 0;
}

# define	M	20


