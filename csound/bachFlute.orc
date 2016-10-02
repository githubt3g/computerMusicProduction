sr = 44100
kr = 4410
ksmps =  10
nchnls = 1
0dbfs = 1

;Flute Instrument based on Perry Cook's Slide Flute

instr 1

  aflute1 init 0
  ifqc    = cpsmidinn(p4)
  ipress  = 0.9  
  ibreath = 0.015           
  ifeedbk1=  0.4
  ifeedbk2= 0.4

; Flow setup
  kenv1   linseg 0, .06, 1.1*ipress, .2, ipress, p3-.16, ipress, .02, 0 
  kenv2   linseg 0, .01, 1, p3-.02, 1, .01, 0
  kenvibr linseg 0, .5, 0, .5, 1, p3-1, 1  ; Vibrato envelope

; The values must be approximately -1 to 1 or the cubic will blow up.
  aflow1 rand kenv1
  kvibr oscil .1*kenvibr, 5, 3

; ibreath can be used to adjust the noise level.
  asum1 = ibreath*aflow1 + kenv1 + kvibr
  asum2 = asum1 + aflute1*ifeedbk1

  afqc  = 1/ifqc - asum1/20000 -9/sr + ifqc/12000000

; Embouchure delay should be 1/2 the bore delay
;  ax delay asum2, (1/ifqc-10/sr)/2
  atemp1 delayr 1/ifqc/2
  ax     deltapi afqc/2 ; - asum1/ifqc/10 + 1/1000
         delayw asum2

  apoly = ax - ax*ax*ax
  asum3 = apoly + aflute1*ifeedbk2

  avalue tone asum3, 2000

; Bore, the bore length determines pitch.  Shorter is higher pitch.
   atemp2   delayr 1/ifqc
   aflute1 deltapi afqc
           delayw avalue

  out avalue*p5/100*kenv2

endin
