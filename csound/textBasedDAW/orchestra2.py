
print '''instr 993  ; Delay
  gkDelTimL =        p4*gkfactor
  gkDelTimR =        p5*gkfactor
  gkDelFB   =        0.85
  gkRvbSnd  =        0
  kDelTimL  limit    gkDelTimL * 60 / (gkDelayBPM*4), 0.001, 9.99  ;DERIVE DELAY TIME IN SECONDS
  kDelTimR  limit    gkDelTimR * 60 / (gkDelayBPM*4), 0.001, 9.99
  aDelTimL  interp   kDelTimL                                     ;CREATE INTERPOLATED A-RATE DELAY TIME VALUES
  aDelTimR  interp   kDelTimR
   aBuffer  delayr   10                                           ;LEFT CHANNEL
     atapL  deltap3  aDelTimL
            delayw   gaDelSnd + (atapL * gkDelFB)
    aBuffe  delayr   10                                           ;RIGHT CHANNEL
     atapR  deltap3  aDelTimR
            delayw   gaDelSnd + (atapR * gkDelFB)
    gatapL  =        atapL
    gatapR  =        atapR
            outs     gklevel*atapL, gklevel*atapR                                 ;SEND DELAY EFFECT AUDIO TO OUTPUTS
 gaRvbSndL  =        gaRvbSndL + (atapL * gkRvbSnd)               ;SEND SOME OF THE DELAY OUTPUT TO REVERB
 gaRvbSndR  =        gaRvbSndR + (atapR * gkRvbSnd)
            clear    gaDelSnd                                     ;CLEAR DELAY SEND AUDIO SIGNAL
endin


instr 994
 gkRvbFB lfo 0.100, 128/120/32
 gkRvbFB = gkRvbFB + 0.85
 aRvbL, aRvbR  reverbsc  gaRvbSndL, gaRvbSndR, gkRvbFB, 15000
       ;gaRvbL  =         aRvbL
       ;gaRvbR  =         aRvbR 
               outs      aRvbL, aRvbR
               clear     gaRvbSndL, gaRvbSndR
endin


</CsInstruments>

<CsScore>
f1 0 1048576 1 "./samples/kick.wav"  0 0 0
f2 0 1048576 1 "./samples/snare.wav" 0 0 0
f3 0 1048576 1 "./samples/hats.wav"  0 0 0
f4 0 1048576 1 "./samples/voice.wav" 0 0 0
f5 0 1048576 1 "./samples/bass1.wav" 0 0 0
f6 0 1048576 1 "./samples/bass2.wav" 0 0 0
f7 0 1048576 1 "./samples/stab1.wav" 0 0 0
f8 0 1048576 1 "./samples/stab2.wav" 0 0 0
t0 128
i993 0 269 3 5; delay
i994 0 269 3 5; reverb
'''
