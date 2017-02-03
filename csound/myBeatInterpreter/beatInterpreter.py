from os import system
import os
import re
import readline
from sys import exit

score='''
         1               2               3               4
         1   2   3   4   1   2   3   4   1   2   3   4   1   2   3   4
         |...|...|...|...|...|...|...|...|...|...|...|...|...|...|...|...
    kick 1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...
   snare ....1.......1.......1.......1.......1.......1.......1.......1...
    clap ....1.......1.......1.......1.......1.......1.......1.......1...
     chh 1111111.1111111.1111111.1111111.1111111.1111111.1111111.1111111.
     ohh .......1..............1.......1.......1........1.......1.......1
   stick ..............1...............1...............1...............1.
    bell ..........................................................1.....
'''

COMMANDS = ['play', 'write', 'kick', 'snare', 'clap', 'chh', 'ohh', 'stick', 'bell']
RE_SPACE = re.compile('.*\s+$', re.M)
class Completer(object):
    def complete(self, text1, state):
        buffer = readline.get_line_buffer()
        line = readline.get_line_buffer().split()
        if not line:
            return [c + ' ' for c in COMMANDS][state]
        if RE_SPACE.match(buffer):
            line.append('')
        cmd = line[0].strip()
        if cmd in COMMANDS:
            impl = getattr(self, 'complete_%s' % cmd)
            args = line[1:]
            if args:
                return (impl(args) + [None])[state]
            return [cmd + ' '][state]
        results = [c + ' ' for c in COMMANDS if c.startswith(cmd)] + [None]
        return results[state]

INTEGER, PLUS, MINUS, EOF = 'INTEGER', 'PLUS', 'MINUS', 'EOF'
INTEGER, ACTION, SAMPLE, EOF = 'INTEGER', 'ACTION', 'SAMPLE', 'EOF'
class Interpreter(object):
    def __init__(self, text):
        self.text = text
        self.current_command = self.text.split()[0]
    def makeCsoundScore(self, score):
        f=open('score.txt','w')
        f.write('t0 128\n')
        for i in range(7):
          n=0
          for j in score[214+i*74:278+i*74]:
            if j=='1':
              f.write('i'+str(i+1)+' '+str(n*0.25)+' 1 \n')
            n+=1
    def writeCsd(self, csoundScore):
        pass
    def f(self,l):                   # [a],...,[a],[b],...,[b]
      a=l[0]                    #
      i=l[1]                    # [ab],...,[ab],[a],...,[a]   apply again until ...
      b=l[2]                    # [ab],...,[ab],[a]           stop and create one string from the list
      j=l[3]                    # [ab],...,[ab]               stop ...
      if i>j:                   # [ab],...,[ab],[b]           stop ...
        return [a+b,j,a,i-j]    # [ab],...,[ab],[b],...,[b]   apply again until ...
      if i==j:
        return [a+b,i,'',0]
      if i<j:
        return [a+b,i,b,j-i]
    def euclideanRhythms(self,phase, divisions, pulses):
      if pulses==0:
        return 64*'.'
      l=['1',pulses,'.',divisions-pulses]
      l=self.f(l)
      j=l[3]
      while j>1:
        l=self.f(l)
        j=l[3]
      s=''
      for i in range(l[1]):
        s=s+l[0]
      s=s+l[2]
      ls=len(s)
      s=(64*s)
      return s[phase:phase+64]
#    def euclideanRhythms(self, offset, steps, pulses):
#        print 'Euclidean rhythms: offset =', offset, ' steps =', steps, ' pulses =', pulses
    def expr(self):
        global score
        while True:
            if self.current_command == 'p' or self.current_command == 'play':
                print score
                csoundScore=self.makeCsoundScore(score)
                self.writeCsd(csoundScore)
                system('csound ./beatPlayer.csd -odac')
                break
            elif self.current_command == 'w' or self.current_command == 'write':
                csoundScore=self.makeCsoundScore(score)
                self.writeCsd(csoundScore)          
                system('csound ./beatPlayer.csd -o beat.wav')    
                print 'beat.wav compiled'
                break  
            elif self.current_command == 'kick':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+0*74]+s+score[278+0*74:]
                print score
                break
            elif self.current_command == 'snare':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+1*74]+s+score[278+1*74:]
                print score
                break
            elif self.current_command == 'clap':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+2*74]+s+score[278+2*74:]
                print score
                break
            elif self.current_command == 'chh':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+3*74]+s+score[278+3*74:]
                print score
                break
            elif self.current_command == 'ohh':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+4*74]+s+score[278+4*74:]
                print score
                break
            elif self.current_command == 'stick':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+5*74]+s+score[278+5*74:]
                print score
                break
            elif self.current_command == 'bell':
                m=self.text.split()
                offset = int(m[1])
                steps  = int(m[2])
                pulses = int(m[3])
                s=self.euclideanRhythms(offset, steps, pulses)
                score = score[:214+6*74]+s+score[278+6*74:]
                print score
                break
            elif self.current_command == 'x':
                exit()
        return
def main():
    while True:
        try:
            comp = Completer()
            readline.set_completer_delims(' \t\n;')
            readline.parse_and_bind("tab: complete")
            readline.set_completer(comp.complete)
            text=raw_input('>> ')
        except EOFError:
            break
        if not text:
            continue
        interpreter = Interpreter(text)
        result = interpreter.expr()
if __name__ == '__main__':
    main()
