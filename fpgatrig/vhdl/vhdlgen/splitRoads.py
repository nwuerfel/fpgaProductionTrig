# reads roads.tsv and splits into 4 files based on charge and half
# outputs roads formatted as [roadid,h1,h2,h3,h4,charge,pxbin]
import sys

def main(roadsfilename):
    with open(roadsfilename,"r") as rfp, \
    open("roads_plus_top.txt","w") as ptfp, \
    open("roads_minus_top.txt","w") as mtfp, \
    open("roads_plus_bottom.txt","w") as pbfp, \
    open("roads_minus_bottom.txt","w") as mbfp:

        roads = rfp.readlines()
        roads = roads[1:]
        for road in roads:
            road = road.split()
            charge = road[7]
            half = road[2]
            trimmedroad = [road[1],road[3],road[4],road[5],road[6],\
                charge,road[8]]
            if charge == "1":
                if half == "T":
                    wp = ptfp
                else:
                    wp = pbfp
            else:
                if half == "T":
                    wp = mtfp
                else:
                    wp = mbfp
            for item in trimmedroad:
                wp.write(str(item))
                wp.write("\t")
            # replace last tab with newline
            wp.seek(-1,1)
            wp.write("\n")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "usage: $> python splitRoads.py <roads.tsv filename>"
        quit()
    main(sys.argv[1])
