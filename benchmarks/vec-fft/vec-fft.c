// See LICENSE for license details.

// *************************************************************************
// multiply function (c version)
// -------------------------------------------------------------------------
#include "vec-fft.h"
#include "fft_const.h"

int log2down(int in)
{
  int counter = -1;
  while(in > 0) { counter++; in = in >> 1; }
  return counter;
}

void fft(fftval_t workspace_real[], fftval_t workspace_imag[],
         const fftval_t tf_real[],  const fftval_t tf_imag[]) //size is FFT_SIZE
{
  const int num_stage_ops = FFT_SIZE >> 1;
  const int logfftsize = log2down(FFT_SIZE);

  int given_vl;
  // First, setup hwacha to what we need:
#if defined(FFT_FIXED)
  //   num_stage_ops VL, 9 x-reg (1 zero, 2 ctrl, 4 data, 2 scratch), 1 fpu (avert bug)
  asm volatile ("vsetcfg 9, 1");
#elif defined(FFT_FLOATING)
  asm volatile ("vsetcfg 8, 6");
  #if defined(FP_SINGLE)
//    asm volatile ("vsetprec 32");
  #elif defined(FP_HALF)
//    asm volatile ("vsetprec 16");
  #elif defined(FP_DOUBLE)
  #else
    #error wat
  #endif
#endif
  asm volatile ("vsetvl %[gvl], %[nvl]" : [gvl]"=r"(given_vl) : [nvl]"r"(num_stage_ops));
  asm volatile ("fence"); // Make sure prefilling of workspace is complete

  for(int stage = 0; stage < logfftsize; stage++)
  {
    const int half_cur_fft_size = (1 << stage);
    const int sel_block_op = half_cur_fft_size-1;
    const int sel_block = ~sel_block_op;
    const int tf_scale = logfftsize - stage - 1;

    // Stripmining loop
    for(int lane_start = 0; lane_start < num_stage_ops; lane_start += given_vl)
    {
      // Setup new vector length for this stripmining pass
      const int needed_vl = num_stage_ops - lane_start;
      asm volatile ("vsetvl %[gvl], %[nvl]" : [gvl]"=r"(given_vl) : [nvl]"r"(needed_vl));
      
#if defined(FFT_FIXED)
      // First VF block to have vector unit determine what op it is doing
      asm volatile (R"(
          vmsv vx1, %[lane_start]
          vmsv vx2, %[sel_block]
          vmsv vx3, %[sel_block_op]
          vmsv vx4, %[tf_scale]
          vmsv vx5, %[half_cfs]
          vf 0(%[vf_ptr])
      )": // no output registers 
        : [lane_start]"r"(lane_start),
          [sel_block]"r"(sel_block),
          [sel_block_op]"r"(sel_block_op),
          [tf_scale]"r"(tf_scale),
          [half_cfs]"r"(half_cur_fft_size),
          [vf_ptr]"r"(&vf_fft_init)
        : // no clobber 
      );
      
      // Second VF block loads tf and op2 then calculates scale factor
      asm volatile (R"(
          vmsv vx4, %[tf_real]
          vmsv vx5, %[tf_imag]
          vmsv vx6, %[workspace_real]
          vmsv vx7, %[workspace_imag]
          vmsv vx8, %[fix_pt]
          vf 0(%[vf_ptr])
      )": // no output registers
        : [tf_real]"r"(tf_real),
          [tf_imag]"r"(tf_imag),
          [workspace_real]"r"(workspace_real),
          [workspace_imag]"r"(workspace_imag),
          [fix_pt]"r"(FIX_PT),
          [vf_ptr]"r"(&vf_fft_scale)
        : // no clobber
      );
#elif defined(FFT_FLOATING)
      // First VF block to have vector unit determine what op it is doing
      asm volatile (R"(
          vmsv vx1, %[lane_start]
          vmsv vx2, %[sel_block]
          vmsv vx3, %[sel_block_op]
          vmsv vx4, %[tf_scale]
          vmsv vx5, %[half_cfs]
          vf 0(%[vf_ptr])
      )": // no output registers 
        : [lane_start]"r"(lane_start),
          [sel_block]"r"(sel_block),
          [sel_block_op]"r"(sel_block_op),
          [tf_scale]"r"(tf_scale),
          [half_cfs]"r"(half_cur_fft_size),
          [vf_ptr]"r"(&vf_fft_init)
        : // no clobber 
      );
      
      // Second VF block loads tf and op2 then calculates scale factor
      asm volatile (R"(
          vmsv vx4, %[tf_real]
          vmsv vx5, %[tf_imag]
          vmsv vx6, %[workspace_real]
          vmsv vx7, %[workspace_imag]
          vf 0(%[vf_ptr])
      )": // no output registers
        : [tf_real]"r"(tf_real),
          [tf_imag]"r"(tf_imag),
          [workspace_real]"r"(workspace_real),
          [workspace_imag]"r"(workspace_imag),
          [vf_ptr]"r"(&vf_fft_scale)
        : // no clobber
      );
#else
  #error no mode selected in vec-fft/vec-fft.c
#endif
      
      // Third VF block actually calculates the results
      asm volatile (R"(
          vmsv vx5, %[workspace_real]
          vmsv vx6, %[workspace_imag]
          vf 0(%[vf_ptr])
      )": // no output registers
        : [workspace_real]"r"(workspace_real),
          [workspace_imag]"r"(workspace_imag),
          [vf_ptr]"r"(&vf_fft_exec)
        : // no clobber
      );

      // Fourth VF block stores first result
      asm volatile (R"(
          vmsv vx3, %[workspace_real]
          vmsv vx4, %[workspace_imag]
          vf 0(%[vf_ptr])
      )": // no output registers
        : [workspace_real]"r"(workspace_real),
          [workspace_imag]"r"(workspace_imag),
          [vf_ptr]"r"(&vf_fft_store1)
        : "memory"
      );

      // Fifth VF block stores second result
      asm volatile (R"(
          vmsv vx3, %[workspace_real]
          vmsv vx4, %[workspace_imag]
          vf 0(%[vf_ptr])
      )": // no output registers
        : [workspace_real]"r"(workspace_real),
          [workspace_imag]"r"(workspace_imag),
          [vf_ptr]"r"(&vf_fft_store2)
        : "memory"
      );
      
    }
  }

  asm volatile ("fence"); // Make sure all that work from vector unit is visible to CPU

  return;
}
