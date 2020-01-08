def main():
    with open("nim24-roads.txt",'w+') as fp:
        for i in range(1,17):
            for j in range(1,17):
                fp.write(str("{}\t{}\n").format(i,j))

#python is dumb
if __name__ == "__main__":
    main()

