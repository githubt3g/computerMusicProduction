from os import system
from dirlist import dirlist
ll=dirlist
for l in ll:
  directory='/home/tom/Desktop/mar06/contemporaryMidiFiles/'+l+'/'  
  system('ls '+directory+'*.sco > scoList')
  scoFiles=open('scoList','r').read().split()
  n=len(scoFiles)
  include=''
  for s in scoFiles:
    include+='#include"'+s+'"\n'
  csound='''<CsoundSynthesizer>
<CsOptions>
;-omix.wav
-d
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 4

FLpanel "Title", 200, 50, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
FLpanel_end
FLrun


gaRvbSndL  init  0 
gaRvbSndR  init  0
gkRvbFB    init  0.96
gkDelSnd   init  0.85
gaDelSnd   init  0
gklevel    init  1.5
gkRvbSnd   init  0.80
;ga0        init  0

isf	sfload	"/home/tom/sf2/SF2/classical/acoustic_grand_piano_ydp_20080910.sf2"
	sfplist isf
	sfpassign	0, isf	

instr 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
p3=1
imidinotnum	=	p4-24
ivel	=	100;p5/10000
kamp	linseg	1,0.8*p3, 1, 0.2*p3, 0
aL,aR	sfplay3	ivel, imidinotnum, 0.0001, 1, 0			;preset index = 0
  	    aSig = 0.5 * (aL * 0.9 + aR * 0.9)
        gaDelSnd = aSig * gkDelSnd
schedule 22, 2*4/3, 0.25*p3, p4-17, p5, 1,        0.25
schedule 22, 3*4/3, 0.25*p3, p4-24, p5, 0.25,     1
schedule 22, 5*4/3, 0.25*p3, p4-17, p5, 0.85,      0.85*0.25
schedule 22, 8*4/3, 0.25*p3, p4-24, p5, 0.85*0.25, 0.85*1
;schedule 22,13, 0.25*p3, p4, p5, 0.5*1,    0.5*0.25
;schedule 22,21, 0.25*p3, p4, p5, 0.5*0.25, 0.5*1
	outs	kamp*aL, kamp*aR
  	    gaRvbSndL = gaRvbSndL+aL * 0.9
  	    gaRvbSndR = gaRvbSndR+aR * 0.9
endin

instr 22
p3=0.5
imidinotnum	=	p4
ivel	=	0.5*p5/10000
kamp	linseg	1,0.8*p3, 1, 0.2*p3, 0
aL,aR	sfplay3	ivel, imidinotnum, 0.00005, 1, 0			;preset index = 0
	outs	kamp*p6*aL, kamp*p7*aR
  	    gaRvbSndL = gaRvbSndL+aL * 0.9
  	    gaRvbSndR = gaRvbSndR+aR * 0.9
endin



;instr 990  ; Delay1
;  gkDelFB   =        0.5
;  kDelTimL  =1.5;limit    gkDelTimL * 60 / (gkDelayBPM*3), 0.001, 9.99  ;DERIVE DELAY TIME IN SECONDS
;  kDelTimR  =2.5;limit    gkDelTimR * 60 / (gkDelayBPM*2), 0.001, 9.99
;  aDelTimL  interp   kDelTimL                                     ;CREATE INTERPOLATED A-RATE DELAY TIME VALUES
;  aDelTimR  interp   kDelTimR
;   aBuffer  delayr   20                                           ;LEFT CHANNEL
;     atapL  deltap3  aDelTimL
;            delayw   gaDelSnd + (atapL * gkDelFB)
;    aBuffe  delayr   20                                           ;RIGHT CHANNEL
;     atapR  deltap3  aDelTimR
;            delayw   gaDelSnd + (atapR * gkDelFB)
;    gatapL  =        atapL
;    gatapR  =        atapR
;            outs     gklevel*atapL, gklevel*atapR                                 ;SEND DELAY EFFECT AUDIO TO OUTPUTS
; gaRvbSndL  =        gaRvbSndL + (atapL * gkRvbSnd)               ;SEND SOME OF THE DELAY OUTPUT TO REVERB
; gaRvbSndR  =        gaRvbSndR + (atapR * gkRvbSnd)
;            clear    gaDelSnd                                     ;CLEAR DELAY SEND AUDIO SIGNAL
;endin


instr 993
 aRvbL, aRvbR  reverbsc  gaRvbSndL, gaRvbSndR, gkRvbFB, 22000
               outs      0.8*aRvbL, 0.8*aRvbR
               clear     gaRvbSndL, gaRvbSndR
endin

instr 1000
  exitnow
endin

</CsInstruments>
<CsScore>
t0 10
'''+include+'''
i993 0 100
</CsScore>
</CsoundSynthesizer>'''
  open(directory+'playScore.csd','w').write(csound)
