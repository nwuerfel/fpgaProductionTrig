import random
import matplotlib.pyplot as plt
def main():

    data=[]
    badevents=[]
    intervals = []
    
    for i in range(0,20553):
        num = random.randrange(99) 
        if num < 94.5:
            data.append(1)
        else: 
            data.append(0)
            badevents.append(i)

    for eventdx,event in enumerate(badevents):
        if eventdx==0:
            last = event
            continue
        num = event - last
        intervals.append(num)
        last = event

    # compute mean of the intervals...
    mean = sum(intervals)/float(len(intervals))
    print "mean is: " + str(mean)

    fig, ax = plt.subplots(tight_layout=True)
    ax.hist(intervals)
    plt.show()




if __name__ == "__main__":
    main()
