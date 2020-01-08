
# stupid way to do NIM2-4 : make roadsets of all combos of hits in 1 and
# 4...

#dif from L1 because I want the output port not input for this app
# [[hodoname,outputport],...]
def readL1Map(filename):
    maplines = []
    print "reading mapping for " + filename
    with open(filename) as fp: 
        mapping = fp.readlines()
        mapping = mapping[1:]
        for line in mapping:
            line = line.strip().split(',')
            maplines.append(line[1:3])
    return maplines

# L0 mapping was incorrect so I cluged this.... chan for Hodoword now gives
# the L1 PORT NAME (A B D) but the L0 output pin (what we need for pattern) 
# only significant if you go poking around in here....
def hodoWordsToPatterns(hodo_code_set, halfFrom, halfTo):
    if halfFrom == 'T':
        mappingfileFrom= "460mapping.txt"
    else:
        mappingfileFrom= "470mapping.txt"
    if halfTo == 'T':
        mappingfileTo= "460mapping.txt"
    else:
        mappingfileTo= "470mapping.txt"


    maplinesFrom = readL1Map(mappingfileFrom)
    maplinesTo = readL1Map(mappingfileTo)
    hodohits = []
    channel_set = []
    channels = []
    chans_sorted = []
    pattern_set = []

    for code in hodo_code_set:
        #code to channels
        
        # MORE BAD IMPLEMENTATION THAT ONLY HANDLES 24 case
        del channels[:]
        del hodohits[:]
        del chans_sorted[:]
        pattern = []
        for i in range(1,5):
            chan = code[2*(i-1):2*i]
            if chan == "XX":
                continue
            if i == 2:
                hodoword = "H" + str(i) + halfFrom
            elif i==4:
                hodoword = "H" + str(i) + halfTo
            if i == 4: 
                hodoword = hodoword + "u"
            hodoword = hodoword + str(chan.zfill(2))
            hodohits.append(hodoword)
        # H4 has u and d hodos sucks...
        # corner cases for days
        hodoword = hodoword[0:3] + "d" + str(chan.zfill(2))
        hodohits.append(hodoword) 

        for idx, word in enumerate(hodohits):
            if idx == 0:
                channel = chanForHodoWord(word,maplinesFrom)
                channels.append(channel)
            else:  
                channel = chanForHodoWord(word,maplinesTo)
                channels.append(channel)

        # channels to patterns
        for chan in channels:
            if chan[0] == 'A':
                majidx = 0 
            elif chan[0] == 'B':
                majidx = 2 
            elif chan[0] == 'D':
                majidx = 4 
            if int(chan[1:]) > 15: 
                idx = majidx + 1 
            else: 
                idx = majidx
            chans_sorted.append([chan,idx])
            
        chans_sorted = sorted(chans_sorted, key = lambda x: x[1])

        # generate bitwise patterns
        indxpat = []
        for chan in chans_sorted:
            patword = ''
            num = chan[0]
            num = int(num[1:]) % 16
            idx = chan[1]
            # what a terrible thing I've done to generate bitwise patterns
            for i in range(0,16):
                if i == num:
                    patword = patword + '1' 
                else:
                    patword = patword + '0' 
            #then need to flip cuz I'm dumb and MSB on LHS
            patword = ''.join(reversed(patword))
            patword = format(int(patword,2),'04x')
            indxpat.append([patword,idx])
        #print indxpat
        # ok with pattern we need fillers and to add patterns with same
        # index...
        for i in range(0,6):
            patword = format(int('0',16),'04x')
            for chan in indxpat:
                if int(chan[1]) == i:
                    patword = format(int(patword,16) + int(chan[0],16),'04x')
            pattern.append(patword)
        pattern_set.append(pattern)
 
    return pattern_set
    
# searches L0 mapping for hodoword to get chan 
# NOTE BIG FLIP IN CHAN BECAUSE mapping from L0 to L1 is WRONG
def chanForHodoWord(hodoword,maplines):
    found = 0 
    for mapping in maplines:        
        if mapping[0] == hodoword:
            found = 1 
            port = mapping[1]
            chan_num = (int(port[1:]) + 16) % 32
            port = port[0] + str(chan_num)
            break
    if not found:
        print 'didnt find the pattern word in roadset'
        print mapping[0]
        print hodoword 
    return port    

def main():
    
    roads = []

    # ~~~~~~ BOO BAD CODING ~~~~~~ fixed for Nim24 isntead of all nim
    # possilbe....
    for h2_idx in range(1,17):
        for h4_idx in range(1,17):
            word = "XX" + str(h2_idx).zfill(2) + \
                "XX" + str(h4_idx).zfill(2) 
            roads.append(word)

    # convert words to patterns
    toptop = hodoWordsToPatterns(roads,'T','T')
    topbot = hodoWordsToPatterns(roads,'T','B')
    bottop = hodoWordsToPatterns(roads,'B','T')
    botbot = hodoWordsToPatterns(roads,'B','B')
   
    with open("nimfiles/nimtt.txt",'w+') as fp:
        for pattern in toptop:
            for word in pattern:
                fp.write(word)
                fp.write(',')
            fp.seek(-1,1)
            fp.write('\n')
    with open("nimfiles/nimtb.txt",'w+') as fp:
        for pattern in topbot:
            for word in pattern:
                fp.write(word)
                fp.write(',')
            fp.seek(-1,1)
            fp.write('\n')
    with open("nimfiles/nimbt.txt",'w+') as fp:
        for pattern in bottop:
            for word in pattern:
                fp.write(word)
                fp.write(',')
            fp.seek(-1,1)
            fp.write('\n')
    with open("nimfiles/nimbb.txt",'w+') as fp:
        for pattern in botbot:
            for word in pattern:
                fp.write(word)
                fp.write(',')
            fp.seek(-1,1)
            fp.write('\n')

if __name__ == "__main__":
    main()
