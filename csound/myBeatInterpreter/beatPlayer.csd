<CsoundSynthesizer>
<CsOptions>
;-F AnyMIDIfile.mid
;  -odac
-odubTechno.wav
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

          gaL  init  0
          gaR  init  0
     gkfactor  init  4
     gkRvbSnd  init  0.8
     gkDelSnd  init  0.5
    gaRvbSndL  init  0
    gaRvbSndR  init  0
     gaDelSnd  init  0
gihMainLlevel  init  0.5
gihMainRlevel  init  0.5
   gkDelayBPM  init  128
      gklevel  init  1

 gkfactor2    init  1
; gkDelFB2
 gkDelayBPM2  init  127
 gaDelSnd2    init  0
 gklevel2     init  1
 gaRvbSndL2   init  0
 gaRvbSndR2   init  0
 gkRvbSnd2    init  0.8

FLpanel "Title", 800, 400, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
FLpanel_end
FLrun




instr 1000
  exitnow
endin


#define instrument(midiNoteNumber) #
instr $midiNoteNumber.
   aL  loscil  0.5, 1, $midiNoteNumber., 1, 1, 0, 82687
   aR  =       aL
       outs    aL, aR
 if p4=1 then
         ga = 0.5 * (aL + aR) 
         gaDelSnd atone ga, 220
         gkfactor = 1.667 
 endif   
 if p5=1 then
         ga = 0.5 * (aL + aR) 
         gaDelSnd2 atone ga, 110
         gkfactor2 = 8
 endif   
 if p6=1 || p7=1 then
  gkRvbSnd  =        0.925
 gaRvbSndL  =        gaRvbSndL + (aL * gkRvbSnd)               ;SEND SOME OF THE DELAY OUTPUT TO REVERB
 gaRvbSndR  =        gaRvbSndR + (aR * gkRvbSnd)
 endif   
endin
#

$instrument(1)
$instrument(2)
$instrument(3)
$instrument(4)
$instrument(5)
$instrument(6)
$instrument(7)

instr 993  ; Delay1
  gkDelTimL =        8;p4*gkfactor
  gkDelTimR =        8;p5*gkfactor
  gkDelFB   =        0.8
  kDelTimL  =3.75/4*2;limit    gkDelTimL * 60 / (gkDelayBPM*3), 0.001, 9.99  ;DERIVE DELAY TIME IN SECONDS
  kDelTimR  =3.75/3*2;limit    gkDelTimR * 60 / (gkDelayBPM*2), 0.001, 9.99
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




instr 994  ; Delay2
  gkDelTimL2 =        8;p4*gkfactor2
  gkDelTimR2 =        8;p5*gkfactor2
  gkDelFB2   =        0.85
  kDelTimL  limit    gkDelTimL2 * 60 / (gkDelayBPM2*1), 0.001, 19.99  ;DERIVE DELAY TIME IN SECONDS
  kDelTimR  limit    gkDelTimR2 * 60 / (gkDelayBPM2*1), 0.001, 19.99
  aDelTimL  interp   kDelTimL                                     ;CREATE INTERPOLATED A-RATE DELAY TIME VALUES
  aDelTimR  interp   kDelTimR
   aBuffer  delayr   10                                           ;LEFT CHANNEL
     atapL  deltap3  aDelTimL
            delayw   gaDelSnd2 + (atapL * gkDelFB2)
    aBuffe  delayr   10                                           ;RIGHT CHANNEL
     atapR  deltap3  aDelTimR
            delayw   gaDelSnd2 + (atapR * gkDelFB2)
    gatapL2  =        atapL
    gatapR2  =        atapR
            outs     gklevel2*atapL, gklevel*atapR                                 ;SEND DELAY EFFECT AUDIO TO OUTPUTS
 gaRvbSndL2  =        gaRvbSndL2 + (atapL * gkRvbSnd2)               ;SEND SOME OF THE DELAY OUTPUT TO REVERB
 gaRvbSndR2  =        gaRvbSndR2 + (atapR * gkRvbSnd2)
            clear    gaDelSnd2                                     ;CLEAR DELAY SEND AUDIO SIGNAL
endin


instr 995
; gkRvbFB lfo 0.100, 128/120/32
 gkRvbFB = 0.95
 aRvbL, aRvbR  reverbsc  gaRvbSndL, gaRvbSndR, gkRvbFB, 15000
       ;gaRvbL  =         aRvbL
       ;gaRvbR  =         aRvbR 
               outs      aRvbL, aRvbR
               clear     gaRvbSndL, gaRvbSndR
endin


</CsInstruments>

<CsScore>
f1 0 1048576 1 "./samples/kick.wav"  0 0 0
f2 0 1048576 1 "./samples/snare.wav"  0 0 0
f3 0 1048576 1 "./samples/clap.wav"  0 0 0
f4 0 1048576 1 "./samples/chh.wav"  0 0 0
f5 0 1048576 1 "./samples/ohh.wav"  0 0 0
f6 0 1048576 1 "./samples/stick.wav"  0 0 0
f7 0 1048576 1 "./samples/bell.wav"  0 0 0
i993 0 20 ; delay1
i994 0 20 ; delay2
i995 0 20 ; reverb
#include "score.txt"

</CsScore>
</CsoundSynthesizer>
