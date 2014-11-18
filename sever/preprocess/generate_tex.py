#!/usr/bin/python

import sys

f = open('show_eps.tex', 'w')

f.write('\documentclass[12pt,notitlepage]{report}\n')
f.write('\pagestyle{plain}\n')
f.write('\usepackage[top=30mm, bottom=30mm, paperwidth=170mm, paperheight=220mm]{geometry}\n')
f.write('\usepackage{graphicx}\n')
f.write('\usepackage{subfigure}\n')
f.write('\\begin{document}\n')
i = 0
num_per_line = 5
while i < len(sys.argv)-1: 
    f.write('\\begin{figure}[ht]\n')
    f.write('\centering\n')
    f.write('\subfigure{\n')
    f.write('\includegraphics[scale=.5]{%s}\n' % sys.argv[i+1])
    f.write('}\n')
    for j in range(num_per_line-1):
        if i+j+2 < len(sys.argv):
            f.write('\subfigure{\n')
            f.write('\includegraphics[scale=.5]{%s}\n' % sys.argv[i+j+2])
            f.write('}\n')
    f.write('\end{figure}\n')
    i = i + num_per_line
f.write('\end{document}\n')
f.close()
