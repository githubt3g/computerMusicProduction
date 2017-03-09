from os import system
system('ls *.mid > list')
ll=open('list','r').read().split()
for l in ll:
  system('mkdir '+l[:-4])
  system('mv '+l+' '+l[:-4])
  csound='''
<CsoundSynthesizer>
<CsOptions>
-F '''+l+'''
</CsOptions>
<CsInstruments>
ksmps = 10

massign 0,1

  instr 1
iChan       midichn
inotnum     notnum            ; read pitch in frequency from midi notes
iVel        veloc	0, 127 ; read in velocity from midi notes
kDur        timeinsts          ; running total of duration of this note
kRelease    release            ; sense when note is ending
 if kRelease=1 then            ; if note is about to end
;           p1  p2  p3    p4     p5    p6
event "i",  2,  0, kDur, iChan, inotnum, iVel ; send full note data to instr 2
 endif
  endin

  instr 2
iDur        =        p3
iChan       =        p4
inotnum        =        p5
iVel        =        p6
iStartTime  times        ; read current time since the start of performance
; form file name for this channel (1-16) as a string variable
SFileName   sprintf  "part_alina60%d.sco",iChan
; write a line to the score for this channel's .sco file
            fprints  SFileName, "i%d\\t%f\\t%f\\t%d\\t%d\\n", iChan, iStartTime-iDur, iDur, inotnum, iVel/127
  endin

</CsInstruments>

<CsScore>
f 0 480 ; ensure this duration is as long or longer that duration of midi file
e
</CsScore>

</CsoundSynthesizer>
'''
