# reads roads.tsv file and generates L1 trigger matrix for the new mapping
# Forhad enacted as of end of 2019 

# shit its really hard to do a direct comparison of firmware because I have
# no idea what order the roads were sorted in the old version, and I don't
# care to figure it out, should just run pulser test to confirm full
# test....

# spacing from tab expand is dumb but oh well...


# N wuerfel 
# ~ AP AP AP AP ~

pxbins = 12
nlevels = 9

import math
import sys

# generates array of [hodo,firmwarename] elements
# returns list
def readL1FirmwareMap(filename):
    maplines = []
    print "reading mapping for " + filename
    with open(filename) as fp:
        mapping = fp.readlines()
        mapping = mapping[1:]
        for line in mapping:
            line = line.strip().split(',')
            maplines.append(line[1:4:2])

    return maplines

# reads roadset and generates and generates array of  roads as 
# [roadid, hodo_pattern_word, PxBin] elements
# returns roadset, array with num in each bin, indexed by bin
# roadset sorted by pxbin
def readL1roadset(filename):
    L1roadset=[]
    print "reading roadset for " + filename
    with open(filename) as fp:
        roads = fp.readlines() 
        for rawroad in roads: 
            hodo_pattern_word = ''
            rawroad = rawroad.strip().split()
            rawroad = rawroad[0:8]
            roadid = rawroad[0]
            for i in range(1,5):
                hodo_pattern_word += rawroad[i].zfill(2)
            PxBin = rawroad[6]
            road = [roadid, hodo_pattern_word, PxBin]
            L1roadset.append(road)
    # generate array with pxbin numbers:
    binnumbers = [0]*pxbins
    for road in L1roadset:
        binnumbers[int(road[2])] = binnumbers[int(road[2])] + 1
    L1roadset = sorted(L1roadset, key = lambda x: x[2])
    return L1roadset,binnumbers

# returns string line of the form: "if(4 fold coincidence)then"
def road2firmwareline(mapping, hodoword, half):
    firmwarewords=[]
    for i in range(1,5):
        searchword = "H"+str(i)+half
        # god I hate the corner case of H4 having u and b 
        if i==4:
            searchword = searchword + "u"
        searchword = searchword+str(hodoword[2*(i-1):2*i].zfill(2))
        for item in mapping:
            found = 0
            if str(item[0]) == searchword:
                firmwarewords.append(item[1])
                found = 1
                break
        if not found:
            print "couldn't find this hit:"
            print searchword
            quit()

    # constructing the line with stupid formatting 
    vhdline = "        if("
    for idx,word in enumerate(firmwarewords):
        letter = word[0]

        # stupid stripping formatting
        # strip only one leading zero if it exists
        num = word[1:]
        if num[0] == '0':
            num = num[-1]

        vhdline = vhdline+str(letter)+\
        "("+str(num).rjust(2)+\
        ")=\'1\'"
        if idx < 3:
            vhdline = vhdline+" AND "
        else:
            vhdline = vhdline+ " )then\n"
    return vhdline

# takes set of up to 4 signals to or reduce
# produces a line like: "if(up to 4 fold OR)then"
def ORreduce(header,signals,level,pxbin):
    if len(signals) < 1 or len(signals) > 4:
        print "wrong length for ,levelsigset..."
        print signals
        quit()
    line="      if("
    for sigdx,sig in enumerate(signals):
        line = line + header + "_temp_lv" + str(level) + "_" +\
        str(pxbin).zfill(2) + "(" + str(sig).rjust(4) + ")='1' "
        if sigdx < len(signals)-1:
            line = line + "OR "
    line = line + ")then\n"
    print line
    return line

def main(version):
    if version == 460:
        half = 'T'
        halfname = "top"
    else:
        half = 'B'
        halfname = "bottom"

    vhdlfilename = "code_" + str(version) + ".vhd"
    vhdlheaderfname = "vhdtext/" + str(version) + "header.txt"

    mappingfile = str(version)+"mapping.txt" 
    hodomapping = readL1FirmwareMap(mappingfile)
#    print hodomapping

    proadfname = "roads_plus_"+halfname+".txt"
    mroadfname = "roads_minus_"+halfname+".txt"

    proads,ppxbins = readL1roadset(proadfname)
    mroads,mpxbins = readL1roadset(mroadfname)

    # multidim: [[numperbin_0..._i],....] indx is level
    psiglens = [] 
    msiglens = []

    # somethings are nasty hardcoded headers...
    with open(vhdlfilename,"w") as vfp:
        # copy header over
        with open(vhdlheaderfname,"r") as hfp:
            lines = hfp.readlines()
            for line in lines:
                vfp.write(line)
        # now write signals needed
        # this take input about num roads -> 12 signals for each pxbin (can
        # change later but for now just recreate old version)
        # num signals in l1 is numroads in bin
        #//TODO 
        # 8 levels for pos and 8 for min 
        # TODO change PF and NF to MF just recreating now
        for header in ["PF","NF"]:
            if header == "PF":
                binlist = ppxbins
                siglens = psiglens
            else:
                binlist = mpxbins
                siglens = msiglens
            #do reduction at each level
            lastbinval=binlist[:]
            for level in range(1,nlevels):
                siglens.append(lastbinval[:])
                for binno in range(0,pxbins):
                    # stupid like most things its all corner cases
                    if level == 1:
                        divisor = 1
                    else:
                        divisor = 4.0
                    siglen = int(math.ceil(lastbinval[binno]/divisor))

                    # take off 1 unless 0 in the bin...
                    if lastbinval[binno] != 0:
                       offset = 1
                    else:
                       offset = 0

                    line = "        signal " + header + "_temp_lv" +\
                    str(level)
                    if level!=nlevels-1:
                        line = line + "_" + str(binno).zfill(2) + \
                    ": std_logic_vector" + "(" + \
                    str(siglen - offset).rjust(4) + \
                    " downto 0);\n"

                    # update lasbinvals
                    lastbinval[binno] = siglen 

                    
                    vfp.write(line)
             # other stupid corner case is last line, always same
            line = "        signal " + header + "_temp_lv8: " + \
            "std_logic_vector(  11 downto 0);\n"
            vfp.write(line)

                      
        # write the mapping that swaps channels around between sampling and
        # the firmware values...
        with open("vhdtext/signalmapping.txt","r") as sigmapfp:
            lines = sigmapfp.readlines()
            for line in lines:
                vfp.write(line)
        

        # now write l0, doesn't change because it just combines u/d on
        # vertical in ST4 and kills a clock for other signals
        with open("vhdtext/level0.txt","r") as l0fp:
            lines = l0fp.readlines()
            for line in lines:
                vfp.write(line)

        # L1 #
        vfp.write("lookuptable_LV1 : process(c1)\nbegin\n")
        vfp.write(" if c1'event and c1='1' then\n")
        # we have num per bin, but its clunky to iterate based on bin
        # instead, we sort roads when we read them in by bin indx, then we
        # iterate the binidx as we write each road and check that it
        # matches expectation and scream if it doesnt
        for header in ["PF","NF"]:
            if header == "PF":
                roadlist = proads
                binlist = ppxbins
            else:
                roadlist = mroads
                binlist = mpxbins

            binidx = 0
            bincount = 0
            for road in roadlist:
                # check if we're in the next pxbin
                # and check if we wrote the num expected for that bin to
                # match signal length
                if int(binidx) != int(road[2]):
                    if bincount != int(binlist[binidx]):
                        print "bincount written doesn't match sig len"
                        print "count: " + str(bincount)
                        print "siglen: " + str(binlist[binidx])
                        quit()
                    binidx = binidx+1
                    bincount = 0

                binidx = int(road[2])
                coincidenceline = road2firmwareline(hodomapping,\
                road[1],half)
                signal = header + "_temp_lv1_" + str(binidx).zfill(2) +\
                "(" + str(bincount).rjust(4) + ")"
            
                # write this ugly guy
                vfp.write(coincidenceline)
                vfp.write("          "+signal+"<=\'1\';\n")
                vfp.write("          else\n")
                vfp.write("          "+signal+"<=\'0\';\n")
                vfp.write("          end if;\n")
                bincount = bincount + 1
            ## more stupid corner cases, assigning 0 to bins with no hits
            for i in range(0,pxbins):
                if int(binlist[i]) == 0:
                    vfp.write("\t\t  " + header + "_temp_lv1_"+\
                    str(i).zfill(2)+"(   0)<='0';\n")
        vfp.write(" end if;\nend process;\n") 

        # all except L0-1 from here just do or reduction...
        # L2 - L7 #

        for level in range(2,nlevels):
            # header stuff for each level
            vfp.write("lookuptable_LV"+str(level)+ " : process(c1)\n")
            vfp.write("begin\n")
            vfp.write(" if c1\'event and c1=\'1\' then\n")

            for header in ["PF","NF"]:
                if header == "PF":
                    binlist = psiglens
                else:
                    binlist = msiglens

                # doing reduction on sigs requires us to know how many sigs
                # at each level in each bin...
                nsigsforlevel = binlist[level-1]     
                # janky way to pick max four sigs to or reduce
                sigset = []
                for bindx, nsig in enumerate(nsigsforlevel):
                    # corner case on empty bins
                    # cheat...
                    if nsig == 0:
                        nsig = 1
                    for i in range(0,nsig):
                        # if we have 4 OR we're at the end of the set
                        # take up to 4 and turn into OR reduction
                        # then write to file
                        sigset.append(i)
                        if ((i+1) % 4 == 0) or (i==nsig-1):
                            print "hit module"
                            vhdlORreduceline = ORreduce(header,sigset,\
                            level-1,bindx)

                            # if A OR B OR C OR D then
                            vfp.write(vhdlORreduceline)

                            # set next sig to 1
                            # corner case on level 8....
                            if level == nlevels-1:
                                vfp.write("\t\t  " + header+"_temp_lv"+\
                                str(level)+"("+\
                                str(bindx).rjust(4) +\
                                ")<=\'1\';\n")

                            else:
                                vfp.write("\t\t  " + header+"_temp_lv"+\
                                str(level)+ "_"+str(bindx).zfill(2) + "("+\
                                str(int(sigset[0]/4)).rjust(4) +\
                                ")<=\'1\';\n")

                            # or 
                            vfp.write("\t\t  else\n")

                            # set next sig to 0
                            # again corner case on lastlev 
                            if level == nlevels-1:
                                vfp.write("\t\t  " + header+"_temp_lv"+\
                                str(level)+ "("+\
                                str(bindx).rjust(4) +\
                                ")<=\'0\';\n")

                            else:
                                vfp.write("\t\t  " + header+"_temp_lv"+\
                                str(level)+ "_"+str(bindx).zfill(2) + "("+\
                                str(int(sigset[0]/4)).rjust(4) +\
                                ")<=\'0\';\n")
                            # wrap up this or reduction
                            vfp.write("\t\t  end if;\n")

                            # clear sigs for next line
                            sigset[:] = []

                            # L8 is basically the same but 
                            # only one sig rather than many bins


                # trailers at each level
                vfp.write(" end if;\n")
                vfp.write("end process;\n")


                
        # tail #
        vfp.write("end rtl;")


      


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "usage: $> python road2vhdl.py <revision number>"
        quit()
    else:
        version = int(sys.argv[1])
        if version not in [460,470]:
            print "please give revision 460 or 470"
            quit()
    main(version)
