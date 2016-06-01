<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1
gaSigL,gaSigR init 0
gasendL,gasendR	init	0					;GLOBAL VARIABLES USED TO SEND SIGNAL TO THE DELAY EFFECT
gkDelType init 1 ; 0=simpleDelay 1=
gkDelOnOff init 1 ; 0=off 1=on
gkFBamt init 0.70
gkDelTone init 13
gkDelTimMode init 1
gkRhyNum init 7
gkrate init 8
gkRhyDen init 13
gkDelTim init 0.4
gkDelTimPort init 0
gkRoomSize init 0.98
gkHFDamp init 0.10
gkmix init 0.90
gkReverbWet init 2.50
gkDelayWet init 2.50

instr 1
gkrate = 8+4*p4%8
aL1 vco2 0.25, cpsmidinn(57)*0.990	; sawtooth waveform
aR1 vco2 0.25, cpsmidinn(57)*1.010	; sawtooth waveform
aL2 vco2 0.25, cpsmidinn(60)*0.990	; sawtooth waveform
aR2 vco2 0.25, cpsmidinn(60)*1.010	; sawtooth waveform
aL3 vco2 0.25, cpsmidinn(64)*0.990	; sawtooth waveform
aR3 vco2 0.25, cpsmidinn(64)*1.010	; sawtooth waveform
aLin=0.25*(aL1+aL2+aL3)
aRin=0.25*(aR1+aR2+aR3)
kfe  expseg 500, p3*0.9, 1800, p3*0.1, 3000
kres line .1, p3, .99	;increase resonance
aL moogladder aLin, 2500, 0*kres
aR moogladder aRin, 2500, 0*kres
	gasendL	=	gasendL+aL*gkDelayWet
	gasendR	=	gasendR+aR*gkDelayWet
        gaSigL  = gaSigL + aL*gkReverbWet
        gaSigR  = gaSigR + aR*gkReverbWet
     outs 0.8*(aL+aR), 0.8*(aL-aR)
endin

instr	Delay
	iMaxRhyVal	=	32/1	;LONGEST POSSIBLE RHYTHMIC VALUE
	iMinRate	=	0.25	;MINIMUM POSSIBLE ARPEGGIATOR RATE
	iArpRhyVal	=	1/8/0.33	;VALUE OF ARPEGGIATOR DIVISION (1/8 = QUAVER/EIGHTH NOTE)
	iMaxDelay	=	(iMaxRhyVal*iArpRhyVal)/iMinRate

	kporttime	linseg	0,0.001,0.05
	;kcf	portk	cpsoct(gkDelTone),kporttime
	kcf	=	cpsoct(gkDelTone)
	kFBamt	portk	gkFBamt,kporttime
	
	if gkDelOnOff==0 kgoto SKIP		;IF DELAY ON/OFF BUTTON IS OFF SKIP ALL OF THE DELAY CODE 
	kptime	linseg	0,0.001,0.4		;CREATE A FUNCTION THAT RISES QUICKLY FROM ZERO TO A STEADY VALUE. THIS WILL BE USED FOR PORTAMENTO TIME
	if gkDelTimMode==1 then			;IF RHYTHMIC DELAY TIME MODE HAS BEEN CHOSEN...
	 kDelTim	=	(gkRhyNum)/(gkrate*gkRhyDen*iArpRhyVal)	;
	 kDelTim	limit	kDelTim,0,iMaxDelay	;PROTECT AGAINST OUT OF RANGE DELAY TIMES
	else
	 kDelTim	=	gkDelTim 	
	 kDelTim	limit	kDelTim,0,iMaxDelay
	endif
	
	kDelTim	portk	kDelTim,0.0001+kptime*gkDelTimPort
	aDelTim	interp	kDelTim
	
	if gkDelType==0 then	;SIMPLE STEREO DELAY
	 abuffer	delayr	iMaxDelay	;ESTABLISH LEFT CHANNEL BUFFER
	 aTapL	deltapi	aDelTim			;TAP LEFT CHANNEL BUFFER
	 aTapL	tone	aTapL,kcf		;LOWPASS FILTER
	 	delayw	gasendL+aTapL*kFBamt	;WRITE INTO LEFT CHANNEL BUFFER
	 abuffer	delayr	iMaxDelay       ;ESTABLISH RIGHT CHANNEL BUFFER 
	 aTapR	deltapi	aDelTim                 ;TAP RIGHT CHANNEL BUFFER       
	 aTapR	tone	aTapR,kcf               ;LOWPASS FILTER                
	 	delayw	gasendR+aTapR*kFBamt    ;WRITE INTO RIGHT CHANNEL BUFFER
        gaSigL  = gaSigL + (aTapL)*gkDelayWet
        gaSigR  = gaSigR + (aTapR)*gkDelayWet
	 	outs	aTapL,aTapR		;SEND LEFT AND RIGHT CHANNEL TAPS TO AUDIO OUTPUT
	
	else					;PING PONG DELAY
	 ;LEFT CHANNEL OFFSET / FIRST ECHO (NO FEEDBACK)
	 aL	vdelay	gasendL,aDelTim*1000,iMaxDelay*1000
	 aL	tone	aL,kcf			;LOWPASS FILTER
	 
	 abuffer	delayr	iMaxDelay*2	;ESTABLISH LEFT CHANNEL BUFFER
	 aTapL	deltapi	aDelTim * 2		;TAP LEFT CHANNEL BUFFER
 	 aTapL	tone	aTapL,kcf		;LOWPASS FILTER
	 	delayw	aL+aTapL*kFBamt		;WRITE INTO LEFT CHANNEL BUFFER
         
	 abuffer	delayr	iMaxDelay*2	;ESTABLISH RIGHT CHANNEL BUFFER
	 aTapR	deltapi	aDelTim * 2		;TAP RIGHT CHANNEL BUFFER
	 aTapR	tone	aTapR,kcf		;LOWPASS FILTER
	 	delayw	gasendR+aTapR*kFBamt	;WRITE INTO RIGHT CHANNEL BUFFER
        gaSigL  = gaSigL + (aTapL+aL)*gkDelayWet
        gaSigR  = gaSigR + (aTapR)*gkDelayWet
	 	outs	aTapL+aL,aTapR	;SEND LEFT AND RIGHT CHANNEL TAPS AND LEFT CHANNEL INITIAL TAP TO AUDIO OUTPUT
	endif
	SKIP:
		clear	gasendL,gasendR		;CLEAR GLOBAL SEND AUDIO VARIABLES
endin

instr	Reverb
	denorm		gaSigL, gaSigR	;DENORMALIZE BOTH CHANNELS OF AUDIO SIGNAL
	arvbL, arvbR 	freeverb 	gaSigL, gaSigR, gkRoomSize, gkHFDamp , sr, 0
	rireturn			;RETURN TO PERFORMANCE TIME PASSES
	amixL		ntrpol		gaSigL, arvbL, gkmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL
	amixR		ntrpol		gaSigR, arvbR, gkmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL
			outs		amixL, amixR
	gaSigL		=	0	;CLEAR THE GLOBAL AUDIO SEND VARIABLES
	gaSigR		=	0	;CLEAR THE GLOBAL AUDIO SEND VARIABLES
	;clear	gaSigL, gaSigR	;CLEAR GLOBAL AUDIO VARIABLES
endin

instr     2313
  atmp      alpass    gadrysig, 1.7, .1
  aleft     alpass    atmp, 1.01, .07
  atmp      alpass    gadrysig, 1.5, .2
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
  gadrysig  =  0
endin

instr Loop
   aL, aR loscil 0.4, 1, 1, 1, 1
   outs aL, aR
endin

instr Loop2
   aL, aR loscil 0.5, 1, 2, 1, 1
   outs aL, aR
endin

instr Loop3
   aL, aR loscil 0.33, 1, 3, 1, 1
   outs aL, aR
endin

</CsInstruments>
<CsScore>
f1 0 0 1 "loop.wav"  0 0 0
f2 0 0 1 "loop2.wav" 0 0 0
f3 0 0 1 "loop3.wav" 0 0 0

t0 127
{9 counter
i1  [32+0+32*$counter] 0.33 $counter
i1  [32+8+32*$counter] 0.33
i1 [32+16+32*$counter] 0.33
i1 [32+24+32*$counter] 0.33
}
i"Delay"          0  [13*32]
i"Reverb"         0  [13*32]
i"Loop"           0   [3*32]
i"Loop"       [4*32]  [4*32]
i"Loop"      [10*32]  [1*32]
i"Loop2"   [32+4*32]  [6*32]
i"Loop3"      [9*32]  [3*32]
e
</CsScore>
</CsoundSynthesizer>
