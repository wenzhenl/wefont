#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
# import codecs
from fpdf import FPDF

f= open(sys.argv[1], 'r')

pdf=FPDF()
pdf.set_author('Leeyukuang')
pdf.set_title('gb2312 Chinese font set template')
pdf.set_margins(15,10)
pdf.add_page()
pdf.set_draw_color(230,225,225);
# pdf.set_text_color(230,225,225);

pdf.set_text_color(200,200,200);
pdf.add_font('fireflysung', '','./fireflysung.ttf', uni=True)
pdf.set_font('fireflysung','',14)

# set the size of each cell
cell_size = 20

# set the margin of the inner cell
inner = 3

# set the position of the sub #
subx = 6
suby = 2

# limit of total num of char
limit_total_num = 2500

# count the num of char of a page
per_page = 0

# count the num of char in total
total_num = 0

# page num
page = 0

while total_num < limit_total_num:
    per_page = 0
    next_page = 0

    # first cell is solid black location indicator
    pdf.set_fill_color(0,0,0)
    pdf.cell(cell_size,cell_size,"",1,0,'C',1)

    # draw a qrcode graph on each page
    pdf.image('qrcode.png',165,10,30)

    pdf.set_fill_color(255,255,255)
    cnt = 0
    for line in f:
        total_num = total_num + 1
        per_page = per_page + 1
        line = line.rstrip()
        pdf.cell(cell_size,cell_size,line,1,0,'C')
        # left margin is 15 
        # top margin is 10
        x1 = 15 + cell_size * (cnt + 1) + inner
        y1 = 10 + inner
        x2 = x1 + cell_size - 2 * inner
        y2 = y1 + cell_size - 2 * inner
        pdf.line(x1, y1, x2, y1)
        pdf.line(x1, y1, x1, y2)
        pdf.line(x1, y2, x2, y2)
        pdf.line(x2, y1, x2, y2)

        # draw the sub #
        # reset font size to smaller
        pdf.set_font('fireflysung','',8)
        sx = x2 - subx
        sy = y2 - suby
        pdf.text(sx, sy, str(total_num))
        # restore font size
        pdf.set_font('fireflysung','',14)

        cnt = cnt + 1
        if(cnt == 6):
            pdf.ln()
            break

    for x in range(0,1):
        cnt = 0
        for line in f:
            total_num = total_num + 1
            per_page = per_page + 1
            line = line.rstrip()
            pdf.cell(cell_size,cell_size,line,1,0,'C')
            # left margin is 15 
            # top margin is 10
            x1 = 15 + cell_size * cnt + inner
            y1 = 10 + cell_size * ( x + 1 ) + inner
            x2 = x1 + cell_size - 2 * inner
            y2 = y1 + cell_size - 2 * inner
            pdf.line(x1, y1, x2, y1)
            pdf.line(x1, y1, x1, y2)
            pdf.line(x1, y2, x2, y2)
            pdf.line(x2, y1, x2, y2)

            # draw the sub #
            # reset font size to smaller
            pdf.set_font('fireflysung','',8)
            sx = x2 - subx
            sy = y2 - suby
            pdf.text(sx, sy, str(total_num))
            # restore font size
            pdf.set_font('fireflysung','',14)

            cnt = cnt + 1
            if(cnt == 7):
                pdf.ln()
                break
    cnt = 0
    x = 1
    for line in f:
        total_num = total_num + 1
        per_page = per_page + 1
        print per_page
        line = line.rstrip()
        pdf.cell(cell_size,cell_size,line,1,0,'C')
        # left margin is 15 
        # top margin is 10
        x1 = 15 + cell_size * cnt + inner
        y1 = 10 + cell_size * ( x + 1 ) + inner
        x2 = x1 + cell_size - 2 * inner
        y2 = y1 + cell_size - 2 * inner
        pdf.line(x1, y1, x2, y1)
        pdf.line(x1, y1, x1, y2)
        pdf.line(x1, y2, x2, y2)
        pdf.line(x2, y1, x2, y2)

        # draw the sub #
        # reset font size to smaller
        pdf.set_font('fireflysung','',8)
        sx = x2 - subx
        sy = y2 - suby
        pdf.text(sx, sy, str(total_num))
        # restore font size
        pdf.set_font('fireflysung','',14)

        cnt = cnt + 1
        if(cnt == 9):
            cnt = 0
            x = x + 1
            pdf.ln()
        if(per_page == 111):
            print "end of page"
            next_page = 1
            break

    if(next_page == 1 or per_page < 111):
        while(per_page < 111):
            per_page = per_page + 1
            pdf.cell(cell_size,cell_size,"",1,0,'C')
            cnt = cnt + 1
            if(cnt == 9):
                cnt = 0
                pdf.ln()
        page = page + 1
        # draw page num
        pdf.set_font('fireflysung','',10)
        px = x2 + inner + cell_size - 5
        py = y2 + inner + 4
        pdf.text(px, py, str(page))
        pdf.set_font('fireflysung','',14)

        # draw end of page location indicator
        pdf.set_fill_color(0,0,0)
        pdf.cell(cell_size,cell_size,"",1,0,'C',1)
        pdf.ln()
        print "last char of page"


print total_num
print per_page
pdf.output('tuto1.pdf','F')
