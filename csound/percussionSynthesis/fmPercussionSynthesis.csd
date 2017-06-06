<CsoundSynthesizer>
<CsOptions>
-ot.wav ;dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 1
nchnls = 1
0dbfs  = 1

FLpanel "Title", 800, 400, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
FLpanel_end
FLrun
 
instr fmPercussion
    kA linseg   16, p3, 1
   kfm linseg   440, 0.05, 55, 0.45, 33
  kfm2 linseg   880, 0.05, 440, 0.45, 33
   kfc linseg   150, 0.05, 100, 0.45, 80
    kz oscil    1, kfm, 1
   kz2 oscil    1, kfm2, 1
 kmenv linseg   0, 0.03, 1, 0.45, 0
km2env linseg   0, 0.02, 1, 0.02, 0
    ay oscil    1, kfc+kmenv*kA*kz+km2env*kA*kz, 1
   ;ay butterlp ay, 82.5 
   ;ay butterlp ay, 55 
   ;ay butterlp ay, 110 
   ;ay butterlp ay, 110 
 kcenv linseg   0, 0.03, 1 
kcenv2 expseg   2, p3/2, 1.25, p3/2, 1 
       out      (kcenv2-1)*kcenv*ay 
endin 

instr 999
aL monitor
   fout "out.wav", 14, aL
endin

instr 1000
  exitnow
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
#define r #4#
{$r n
i"fmPercussion" [0.00+$n*4*60/128] [60/128]
i"fmPercussion" [2.00+$n*4*60/128] [60/128]
i"fmPercussion" [2.50+$n*4*60/128] [60/128]
i"fmPercussion" [3.33+$n*4*60/128] [60/128]
}
i999 0 [$r*60/128]
</CsScore>
</CsoundSynthesizer>
