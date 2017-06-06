<CsoundSynthesizer>
<CsOptions>
-odac
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
#define pi #3.14159#

instr kick
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


instr snare
                 seed   0
kBodyFrequencies linseg 0, 0.01, 220, 0.01, 55, 0.03, 27.5
           aBody oscili 1, kBodyFrequencies, 2
   kBodyEnvelope linseg 0, 0.01, 1, 0.1, 0
              aL =      0.75 * kBodyEnvelope * aBody
         anoise  gauss  0.5
  kNoiseEnvelope linseg 1, 0.075, 0.1, 0.2, 0
              aL +=     kNoiseEnvelope*anoise
              aL =      2/3*sqrt(2*aL)
                 out    aL
endin

instr hihat
aL gauss 1
kenv linseg 0, 0.01, 1
kenv2 expseg 8, p3, 1
out 0.05*aL*kenv*(kenv2-1)
endin

instr playSampleHit

ichnls = ftchnls(p4)
print ichnls

if (ichnls == 1) then
   asigL loscil .8, 1, p4, 1
   asigR = 	asigL
elseif (ichnls == 2) then
   asigL, asigR loscil .8, 1, p4, 1
;safety precaution if not mono or stereo
else
   asigL = 0
   asigR = 0
endif
        outs 0.33*asigL, 0.33*asigR

endin


instr wobbleBass
     ispb  =          p3                                     ; Seconds-per-beat. Must specify "1" in score
       p3  =          ispb * p4                              ; Reset the duration
     idur  =          p3                                     ; Duration
     iamp  =          p5                                     ; Amplitude
     ipch  =          cpsmidinn(p6)                             ; Pitch
idivision  =          1 / (p7 * ispb)                        ; Division of Wobble
;       a1  vco2       iamp, ipch * 1.005,  0                 ; Oscillator
;       a2  vco2       iamp, ipch * 0.495, 10                 ; Oscillator
       a1  oscil      iamp, ipch * 0.495, 3
       a2  oscil      iamp, ipch * 0.245, 2
       a1  =          a1 + a2
   itable  ftgen      0, 0, 8192, -7, 0, 4096, 1, 4096, 0    ; Wobble envelope shape
     klfo  oscil      1, idivision, itable                   ; LFO for wobble sound
    ibase  =          ipch
     imod  =          ibase * 9
       a1  moogladder a1, ibase + imod * klfo, 0.6           ; Filter
           out        0.8*a1
endin


instr 999
aL monitor
   fout     "output.wav", 14, aL
endin



instr 1000
  exitnow
endin

</CsInstruments>


<CsScore bin="python">
import sys
f=open(sys.argv[1], 'w')
kick  = 'i"playSampleHit" %f 0.66 11\n'
snare = 'i"playSampleHit" %f 0.66 12\n'
hihat = 'i"playSampleHit" %f 0.25 13\n'
f.write('''
f1 0 4096 10 1
f2 0 4096 7 -1 2048 1 2048 -1
f3 0 2048 -23 "mySaw.table"
f11 0 0 1 "./kit/kick.wav" 0 0 0
f12 0 0 1 "./kit/snare.wav" 0 0 0
f13 0 0 1 "./kit/chh.wav" 0 0 0
t0 140
i999 0 64
{4 count
i "wobbleBass"   [0.00+16*$count]   1  1.50 0.404 40 2
i "wobbleBass"   [1.50+16*$count]   1  2.50 0.404 45 [1/3]
i "wobbleBass"   [4.00+16*$count]   1  1.50 0.404 47 2
i "wobbleBass"   [5.50+16*$count]   1  1.50 0.404 40 [4/3]
i "wobbleBass"   [7.00+16*$count]   1  1.00 0.404 43 [1/2]

i "wobbleBass"   [8.00+16*$count]   1  2.00 0.404 40 2
i "wobbleBass"  [10.00+16*$count]   1  2.00 0.404 40 1
i "wobbleBass"  [12.00+16*$count]   1  2.00 0.404 40 [2/3]
i "wobbleBass"  [14.00+16*$count]   1  2.00 0.404 40 [1/3]
}

''')
bars=4
pkick = '1000 0010 0000 0000  1000 0010 0000 0010  1000 0000 0000 0000  1000 1000 0000 0010 '
psnare= '0000 0000 1000 0000  0000 0000 1001 0000  0000 0000 1000 0000  0000 0000 1001 0000 '
phihat= '1111 1011 1111 0011  1111 1011 1111 0011  1111 1011 1111 0011  1111 1011 1111 0011 '
pohh  = '0000 0100 0000 1000  0000 0100 0000 0000  0000 0000 0000 0000  0000 0000 0000 0000  '
def playPattern(n,name, pname):
  for j in range(n):
    for i in range(16*bars):
      if [x for x in list(pname) if x!=' '][i]=='1':
        f.write(name % (4*bars*j+i*0.25))
playPattern(4, kick, pkick)
playPattern(3,snare, psnare)
playPattern(2,hihat, phihat)
</CsScore>
;<CsScore>
;f1 0 4096 10 1
;f2 0 4096 7 -1 2048 1 2048 -1
;;#include ""
;t0 128
;{16 count
;i"kick"  [4*$count+0] 0.66
;i"kick"  [4*$count+1.5] 0.66
;i"snare" [4*$count+2] 0.66
;}
;{16 count
;i"hihat" [4*$count+0.00] 0.25
;i"hihat" [4*$count+0.25] 0.25
;i"hihat" [4*$count+0.50] 0.25
;i"hihat" [4*$count+0.75] 0.25
;i"hihat" [4*$count+1.00] 0.25
;;i"hihat" [4*$count+1.25] 0.25
;i"hihat" [4*$count+1.50] 0.25
;i"hihat" [4*$count+1.75] 0.25
;i"hihat" [4*$count+2.00] 0.25
;i"hihat" [4*$count+2.25] 0.25
;i"hihat" [4*$count+2.50] 0.25
;i"hihat" [4*$count+2.75] 0.25
;;i"hihat" [4*$count+3.00] 0.25
;;i"hihat" [4*$count+3.25] 0.25
;i"hihat" [4*$count+3.50] 0.25
;i"hihat" [4*$count+3.75] 0.25
;}

;</CsScore>
</CsoundSynthesizer>
