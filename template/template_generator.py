#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
# import codecs
from fpdf import FPDF

f= open(sys.argv[1], 'r')

pdf=FPDF()
pdf.add_page()
pdf.set_draw_color(230,225,225);
pdf.set_text_color(230,225,225);
pdf.add_font('fireflysung', '','./fireflysung.ttf', uni=True)
pdf.set_font('fireflysung','',14)

per_page = 0
total_num = 0
while total_num < 6763:
    per_page = 0
    next_page = 0
    pdf.set_fill_color(0,0,0)
    pdf.cell(10,10,"",1,0,'C',1)
    pdf.image('qrcode.png',160,10,30)
    pdf.set_fill_color(255,255,255)
    cnt = 0
    for line in f:
        total_num = total_num + 1
        per_page = per_page + 1
        line = line.rstrip()
        pdf.cell(10,10,line,1,0,'C')
        cnt = cnt + 1
        if(cnt == 13):
            pdf.ln()
            break

    for x in range(0,3):
        cnt = 0
        for line in f:
            total_num = total_num + 1
            per_page = per_page + 1
            line = line.rstrip()
            pdf.cell(10,10,line,1,0,'C')
            cnt = cnt + 1
            if(cnt == 14):
                pdf.ln()
                break
    cnt = 0
    for line in f:
        total_num = total_num + 1
        per_page = per_page + 1
        print per_page
        line = line.rstrip()
        pdf.cell(10,10,line,1,0,'C')
        cnt = cnt + 1
        if(cnt == 18):
            cnt = 0
            pdf.ln()
        if(per_page == 450):
            print "end of page"
            next_page = 1
            break

    if(next_page == 1):
        pdf.set_fill_color(0,0,0)
        pdf.cell(10,10,"",1,0,'C',1)
        pdf.ln()
        print "last char of page"

print total_num
print per_page
pdf.output('tuto1.pdf','F')
