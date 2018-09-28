import sys
import numpy as np
import matplotlib.pyplot as plt
import time
import re
from fractions import Fraction

def main():
    file_name = sys.argv[1] 
    output = ""
    
    doc = open(file_name,"r")
    scale_found = False
    first_box_found = False
    for line in doc:
        if line.find("begin{picture}")!=-1:
            out = re.sub('[^0-9,.,,]', '', line).split(",")
            max_y = (float(out[1]));
            scale_found = True

        if first_box_found == True and line.find("\\put(")!=-1:
            y_axis = float(line.split("){")[0].split(",")[1])
            out = max_y - y_axis
            line = line.replace(str(y_axis),str(out))

        if line.find("\\put(") !=-1 and first_box_found == False:
            first_box_found = True

        if line.find("page=2") !=-1:
            line = line.replace("page=2","page=1") 
            
        output = output+line

    outfile = open(file_name,"w")
    outfile.write(output)


if __name__ == '__main__':
  main()
