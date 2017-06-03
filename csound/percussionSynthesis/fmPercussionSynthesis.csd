<CsoundSynthesizer>
<CsOptions>
-ot.wav ;dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs  = 1

FLpanel "Title", 800, 400, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
FLpanel_end
FLrun
 
instr fmPercussion
 kA linseg 16, p3, 1
kfm linseg 440, 0.05, 55, 0.45, 33
kfc linseg 330, 0.05, 66, 0.45, 22
kz oscil 1, kfm, 1
kmenv linseg 0, 0.03, 1, 0.45, 0
ay oscil 1, kfc+kmenv*kA*kz, 1
ay butterlp ay, 165 
;ay butterlp ay, 55 
;ay butterlp ay, 110 
;ay butterlp ay, 110 
kcenv linseg 0, 0.03, 1 
kcenv2 expseg 2, p3, 1 
   out   (kcenv2-1)*kcenv*ay 
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

{1 n
i"fmPercussion" $n [60/128]
}
i999 0 0.5
</CsScore>
</CsoundSynthesizer>
