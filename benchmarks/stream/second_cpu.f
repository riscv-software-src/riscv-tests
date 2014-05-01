*-------------------------------------
* Sample timing routine
*       This code works on Sun and Silicon Graphics machines.
*       DOUBLE PRECISION function second(dummy)
*       double precision dummy
*       real arg(2)
*       second = etime(arg)
*       end
* Sample timing routine
*       This code works on IBM RS/6000 machines
      DOUBLE PRECISION FUNCTION second(dummy)
C     .. Scalar Arguments ..
      DOUBLE PRECISION dummy
C     ..
C     .. External Functions ..
      INTEGER mclock
      EXTERNAL mclock
C     ..
      second = mclock()*0.01D0
      END

