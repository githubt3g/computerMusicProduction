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

instr 1
kBodyFrequencies expseg 220, p3/16, 110, p3/16, 55, 7*p3/8, 27.5
           aBody oscili 1, kBodyFrequencies, 1
   kBodyEnvelope expseg 1, p3/16, 2, 2*p3/16, 2, 13*p3/16, 1
              aL =      0.5 * (kBodyEnvelope-1) * aBody
 kPopFrequencies expseg 1760, 2.25*p3/32, 22
            aPop oscili 1, kPopFrequencies, 1
    kPopEnvelope linseg 0, p3/32, 1, p3/32, 0, 15*p3/16, 0
              aL +=     0.25 * kPopEnvelope * aPop
 kClickFrequencies expseg 1760*8, 2.25*p3/32, 22*8
            aClick oscili 1, kClickFrequencies, 1
    kClickEnvelope linseg 0, p3/128, 1, p3/128, 0
              aL +=     0.125 * kClickEnvelope * aClick
                 out    aL
endin


instr 1000
  exitnow
endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1
;#include ""
t0 128
{32 count
i1 $count 0.66
}
</CsScore>
</CsoundSynthesizer>
