# reads roads.tsv file and generates L1 trigger matrix for the new mapping
# Forhad enacted as of end of 2019 
# generates vhdl for 2-4 nim coincidence trigger.... just an or reduction
# over all hits, but implemented in standard "roads" way, by making all
# combos or all hits on 2 and 4

# L1 just takes an OR reduction on ST2 and ST4 for its half.... then it
# sets two bits according to ST2 or ST4....

# nim raods was a waste haha, shouldn't use road look ups

# spacing from tab expand is dumb but oh well...


# N wuerfel 
# ~ AP AP AP AP ~

nlevels = 9
hodosInS2 = 16
hodosInS4 = 16

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
# [hodo_pattern_word] elements
# returns roadset
def readNIM24roadset(filename):
    L1roadset=[]
    print "reading roadset for " + filename
    with open(filename) as fp:
        roads = fp.readlines() 
        for rawroad in roads: 
            hodo_pattern_word = ''
            rawroad = rawroad.strip().split()
            for i in range(0,2):
                hodo_pattern_word += rawroad[i].zfill(2)
            L1roadset.append(hodo_pattern_word)
    return L1roadset

# returns string line of the form: "if(4 fold coincidence)then"
# thankfully nim logic only has chunks of 4 hits
def hit2firmwareline(mapping, hodohitmax, half,st4):
    firmwarewords = []

    if st4 == True:
        num = "4"
    else:
        num = "2"

    for i in range(hodohitmax-3, hodohitmax+1):
        searchword = "H"+num+half
        # god I hate the corner case of H4 having u and b 
        if st4 == True:
            searchword = searchword + "u"
        searchword = searchword+str(i).zfill(2)
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
            vhdline = vhdline+" OR "
        else:
            vhdline = vhdline+ " )then\n"
    return vhdline

# takes set of up to 4 signals to or reduce
# produces a line like: "if(up to 4 fold OR)then"
def ORreduce(header,signals,level):
    if len(signals) < 1 or len(signals) > 4:
        print "wrong length for ,levelsigset..."
        print signals
        quit()
    line="      if("
    for sigdx,sig in enumerate(signals):
        line = line + header + "temp_lv" + str(level) +\
        "(" + str(sig).rjust(4) + ")='1' "
        if sigdx < len(signals)-1:
            line = line + "OR "
    line = line + ")then\n"
    return line

def main(version):
    if version == 460:
        half = 'T'
        halfname = "top"
    else:
        half = 'B'
        halfname = "bottom"

    vhdlfilename = "nimcode_" + str(version) + ".vhd"
    vhdlheaderfname = "vhdtext/" + str(version) + "header.txt"

    mappingfile = str(version)+"mapping.txt" 
    hodomapping = readL1FirmwareMap(mappingfile)

    roadfname = "nim24-roads.txt"

    roads = readNIM24roadset(roadfname)

    # somethings are nasty hardcoded headers...
    with open(vhdlfilename,"w") as vfp:
        # copy header over
        with open(vhdlheaderfname,"r") as hfp:
            lines = hfp.readlines()
            for line in lines:
                vfp.write(line)

        # now write signals needed
        #//TODO 
        for level in range(1,nlevels-1):
            # stupid like most things its all corner cases
            divisor = 4.0**(level)
                   
            for header in ["ST2","ST4"]:
                if header == "ST2":
                    numhodos = hodosInS2
                else:
                    numhodos = hodosInS4
                siglen = int(math.ceil(float(numhodos)/divisor))
                line = "        signal " + header + "temp_lv" +\
                str(level)
                line = line + ": std_logic_vector" + "(" + \
                str(siglen-1).rjust(4) + \
                " downto 0);\n"
                vfp.write(line)
         # other stupid corner case is last line, always same
        line = "        signal temp_lv8: " + \
        "std_logic_vector(  1 downto 0);\n"
        vfp.write(line)

                      
        # write the mapping that swaps channels around between sampling and
        # the firmware values...
        with open("vhdtext/nimsignalmapping.txt","r") as sigmapfp:
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
        # just set ST2 or 4 high if you get a hit in that plane...
        for header in ["ST2","ST4"]:
            if header == "ST2":
                numhodos = hodosInS2
                st4= False;
            else:
                numhodos = hodosInS4
                st4 = True;
            for hodonum in range(1,numhodos+1):
                if hodonum%4!=0:
                    continue
                else:
                    coincidenceline = hit2firmwareline(hodomapping,hodonum\
                    ,half,st4)
                    signal = header + "temp_lv1" + \
                    "(" + str(int(math.floor(hodonum/4.0))-1)+ ")"
                
                    # write this ugly guy
                    vfp.write(coincidenceline)
                    vfp.write("          "+signal+"<=\'1\';\n")
                    vfp.write("          else\n")
                    vfp.write("          "+signal+"<=\'0\';\n")
                    vfp.write("          end if;\n")
        vfp.write(" end if;\nend process;\n") 

        # all except L0-1 from here just do or reduction...
        # L2 - L7 #
        for level in range(2,nlevels-1):

            # header stuff for each level
            vfp.write("lookuptable_LV"+str(level)+ " : process(c1)\n")
            vfp.write("begin\n")
            vfp.write(" if c1\'event and c1=\'1\' then\n")

            for header in ["ST2","ST4"]:
                if header == "ST2":
                    nsig = int(math.ceil(hodosInS2/(4.0 ** (level-1))))
                else:
                    nsig = int(math.ceil(hodosInS4/(4.0 ** (level-1))))

                sigset=[]  
                for i in range(0,nsig):
                    sigset.append(i)
                    # if we have 4 OR we're at the end of the set
                    # take up to 4 and turn into OR reduction
                    # then write to file
                    if ((i+1) % 4 == 0) or (i==nsig-1):
                        vhdlORreduceline = ORreduce(header,sigset,\
                        level-1)

                        # if A OR B OR C OR D then
                        vfp.write(vhdlORreduceline)

                        # set next sig to 1
                        # corner case on level 8....
                        vfp.write("\t\t  " + header+"temp_lv"+\
                        str(level)+ "("+\
                        str(int(i/4)).rjust(4) +\
                        ")<=\'1\';\n")

                        # or 
                        vfp.write("\t\t  else\n")

                        # set next sig to 0
                        # again corner case on lastlev 
                        vfp.write("\t\t  " + header+"temp_lv"+\
                        str(level)+ "("+\
                        str(int(i/4)).rjust(4) +\
                        ")<=\'0\';\n")
                        # wrap up this or reduction
                        vfp.write("\t\t  end if;\n")

                        # clear sigs for next line
                        sigset[:] = []

            # trailers at each level
            vfp.write(" end if;\n")
            vfp.write("end process;\n")

        #L8
        vfp.write("lookuptable_LV8 : process(c1)\n")
        vfp.write("begin\n  if c1\'event and c1=\'1\' then\n")
        vfp.write("\t\t  if(ST2temp_lv7(   0) = \'1') then\n")
        vfp.write("\t\t    temp_lv8( 0) <= \'1\';\n")
        vfp.write("\t\t    else\n")
        vfp.write("\t\t    temp_lv8( 0) <= \'0\';\n")
        vfp.write("\t\t    end if;\n")
        vfp.write("\t\t  if(ST4temp_lv7(   0) = \'1') then\n")
        vfp.write("\t\t    temp_lv8( 1) <= \'1\';\n")
        vfp.write("\t\t    else\n")
        vfp.write("\t\t    temp_lv8( 1) <= \'0\';\n")
        vfp.write("\t\t    end if;\n")
        vfp.write("  end if;\n")
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
