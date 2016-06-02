; ConvolutionReverb.csd
; Written by Iain McCurdy, 2012.
; 
; ------------------
; You are encouraged to experiment with different impulse files.
; You can try this one to start with: http://www.iainmccurdy.org/CsoundRealtimeExamples/SourceMaterials/Stairwell.wav
; You can find some here: http://www.openairlib.net/
<CsoundSynthesizer>

<CsOptions>
-odac
</CsOptions>

<CsInstruments>

sr 		= 	44100	;SAMPLE RATE
ksmps 		= 	32	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)
0dbfs		=	1

;Author: Iain McCurdy (2012)

giImpulse	ftgen	1,0,0,1,"Stairwell.wav",0,0,0	; load stereo file
;giImpulse	ftgen	1,0,2,-2,0
giDisplay	ftgen	2,0,ftlen(giImpulse),2,0						; display table table
tableicopy 2, 1
gkReady	init	0



instr	2	;CONVOLUTION REVERB INSTRUMENT
	kresize		= 0
	kmix		= 0.05
	klevel		= 0.25
	kCurve		= 0
	iskipsamples	= 0
	kDelayOS	= 0
	iplen		=	1024			;BUFFER LENGTH (INCREASE IF EXPERIENCING PERFORMANCE PROBLEMS, REDUCE IN ORDER TO REDUCE LATENCY)
	itab		=	giImpulse			;DERIVE FUNCTION TABLE NUMBER OF CHOSEN TABLE FOR IMPULSE FILE
	iirlen		=	nsamp(itab)*0.5			;DERIVE THE LENGTH OF THE IMPULSE RESPONSE IN SAMPLES. DIVIDE BY 2 AS TABLE IS STEREO.
	kCompRat        init	1 			;IF THIS IS LEFT UNINITIALISED A CRASH WILL OCCUR! 
        ainL,ainR	diskin2	"../may31/loop.wav",1,0,1	;USE A SOUND FILE FOR TESTING
	ainMix		sum	ainL,ainR
	aL,aR	ftconv	ainMix, itab, iplen,iskipsamples, iirlen		;CONVOLUTE INPUT SOUND
	adelL	delay	ainL, abs((iplen/sr)+i(kDelayOS)) 	;DELAY THE INPUT SOUND ACCORDING TO THE BUFFER SIZE
	adelR	delay	ainR, abs((iplen/sr)+i(kDelayOS)) 	;DELAY THE INPUT SOUND ACCORDING TO THE BUFFER SIZE
	; CREATE A DRY/WET MIX
	aMixL	ntrpol	adelL,aL*0.1,kmix
	aMixR	ntrpol	adelR,aR*0.1,kmix
        	outs	aMixL*klevel,aMixR*klevel
endin
		
</CsInstruments>

<CsScore>
i2 0 10
</CsScore>

</CsoundSynthesizer>
