def checkOverlap(road, roadset):
    road_id = road[0]
    for roaddx, checkroad in enumerate(roadset): 
        if checkroad[0] == road_id:
            continue
        checkpattern = checkroad[1]
        for idx, hit in enumerate(road[1]):
            if hit == checkpattern[int(idx)]:
                return True,roaddx
    return False,-1

def main():

    top_roads = []
    bot_roads = []

    with open("roads-78.tsv") as fp:
        lines = fp.readlines()
        lines = lines[1:]
        for line in lines:
            line = line.split()
            half = line[2]
            pattern = [line[1], line[3:7]]
            if half == "B":
                bot_roads.append(pattern)
            elif half == "T":
                top_roads.append(pattern)
            else:
                print "what do you expect me to do with this shit?"

    print "top: " + str(len(top_roads)) + ", bot: " + str(len(bot_roads))
    print "same order..."


    roads_with_overlap = [0,0]
    roads_hit = [[],[]]
    indep_roads = [[],[]]
    for setdx,roadset in enumerate([top_roads,bot_roads]):
        for idx,road in enumerate(roadset):   
            if idx in roads_hit[setdx]:
                continue
            overlapped, overlaproad = checkOverlap(road,roadset)
            if(overlapped):
                roads_with_overlap[setdx] = roads_with_overlap[setdx] + 1
                roads_hit[setdx].append(overlaproad)
            else:
                print "here!"

    print str(roads_with_overlap[0]) + " overlapping roads in top"
    print "is: " + str(float(roads_with_overlap[0])/len(top_roads)*100) \
        + "%" 
    print "indep roads are: " 
    print indep_roads[0]
    print str(roads_with_overlap[1]) + " overlapping roads in bot"
    print "is: " + str(float(roads_with_overlap[1])/len(bot_roads)*100) \
        + "%" 
    print "indep roads are: " 
    print indep_roads[1]





if __name__ == "__main__":
    main()

