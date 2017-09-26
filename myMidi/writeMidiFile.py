basic = [[0,4,8,12],[0,4,8,11],[0,4,7,11],[0,4,7,10],[0,3,7,11],[0,3,7,10],[0,3,6,10],[0,3,6,9]]
progressions = []
for l in basic:
  for i in range(1):
    progressions = progressions + [[l[0]+i-12,l[1]+i-12,l[2]+i-12,l[3]+i-12]]


convertToHex = {  0 : '\x00',   1 : '\x01',   2 : '\x02',   3 : '\x03',   4 : '\x04',   5 : '\x05',   6 : '\x06',   7 : '\x07', \
                  8 : '\x08',   9 : '\x09',  10 : '\x0a',  11 : '\x0b',  12 : '\x0c',  13 : '\x0d',  14 : '\x0e',  15 : '\x0f', \
                 16 : '\x10',  17 : '\x11',  18 : '\x12',  19 : '\x13',  20 : '\x14',  21 : '\x15',  22 : '\x16',  23 : '\x17', \
                 24 : '\x18',  25 : '\x19',  26 : '\x1a',  27 : '\x1b',  28 : '\x1c',  29 : '\x1d',  30 : '\x1e',  31 : '\x1f', \
                 32 : '\x20',  33 : '\x21',  34 : '\x22',  35 : '\x23',  36 : '\x24',  37 : '\x25',  38 : '\x26',  39 : '\x27', \
                 40 : '\x28',  41 : '\x29',  42 : '\x2a',  43 : '\x2b',  44 : '\x2c',  45 : '\x2d',  46 : '\x2e',  47 : '\x2f', \
                 48 : '\x30',  49 : '\x31',  50 : '\x32',  51 : '\x33',  52 : '\x34',  53 : '\x35',  54 : '\x36',  55 : '\x37', \
                 56 : '\x38',  57 : '\x39',  58 : '\x3a',  59 : '\x3b',  60 : '\x3c',  61 : '\x3d',  62 : '\x3e',  63 : '\x3f', \
                 64 : '\x40',  65 : '\x41',  66 : '\x42',  67 : '\x43',  68 : '\x44',  69 : '\x45',  70 : '\x46',  71 : '\x47', \
                 72 : '\x48',  73 : '\x49',  74 : '\x4a',  75 : '\x4b',  76 : '\x4c',  77 : '\x4d',  78 : '\x4e',  79 : '\x4f', \
                 80 : '\x50',  81 : '\x51',  82 : '\x52',  83 : '\x53',  84 : '\x54',  85 : '\x55',  86 : '\x56',  87 : '\x57', \
                 88 : '\x58',  89 : '\x59',  90 : '\x5a',  91 : '\x5b',  92 : '\x5c',  93 : '\x5d',  94 : '\x5e',  95 : '\x5f', \
                 96 : '\x60',  97 : '\x61',  98 : '\x62',  99 : '\x63', 100 : '\x64', 101 : '\x65', 102 : '\x66', 103 : '\x67', \
                104 : '\x68', 105 : '\x69', 106 : '\x6a', 107 : '\x6b', 108 : '\x6c', 109 : '\x6d', 110 : '\x6e', 111 : '\x6f', \
                112 : '\x70', 113 : '\x71', 114 : '\x72', 115 : '\x73', 116 : '\x74', 117 : '\x75', 118 : '\x76', 119 : '\x77', \
                120 : '\x78', 121 : '\x79', 122 : '\x7a', 123 : '\x7b', 124 : '\x7c', 125 : '\x7d', 126 : '\x7e', 127 : '\x7f'}

def createMidiFile(N):
  header         = '\x4D\x54\x68\x64\x00\x00\x00\x06' 
  format         = '\x00\x01'
  numberOfTracks = '\x00\x02'
  numberOfTicks  = '\x01\xE0' # 480
  
  trackOneHeader = '\x4D\x54\x72\x6B'
  trackOneSize   = '\x00\x00\x00\x0B'
  trackOneTempo  = '\x00\xFF\x51\x03\x0A\x67\x5A'
  trackOneEnd    = '\x00\xFF\x2F\x00' 
  
  trackTwoHeader =                  '\x4D\x54\x72\x6B'
  trackTwoSize   =                  '\x00\x00\xC8\x12'
  trackTwoStuff  =                 ['\x00\xFF\x03\x00']
  trackTwoStuff  = trackTwoStuff + ['\x00\xC0\x20']
  trackTwoStuff  = trackTwoStuff + ['\x00\xB0\x07\x64']
  trackTwoStuff  = trackTwoStuff + ['\x00\x0A\x40']
  
  trackTwoNotes = []
  k=0
  for l in progressions:
    for i in range(4):
      for j in range(4):
        noteInHex = convertToHex[60+basic[N][j]]
        trackTwoNotes = trackTwoNotes +  ['\x00\x90'+noteInHex+'\x64\x78\x80'+noteInHex+'\x7F']
    for i in range(4):
      for j in range(4):
        noteInHex = convertToHex[60+l[j]]
        trackTwoNotes = trackTwoNotes +  ['\x00\x90'+noteInHex+'\x64\x78\x80'+noteInHex+'\x7F']
    k=k+1
  
  trackOneEnd    = '\x00\xFF\x2F\x00'
  
  midiFileHeader = header + format + numberOfTracks + numberOfTicks
  trackOne       = trackOneHeader + trackOneSize + trackOneTempo + trackOneEnd
  trackTwo       = trackTwoHeader + trackTwoSize
  for l in trackTwoStuff:
    trackTwo = trackTwo + l
  for l in trackTwoNotes:
    trackTwo = trackTwo + l
  trackTwo = trackTwo + trackOneEnd
  
  midiFile = midiFileHeader + trackOne + trackTwo
  
  open('midiFile.mid','w').write(midiFile)

createMidiFile(0)

