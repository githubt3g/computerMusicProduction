<CsoundSynthesizer>
<CsOptions>
-dodac
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1

FLpanel "T3G Pink Noise", 195, 100, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
;gkfreq, ihandle FLslider "Frequency", imin, imax, iexp, itype, idisp, iwidth, iheight, ix, iy
 gkvolume, ihvolume FLslider "Volume", 0, 1, 0, 5, -1, 175, 20, 10, 55
FLpanel_end
FLrun

;FLsetVal_i ivalue, ihandle
 FLsetVal_i 0.1, ihvolume

instr 1
  awhiteL  unirand  2.0
  awhiteL  =        awhiteL - 1.0 
  awhiteR  unirand  2.0
  awhiteR  =        awhiteR - 1.0 
   apinkL  pinkish  awhiteL, 1, 0, 0, 1
   apinkR  pinkish  awhiteR, 1, 0, 0, 1
           out      gkvolume*apinkL, gkvolume*apinkR
endin

instr 1000
  exitnow
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
i1 0 3600
</CsScore>
</CsoundSynthesizer>
