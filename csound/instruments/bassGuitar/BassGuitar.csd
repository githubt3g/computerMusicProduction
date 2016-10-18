<CsoundSynthesizer>
<CsOptions>
;-M0 -dodac
-dm0 -n -Ma -odac
</CsOptions>
<CsInstruments>
   sr   =  44100
 ksmps  =     64
nchnls  =      2
 0dbfs  =      1


                                     gkfeedback init 1
                                     gkFiltRatio init 0.5
                                     gkbw init 32
                                     gkatt init 0
                                     gkLegSpeed init 1
                                     gkVibDep init 1
                                     gkVibRte init 30
                                     gklevel init 1
                                     gkPickupPos init 0.1
                                     gklegato init 1

gkNoteTrig init 0
giwave ftgen 0,0,4097,11,20,1,0.5
gisine ftgen 0,0,4097,10,1
gasigL init 0
gasigR init 0

opcode PluckedElectricString,a,aakkkak
 asig,acps,kcutoff,kbw,kfeedback,aPickupPos,kporttime xin
 setksmps 1 
 kcutoff portk  kcutoff,kporttime
 kbw portk  kbw,kporttime
 acutoff interp  kcutoff
 kcutoff downsamp acutoff
 abw interp  kbw
 kbw downsamp abw
 kbw  limit kcutoff*kbw,0.001,10000 ;limit bandwidth values to prevent explosion
 aDelTim limit 1/acps,0,1 ;derive required delay time from cycles per second value (reciprocal) and limit range
  
 afb init 0     ;audio feedback signal used by delay buffer
 atap1 vdelay asig+afb,aDelTim*aPickupPos*1000,1000 ;tap 1. Nut

 atap2 vdelay -atap1,aDelTim*(1-aPickupPos)*1000,1000 ;tap 2, Tailpiece
 
 atap2 butbp atap2,kcutoff,kbw   ;bandpass filter (nb. within delay buffer)

 afb = atap2*-kfeedback   ;create feedback signal to add to input for next iteration

  xout atap1+atap2    ;return audio to caller instrument. NB. audio at pickup is a mixture (with positive and negative 
                      ;interference) of wave reflected from the bridge and the nut 
                      ;(the two points of fixture of the string) 
endop

;UDO for lowpass filter attack enveloping - using a UDO permits setting ksmps=1 in order to improve sound quality
opcode butlpsr,a,aii
 setksmps 1
 asig,icps,idur xin
 kcfenv  expseg icps,idur,15000,1,15000
 asig butlp asig,kcfenv
  xout asig
endop


instr 2 ;triggered via MIDI
 gkNoteTrig init 1 ;at the beginning of a new note set note trigger flag to '1'
 icps  cpsmidi  ;read in midi note pitch in cycles per second
 icps  = icps/4
 givel  veloc 0,1 ;read in midi note velocity

 gkcps init icps  ;update a global krate variable for note pitch

;  iactive active 3 ;check to see if these is already a note active...
 ; if iactive==0 then  ;...if not...
   event_i "i",3,0,-1 ;...start a new held note
 ; endif
endin

instr 3
 kporttime linseg 0,0.001,1  ;portamento time function rises quickly from zero to a held value
 kporttime = kporttime*gkLegSpeed ;scale portamento time function with value from GUI knob widget
 
 if i(gklegato)==1 then    ;if we are in legato mode...
  kcps portk gkcps,kporttime   ;apply portamento smooth to changes in note pitch 
                             ;(this will only have an effect in 'legato' mode)
  acps interp kcps    ;create a a-rate version of pitch (cycles per second)
  kactive active p1-1   ;...check number of active midi notes (previous instrument)
  if kactive==0 then    ;if no midi notes are active...
   turnoff     ;... turn this instrument off
  endif
 else      ;otherwise... (polyphonic / non-legato mode)
  acps = p4     ;pitch equal to the original note pitch
 endif
 
 aptr line 0,1/i(gkcps),1   ;pointer that will be used to read excitation signal waveform function table
 asig tablei aptr,giwave,1,0,0  ;create excitation (pluck) signal
 asig butlp asig,cpsoct(4+(givel*8)) ;lowpass filter excitation signal according to midi note velocity of this note 
 asig buthp asig,i(gkcps)   ;highpass filter excitation signal (this could possibly be made adjustable using a GUI widget)
 
 kcutoff  limit gkcps*gkFiltRatio,20,20000 ;cutoff of frequency of the bandpass filter will be relative to the 
                                           ;pitch of the note. 
                                           ;Limit it to prevent out of range values that would cause filter expolosion.
 
 ;In legato mode modulations are reinitialised
 if gkNoteTrig==1&&gklegato==1 then
  reinit RESTART_ENVELOPE
 endif
 RESTART_ENVELOPE:
 krise linseg 0,0.3,0,1.5,1   ;build-up envelope - modulations do not begin immediately
 rireturn
 arise interp krise    ;interpolation prevents discontinuities (clicks) when oscili lfos are reinitialised
 avib oscili 0.8*arise*gkVibDep,gkVibRte,gisine ;vibrato
 acps = acps*semitone(avib)
 atrm oscili 0.8*arise*gkVibDep,gkVibRte,gisine,0 ;tremolo

 gkPickupPos portk gkPickupPos,kporttime  ;smooth changes made to pickup position slider
 aPickupPos interp gkPickupPos   ;interpolate k-rate pickup position variable to create an a-rate version
 ares   PluckedElectricString   asig, acps, kcutoff, gkbw, gkfeedback, aPickupPos,kporttime ;call UDO - using a UDO 
                       ;facilitates the use of a different ksmps value (ksmps=1 and kr=sr) to optimise sound quality
 
 aenv  linsegr 0.7,0.05,0   ;amplitude envelope
 
 if i(gkatt)>0 then     ;if attack time is anything greater than zero call the lowpass filter envelope
  ares  butlpsr ares,i(gkcps),i(gkatt)  ;a UDO is used again to allow the use of ksmps=1
 endif
 
 ares  = 0.25*ares*aenv*(1+atrm)*gklevel ;scale amplitude of audio signal with envelope, tremolo and level knob widget
   outs ares,ares
   gasigL=ares
   gasigR=ares
 gkNoteTrig = 0    ;reset new-note trigger (in case it was '1')
endin


;instr 777
;        gaBeatL, gaBeatR  loscil  1, 1, 777, 1, 1, 0, 148027
;        gaBeatL=0.5*gaBeatL
;        gaBeatR=0.5*gaBeatR
;                outs   gaBeatL,gaBeatR
;endin


instr 900
  outs gasigL, gasigR
  fout "recording.wav", 4, gasigL, gasigR;, gaBeatL, gaBeatR
  clear gasigL
  clear gasigR
endin


instr 1000
  exitnow
endin

</CsInstruments>

<CsScore>
f0 3600
;f777 0 0 1 "beat143.wav" 0 0 0 

;i777 0 -1
;i900 0 -1

</CsScore>

</CsoundSynthesizer>
