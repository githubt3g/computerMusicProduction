<CsoundSynthesizer>
<CsOptions>
-odac           
-iadc     
-d
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100
nchnls = 1

FLpanel "Euclidean Looper", 770, 290, 50, 50
ih  FLbox  "steps", 1, 9, 16, 80, 30,  80, 0
ih  FLbox  "pulses", 1, 9, 16, 80, 30, 180, 0
ih  FLbox  "offset", 1, 9, 16, 80, 30, 280, 0
ih  FLbox  "panL", 1, 9, 16, 80, 30, 380, 0
ih  FLbox  "panR", 1, 9, 16, 80, 30, 480, 0
ih  FLbox  "panLFO", 1, 9, 16, 80, 30, 580, 0
ih  FLbox  "level", 1, 9, 16, 80, 30, 680, 0
#define loop(n) #
           ih       FLbox     "loop $n.", 1, 9, 16,                  60, 20,   0, 45+($n.-1)*30
;   gkoct, ihandle  FLcount   "", imin, imax, istep1, istep2, itype, iw, ih,  ix,            iy, iopcode, 1, 0, 1
    gkoct, ihandle  FLcount   "",    0,  100,      1,     10,     1, 80, 30,  80, 40+($n.-1)*30,      -1
    gkoct, ihandle  FLcount   "",    0,  100,      1,     10,     1, 80, 30, 180, 40+($n.-1)*30,      -1
    gkoct, ihandle  FLcount   "",    0,  100,      1,     10,     1, 80, 30, 280, 40+($n.-1)*30,      -1
;    kout, ihandle  FLslider  "label", imin, imax, iexp, itype, idisp, iw, ih, ix, iy
     kout, ihandle  FLslider  "",        -1,    0,    0,     5,    -1, 80, 20, 380, 40+($n.-1)*30
     kout, ihandle  FLslider  "",         0,    1,    0,     5,    -1, 80, 20, 480, 40+($n.-1)*30
     kout, ihandle  FLslider  "",       1/8,    8,   -1,     5,    -1, 80, 20, 580, 40+($n.-1)*30
     kout, ihandle  FLslider  "",         0,  100,    0,     5,    -1, 80, 20, 680, 40+($n.-1)*30
#
$loop(1)
$loop(2)
$loop(3)
$loop(4)
$loop(5)
$loop(6)
$loop(7)
$loop(8)
gkExit,ihExit	FLbutton "exitnow",1,  0,  21,  60,   25,  5, 5,    0,  999,  0,   0.001

FLpanelEnd
FLrun

instr 1
    iamp = 15000
    ifn = 1
    asig oscili iamp, cpsoct(gkoct), ifn
    out asig
endin

instr 999
exitnow
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1
f 0 3600
</CsScore>
</CsoundSynthesizer>
