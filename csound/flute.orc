;---------------------------------------------------------------------------
; New Age Bull
;---------------------------------------------------------------------------

sr=44100
kr=22050
ksmps=2
nchnls=2
0dbfs=1

;-------------------------------------------------------------
;Flute Instrument based on Perry Cook's Slide Flute
;-------------------------------------------------------------
         instr  60

aflute1  init   0
ifqc     =      cpsmidinn(p5)
ipress   =      .9    ;p6
ibreath  =      .01  ;p7
ifeedbk1 =      .4    ;p8
ifeedbk2 =      .4    ;p9
ibendtab =      p6
ioutch   =      p7
iaccnt   =      p8
kbreath  linseg 0, .005, .4*iaccnt, .2, 0, p3-.205, 0

;-------------------------------------------------------------
kenv1    linseg 0,.01,iaccnt*1.4*ipress,.1,ipress,p3-.17,ipress,.06,0
;Flow setup
kenv2    linseg 0,.01,1,p3-.02,1,.01,0     ;Flow must be about 1 or it will blow up
kenvibr  linseg 0,.5,0,.5,1,p3-1,1         ; Vibrato envelope
kvbrate  oscil  1, 1, 1
kvibr    oscil  .02*kenvibr,5+kvbrate,1    ;Low frequency vibrato
kbend    oscil  1, 1/p3, ibendtab

;-------------------------------------------------------------
arnd0    rand   p4
arnd1    reson  arnd0, 1230, 200
arnd2    reson  arnd0, 3202, 1000
arnd3    reson  arnd0, 6402, 2000

abal1    =      kenv1
aflow1   balance arnd1+arnd2+arnd3,  abal1+kvibr  ;Noise is used to simulate breath sound.
asum1    =      ibreath*aflow1+kenv1+kvibr  ;Add flow, noise and vibrato.
asum2    =      asum1+aflute1*ifeedbk1      ;Add above to scaled feedback.
afqc     =      1/ifqc/kbend-asum1/20000-4/sr+ifqc/kbend/5000000 ;Find delay length.

;-------------------------------------------------------------
atemp1   delayr   1/ifqc/2                  ;The embouchoure delay should
ax       deltapi  afqc/2                    ;be about 1/2 the bore delay.
         delayw   asum2

;-------------------------------------------------------------
apoly    =        ax-ax*ax*ax               ;A polynomial is used to adjust
asum3    =        apoly+aflute1*ifeedbk2    ;the feedback.

kfco     linseg   4000, .1, 1000, .1, 2400, p3-.2, 2000
avalue   tone     asum3, kfco

; Bore, the bore length determines pitch.  Shorter is higher pitch.
;-------------------------------------------------------------
atemp2   delayr   1/ifqc
aflute1  deltapi  afqc
         delayw   avalue

khpenv   linseg   600, .3, 20, p3-.3, 20
aout     butterhp avalue, khpenv

         outs     (aout+kbreath*(arnd2+arnd3)/400000)*p4*kenv2, (aout+kbreath*(arnd2+arnd3)/400000)*p4*kenv2

         endin

