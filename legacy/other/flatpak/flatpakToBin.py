import os 
from subprocess import call
script = "flatpak list >> flatpakList.txt"
call(script, shell=True)
flatdic = []
with open('flatpakList.txt') as fpL:
    for line in fpL:
        flatdic.append(line.split('\t'))

print(flatdic.index(1))
