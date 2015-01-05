//**************************************************************************
// Dhrystone bencmark
//--------------------------------------------------------------------------
//
// This is the classic Dhrystone synthetic integer benchmark.
// You should not change anything except the HOST_DEBUG and
// PREALLOCATE macros for your timing run.

#include "dhrystone.h"

//--------------------------------------------------------------------------
// Macros

// Set HOST_DEBUG to 1 if you are going to compile this for a host
// machine (ie Athena/Linux) for debug purposes and set HOST_DEBUG
// to 0 if you are compiling with the smips-gcc toolchain.

#ifndef HOST_DEBUG
#define HOST_DEBUG 0
#endif

// Set PREALLOCATE to 1 if you want to preallocate the benchmark
// function before starting stats. If you have instruction/data
// caches and you don't want to count the overhead of misses, then
// you will need to use preallocation.

#ifndef PREALLOCATE
#define PREALLOCATE 0
#endif

// Set SET_STATS to 1 if you want to carve out the piece that actually
// does the computation.

#ifndef SET_STATS
#define SET_STATS 0
#endif

#if HOST_DEBUG
# define do_fprintf fprintf
#else
int __attribute__((noinline)) do_fprintf(FILE* f, const char* str, ...)
{
  return 0;
}
#endif

#include "util.h"

#include <alloca.h>

/* Global Variables: */

Rec_Pointer     Ptr_Glob,
                Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob,
                Ch_2_Glob;
int             Arr_1_Glob [50];
int             Arr_2_Glob [50] [50];

#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#undef REG
#define REG register
#endif

Boolean		Done;

long            Begin_Time,
                End_Time,
                User_Time;
float           Microseconds,
                Dhrystones_Per_Second;

/* end of variables for time measurement */


int main (int argc, char** argv)
/*****/
  /* main program, corresponds to procedures        */
  /* Main and Proc_0 in the Ada version             */
{
        One_Fifty       Int_1_Loc;
  REG   One_Fifty       Int_2_Loc;
        One_Fifty       Int_3_Loc;
  REG   char            Ch_Index;
        Enumeration     Enum_Loc;
        Str_30          Str_1_Loc;
        Str_30          Str_2_Loc;
  REG   int             Run_Index;
  REG   int             Number_Of_Runs;

  /* Arguments */
#if HOST_DEBUG
  if (argc > 2)
  {
     do_fprintf (stdout, "Usage: %s [number of loops]\n", argv[0]);
     exit (1);
  }
  if (argc == 2)
  {
     Number_Of_Runs = atoi (argv[1]);
  } else
#endif
  {
     Number_Of_Runs = NUMBER_OF_RUNS;
  }
  if (Number_Of_Runs <= 0)
  {
     Number_Of_Runs = NUMBER_OF_RUNS;
  }

  /* Initializations */

  Next_Ptr_Glob = (Rec_Pointer) alloca (sizeof (Rec_Type));
  Ptr_Glob = (Rec_Pointer) alloca (sizeof (Rec_Type));

  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
  Ptr_Glob->Discr                       = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
        /* Was missing in published program. Without this statement,    */
        /* Arr_2_Glob [8][7] would have an undefined value.             */
        /* Warning: With 16-Bit processors and Number_Of_Runs > 32000,  */
        /* overflow may occur for this array element.                   */

#if HOST_DEBUG
  do_fprintf (stdout, "\n");
  do_fprintf (stdout, "Dhrystone Benchmark, Version %s\n", Version);
  if (Reg)
  {
    do_fprintf (stdout, "Program compiled with 'register' attribute\n");
  }
  else
  {
    do_fprintf (stdout, "Program compiled without 'register' attribute\n");
  }
  do_fprintf (stdout, "Using %s, HZ=%d\n", CLOCK_TYPE, HZ);
  do_fprintf (stdout, "\n");
#endif

  Done = false;
  while (!Done) {
#if HOST_DEBUG
    do_fprintf (stdout, "Trying %d runs through Dhrystone:\n", Number_Of_Runs);
#endif

    /***************/
    /* Start timer */
    /***************/

    Start_Timer();
    setStats(1);

    for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
    {

      Proc_5();
      Proc_4();
	/* Ch_1_Glob == 'A', Ch_2_Glob == 'B', Bool_Glob == true */
      Int_1_Loc = 2;
      Int_2_Loc = 3;
      strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
      Enum_Loc = Ident_2;
      Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	/* Bool_Glob == 1 */
      while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
      {
	Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
	  /* Int_3_Loc == 7 */
	Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
	  /* Int_3_Loc == 7 */
	Int_1_Loc += 1;
      } /* while */
	/* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
      Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
	/* Int_Glob == 5 */
      Proc_1 (Ptr_Glob);
      for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
			       /* loop body executed twice */
      {
	if (Enum_Loc == Func_1 (Ch_Index, 'C'))
	    /* then, not executed */
	  {
	  Proc_6 (Ident_1, &Enum_Loc);
	  strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
	  Int_2_Loc = Run_Index;
	  Int_Glob = Run_Index;
	  }
      }
	/* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
      Int_2_Loc = Int_2_Loc * Int_1_Loc;
      Int_1_Loc = Int_2_Loc / Int_3_Loc;
      Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
	/* Int_1_Loc == 1, Int_2_Loc == 13, Int_3_Loc == 7 */
      Proc_2 (&Int_1_Loc);
	/* Int_1_Loc == 5 */

    } /* loop "for Run_Index" */

    /**************/
    /* Stop timer */
    /**************/

    setStats(0);
    Stop_Timer();

    User_Time = End_Time - Begin_Time;

    if (User_Time < Too_Small_Time)
    {
      do_fprintf (stdout, "Measured time too small to obtain meaningful results\n");
      Number_Of_Runs = Number_Of_Runs * 10;
      do_fprintf (stdout, "\n");
    } else Done = true;
  }

  do_fprintf (stderr, "Final values of the variables used in the benchmark:\n");
  do_fprintf (stderr, "\n");
  do_fprintf (stderr, "Int_Glob:            %d\n", Int_Glob);
  do_fprintf (stderr, "        should be:   %d\n", 5);
  do_fprintf (stderr, "Bool_Glob:           %d\n", Bool_Glob);
  do_fprintf (stderr, "        should be:   %d\n", 1);
  do_fprintf (stderr, "Ch_1_Glob:           %c\n", Ch_1_Glob);
  do_fprintf (stderr, "        should be:   %c\n", 'A');
  do_fprintf (stderr, "Ch_2_Glob:           %c\n", Ch_2_Glob);
  do_fprintf (stderr, "        should be:   %c\n", 'B');
  do_fprintf (stderr, "Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
  do_fprintf (stderr, "        should be:   %d\n", 7);
  do_fprintf (stderr, "Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
  do_fprintf (stderr, "        should be:   Number_Of_Runs + 10\n");
  do_fprintf (stderr, "Ptr_Glob->\n");
  do_fprintf (stderr, "  Ptr_Comp:          %d\n", (long) Ptr_Glob->Ptr_Comp);
  do_fprintf (stderr, "        should be:   (implementation-dependent)\n");
  do_fprintf (stderr, "  Discr:             %d\n", Ptr_Glob->Discr);
  do_fprintf (stderr, "        should be:   %d\n", 0);
  do_fprintf (stderr, "  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
  do_fprintf (stderr, "        should be:   %d\n", 2);
  do_fprintf (stderr, "  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
  do_fprintf (stderr, "        should be:   %d\n", 17);
  do_fprintf (stderr, "  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
  do_fprintf (stderr, "        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  do_fprintf (stderr, "Next_Ptr_Glob->\n");
  do_fprintf (stderr, "  Ptr_Comp:          %d\n", (long) Next_Ptr_Glob->Ptr_Comp);
  do_fprintf (stderr, "        should be:   (implementation-dependent), same as above\n");
  do_fprintf (stderr, "  Discr:             %d\n", Next_Ptr_Glob->Discr);
  do_fprintf (stderr, "        should be:   %d\n", 0);
  do_fprintf (stderr, "  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
  do_fprintf (stderr, "        should be:   %d\n", 1);
  do_fprintf (stderr, "  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
  do_fprintf (stderr, "        should be:   %d\n", 18);
  do_fprintf (stderr, "  Str_Comp:          %s\n",
                                Next_Ptr_Glob->variant.var_1.Str_Comp);
  do_fprintf (stderr, "        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  do_fprintf (stderr, "Int_1_Loc:           %d\n", Int_1_Loc);
  do_fprintf (stderr, "        should be:   %d\n", 5);
  do_fprintf (stderr, "Int_2_Loc:           %d\n", Int_2_Loc);
  do_fprintf (stderr, "        should be:   %d\n", 13);
  do_fprintf (stderr, "Int_3_Loc:           %d\n", Int_3_Loc);
  do_fprintf (stderr, "        should be:   %d\n", 7);
  do_fprintf (stderr, "Enum_Loc:            %d\n", Enum_Loc);
  do_fprintf (stderr, "        should be:   %d\n", 1);
  do_fprintf (stderr, "Str_1_Loc:           %s\n", Str_1_Loc);
  do_fprintf (stderr, "        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
  do_fprintf (stderr, "Str_2_Loc:           %s\n", Str_2_Loc);
  do_fprintf (stderr, "        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
  do_fprintf (stderr, "\n");


#if HOST_DEBUG
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
                        / ((float) HZ * ((float) Number_Of_Runs));
    Dhrystones_Per_Second = ((float) HZ * (float) Number_Of_Runs)
                        / (float) User_Time;

    do_fprintf (stdout, "Microseconds for one run through Dhrystone: ");
    do_fprintf (stdout, "%10.1f \n", Microseconds);
    do_fprintf (stdout, "Dhrystones per Second:                      ");
    do_fprintf (stdout, "%10.0f \n", Dhrystones_Per_Second);
    do_fprintf (stdout, "\n");
#endif

  return 0;
}


void Proc_1(Rec_Pointer Ptr_Val_Par)
/******************/
    /* executed once */
{
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
                                        /* == Ptr_Glob_Next */
  /* Local variable, initialized with Ptr_Val_Par->Ptr_Comp,    */
  /* corresponds to "rename" in Ada, "with" in Pascal           */
  
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
  Next_Record->variant.var_1.Int_Comp 
        = Ptr_Val_Par->variant.var_1.Int_Comp;
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
  Proc_3 (&Next_Record->Ptr_Comp);
    /* Ptr_Val_Par->Ptr_Comp->Ptr_Comp 
                        == Ptr_Glob->Ptr_Comp */
  if (Next_Record->Discr == Ident_1)
    /* then, executed */
  {
    Next_Record->variant.var_1.Int_Comp = 6;
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
           &Next_Record->variant.var_1.Enum_Comp);
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
           &Next_Record->variant.var_1.Int_Comp);
  }
  else /* not executed */
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
} /* Proc_1 */


void Proc_2(int* Int_Par_Ref)
/******************/
    /* executed once */
    /* *Int_Par_Ref == 1, becomes 4 */
{
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
      /* then, executed */
    {
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */


void Proc_3(Rec_Pointer* Ptr_Ref_Par)
/******************/
    /* executed once */
    /* Ptr_Ref_Par becomes Ptr_Glob */
{
  if (Ptr_Glob != Null)
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
} /* Proc_3 */


void Proc_4()
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
  Bool_Glob = Bool_Loc | Bool_Glob;
  Ch_2_Glob = 'B';
} /* Proc_4 */


void Proc_5()
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
  Bool_Glob = false;
} /* Proc_5 */
