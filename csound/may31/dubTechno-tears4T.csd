<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

                        FLcolor      255, 255, 255, 0, 0, 0
                        FLpanel      "freeverb", 500, 275, 0, 0
                idFreq  FLvalue      " ", 100, 20, 5, 100
              idHFDamp  FLvalue      " ", 100, 20, 5, 150
                 idmix  FLvalue      " ", 100, 20, 5, 200
gkRoomSize, ihRoomSize  FLslider     "Room Size",              0, 1, 0, 23, idFreq,   490, 25, 5,  75
  gkHFDamp,   ihHFDamp  FLslider     "High Frequency Damping", 0, 1, 0, 23, idHFDamp, 490, 25, 5, 125
     gkmix,   ihmix     FLslider     "Dry/Wet Mix",            0, 1, 0, 23, idmix,    490, 25, 5, 175
                        FLsetVal_i   1, ihRoomSize
                        FLsetVal_i   0, ihHFDamp
                        FLsetVal_i   0.75, ihmix
                        FLpanel_end
                       ;FLrun


  gaSigL,gaSigR init  0
gasendL,gasendR	init  0
        gkFBamt init  0.70
      gkDelTone init 13
   gkDelTimMode init  1
       gkRhyNum init  7
       gkRhyDen init 13
       gkDelTim init  0.4
   gkDelTimPort init  0
     ;gkRoomSize init  0.98
       ;gkHFDamp init  0.10
          ;gkmix init  0.90
    gkReverbWet init  5
     gkDelayWet init  2.50

  gifeed    =  2.0
  gilp1     =  1/2;1/10
  gilp2     =  1/5;1/35;1/23
  gilp3     =  1/11;1/71;1/41
  giroll    =  22000
  gadrysig  init      0


instr 1
kc1 = 1
kc2 = 2
kvrate = 1

kvdpth line 0, p3, 0.01
aL1   fmb3 0.4, cpsmidinn(p4-12)*0.990, kc1, kc2, kvdpth, kvrate
aR1   fmb3 0.4, cpsmidinn(p4-12)*1.010, kc1, kc2, kvdpth, kvrate
aL2   fmb3 0.4, cpsmidinn(p5-12)*0.990, kc1, kc2, kvdpth, kvrate
aR2   fmb3 0.4, cpsmidinn(p5-12)*1.010, kc1, kc2, kvdpth, kvrate
aL3   fmb3 0.4, cpsmidinn(p6-12)*0.990, kc1, kc2, kvdpth, kvrate
aR3   fmb3 0.4, cpsmidinn(p6-12)*1.010, kc1, kc2, kvdpth, kvrate

/*aL1 vco2 0.25, cpsmidinn(57)*0.990	; sawtooth waveform
aR1 vco2 0.25, cpsmidinn(57)*1.010	; sawtooth waveform
aL2 vco2 0.25, cpsmidinn(60)*0.990	; sawtooth waveform
aR2 vco2 0.25, cpsmidinn(60)*1.010	; sawtooth waveform
aL3 vco2 0.25, cpsmidinn(64)*0.990	; sawtooth waveform
aR3 vco2 0.25, cpsmidinn(64)*1.010	; sawtooth waveform*/
aLin=0.33*(aL1+aL2+aL3)
aRin=0.33*(aR1+aR2+aR3)
kfe  expseg 1500, p3*0.9, 1800, p3*0.1, 1800
kres line .1, p3, .99	;increase resonance
aLout moogladder aLin, kfe, kres
aRout moogladder aRin, kfe, kres
   aL atone aLout, 880
   aR atone aRout, 880
	gasendL	=	gasendL+aL*gkDelayWet
	gasendR	=	gasendR+aR*gkDelayWet
        gaSigL  = gaSigL + aL*gkReverbWet
        gaSigR  = gaSigR + aR*gkReverbWet
     outs 0.3*aL, 0.3*aR
endin

instr     Delay  
  atapA     delay     gasendL*0.9,  3 /16 * 240/120
  atapB     delay     gasendR*0.8,  6 /16 * 240/120
  atapC     delay     gasendL*0.7,  9.667 /16 * 240/120
  atapD     delay     gasendR*0.6, 12.333 /16 * 240/120
  atapE     delay     gasendR*0.5, 12.333 /16 * 240/120
  atapF     delay     gasendL*0.4, 15 /16 * 240/120
  atapG     delay     gasendR*0.3, 18 /16 * 240/120
  atapH     delay     gasendL*0.3, 18 /16 * 240/120
  ;atapI     delay     gasendR*0.6, 24.5 /16 * 240/120
  ;atapJ     delay     gasendR*0.6, 27 /16 * 240/120
  ;atapK     delay     gasendR*0.6, 27 /16 * 240/120
  aL = 0.5*(atapA+atapC+atapE+atapF+atapH);+atapJ)
  aR = 0.5*(atapB+atapD+atapE+atapG);+atapI+atapJ) 
            outs   aL, aR
        gaSigL  = gaSigL + aL*gkDelayWet
        gaSigR  = gaSigR + aR*gkDelayWet              
  gasendL    =  0                                  
  gasendR    =  0                                  
endin

instr freeverb
               denorm    gaSigL, gaSigR
 arvbL, arvbR  freeverb  gaSigL, gaSigR, gkRoomSize, gkHFDamp , sr, 0
        amixL  ntrpol    gaSigL, arvbL, gkmix
        amixR  ntrpol    gaSigR, arvbR, gkmix
               outs      amixL, amixR
               clear     gaSigL, gaSigR
endin


instr     Reverb
  atmp      alpass    gaSigL, 1.7, .1
  aleft     alpass    atmp, 1.01, .07
  atmp      alpass    gaSigR, 1.5, .2
  aright    alpass    atmp, 1.33, .05
  kdel1     randi     .01, 1, .666
  kdel1     =  kdel1+.1
  addl1     delayr    .3
  afeed1    deltapi   kdel1
  afeed1    =  afeed1+gifeed*aleft
            delayw    aleft
  kdel2     randi     .01,. 95, .777
  kdel2     =  kdel2+.1
  addl2     delayr    .3
  afeed2    deltapi   kdel2
  afeed2    =  afeed2+gifeed*aright
            delayw    aright
  aglobin   =  (afeed1+afeed2)*.05
  atap1     comb      aglobin, 3.3, gilp1
  atap2     comb      aglobin, 3.3, gilp2
  atap3     comb      aglobin, 3.3, gilp3
  aglobrev  alpass    atap1+atap2+atap3, 2.6, .085
  aglobrev  tone      aglobrev, giroll
            outs      aglobrev, aglobrev
  gaSigL  =  0
  gaSigR  =  0
endin

instr Beat
   aL, aR loscil 0.2, 1, 1, 1, 1
   outs aL, aR
        gaSigL  = gaSigL + aL*gkDelayWet*0.3
        gaSigR  = gaSigR + aR*gkDelayWet*0.3 
endin

instr Flute
   aLin, aRin loscil 0.3, 1, 2, 1, 1
   aL atone aLin, 440
   aR atone aRin, 440
   outs 0.33*aL, 0.33*aR
endin

instr Dubout
   aL, aR loscil 0.2, 1, 3, 1, 1
   outs 0.66*aL, 0.66*aR
endin

</CsInstruments>
<CsScore>
f1 0 0 1 "loop.wav"  0 0 0
f2 0 0 1 "loop2.wav" 0 0 0
f3 0 0 1 "loop3-1.wav" 0 0 0
;a0 0 160
t0 127
{9 counter
i1 [32+ 0+32*$counter] 0.20 57 60 64
i1 [32+ 8+32*$counter] 0.20 56 59 63
i1 [32+16+32*$counter] 0.20 57 60 64
i1 [32+24+32*$counter] 0.20 59 62 66
}
i"Delay"          0   [11*32]
i"freeverb"       0   [11.4*32]
i"Beat"           0      [3*32]
i"Beat"       [4*32]     [4*32]
i"Beat"      [10*32]     [1*32]
i"Flute"      [5*32]     [6*32]
i"Dubout"      [9*32]        11.3120408163265306
i"Dubout"     [11*32]        11.3120408163265306
e
</CsScore>
</CsoundSynthesizer>
