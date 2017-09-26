import sys
midi=open(sys.argv[1],'r')

def readDeltaTime():
  m1=midi.read(1)
  if ord(m1)&128==0:
    return ord(m1)
  else:
    m2=midi.read(1)
    if ord(m2)&128==0:
      return ord(m2)+128*(ord(m1)&127)
    else:
      m3=midi.read(1)
      if ord(m3)&128==0:
        return ord(m3)+128*(ord(m2)&127)+128*128*(ord(m1)&127)
      else:
        return ord(m4)+128*(ord(m3)&127)+128*128*(ord(m2)&127)+128*128*128*(ord(m1)&127)
    
  
hexdict={}
digit='0123456789ABCDEF'
for i in range(16):
  for j in range(16):
    hexdict[16*i+j]=digit[i]+digit[j]
def int2(s):
  return ord(s[0])*256+ord(s[1])    
def int4(s):
  return ord(s[0])*256*256*256+ord(s[1])*256*256+ord(s[2])*256+ord(s[3])    
print '-------------------------------------------------'
m=midi.read(4)
print m,
for i in range(4):
  print hexdict[ord(midi.read(1))],
print '  # midi file header   - 8 bytes'
print int2(midi.read(2)), '                 # format             - 2 bytes'
N=int2(midi.read(2))
print N, '                 # number of tracks   - 2 bytes'
print int2(midi.read(2)), '               # number of ticks per quarter note    - 2 bytes'
for n in range(N):
  print
  print '-------------------------------------------------'
  print midi.read(4), '              # track ',n+1,' header - 4 bytes'
  L=int4(midi.read(4))
  print L, '                # length of track    - 4 bytes'
  print '-------------------------------------------------'
  mm=midi.read(L)
  l=len(m)
  n=0
  p=0
  for m in mm:
    pos=32*p+n
    print hexdict[ord(m)],
    n+=1
    if n==8:
      print '   ',
    if n==16:
      print '   ',
    if n==24:
      print '   ',
    if n==32:
      print 
      n=0
      p+=1
