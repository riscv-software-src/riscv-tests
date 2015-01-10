// See LICENSE for license details.

#ifndef _CVT16_H
#define _CVT16_H

#include <stdint.h>

extern uint_fast32_t cvt_hs(uint_fast16_t);
extern uint_fast16_t cvt_sh(uint_fast32_t, int);

enum riscv_rm {
	RNE = 0, /* Round to nearest; ties to even */
	RTZ = 1, /* Round towards zero (truncate) */
	RDN = 2, /* Round towards negative infinity (down) */
	RUP = 3, /* Round towards positive infinity (up) */
	RMM = 4, /* Round to nearest; ties to max magnitude */
};

#endif
