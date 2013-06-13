/*size_t i;
  size_t j;
  size_t max_dim = lda*lda;
  if (coreid==0){
    for (i=0; i<max_dim/(ncores*2); i+=8){
      data_t elementA1 = A[i];
      data_t elementA12 = A[i+1];
      data_t elementA13 = A[i+2];
      data_t elementA14 = A[i+3];
      data_t elementA15 = A[i+4];
      data_t elementA16 = A[i+5];
      data_t elementA17 = A[i+6];
      data_t elementA18 = A[i+7];
      data_t elementA2 = A[i+32*8];
      data_t elementA21 = A[i+32*8+1];
      data_t elementA22 = A[i+32*8+2];
      data_t elementA23 = A[i+32*8+3];
      data_t elementA24 = A[i+32*8+4];
      data_t elementA25 = A[i+32*8+5];
      data_t elementA26 = A[i+32*8+6];
      data_t elementA27 = A[i+32*8+7];
      int row= (int)(i/32)*32;
      int row2 = row+8*32;
      int column1 = i%32*32;
      int column12 = (i+1)%32*32;
      int column13 = (i+2)%32*32;
      int column14 = (i+3)%32*32;
      int column15 = (i+4)%32*32;
      int column16 = (i+5)%32*32;
      int column17 = (i+6)%32*32;
      int column18 = (i+7)%32*32;
    
      for (j=0; j<lda; j++){
	C[row+j]+=elementA1*B[column1+j]+elementA12*B[column12+j]+elementA13*B[column13+j]+elementA14*B[column14+j]+elementA15*B[column15+j]+elementA16*B[column16+j]+elementA17*B[column17+j]+elementA18*B[column18+j]
 
	C[row2+j]+=elementA2*B[column1+j]+elementA21*B[column12+j]+elementA22*B[column13+j]+elementA23*B[column14+j]+elementA24*B[column15+j]+elementA25*B[column16+j]+elementA26*B[column17+j]+elementA27*B[column18+j];
      }
  }}else{
    for (i=max_dim/2; i<(max_dim/(ncores*2)+max_dim/2); i+=8){
      data_t elementA1 = A[i];
      data_t elementA12 = A[i+1];
      data_t elementA13 = A[i+2];
      data_t elementA14 = A[i+3];
      data_t elementA15 = A[i+4];
      data_t elementA16 = A[i+5];
      data_t elementA17 = A[i+6];
      data_t elementA18 = A[i+7];
      data_t elementA2 = A[i+32*8];
      data_t elementA21 = A[i+32*8+1];
      data_t elementA22 = A[i+32*8+2];
      data_t elementA23 = A[i+32*8+3];
      data_t elementA24 = A[i+32*8+4];
      data_t elementA25 = A[i+32*8+5];
      data_t elementA26 = A[i+32*8+6];
      data_t elementA27 = A[i+32*8+7];
      int row= (int)(i/32)*32;
      int row2 = row+8*32;
      int column1 = i%32*32;
      int column12 = (i+1)%32*32;
      int column13 = (i+2)%32*32;
      int column14 = (i+3)%32*32;
      int column15 = (i+4)%32*32;
      int column16 = (i+5)%32*32;
      int column17 = (i+6)%32*32;
      int column18 = (i+7)%32*32;
    
      for (j=0; j<lda; j++){
	C[row+j]+=elementA1*B[column1+j]+elementA12*B[column12+j]+elementA13*B[column13+j]+elementA14*B[column14+j]+elementA15*B[column15+j]+elementA16*B[column16+j]+elementA17*B[column17+j]+elementA18*B[column18+j];
	C[row2+j]+=elementA2*B[column1+j]+elementA21*B[column12+j]+elementA22*B[column13+j]+elementA23*B[column14+j]+elementA24*B[column15+j]+elementA25*B[column16+j]+elementA26*B[column17+j]+elementA27*B[column18+j];

      }
    }
    }*/
