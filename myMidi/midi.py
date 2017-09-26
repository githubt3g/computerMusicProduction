#import sys
#sys.stdout = open("./1.mid", "w") 
#redirect print to file

def tempoTrack(bpm):
  m=60000000/bpm
  return '\x4D\x54\x72\x6B\x00\x00\x00\x13'+\
         '\x00\xFF\x58\x04\x04\x02\x18\x08'+\
         '\x00\xFF\x51\x03'+chr(m>>16&255)+chr(m>>8&255)+chr(m&255)+\
         '\x00\xFF\x2F\x00'
for t in tempoTrack(128):
  print format(ord(t), '02x'),
print

def trackLength(track):
  l=len(track)
  length=chr(l>>24&255)+chr(l>>16&255)+chr(l>>8&255)+chr(l&255)
  return length

#track=     '\x00\xFF\x58\x04\x04\x02\x18\x08'
#track+=    '\x00\xFF\x51\x03\x07\xA1\x20'
#track+=    '\x00\xC0\x28'
#track+=    '\x00\xC1\x28'
#track+=    '\x00\xC2\x28'
track=    '\x00\x99\x30\x7f'
track+=    '\x00\x99\x43\x40'
track+=    '\x00\x99\x4C\x40'
track+='\x60\x89\x30\x7f'
track+=    '\x00\x89\x43\x40'
track+=    '\x00\x89\x4C\x40'
track+=    '\x00\x99\x30\x7f'
track+=    '\x00\x99\x43\x40'
track+=    '\x00\x99\x4C\x40'
track+='\x60\x89\x30\x7f'
track+=    '\x00\x89\x43\x40'
track+=    '\x00\x89\x4C\x40'
track+=    '\x00\x99\x30\x7f'
track+=    '\x00\x99\x43\x40'
track+=    '\x00\x99\x4C\x40'
track+='\x60\x89\x30\x7f'
track+=    '\x00\x89\x43\x40'
track+=    '\x00\x89\x4C\x40'
track+=    '\x00\x99\x30\x7f'
track+=    '\x00\x99\x43\x40'
track+=    '\x00\x99\x4C\x40'
track+='\x60\x89\x30\x7f'
track+=    '\x00\x89\x43\x40'
track+=    '\x00\x89\x4C\x40'
track+=    '\x00\xFF\x2F\x00'

track ='\x4D\x54\x72\x6B'+trackLength(track)+track

print len(track)

def int2vlqString(n):
  v1=n    &127
  v2=n>>7 &127
  v3=n>>14&127
  v4=n>>21&127
  s=chr(v1)
  if (v2>0)|(v3>0)|(v4>0):
    v2=v2|128
    s=chr(v2)+s
  if (v3>0)|(v4>0):
    v3=v3|128
    s=chr(v3)+s
  if v4>0:
    v4=v4|128
    s=chr(v4)+s
  return n, hex(n), s 
headerLength='\x00\x00\x00\x06'
format='\x00\x01'
ntrks='\x00\x02'
division=chr(0)+chr(96)
f=open('1.mid','w')
midiFile='MThd'+headerLength+format+ntrks+division
midiFile+=tempoTrack(128)
midiFile+=track
f.write(midiFile)


kick ='8888 8888 8888 8888'.replace(' ','')
snare='0808 0808 0828 0828'.replace(' ','')
chh  ='fffa fffa fffa ffaa'.replace(' ','')
ohh  ='0005 0005 0005 0055'.replace(' ','')

binary={'0':'0000', '1':'0001', '2':'0010', '3':'0011',
        '4':'0100', '5':'0101', '6':'0110', '7':'0111',
        '8':'1000', '9':'1001', 'a':'1010', 'b':'1011',
        'c':'1100', 'd':'1101', 'e':'1110', 'f':'1111',}

drumTracks=[['kick',kick],['snare',snare],['chh',chh],['ohh',ohh]]

c=1

for e in drumTracks:
  print str(e[0]),'\t',
  for l in e[1]:
    print binary[l],
    if c%4==0:
      print '  ',
    c+=1
  print

'''
  integer     hexadecimal     variable-length-quantity
        0               0        00                  0000 0000            
       64              40        40                  0100 0000
      127              7F        7F                  0111 1111
      128              80        81 00               1000 0001 0000 0000
     8192            2000        C0 00               1100 0000 0000 0000
    16383            3FFF        FF 7F               1111 1111 0111 1111
    16384            4000        81 80 00            1000 0001 1000 0000 0000 0000
  1048576          100000        C0 80 00            1100 0000 1000 0000 0000 0000
  2097151          1FFFFF        FF FF 7F            1111 1111 1111 1111 0111 1111
  2097152          200000        81 80 80 00         1000 0001 1000 0000 1000 0000 0000 0000
134217728         8000000        C0 80 80 00         1100 0000 1000 0000 1000 0000 0000 0000
268435455         FFFFFFF        FF FF FF 7F         1111 1111 1111 1111 1111 1111 0111 1111
'''
'''
MThd <length of header data>
<header data>
MTrk <length of track data>
<track data>
MTrk <length of track data>
<track data>
. . .
'''

