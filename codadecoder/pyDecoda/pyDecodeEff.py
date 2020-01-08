# looks at dumped ROC data from coda to determine intervals between
# failures in testbench....

import matplotlib.pyplot as plt
import math, sys
from scipy import stats
import numpy as np

def main(filename):
    
    evNo = 0
    intervals = []
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
                    if count != "0000000a":
                        bad_events.append(evNo)
                # chan 0x1f = 31 is start
                if word == "feedb001f":
                    start = line[-1]
                    if start != "00000001":
                        print "data corrupt..."
                        quit()


    # want intervals... skip first event
    for evidx, event in enumerate(bad_events):
        if evidx == 0:
            last = int(event,16)
            continue
        num = int(event,16)
        interval = num - last
        intervals.append(interval)
        last = num

    #compute the mean
    mean = sum(intervals)/float(len(intervals))
    print "mean is: " + str(mean)


    plt.subplot(1,2,1)
    #ax.hist(intervals,bins=100)
    n,bins,patches = plt.hist(intervals)

    # choose x locations to be half of bin edge
    x_pts = []
    for bindx, bn in enumerate(bins):
        # corner case at beginning
        if bindx == 0:
            continue
        x_pts.append(bins[bindx-1]+(bn-bins[bindx-1])/2.)

    plt.scatter(x_pts,n,label='counts')

    # guess exponential distribution between failures
    # y = Ae^BY -> log(y) = log(A) + BY
    print n
    y_logs = [math.log(y) for y in n]

    m, b = np.polyfit(x_pts, y_logs, 1)
    print m 
    print b

    print "bad events: " + str(len(bad_events)) + " out of " + str(total_ev)
    print "eff: " + str(float(total_ev-len(bad_events))/float(total_ev))

    exp_x = np.linspace(0,bins[-1],100)
    exp_y = np.exp(b)*np.exp(m*exp_x)
    plt.plot(exp_x,exp_y,label='exponential fit')

    plt.xlim(bins[0],bins[-1])
    plt.ylim(0,500)
    plt.xlabel("interval from last failure")
    plt.ylabel("counts")
    plt.legend()

    plt.subplot(1,2,2)

    fit = np.poly1d(np.polyfit(x_pts, y_logs, 1))(np.unique(x_pts))

    plt.plot(np.unique(x_pts), fit,label='linreg fit') 
    plt.plot(np.unique(x_pts),np.array(y_logs),'o',label='log(counts)')
    plt.xlabel("interval from last failure")
    plt.ylabel("log(counts)")
    plt.legend()

       
    plt.show()

if __name__ == "__main__":
    
    if len(sys.argv) < 2:
        print "usage: python pyDecode <file>"        
        quit()
    print "decoding...",
    print sys.argv[1]
    main(sys.argv[1])
