;Written by Iain McCurdy, 2006

;THE freeverb OPCODE IS PLACED IN A SEPARATE, ALWAYS ON, INSTRUMENT FROM THE SOURCE SOUND PRODUCING INSTRUMENT.
;THE IS A COMMONLY USED TECHNIQUE WITH TIME SMEARING OPCODES AND EFFECTS LIKE REVERBS AND DELAYS.

<CsoundSynthesizer>

<CsOptions>
-iadc -odac -dm0
</CsOptions>

<CsInstruments>

sr 		= 	44100	;SAMPLE RATE
ksmps 		= 	100	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)

;FLTK INTERFACE CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FLcolor	255, 255, 255, 0, 0, 0
;			LABEL    | WIDTH | HEIGHT | X | Y
		FLpanel	"freeverb", 500,    275,    0,  0


;GENERAL_TEXT_SETTINGS			SIZE | FONT |  ALIGN | RED | GREEN | BLUE
			FLlabel		13,      1,      3,    255,   255,   255		;LABELS MADE INVISIBLE (I.E. SAME COLOR AS PANEL)


;GENERAL_TEXT_SETTINGS			SIZE | FONT |  ALIGN | RED | GREEN | BLUE
			FLlabel		13,      1,      3,     0,     0,     0			;LABELS MADE VISIBLE AGAIN


;VALUE DISPLAY BOXES			LABEL  | WIDTH | HEIGHT | X | Y
idlpt				FLvalue	" ",      100,     20,    5,  75
idrvt				FLvalue	" ",      100,     20,    5, 125
idamp				FLvalue	" ",      100,     20,    5, 175

;VALUE_DISPLAY_BOXES			 	WIDTH | HEIGHT | X | Y
idFreq				FLvalue	" ",     100,    20,     5, 100
idHFDamp			FLvalue	" ",     100,    20,     5, 150
idmix				FLvalue	" ",     100,    20,     5, 200

;SLIDERS					            			MIN | MAX | EXP | TYPE | DISP   | WIDTH | HEIGHT | X | Y
gkRoomSize,ihRoomSize		FLslider 	"Room Size",			0,     1,    0,    23,  idFreq,    490,     25,    5,  75
gkHFDamp,ihHFDamp		FLslider 	"High Frequency Damping",	0,     1,    0,    23,  idHFDamp,  490,     25,    5, 125
gkmix,ihmix			FLslider 	"Dry/Wet Mix",			0,     1,    0,    23,  idmix,     490,     25,    5, 175

;SET_INITIAL_VALUES		VALUE | HANDLE
		FLsetVal_i	.5, 	ihRoomSize
		FLsetVal_i	.5, 	ihHFDamp
		FLsetVal_i	.5, 	ihmix

		FLpanel_end	;END OF PANEL CONTENTS


				FLrun	;RUN THE FLTK WIDGET THREAD
;END OF FLTK INTERFACE CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

gaSigL,gaSigR	init	0

instr	1	;PLAYS FILE AND OUTPUTS GLOBAL VARIABLES
		gaSigL, gaSigR	diskin2	"808loop.wav",    1,       0,         1	;GENERATE 2 AUDIO SIGNALS FROM A STEREO SOUND FILE (NOTE THE USE OF GLOBAL VARIABLES)		
endin

instr	2	;REVERB - ALWAYS ON
	denorm		gaSigL, gaSigR	;DENORMALIZE BOTH CHANNELS OF AUDIO SIGNAL
	arvbL, arvbR 	freeverb 	gaSigL, gaSigR, gkRoomSize, gkHFDamp , sr, 0
	rireturn			;RETURN TO PERFORMANCE TIME PASSES
	amixL		ntrpol		gaSigL, arvbL, gkmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL
	amixR		ntrpol		gaSigR, arvbR, gkmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE REVERBERATED SIGNAL
			outs		amixL, amixR
	gaSigL		=	0	;CLEAR THE GLOBAL AUDIO SEND VARIABLES
	gaSigR		=	0	;CLEAR THE GLOBAL AUDIO SEND VARIABLES
	clear	gaSigL, gaSigR	;CLEAR GLOBAL AUDIO VARIABLES
endin

</CsInstruments>
<CsScore>
i1 0 3600
i2 0 3600
</CsScore>
</CsoundSynthesizer>
