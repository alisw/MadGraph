      SUBROUTINE ML5_0_HELAS_CALLS_AMPB_1(P,NHEL,H,IC)
C     
C     Modules
C     
      USE ML5_0_POLYNOMIAL_CONSTANTS
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
      INTEGER    NCOMB
      PARAMETER (NCOMB=48)
      INTEGER NBORNAMPS
      PARAMETER (NBORNAMPS=8)
      INTEGER    NLOOPS, NLOOPGROUPS, NCTAMPS
      PARAMETER (NLOOPS=144, NLOOPGROUPS=77, NCTAMPS=252)
      INTEGER    NLOOPAMPS
      PARAMETER (NLOOPAMPS=396)
      INTEGER    NWAVEFUNCS,NLOOPWAVEFUNCS
      PARAMETER (NWAVEFUNCS=28,NLOOPWAVEFUNCS=267)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
      REAL*16     MP__ZERO
      PARAMETER (MP__ZERO=0.0E0_16)
C     These are constants related to the split orders
      INTEGER    NSO, NSQUAREDSO, NAMPSO
      PARAMETER (NSO=0, NSQUAREDSO=0, NAMPSO=0)
C     
C     ARGUMENTS
C     
      REAL*8 P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
      INTEGER H
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J,K
      COMPLEX*16 COEFS(MAXLWFSIZE,0:VERTEXMAXCOEFS-1,MAXLWFSIZE)

      LOGICAL DUMMYFALSE
      DATA DUMMYFALSE/.FALSE./
C     
C     GLOBAL VARIABLES
C     
      INCLUDE 'coupl.inc'
      INCLUDE 'mp_coupl.inc'

      INTEGER HELOFFSET
      INTEGER GOODHEL(NCOMB)
      LOGICAL GOODAMP(NSQUAREDSO,NLOOPGROUPS)
      COMMON/ML5_0_FILTERS/GOODAMP,GOODHEL,HELOFFSET

      LOGICAL CHECKPHASE
      LOGICAL HELDOUBLECHECKED
      COMMON/ML5_0_INIT/CHECKPHASE, HELDOUBLECHECKED

      INTEGER SQSO_TARGET
      COMMON/ML5_0_SOCHOICE/SQSO_TARGET

      LOGICAL UVCT_REQ_SO_DONE,MP_UVCT_REQ_SO_DONE,CT_REQ_SO_DONE
     $ ,MP_CT_REQ_SO_DONE,LOOP_REQ_SO_DONE,MP_LOOP_REQ_SO_DONE
     $ ,CTCALL_REQ_SO_DONE,FILTER_SO
      COMMON/ML5_0_SO_REQS/UVCT_REQ_SO_DONE,MP_UVCT_REQ_SO_DONE
     $ ,CT_REQ_SO_DONE,MP_CT_REQ_SO_DONE,LOOP_REQ_SO_DONE
     $ ,MP_LOOP_REQ_SO_DONE,CTCALL_REQ_SO_DONE,FILTER_SO

      INTEGER I_SO
      COMMON/ML5_0_I_SO/I_SO
      INTEGER I_LIB
      COMMON/ML5_0_I_LIB/I_LIB

      COMPLEX*16 AMP(NBORNAMPS)
      COMMON/ML5_0_AMPS/AMP
      COMPLEX*16 W(20,NWAVEFUNCS)
      COMMON/ML5_0_W/W

      COMPLEX*16 WL(MAXLWFSIZE,0:LOOPMAXCOEFS-1,MAXLWFSIZE,
     $ -1:NLOOPWAVEFUNCS)
      COMPLEX*16 PL(0:3,-1:NLOOPWAVEFUNCS)
      COMMON/ML5_0_WL/WL,PL

      COMPLEX*16 AMPL(3,NCTAMPS)
      COMMON/ML5_0_AMPL/AMPL

C     
C     ----------
C     BEGIN CODE
C     ----------

C     The target squared split order contribution is already reached
C      if true.
      IF (FILTER_SO.AND.CT_REQ_SO_DONE) THEN
        GOTO 1001
      ENDIF

      CALL VXXXXX(P(0,1),ZERO,NHEL(1),-1*IC(1),W(1,1))
      CALL VXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
      CALL VXXXXX(P(0,3),MDL_MW,NHEL(3),+1*IC(3),W(1,3))
      CALL OXXXXX(P(0,4),MDL_MT,NHEL(4),+1*IC(4),W(1,4))
      CALL IXXXXX(P(0,5),MDL_MB,NHEL(5),-1*IC(5),W(1,5))
      CALL VVV1P0_1(W(1,1),W(1,2),GC_4,ZERO,ZERO,W(1,6))
      CALL FFV2_1(W(1,4),W(1,3),GC_11,MDL_MB,ZERO,W(1,7))
C     Amplitude(s) for born diagram with ID 1
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),GC_5,AMP(1))
      CALL FFV2_2(W(1,5),W(1,3),GC_11,MDL_MT,MDL_WT,W(1,8))
C     Amplitude(s) for born diagram with ID 2
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),GC_5,AMP(2))
      CALL FFV1_1(W(1,4),W(1,1),GC_5,MDL_MT,MDL_WT,W(1,9))
      CALL FFV1_2(W(1,5),W(1,2),GC_5,MDL_MB,ZERO,W(1,10))
C     Amplitude(s) for born diagram with ID 3
      CALL FFV2_0(W(1,10),W(1,9),W(1,3),GC_11,AMP(3))
C     Amplitude(s) for born diagram with ID 4
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),GC_5,AMP(4))
      CALL FFV1_2(W(1,5),W(1,1),GC_5,MDL_MB,ZERO,W(1,11))
      CALL FFV1_1(W(1,4),W(1,2),GC_5,MDL_MT,MDL_WT,W(1,12))
C     Amplitude(s) for born diagram with ID 5
      CALL FFV2_0(W(1,11),W(1,12),W(1,3),GC_11,AMP(5))
C     Amplitude(s) for born diagram with ID 6
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),GC_5,AMP(6))
C     Amplitude(s) for born diagram with ID 7
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),GC_5,AMP(7))
C     Amplitude(s) for born diagram with ID 8
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),GC_5,AMP(8))
      CALL FFV1P0_3(W(1,5),W(1,7),GC_5,ZERO,ZERO,W(1,13))
C     Counter-term amplitude(s) for loop diagram number 9
      CALL R2_GG_1_0(W(1,6),W(1,13),R2_GGQ,AMPL(1,1))
      CALL R2_GG_1_0(W(1,6),W(1,13),R2_GGQ,AMPL(1,2))
      CALL R2_GG_1_0(W(1,6),W(1,13),R2_GGQ,AMPL(1,3))
      CALL R2_GG_1_0(W(1,6),W(1,13),R2_GGQ,AMPL(1,4))
      CALL FFV1P0_3(W(1,8),W(1,4),GC_5,ZERO,ZERO,W(1,14))
C     Counter-term amplitude(s) for loop diagram number 10
      CALL R2_GG_1_0(W(1,6),W(1,14),R2_GGQ,AMPL(1,5))
      CALL R2_GG_1_0(W(1,6),W(1,14),R2_GGQ,AMPL(1,6))
      CALL R2_GG_1_0(W(1,6),W(1,14),R2_GGQ,AMPL(1,7))
      CALL R2_GG_1_0(W(1,6),W(1,14),R2_GGQ,AMPL(1,8))
C     Counter-term amplitude(s) for loop diagram number 11
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,9))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,10))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,11))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,12))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB,AMPL(1,13))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,14))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GT,AMPL(1,15))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GB_1EPS,AMPL(2,16))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),UV_3GG_1EPS,AMPL(2,17))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,18))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,19))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,20))
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,21))
C     Counter-term amplitude(s) for loop diagram number 12
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,22))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,23))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,24))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,25))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB,AMPL(1,26))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,27))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GT,AMPL(1,28))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GB_1EPS,AMPL(2,29))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),UV_3GG_1EPS,AMPL(2,30))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,31))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,32))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,33))
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,34))
      CALL FFV1_2(W(1,5),W(1,6),GC_5,MDL_MB,ZERO,W(1,15))
C     Counter-term amplitude(s) for loop diagram number 15
      CALL R2_QQ_1_R2_QQ_2_0(W(1,15),W(1,7),R2_QQQ,R2_QQB,AMPL(1,35))
      CALL R2_QQ_2_0(W(1,15),W(1,7),UV_BMASS,AMPL(1,36))
      CALL R2_QQ_2_0(W(1,15),W(1,7),UV_BMASS_1EPS,AMPL(2,37))
C     Counter-term amplitude(s) for loop diagram number 16
      CALL R2_GG_1_R2_GG_3_0(W(1,6),W(1,13),R2_GGQ,R2_GGB,AMPL(1,38))
C     Counter-term amplitude(s) for loop diagram number 17
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,39))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,40))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,41))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,42))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB,AMPL(1,43))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,44))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQT,AMPL(1,45))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQB_1EPS,AMPL(2,46))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),UV_GQQG_1EPS,AMPL(2,47))
      CALL FFV1_0(W(1,5),W(1,7),W(1,6),R2_GQQ,AMPL(1,48))
C     Counter-term amplitude(s) for loop diagram number 19
      CALL R2_GG_1_R2_GG_3_0(W(1,6),W(1,14),R2_GGQ,R2_GGB,AMPL(1,49))
C     Counter-term amplitude(s) for loop diagram number 20
      CALL FFV2_0(W(1,15),W(1,4),W(1,3),R2_BXTW,AMPL(1,50))
      CALL FFV1_1(W(1,4),W(1,6),GC_5,MDL_MT,MDL_WT,W(1,16))
C     Counter-term amplitude(s) for loop diagram number 23
      CALL FFV2_0(W(1,5),W(1,16),W(1,3),R2_BXTW,AMPL(1,51))
      CALL FFV2_1(W(1,9),W(1,3),GC_11,MDL_MB,ZERO,W(1,17))
C     Counter-term amplitude(s) for loop diagram number 25
      CALL R2_QQ_1_R2_QQ_2_0(W(1,10),W(1,17),R2_QQQ,R2_QQB,AMPL(1,52))
      CALL R2_QQ_2_0(W(1,10),W(1,17),UV_BMASS,AMPL(1,53))
      CALL R2_QQ_2_0(W(1,10),W(1,17),UV_BMASS_1EPS,AMPL(2,54))
C     Counter-term amplitude(s) for loop diagram number 26
      CALL FFV2_0(W(1,10),W(1,9),W(1,3),R2_BXTW,AMPL(1,55))
C     Counter-term amplitude(s) for loop diagram number 27
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,56))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,57))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,58))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,59))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB,AMPL(1,60))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,61))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQT,AMPL(1,62))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQB_1EPS,AMPL(2,63))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),UV_GQQG_1EPS,AMPL(2,64))
      CALL FFV1_0(W(1,5),W(1,17),W(1,2),R2_GQQ,AMPL(1,65))
      CALL FFV1_1(W(1,9),W(1,2),GC_5,MDL_MT,MDL_WT,W(1,18))
C     Counter-term amplitude(s) for loop diagram number 29
      CALL FFV2_0(W(1,5),W(1,18),W(1,3),R2_BXTW,AMPL(1,66))
      CALL FFV2_1(W(1,12),W(1,3),GC_11,MDL_MB,ZERO,W(1,19))
C     Counter-term amplitude(s) for loop diagram number 33
      CALL R2_QQ_1_R2_QQ_2_0(W(1,11),W(1,19),R2_QQQ,R2_QQB,AMPL(1,67))
      CALL R2_QQ_2_0(W(1,11),W(1,19),UV_BMASS,AMPL(1,68))
      CALL R2_QQ_2_0(W(1,11),W(1,19),UV_BMASS_1EPS,AMPL(2,69))
C     Counter-term amplitude(s) for loop diagram number 34
      CALL FFV2_0(W(1,11),W(1,12),W(1,3),R2_BXTW,AMPL(1,70))
C     Counter-term amplitude(s) for loop diagram number 35
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,71))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,72))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,73))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,74))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB,AMPL(1,75))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,76))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQT,AMPL(1,77))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQB_1EPS,AMPL(2,78))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),UV_GQQG_1EPS,AMPL(2,79))
      CALL FFV1_0(W(1,11),W(1,7),W(1,2),R2_GQQ,AMPL(1,80))
      CALL FFV1_2(W(1,11),W(1,2),GC_5,MDL_MB,ZERO,W(1,20))
C     Counter-term amplitude(s) for loop diagram number 37
      CALL R2_QQ_1_R2_QQ_2_0(W(1,20),W(1,7),R2_QQQ,R2_QQB,AMPL(1,81))
      CALL R2_QQ_2_0(W(1,20),W(1,7),UV_BMASS,AMPL(1,82))
      CALL R2_QQ_2_0(W(1,20),W(1,7),UV_BMASS_1EPS,AMPL(2,83))
      CALL FFV1_1(W(1,7),W(1,2),GC_5,MDL_MB,ZERO,W(1,21))
C     Counter-term amplitude(s) for loop diagram number 38
      CALL R2_QQ_1_R2_QQ_2_0(W(1,11),W(1,21),R2_QQQ,R2_QQB,AMPL(1,84))
      CALL R2_QQ_2_0(W(1,11),W(1,21),UV_BMASS,AMPL(1,85))
      CALL R2_QQ_2_0(W(1,11),W(1,21),UV_BMASS_1EPS,AMPL(2,86))
C     Counter-term amplitude(s) for loop diagram number 40
      CALL FFV2_0(W(1,20),W(1,4),W(1,3),R2_BXTW,AMPL(1,87))
C     Counter-term amplitude(s) for loop diagram number 43
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,88))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,89))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,90))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,91))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB,AMPL(1,92))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,93))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQT,AMPL(1,94))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQB_1EPS,AMPL(2,95))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),UV_GQQG_1EPS,AMPL(2,96))
      CALL FFV1_0(W(1,5),W(1,19),W(1,1),R2_GQQ,AMPL(1,97))
C     Counter-term amplitude(s) for loop diagram number 45
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,98))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,99))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,100))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,101))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB,AMPL(1,102))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,103))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQT,AMPL(1,104))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQB_1EPS,AMPL(2,105))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),UV_GQQG_1EPS,AMPL(2,106))
      CALL FFV1_0(W(1,10),W(1,7),W(1,1),R2_GQQ,AMPL(1,107))
C     Counter-term amplitude(s) for loop diagram number 48
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,108))
C     Counter-term amplitude(s) for loop diagram number 50
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,109))
C     Counter-term amplitude(s) for loop diagram number 53
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,110))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,111))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,112))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,113))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB,AMPL(1,114))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,115))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQT,AMPL(1,116))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQB_1EPS,AMPL(2,117))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),UV_GQQG_1EPS,AMPL(2,118))
      CALL FFV1_0(W(1,5),W(1,21),W(1,1),R2_GQQ,AMPL(1,119))
      CALL FFV1_1(W(1,12),W(1,1),GC_5,MDL_MT,MDL_WT,W(1,22))
C     Counter-term amplitude(s) for loop diagram number 59
      CALL FFV2_0(W(1,5),W(1,22),W(1,3),R2_BXTW,AMPL(1,120))
      CALL FFV1_2(W(1,10),W(1,1),GC_5,MDL_MB,ZERO,W(1,23))
C     Counter-term amplitude(s) for loop diagram number 63
      CALL R2_QQ_1_R2_QQ_2_0(W(1,23),W(1,7),R2_QQQ,R2_QQB,AMPL(1,121))
      CALL R2_QQ_2_0(W(1,23),W(1,7),UV_BMASS,AMPL(1,122))
      CALL R2_QQ_2_0(W(1,23),W(1,7),UV_BMASS_1EPS,AMPL(2,123))
      CALL FFV1_1(W(1,7),W(1,1),GC_5,MDL_MB,ZERO,W(1,24))
C     Counter-term amplitude(s) for loop diagram number 64
      CALL R2_QQ_1_R2_QQ_2_0(W(1,10),W(1,24),R2_QQQ,R2_QQB,AMPL(1,124))
      CALL R2_QQ_2_0(W(1,10),W(1,24),UV_BMASS,AMPL(1,125))
      CALL R2_QQ_2_0(W(1,10),W(1,24),UV_BMASS_1EPS,AMPL(2,126))
C     Counter-term amplitude(s) for loop diagram number 66
      CALL FFV2_0(W(1,23),W(1,4),W(1,3),R2_BXTW,AMPL(1,127))
C     Counter-term amplitude(s) for loop diagram number 69
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,128))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,129))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,130))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,131))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB,AMPL(1,132))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,133))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQT,AMPL(1,134))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQB_1EPS,AMPL(2,135))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),UV_GQQG_1EPS,AMPL(2,136))
      CALL FFV1_0(W(1,5),W(1,24),W(1,2),R2_GQQ,AMPL(1,137))
C     Counter-term amplitude(s) for loop diagram number 85
      CALL R2_GG_1_R2_GG_3_0(W(1,6),W(1,13),R2_GGQ,R2_GGT,AMPL(1,138))
C     Counter-term amplitude(s) for loop diagram number 86
      CALL R2_QQ_1_R2_QQ_2_0(W(1,8),W(1,16),R2_QQQ,R2_QQT,AMPL(1,139))
      CALL R2_QQ_2_0(W(1,8),W(1,16),UV_TMASS,AMPL(1,140))
      CALL R2_QQ_2_0(W(1,8),W(1,16),UV_TMASS_1EPS,AMPL(2,141))
C     Counter-term amplitude(s) for loop diagram number 87
      CALL R2_GG_1_R2_GG_3_0(W(1,6),W(1,14),R2_GGQ,R2_GGT,AMPL(1,142))
C     Counter-term amplitude(s) for loop diagram number 88
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,143))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,144))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,145))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,146))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB,AMPL(1,147))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,148))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQT,AMPL(1,149))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQB_1EPS,AMPL(2,150))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),UV_GQQG_1EPS,AMPL(2,151))
      CALL FFV1_0(W(1,8),W(1,4),W(1,6),R2_GQQ,AMPL(1,152))
      CALL FFV2_2(W(1,10),W(1,3),GC_11,MDL_MT,MDL_WT,W(1,25))
C     Counter-term amplitude(s) for loop diagram number 90
      CALL R2_QQ_1_R2_QQ_2_0(W(1,25),W(1,9),R2_QQQ,R2_QQT,AMPL(1,153))
      CALL R2_QQ_2_0(W(1,25),W(1,9),UV_TMASS,AMPL(1,154))
      CALL R2_QQ_2_0(W(1,25),W(1,9),UV_TMASS_1EPS,AMPL(2,155))
C     Counter-term amplitude(s) for loop diagram number 91
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,156))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,157))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,158))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,159))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB,AMPL(1,160))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,161))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQT,AMPL(1,162))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQB_1EPS,AMPL(2,163))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),UV_GQQG_1EPS,AMPL(2,164))
      CALL FFV1_0(W(1,8),W(1,9),W(1,2),R2_GQQ,AMPL(1,165))
C     Counter-term amplitude(s) for loop diagram number 92
      CALL R2_QQ_1_R2_QQ_2_0(W(1,8),W(1,18),R2_QQQ,R2_QQT,AMPL(1,166))
      CALL R2_QQ_2_0(W(1,8),W(1,18),UV_TMASS,AMPL(1,167))
      CALL R2_QQ_2_0(W(1,8),W(1,18),UV_TMASS_1EPS,AMPL(2,168))
      CALL FFV1_2(W(1,8),W(1,2),GC_5,MDL_MT,MDL_WT,W(1,26))
C     Counter-term amplitude(s) for loop diagram number 93
      CALL R2_QQ_1_R2_QQ_2_0(W(1,26),W(1,9),R2_QQQ,R2_QQT,AMPL(1,169))
      CALL R2_QQ_2_0(W(1,26),W(1,9),UV_TMASS,AMPL(1,170))
      CALL R2_QQ_2_0(W(1,26),W(1,9),UV_TMASS_1EPS,AMPL(2,171))
      CALL FFV2_2(W(1,11),W(1,3),GC_11,MDL_MT,MDL_WT,W(1,27))
C     Counter-term amplitude(s) for loop diagram number 95
      CALL R2_QQ_1_R2_QQ_2_0(W(1,27),W(1,12),R2_QQQ,R2_QQT,AMPL(1,172))
      CALL R2_QQ_2_0(W(1,27),W(1,12),UV_TMASS,AMPL(1,173))
      CALL R2_QQ_2_0(W(1,27),W(1,12),UV_TMASS_1EPS,AMPL(2,174))
C     Counter-term amplitude(s) for loop diagram number 96
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,175))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,176))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,177))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,178))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB,AMPL(1,179))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,180))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQT,AMPL(1,181))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,182))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),UV_GQQG_1EPS,AMPL(2,183))
      CALL FFV1_0(W(1,27),W(1,4),W(1,2),R2_GQQ,AMPL(1,184))
C     Counter-term amplitude(s) for loop diagram number 98
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,185))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,186))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,187))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,188))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB,AMPL(1,189))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,190))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQT,AMPL(1,191))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQB_1EPS,AMPL(2,192))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),UV_GQQG_1EPS,AMPL(2,193))
      CALL FFV1_0(W(1,8),W(1,12),W(1,1),R2_GQQ,AMPL(1,194))
C     Counter-term amplitude(s) for loop diagram number 99
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,195))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,196))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,197))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,198))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB,AMPL(1,199))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,200))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQT,AMPL(1,201))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,202))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),UV_GQQG_1EPS,AMPL(2,203))
      CALL FFV1_0(W(1,25),W(1,4),W(1,1),R2_GQQ,AMPL(1,204))
C     Counter-term amplitude(s) for loop diagram number 100
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GQ,AMPL(1,205))
C     Counter-term amplitude(s) for loop diagram number 101
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GQ,AMPL(1,206))
C     Counter-term amplitude(s) for loop diagram number 107
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,207))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,208))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,209))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,210))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB,AMPL(1,211))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,212))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQT,AMPL(1,213))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQB_1EPS,AMPL(2,214))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),UV_GQQG_1EPS,AMPL(2,215))
      CALL FFV1_0(W(1,26),W(1,4),W(1,1),R2_GQQ,AMPL(1,216))
C     Counter-term amplitude(s) for loop diagram number 108
      CALL R2_QQ_1_R2_QQ_2_0(W(1,8),W(1,22),R2_QQQ,R2_QQT,AMPL(1,217))
      CALL R2_QQ_2_0(W(1,8),W(1,22),UV_TMASS,AMPL(1,218))
      CALL R2_QQ_2_0(W(1,8),W(1,22),UV_TMASS_1EPS,AMPL(2,219))
      CALL FFV1_2(W(1,8),W(1,1),GC_5,MDL_MT,MDL_WT,W(1,28))
C     Counter-term amplitude(s) for loop diagram number 109
      CALL R2_QQ_1_R2_QQ_2_0(W(1,28),W(1,12),R2_QQQ,R2_QQT,AMPL(1,220))
      CALL R2_QQ_2_0(W(1,28),W(1,12),UV_TMASS,AMPL(1,221))
      CALL R2_QQ_2_0(W(1,28),W(1,12),UV_TMASS_1EPS,AMPL(2,222))
C     Counter-term amplitude(s) for loop diagram number 112
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,223))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,224))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,225))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,226))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB,AMPL(1,227))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,228))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQT,AMPL(1,229))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQB_1EPS,AMPL(2,230))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),UV_GQQG_1EPS,AMPL(2,231))
      CALL FFV1_0(W(1,28),W(1,4),W(1,2),R2_GQQ,AMPL(1,232))
C     Counter-term amplitude(s) for loop diagram number 119
      CALL R2_GG_1_R2_GG_2_0(W(1,6),W(1,13),R2_GGG_1,R2_GGG_2,AMPL(1
     $ ,233))
C     Counter-term amplitude(s) for loop diagram number 120
      CALL R2_GG_1_R2_GG_2_0(W(1,6),W(1,14),R2_GGG_1,R2_GGG_2,AMPL(1
     $ ,234))
C     Counter-term amplitude(s) for loop diagram number 121
      CALL VVV1_0(W(1,1),W(1,2),W(1,13),R2_3GG,AMPL(1,235))
C     Counter-term amplitude(s) for loop diagram number 122
      CALL VVV1_0(W(1,1),W(1,2),W(1,14),R2_3GG,AMPL(1,236))

      GOTO 1001
 2000 CONTINUE
      CT_REQ_SO_DONE=.TRUE.
 1001 CONTINUE
      END

