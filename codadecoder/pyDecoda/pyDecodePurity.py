# looks at coda files in purity tests -> extracts event number if an event
# fired when it should not have...

import matplotlib.pyplot as plt
import math, sys

def main(filename):
    
    evNo = 0
    bad_events = []
    total_ev = 0

    print "starting decode...."
    with open(str(filename),"r") as fp:
        for idx,line in enumerate(fp.readlines()):
            #skip first 4 lines
            if idx < 4:
                continue
            # each line is one event CSV
            line = line.strip().split(",")
            total_ev = total_ev + 1
            for worddx,word in enumerate(line): 
                # evNo = 2nd word
                if worddx == 1:
                    evNo = word
                # chan 0x1c = 28 is FPGA4 
                if word == "feed001b":
                    count = line[worddx+1]
                    if count != "00000000":
                        bad_events.append([evNo,count])
                # chan 0x1f = 31 is start
                if word == "feedb001f":
                    start = line[-1]
                    if start != "00000001":
                        print "data corrupt..."
                        quit()


    # looking for counts where there should be none.
    for evidx, event in enumerate(bad_events):
        print event

if __name__ == "__main__":
    
    if len(sys.argv) < 2:
        print "usage: python pyDecode <file>"        
        quit()
    print "decoding...",
    print sys.argv[1]
    main(sys.argv[1])
