// See LICENSE for license details.

static const int HCBM = 18;
static const int HCBN = 80;
static const int HCBK = 16;

static const int HRBM = 18;
static const int HRBN = 80;
static const int HRBK = 1;

extern void hwacha_mm_0();
extern void hwacha_mm_1();
extern void hwacha_mm_2();
extern void hwacha_mm_3();
extern void hwacha_mm_4();
extern void hwacha_mm_5();
extern void hwacha_mm_6();
extern void hwacha_mm_7();
extern void hwacha_mm_8();
extern void hwacha_mm_9();
extern void hwacha_mm_10();
extern void hwacha_mm_11();
extern void hwacha_mm_12();
extern void hwacha_mm_13();
extern void hwacha_mm_14();
extern void hwacha_mm_15();
extern void hwacha_mm_16();
extern void hwacha_mm_17();

static inline void nloop(int s, int e, t* a, size_t lda, t* b, size_t ldb, t* c, size_t ldc)
{
         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[0*lda]));
         asm volatile ("vfld vf20, %[ptr]" : : [ptr]"r"(b) : );
  if (s) asm volatile ("vfld vf0,  %[ptr]" : : [ptr]"r"(&c[ldc*0]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_0) : );
  if (e) asm volatile ("vfsd vf0,  %[ptr]" : : [ptr]"r"(&c[ldc*0]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[1*lda]));
  if (s) asm volatile ("vfld vf1,  %[ptr]" : : [ptr]"r"(&c[ldc*1]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_1) : );
  if (e) asm volatile ("vfsd vf1,  %[ptr]" : : [ptr]"r"(&c[ldc*1]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[2*lda]));
  if (s) asm volatile ("vfld vf2,  %[ptr]" : : [ptr]"r"(&c[ldc*2]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_2) : );
  if (e) asm volatile ("vfsd vf2,  %[ptr]" : : [ptr]"r"(&c[ldc*2]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[3*lda]));
  if (s) asm volatile ("vfld vf3,  %[ptr]" : : [ptr]"r"(&c[ldc*3]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_3) : );
  if (e) asm volatile ("vfsd vf3,  %[ptr]" : : [ptr]"r"(&c[ldc*3]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[4*lda]));
  if (s) asm volatile ("vfld vf4,  %[ptr]" : : [ptr]"r"(&c[ldc*4]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_4) : );
  if (e) asm volatile ("vfsd vf4,  %[ptr]" : : [ptr]"r"(&c[ldc*4]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[5*lda]));
  if (s) asm volatile ("vfld vf5,  %[ptr]" : : [ptr]"r"(&c[ldc*5]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_5) : );
  if (e) asm volatile ("vfsd vf5,  %[ptr]" : : [ptr]"r"(&c[ldc*5]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[6*lda]));
  if (s) asm volatile ("vfld vf6,  %[ptr]" : : [ptr]"r"(&c[ldc*6]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_6) : );
  if (e) asm volatile ("vfsd vf6,  %[ptr]" : : [ptr]"r"(&c[ldc*6]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[7*lda]));
  if (s) asm volatile ("vfld vf7,  %[ptr]" : : [ptr]"r"(&c[ldc*7]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_7) : );
  if (e) asm volatile ("vfsd vf7,  %[ptr]" : : [ptr]"r"(&c[ldc*7]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[8*lda]));
  if (s) asm volatile ("vfld vf8,  %[ptr]" : : [ptr]"r"(&c[ldc*8]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_8) : );
  if (e) asm volatile ("vfsd vf8,  %[ptr]" : : [ptr]"r"(&c[ldc*8]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[9*lda]));
  if (s) asm volatile ("vfld vf9,  %[ptr]" : : [ptr]"r"(&c[ldc*9]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_9) : );
  if (e) asm volatile ("vfsd vf9,  %[ptr]" : : [ptr]"r"(&c[ldc*9]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[10*lda]));
  if (s) asm volatile ("vfld vf10,  %[ptr]" : : [ptr]"r"(&c[ldc*10]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_10) : );
  if (e) asm volatile ("vfsd vf10,  %[ptr]" : : [ptr]"r"(&c[ldc*10]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[11*lda]));
  if (s) asm volatile ("vfld vf11,  %[ptr]" : : [ptr]"r"(&c[ldc*11]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_11) : );
  if (e) asm volatile ("vfsd vf11,  %[ptr]" : : [ptr]"r"(&c[ldc*11]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[12*lda]));
  if (s) asm volatile ("vfld vf12,  %[ptr]" : : [ptr]"r"(&c[ldc*12]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_12) : );
  if (e) asm volatile ("vfsd vf12,  %[ptr]" : : [ptr]"r"(&c[ldc*12]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[13*lda]));
  if (s) asm volatile ("vfld vf13,  %[ptr]" : : [ptr]"r"(&c[ldc*13]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_13) : );
  if (e) asm volatile ("vfsd vf13,  %[ptr]" : : [ptr]"r"(&c[ldc*13]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[14*lda]));
  if (s) asm volatile ("vfld vf14,  %[ptr]" : : [ptr]"r"(&c[ldc*14]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_14) : );
  if (e) asm volatile ("vfsd vf14,  %[ptr]" : : [ptr]"r"(&c[ldc*14]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[15*lda]));
  if (s) asm volatile ("vfld vf15,  %[ptr]" : : [ptr]"r"(&c[ldc*15]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_15) : );
  if (e) asm volatile ("vfsd vf15,  %[ptr]" : : [ptr]"r"(&c[ldc*15]) : );

         asm volatile ("vfmsv.d vf19, %[ptr]" : : [ptr]"r"(a[16*lda]));
  if (s) asm volatile ("vfld vf16,  %[ptr]" : : [ptr]"r"(&c[ldc*16]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_16) : );
  if (e) asm volatile ("vfsd vf16,  %[ptr]" : : [ptr]"r"(&c[ldc*16]) : );

         asm volatile ("vfmsv.d vf18, %[ptr]" : : [ptr]"r"(a[17*lda]));
  if (s) asm volatile ("vfld vf17,  %[ptr]" : : [ptr]"r"(&c[ldc*17]) : );
         asm volatile ("vf 0(%[vf_ptr])" : : [vf_ptr]"r"(&hwacha_mm_17) : );
  if (e) asm volatile ("vfsd vf17,  %[ptr]" : : [ptr]"r"(&c[ldc*17]) : );
}

static inline void mm_rb_hwacha(size_t m, size_t n, size_t p,
                                t* a, size_t lda, t* b, size_t ldb, t* c, size_t ldc)
{
  int vl;
  asm volatile ("vsetcfg 4, 21" : : : );
  asm volatile ("vsetvl %[gvl], %[nvl]" : [gvl]"=r"(vl) : [nvl]"r"(n) : );

  size_t mb = m/HRBM*HRBM, nk=p/HRBK*HRBK;

  for (size_t i=0; i<mb; i+=HRBM)
  {
    for (size_t k=0; k<nk; k+=HRBK)
    {
      nloop(k==0, k==(p-1), a+i*lda+k, lda, b+k*ldb, ldb, c+i*ldc, ldc);
    }
  }
}
