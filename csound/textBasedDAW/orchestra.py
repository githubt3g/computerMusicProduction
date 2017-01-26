print '''<CsoundSynthesizer>
<CsOptions>
;-F AnyMIDIfile.mid
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gaL init 0
gaR init 0
gkfactor init 1
gkDelSnd init 0.5
gaRvbSndL init 0
gaRvbSndR init 0
gaDelSnd  init 0
gihMainLlevel init 0.5
gihMainRlevel init 0.5
gkDelayBPM init 140
gklevel init 1

FLpanel "Title", 800, 400, 100, 100
 gkexit,   giexit     FLbutton      "EXIT",   1, 1, 11, 175,  25, 10, 10, 105, 1000, 0,  0.1
FLpanel_end
FLrun




instr 1000
  exitnow
endin


#define instrument(name'loop) #
instr $name.
iloop  =       1
;   aL  loscil  0.5, 1, $loop., 1, 1
   aL  loscil  0.375, 1, $loop., 1, 1, 0, 165375	; use a mono loscil3
   aR  =       aL
       outs    aL, aR
 if p4=1 || p5=1 then
         ga = 0.5 * (aL + aR) 
         gaDelSnd atone ga, 660
         gkfactor = 1      
 endif   
 if p6=1 || p7=1 then
  gkRvbSnd  =        0.5
 gaRvbSndL  =        gaRvbSndL + (aL * gkRvbSnd)               ;SEND SOME OF THE DELAY OUTPUT TO REVERB
 gaRvbSndR  =        gaRvbSndR + (aR * gkRvbSnd)
 endif   
endin
#
'''

