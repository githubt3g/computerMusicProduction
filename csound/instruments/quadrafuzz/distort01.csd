<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr=44100
kr=44100
ksmps = 1
nchnls = 2
		
instr 1

	   ; 	Like a primitive "quadra fuzz": split the signale into four separate bands,
	   ;	clip each one (badly), then add them back together.  
	   ;    
	   ;    This is all reminscent of Craig Anderton's QuadraFuzz idea.
	   ;
	   ;	p4, p5, p6, p7 are the center frequencies of the four bands
	   ;

;; the input sound file	   
ain soundin "guitar06.aiff"

;; rename the p-codes so we remember what's what
icen1=p4
icen2=p5
icen3=p6
icen4=p7

;; the bandwidth calculations: the idea here is that once we set the bandwidth of the middle two 
;; bands so that the bands are adjacent, this determines the other bands' widths
;; This forces a requirement that icen1 < 1.5 icen2 - 0.5 icen3, else iban1 will be negative
;; Similarly, we must have icen4 > 1.5 icen3 - 0.5 icen 2
;;

iban2=icen3-icen2
iban3=iban2
iban1=2*(icen2-iban2*0.5-icen1)
iban4=2*(icen4-(icen3+iban3*0.5))

;; split the signal into four bands

a1	butterbp ain, icen1,iban1
a2	butterbp ain, icen2,iban2
a3  butterbp ain, icen3,iban3
a4	butterbp ain, icen4,iban4

;; clip each of the four bands
a1clip limit a1,-10,10
a2clip limit a2,-10,10
a3clip limit a3,-10,10
a4clip limit a4,-10,10

;;
;; a bit of "equalization" might be a good thing to put here...
;;

;; mix the clipped bands together, and make it stereo

amixl = 0.6*a2clip+0.55*a4clip+0.45*a1clip+0.4*a3clip
amixr = 0.4*a2clip+0.45*a4clip+0.55*a1clip+0.6*a3clip

outs 300*amixl,300*amixr

endin

</CsInstruments>
<CsScore>

i1 0 25 100 500 800 2000 

</CsScore>
</CsoundSynthesizer>
