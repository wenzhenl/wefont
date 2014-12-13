# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

def draw_qrcode(qrstr, qrname):
    from qrcode import *

    qr = QRCode(version=20, error_correction=ERROR_CORRECT_L)
    qr.add_data(qrstr)

    # Generate the QRCode itself
    qr.make() 

    # im contains a PIL.Image.Image object
    im = qr.make_image()

    # To save it
    im.save(qrname)


def fill_one_page():

    fn = args.filename[:args.filename.find(".")] 
    qrname = "tmp_" + str(cnt) + fn + ".png"
    im.save(qrname)

    # first cell is solid black location indicator
    pdf.set_fill_color(0,0,0)
    pdf.cell(cell_size,cell_size,"",0,0,'C')

    # draw a black square at the first cell
    pdf.image('black.png', margin_left + inner, 
            margin_top + inner, cell_size - 2*inner, cell_size - 2*inner)

    # draw a qrcode graph on each page
    pdf.image(qrname, length-2*cell_size+2*inner, margin_top,
            2*cell_size-2*inner)

    pdf.set_fill_color(255,255,255)

    line_num = 1
    processed_chars_num = 0
    for char in chars_of_this_page:

        total_num = total_num + 1

        pdf.cell(cell_size,cell_size,char,0,0,'C')

        # draw the square
        x1 = margin_left + cell_size * (cnt + 1) + inner
        y1 = margin_top + inner
        x2 = x1 + cell_size - 2 * inner
        y2 = y1 + cell_size - 2 * inner
        pdf.line(x1, y1, x2, y1)
        pdf.line(x1, y1, x1, y2)
        pdf.line(x1, y2, x2, y2)
        pdf.line(x2, y1, x2, y2)

        # draw the sub #
        # reset font size to smaller
        pdf.set_font(font_name,'',8)
        sx = x2 - subx
        sy = y2 - suby
        pdf.text(sx, sy, str(total_num))
        # restore font size
        pdf.set_font(font_name,'',14)

        processed_chars_num = processed_chars_num + 1

        if line_num == 1 and  processed_chars_num == cols_of_first_row:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0
        elif line_num == 2 and processed_chars_num == cols_of_second_row:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0
        elif processed_chars_num == num_of_cols:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0

    # draw end of page location indicator
    pdf.set_fill_color(0,0,0)
    pdf.cell(cell_size,cell_size,"",0,0,'C')
    pdf.ln()


from fpdf import FPDF
import argparse
from qrcode import *


cell_size = 20
font_name = "Songti"
font_filename = "Songti.ttc"

#******************* COMMAND LINE OPTIONS *******************************#
parser = argparse.ArgumentParser(description="generate template based on gb2312")
parser.add_argument("filename", help="input file containing the characters")
parser.add_argument("-s", "--cellsize", type=int, 
                    help="the size of cell, default is 20")
parser.add_argument("-f", "--font", 
                    help="the Chinese font used, default is Songti")
parser.add_argument("-o", "--output",
                    help="output pdf file name")
parser.add_argument("-v", "--verbose", action="store_true")
args = parser.parse_args()

if args.cellsize:
    cell_size = args.cellsize

if args.font:
    font_name = args.font[:args.font.find(".")]
    font_filename = args.font
    if args.verbose:
        print "Font: ", font_name

if args.output:
    output_file = args.output
else:
    output_file = str(cell_size) + "_" + str(cell_size) + "_template.pdf"
if args.verbose:
    print ">>>Begin processing file ", args.filename 
#******************** END COMMAND LINE OPTIONS **************************#

# open the input file
f = open(args.filename, 'r')

# global setting
pdf=FPDF()
pdf.set_author('Leeyukuang')
pdf.set_title('gb2312 Chinese font set template cellsize ' + str(cell_size))

margin_left = 15
margin_top = 10
pdf.set_margins(margin_left, margin_top)
pdf.add_page()

pdf.set_draw_color(230,225,225);
pdf.set_text_color(200,200,200);
pdf.add_font(font_name, '', font_filename, uni=True)
pdf.set_font(font_name, '', 14)

# set the margin of the inner cell
inner = 3

# set the position of the sub #
subx = 6
suby = 2


# NOTE THE VALS 180, 260 HERE MAYBE SYSTEM DEPENDENT
length = 180
width = 260
num_of_cols = length / cell_size
num_of_rows = width / cell_size
cols_of_first_row = num_of_cols - 3
cols_of_second_row = num_of_cols -2
cols_of_last_row = num_of_cols -1
num_of_chars_per_page = num_of_cols * num_of_rows - 6

chars_of_this_page = []
cnt = 0
total_num = 0
qrstr = str(cell_size) + " "

for line in f:
    char = line.rstrip()

    if args.verbose:
        print "cnt: ", cnt

    # collect chars from input file until a page is full
    if cnt < num_of_chars_per_page:
        chars_of_this_page.append(char)
        qrstr = qrstr + char
        cnt = cnt + 1

    # page is full now
    else:
        qr = QRCode(version=20, error_correction=ERROR_CORRECT_L)
        qr.add_data(qrstr)
        qr.make() # Generate the QRCode itself

        # im contains a PIL.Image.Image object
        im = qr.make_image()

        # To save it
        fn = args.filename[:args.filename.find(".")] 
        qrname = "tmp_" + str(cnt) + fn + ".png"
        im.save(qrname)

        # first cell is solid black location indicator
        pdf.set_fill_color(0,0,0)
        pdf.cell(cell_size,cell_size,"",0,0,'C')

        # draw a black square at the first cell
        pdf.image('black.png', margin_left + inner, 
                  margin_top + inner, cell_size - 2*inner, cell_size - 2*inner)

        # draw a qrcode graph on each page
        pdf.image(qrname, length-2*cell_size+2*inner, margin_top,
                  2*cell_size-2*inner)

        pdf.set_fill_color(255,255,255)

        line_num = 1
        processed_chars_num = 0
        for char in chars_of_this_page:

            total_num = total_num + 1

            pdf.cell(cell_size,cell_size,char,0,0,'C')

            # draw the square
            x1 = margin_left + cell_size * (cnt + 1) + inner
            y1 = margin_top + inner
            x2 = x1 + cell_size - 2 * inner
            y2 = y1 + cell_size - 2 * inner
            pdf.line(x1, y1, x2, y1)
            pdf.line(x1, y1, x1, y2)
            pdf.line(x1, y2, x2, y2)
            pdf.line(x2, y1, x2, y2)

            # draw the sub #
            # reset font size to smaller
            pdf.set_font(font_name,'',8)
            sx = x2 - subx
            sy = y2 - suby
            pdf.text(sx, sy, str(total_num))
            # restore font size
            pdf.set_font(font_name,'',14)

            processed_chars_num = processed_chars_num + 1

            if line_num == 1 and  processed_chars_num == cols_of_first_row:
                pdf.ln()
                line_num = line_num + 1
                processed_chars_num = 0
            elif line_num == 2 and processed_chars_num == cols_of_second_row:
                pdf.ln()
                line_num = line_num + 1
                processed_chars_num = 0
            elif processed_chars_num == num_of_cols:
                pdf.ln()
                line_num = line_num + 1
                processed_chars_num = 0

        # draw end of page location indicator
        pdf.set_fill_color(0,0,0)
        pdf.cell(cell_size,cell_size,"",0,0,'C')
        pdf.ln()

        cnt = 0
        chars_of_this_page = []
        qrstr = str(cell_size) + " "

# handle those chars not enough for entire page

if args.verbose:
    print ">>>Finish processing file ", args.filename 

pdf.output(output_file, 'F')


