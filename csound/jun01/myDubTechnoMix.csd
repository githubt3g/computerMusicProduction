<CsoundSynthesizer>
<CsOptions>
-odac -dm0
</CsOptions>
<CsInstruments>
    sr = 44100
 ksmps =   100
nchnls =     2
 0dbfs =     1
                        FLcolor      255, 255, 255, 0, 0, 0
                        FLpanel      "freeverb", 500, 275, 0, 0
                idFreq  FLvalue      " ", 100, 20, 5, 100
              idHFDamp  FLvalue      " ", 100, 20, 5, 150
                 idmix  FLvalue      " ", 100, 20, 5, 200
gkRoomSize, ihRoomSize  FLslider     "Room Size",              0, 1, 0, 23, idFreq,   490, 25, 5,  75
  gkHFDamp,   ihHFDamp  FLslider     "High Frequency Damping", 0, 1, 0, 23, idHFDamp, 490, 25, 5, 125
     gkmix,   ihmix     FLslider     "Dry/Wet Mix",            0, 1, 0, 23, idmix,    490, 25, 5, 175
                        FLsetVal_i   0.5, ihRoomSize
                        FLsetVal_i   0.5, ihHFDamp
                        FLsetVal_i   0.5, ihmix
                        FLpanel_end
                        FLrun
    
gaSigL, gaSigR init 0

instr readFile 
  gaSigL, gaSigR diskin2 "808loop.wav", 1, 0, 1
endin

instr freeverb
               denorm    gaSigL, gaSigR
 arvbL, arvbR  freeverb  gaSigL, gaSigR, gkRoomSize, gkHFDamp , sr, 0
        amixL  ntrpol    gaSigL, arvbL, gkmix
        amixR  ntrpol    gaSigR, arvbR, gkmix
               outs      amixL, amixR
               clear     gaSigL, gaSigR
endin

</CsInstruments>
<CsScore>
i"readFile" 0 3600
i"freeverb" 0 3600
</CsScore>
</CsoundSynthesizer>
