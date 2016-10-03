<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac -+rtmidi=alsaseq -Ma -Q129 ;;;midi in and midi out

; first run : csound arpeggiator-seq24.csd &
;  then run : csound midion2.csd &
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

instr 1

kcps line 3, p3, .1	
klf  lfo 1, kcps, 3	;use a unipolar square to trigger
ktr  trigger klf, 1, 1	;from 3 times to .1 time per sec.
     midion2 1, p4, 100, ktr

endin
</CsInstruments>
<CsScore>

i 1 0 2 60
i 1 + . 61
i 1 + . 62
i 1 + . 63
e
</CsScore>
</CsoundSynthesizer>
