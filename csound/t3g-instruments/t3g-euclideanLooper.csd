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

FLpanel "Euclidean Looper", 770, 570, 50, 50
 gkExit,   gihExit   FLbutton  "exitnow", 1, 0, 21,  60, 25,  5, 5,  0, 999, 0, 0.001
 gkOnOff,  gihOnOff  FLbutton  "Run",     1, 0, 22, 100, 25, 70, 5, -1,   3, 0, -1
 gkTempo,  gihTempo  FLcount   "BPM",     1, 500, 21, 10,  1, 120, 20, 175, 5, -1
                     FLsetVal_i  128, gihTempo
gkLevel, gihLevel  FLslider  "Master Level",  0,  1, 0, 21, -1, 120, 20, 300, 5
                     FLsetVal_i  0.70, gihLevel
ih  FLbox  "steps",  1, 9, 16, 80, 30,  80, 40
ih  FLbox  "pulses", 1, 9, 16, 80, 30, 180, 40
ih  FLbox  "offset", 1, 9, 16, 80, 30, 280, 40
ih  FLbox  "panL",   1, 9, 16, 80, 30, 380, 40
ih  FLbox  "panR",   1, 9, 16, 80, 30, 480, 40
ih  FLbox  "panLFO", 1, 9, 16, 80, 30, 580, 40
ih  FLbox  "level",  1, 9, 16, 80, 30, 680, 40
#define loop(n) #
           ih       FLbox     "loop $n.", 1, 9, 16,                  60, 20,   0, 80+($n.-1)*30
;   gkoct,       gihandle      FLcount   "", imin, imax, istep1, istep2, itype, iw, ih,  ix,            iy, iopcode, 1, 0, 1
    gkSteps$n.,  gihSteps$n.   FLcount   "",    0,  100,      1,     10,     1, 80, 20,  80, 80+($n.-1)*30,      -1
                               FLsetVal_i 16, gihSteps$n.   
    gkPulses$n., gihPulses$n.  FLcount   "",    0,  100,      1,     10,     1, 80, 20, 180, 80+($n.-1)*30,      -1
                               FLsetVal_i 4, gihPulses$n.   
    gkOffset$n., gihOffset$n.  FLcount   "",    0,  100,      1,     10,     1, 80, 20, 280, 80+($n.-1)*30,      -1
                               FLsetVal_i 0, gihOffset$n.   
;    kout, ihandle  FLslider  "label", imin, imax, iexp, itype, idisp, iw, ih, ix, iy
     gkPanL$n.,   gihPanL$n.  FLslider  "",        -1,    0,    0,    23,    -1, 80, 20, 380, 80+($n.-1)*30
                               FLsetVal_i -0.5, gihPanL$n.   
     gkpPanR$n.,   gihPanR$n.  FLslider  "",         0,    1,    0,    23,    -1, 80, 20, 480, 80+($n.-1)*30
                               FLsetVal_i  0.5, gihPanR$n.   
     gkPanLFO$n., gihPanLFO$n.  FLslider  "",     1/8,    8,   -1,    23,    -1, 80, 20, 580, 80+($n.-1)*30
                               FLsetVal_i  1, gihPanLFO$n.   
     gkLevel$n.,  gihLevel$n.  FLslider  "",        0,  100,    0,    21,    -1, 80, 20, 680, 80+($n.-1)*30
                               FLsetVal_i 70, gihLevel$n.   
#
$loop(1)
$loop(2)
$loop(3)
$loop(4)
$loop(5)
$loop(6)
$loop(7)
$loop(8)
$loop(9)
$loop(10)
$loop(11)
$loop(12)
$loop(13)
$loop(14)
$loop(15)
$loop(16)

FLpanelEnd
FLrun

instr 1
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
