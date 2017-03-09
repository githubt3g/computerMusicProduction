import re
import urllib
s=open('view-source_www.midiworld.com_earlymus.htm','r').read()
match=re.findall(r'href="http://www.midiworld.com/midis/other/c1/.*?mid"',s)
for m in match:
  mm=re.findall(r'http://www.midiworld.com/midis/other/c1/.*?mid',m)
  for mmm in mm:
    print mmm[40:]
    urllib.urlretrieve (mmm, mmm[40:])
#for l in ll:
#  
