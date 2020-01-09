# looks at dumped ROC data from coda to determine intervals between
# failures in testbench....

#TODO

#    error check inputs
#    error check FPGA trigger 
#    more flexible inputs
#    clean up 2nd run through dat
#
#
#
#

import matplotlib.pyplot as plt
import math, sys
from scipy import stats
import numpy as np
import os

nBoards = 4
eventlen = 16

# clock period in ns
clockPeriod = 25
# scaling factor for TDC: 
# units are 1/16 of clock
tdcScale = 25./16


triggers = {"FPGA1":0, "FPGA2":1, "FPGA3":2, "FPGA4":3, "FPGA5":4,\
        "NIM1":5, "NIM2":6, "NIM3":7, "NIM4":8, "NIM5":9        
    }

    

class boardWords:
    def __init__(self,rev,words,cStopTime):
        self.revision = rev
        self.clockHits = []
        self.channelHits = []
        self.cStopTime = int(cStopTime[-3:],16)
        for word in words:
            if "40" in word[4:6]:
                self.clockHits.append([word[4:6],word[6:8]])
            else:
                self.channelHits.append([word[4:6],word[6:8]])

    def bprint(self):
        print "revision: " + str(self.revision)
        print "~~~~~~~~~~~~~~~~~~~~~~"
        print "~~~~~~~~~~~~~~~~~~~~~~"
        print

        print "clockHits: " 
        print "~~~~~~~~~~~"
        for hit in self.clockHits:
            print str(hit)
        print
        print "channelHits: " 
        print "~~~~~~~~~~~~~"
        for hit in self.channelHits:
            print str(hit)
        print 

class event:
    def __init__(self,nwords,boardData,eventNo,trigType):
        self.nWords=0
        self.boardData=boardData
        self.eventNo=eventNo
        self.trigType = trigType
        if self.trigType == "e906c0da":
            self.trigType = -1
        elif self.trigType == "":
            self.trigType = -1


    def eprint(self):
        print "nWords: " + str(self.nWords)
        print "boardData: " 
        for board in self.boardData:
            board.bprint()

def parseEvent(eventLines,eventNo):

    nWords = eventLines[0][0].split(" ")
    nWords = int(nWords[1])
    boardData = []
    trigword = ''
    rev = []
    nHits = -1
    hits = []

    for idx,line in enumerate(eventLines):
        if idx < 1 or idx == 15:
           continue
        if line[1] == "e906f00f":
            trigword = line[3]
        # TODO wtf is this event
        elif line[1] == "e906f003":
            print "bummer..."
            continue
        elif line[1] == "13378eef":
            for lidx,word in enumerate(line):
                if word == "13378eef":
                    rev = line[lidx+1]
                    cStopTime = line[lidx+4]
                    nHits = line[lidx+3]
                    if nHits == "0000d1ad":
                        hits = []
                    else: 
                        nHits = int(line[lidx+3],16)
                        hits = line[lidx+5:lidx+5+nHits]
                    boardData.append(boardWords(rev,hits,cStopTime))
        else:
            continue
    newEvent = event(nWords,boardData,eventNo,trigword)
    return newEvent

def main(filename,maxEvents=-1,trigger = triggers.get("FPGA5")):
    
    evNo = 0
    total_ev = 0
    nim4_ev = 0
    runNo = int(filename[0:4])
    events = []
    badEvents = []
    noHitEvents = []
    maxEvents = int(maxEvents)
    trigname = trigger
    trigger = triggers.get(trigger)
    eventLines = []
    print "maxEvents: " + str(maxEvents)

    print "starting decode...."
    with open(str(filename),"r") as fp:
        for idx,line in enumerate(fp.readlines()):
            #skip first 8 lines
            if idx < 4:
                continue
            # parse lines
            line = line.strip().split(",")
            if('nWordsTotal' in line[0]):
                if len(eventLines) == eventlen:
                    # build events
                    events.append(parseEvent(eventLines,total_ev))
                    total_ev = total_ev + 1
                    if not (total_ev % 10000):
                        print "total_ev complete: " + str(total_ev)
                    if total_ev == maxEvents:
                        print "hit maxEvents"
                        break
                    eventLines = []
            eventLines.append(line) 
            

    ## TODO fix SUPERSLOP solution
    ckDataArray = [[],[],[],[]]
    chDataArray = [[],[],[],[]]
    revs = ['420','420','460','470']

    with open("timing_log.out","w") as logfp:
        for idx, event in enumerate(events):                        
            hasHits = False
            if (not len(event.boardData)) or (event.trigType) == -1:
                #print "bad event: " + str(idx)
                #print "boardData: " + str(len(event.boardData))
                badEvents.append(idx)
                continue;
            else:
                # just guessing this map....
                # I think it's (LSB TO MSB) FPGA 1-5 NIM 1-5, then some
                # ordering of EOS, BOS, FLUSH, ETC

                #supports all triggers now
                if int(event.trigType,16) >> int(trigger):
#                    logfp.write("NIM4 ")
#                    logfp.write("event: " + str(idx)+"\n") 
#                    logfp.write("~~~~~~~~~\n")
                    nim4_ev = nim4_ev + 1
                    # fill hits on each board
                    for bdx, board in enumerate(event.boardData):
#                        logfp.write("hits for rev: " + board.revision +"\n")
#                        logfp.write("Clock: \n")
#                        logfp.write("~~~~~~~~~\n")

                        #ck hits
                        if not board.clockHits:
                            logfp.write("no clockhits!\n")
                        else:
                            for hit in board.clockHits:
#                                logfp.write(str(hit[0]) + " " +
#                                    str(hit[1]) + "\n")
                                ckDataArray[bdx].append([idx,hit])
#                        logfp.write("Channels: \n")
#                        logfp.write("~~~~~~~~~~\n")
                        # chan hits
                        if not board.channelHits:
                            logfp.write("no hits!\n")
                        else:
                            hasHits = True
                            logfp.write("hit on board!\n")
                            for hit in board.channelHits:
#                                logfp.write(str(hit[0]) + " " + 
#                                    str(hit[1]) + "\n")
                                if hit[0] == '':
                                   print "wtf, empty..."
                                   print "event: " + str(idx)
                                   print hit
                                   events[idx].eprint()
                                   quit()
                                chDataArray[bdx].append([idx,hit])
#                        logfp.write("\n")                                
#                    logfp.write("\n") 
                    if not hasHits:
                        noHitEvents.append(idx)
                else: 
                    continue

        for i in range (0,nBoards):
            logfp.write("total info for board: " + str(revs[i]) + "\n")
            logfp.write("~~~~~~~~~~~~~~~~~~~~~~~~~\n")
            totalCkEvents = len(np.unique([x[0] for x in ckDataArray[i]]))
            totalChEvents = len(np.unique([x[0] for x in ckDataArray[i]]))
            logfp.write("total Ck events: " + str(totalCkEvents) +   
                "\n")
            logfp.write("total Ch events: " + str(totalChEvents) +   
                "\n")
            logfp.write("events with hits: " + str(len(chDataArray[i])) + 
                "\n")
            logfp.write("\n")

     
                
    print "NIM4 events: " + str(nim4_ev)
    print "events with no hits: " + str(len(noHitEvents))
    print "\'good events\': " + str(nim4_ev - len(noHitEvents))
    print ("percent of events with hits: %0.03f" % \
        float(100*(nim4_ev-len(noHitEvents))/float(nim4_ev)))

#    for boarditem in ckDataArray:
#        if not boarditem[1]:
#            print "WTF missing hits"


    for i in range (0,nBoards):
        # TODO clean up this mess/ make more abstract
        cktimeData = np.array([int(x[1][1],16) for x in ckDataArray[i]])
        chchData = np.array([int(x[1][0],16) for x in chDataArray[i]])
        chtimeData = np.array([int(x[1][1],16) for x in chDataArray[i]])
        # TODO clean up this mess, I should really restructure events...
        # anyway this is an array of [common stop times] for above events
        # not all clock events also have hits -> could have different time
        # const....
        ckCStopTime = np.array([events[x[0]].boardData[i].cStopTime 
            for x in ckDataArray[i]])
        chCStopTime = np.array([events[x[0]].boardData[i].cStopTime 
            for x in chDataArray[i]])

        print "chan data length: " + str(len(chDataArray[i]))

        # new fig per guy
        fig = plt.figure(i)
        plt.rcParams["figure.figsize"] = [14,10]
        fig.set_size_inches(14,9,forward=True)

        # sub off times from cstop
        cktimeData = np.subtract(ckCStopTime,cktimeData)
        chtimeData = np.subtract(chCStopTime,chtimeData)

        # scale from clock stretching
        cktimeData = cktimeData*tdcScale
        chtimeData = chtimeData*tdcScale

        # clock tdc distribtuion
        plt.subplot(3,1,1)
        plt.hist(cktimeData,bins=int(max(cktimeData)-min(cktimeData))+1)
#        plt.hist(cktimeData,bins=100)
        plt.title("clock tdc time")
        plt.ylabel("counts")
        plt.xlabel("tdc time")
        plt.legend()

        # channel tdc distributions
        plt.subplot(3,1,2)

#        plt.hist2d(chtimeData,chchData,
#            bins=[int(max(chtimeData)-min(chtimeData))+1,96])

        h,xedges,a,b = plt.hist2d(chtimeData,chchData,
            bins=[133,96])
        #plt.hlines([31,47,63,92],0,xedges[0],xedges[-1])
        plt.title("channel tdc times")
        #plt.ylim([min(chchData),max(chchData)])
        plt.ylabel("channel id")
        plt.xlabel("channel tdc time")
        plt.colorbar()
       # plt.colorbar(orientation='vertical',pad=0.0)

        plt.legend()

        # single channel tdc distributions
        # get mode of the chans to plot most populous one
        plt.subplot(3,1,3)

        maxchan = stats.mode(chchData)
        timesForChan = np.array([int(x[1][1],16) for x in chDataArray[i]
            if int(x[1][0],16) == maxchan[0]])
        stopTimeForChan = np.array([events[x[0]].boardData[i].cStopTime \
            for x in chDataArray[i] if int(x[1][0],16) == maxchan[0]])

        # sub cstop and scale for clock stretch
        timesForChan = np.subtract(stopTimeForChan,timesForChan)
        timesForChan = timesForChan * tdcScale

        plt.hist(timesForChan,bins=133)
        plt.title("single chan: (" + str(int(maxchan[0])) + ") tdc time")
        plt.ylabel("counts")
        plt.xlabel("tdc time")
        plt.legend()

        plt.tight_layout(pad=2.0)
        fig.suptitle("runNo: " + str(runNo) + ", TRIG: " + trigname)
        fig.subplots_adjust(top=0.88)

        try:
            os.mkdir("outfiles/" + str(runNo) + "_" + trigname + "plots/")
        except OSError:
            print "exists"

        plt.savefig("outfiles/" + str(runNo) + "_" + trigname + \
            "plots/rev_" + str(revs[i]) + "_" + str(i) + ".png")
    #plt.show()

if __name__ == "__main__":
    
    if len(sys.argv) < 2:
        print "usage: python pyDecode <file> <optional: maxevents> " +  \
         "<trigType>"        
        quit()
    print "decoding...",
    print sys.argv[1]
    # TODO flexible parsing
    if len(sys.argv) == 4:
        main(sys.argv[1],sys.argv[2],sys.argv[3])
    else:
        main(sys.argv[1])

