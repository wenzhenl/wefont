# -*- coding: utf8 -*-
__author__ = "Wenzheng Li"

#////////////////////////////////////////////////////////
#////////////////// VERSION 0.2 /////////////////////////
#//////////////// WITH PAGE FINDERS ONLY ////////////////
#//// WORKS WITH SCANNED TEMPLATE, NOT PERFECT WITH /////
# /// TEMPLATE TAKEN WITH CAMERA ////////////////////////
#////////////////////////////////////////////////////////

from fpdf import FPDF
from qrcode import *
import argparse
import os
import warnings
warnings.filterwarnings("ignore")

# GLOBAL VARIABLES
cell_size = 20
font_name = "fireflysung"
font_filename = "config/fireflysung.ttf"

# set margins
margin_left = 15
margin_top = 10

# set the margin of the inner cell
inner = 3

# set the position of the sub #
subx = 6
suby = 2

# NOTE THE VALS 180, 260 HERE MAYBE SYSTEM DEPENDENT
length = 180
width = 260
num_of_cols = length // cell_size
num_of_rows = width // cell_size
cols_of_first_row = num_of_cols - 3
cols_of_second_row = num_of_cols - 2
cols_of_last_row = num_of_cols - 2
num_of_chars_per_page = num_of_cols * num_of_rows - 7


def id_generator(size):
    import string
    import random

    chars = string.ascii_uppercase + string.digits
    return ''.join(random.choice(chars) for _ in range(size))


def draw_qrcode(qrstr, qrname):

    qr = QRCode(version=10, error_correction=ERROR_CORRECT_L)
    qr.add_data(qrstr)

    # Generate the QRCode itself
    qr.make()

    # im contains a PIL.Image.Image object
    im = qr.make_image()

    # To save it
    im.save(qrname)


def fill_one_page(pdf, chars, total_num, page_num, draw_sub=False):

    qrstr = str(cell_size) + " "
    for char in chars:
        qrstr += char

    qrname = id_generator(10) + ".png"

    draw_qrcode(qrstr, qrname)

    # first cell is solid black location indicator
    pdf.set_fill_color(0, 0, 0)
    pdf.cell(cell_size, cell_size, "", 0, 0, 'C')

    # draw a finder pattern on the top left
    pdf.image('config/finder.png', margin_left + inner, margin_top + inner,
              cell_size - 2 * inner, cell_size - 2 * inner)

    # draw a finder pattern on the bottom right
    pdf.image('config/finder.png',
              margin_left + (num_of_cols - 1) * cell_size + inner,
              margin_top + (num_of_rows - 1) * cell_size + inner,
              cell_size - 2 * inner, cell_size - 2 * inner)

    # draw a black square at the bottom left
    pdf.image('config/finder.png', margin_left + inner,
              margin_top + (num_of_rows - 1) * cell_size + inner,
              cell_size - 2 * inner, cell_size - 2 * inner)

    # draw a qrcode graph on the top right
    pdf.image(qrname, margin_left + (num_of_cols - 2) * cell_size + inner,
              margin_top + inner, 2 * cell_size - inner, 2 * cell_size - inner)

    os.remove(qrname)

    pdf.set_fill_color(255, 255, 255)

    line_num = 1
    processed_chars_num = 0
    for char in chars_of_this_page:

        total_num = total_num + 1

        pdf.cell(cell_size, cell_size, char, 0, 0, 'C')

        factor = 0
        if line_num == 1:
            factor = 1

        # draw the square
        x1 = margin_left + cell_size * (processed_chars_num + factor) + inner
        y1 = margin_top + cell_size * (line_num - 1) + inner
        x2 = x1 + cell_size - 2 * inner
        y2 = y1 + cell_size - 2 * inner
        pdf.line(x1, y1, x2, y1)
        pdf.line(x1, y1, x1, y2)
        pdf.line(x1, y2, x2, y2)
        pdf.line(x2, y1, x2, y2)

        if draw_sub:
            # draw the sub #
            # reset font size to smaller
            pdf.set_font(font_name, '', 8)
            sx = x2 - subx
            sy = y2 - suby
            pdf.text(sx, sy, str(total_num))
            # restore font size
            pdf.set_font(font_name, '', 14)

        processed_chars_num = processed_chars_num + 1

        if line_num == 1 and processed_chars_num == cols_of_first_row:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0
        elif line_num == 2 and processed_chars_num == cols_of_second_row:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0
        elif line_num == num_of_rows - 1 and processed_chars_num == num_of_cols:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 1
            pdf.cell(cell_size, cell_size, '', 0, 0, 'C')
        elif processed_chars_num == num_of_cols:
            pdf.ln()
            line_num = line_num + 1
            processed_chars_num = 0

    page_num = page_num + 1
    # draw page_num num
    pdf.set_font(font_name, '', 10)
    px = margin_left + num_of_cols * cell_size
    py = margin_top + num_of_rows * cell_size + 4
    pdf.text(px, py, str(page_num))
    pdf.set_font(font_name, '', 14)

    # draw end of page location indicator
    pdf.set_fill_color(0, 0, 0)
    pdf.cell(cell_size, cell_size, "", 0, 0, 'C')
    pdf.ln()


#******************* COMMAND LINE OPTIONS *******************************#
parser = argparse.ArgumentParser(
    description="generate template based on gb2312")
parser.add_argument("filename", help="input file containing the characters")
parser.add_argument("-cs",
                    "--cell_size",
                    type=int,
                    help="the size of cell, default is 20")
parser.add_argument("-f",
                    "--font",
                    help="the Chinese font used, default is fireflysung")
parser.add_argument("-o", "--output", help="output pdf file name")
parser.add_argument("-rs",
                    "--remove_subscript",
                    action="store_true",
                    help="remove the subscript number of cell")
parser.add_argument("-v",
                    "--verbose",
                    action="store_true",
                    help="print more info")
args = parser.parse_args()

if args.cell_size:
    cell_size = args.cell_size
    num_of_cols = length // cell_size
    num_of_rows = width // cell_size
    cols_of_first_row = num_of_cols - 3
    cols_of_second_row = num_of_cols - 2
    cols_of_last_row = num_of_cols - 2
    num_of_chars_per_page = num_of_cols * num_of_rows - 7

if args.font:
    font_name = args.font[:args.font.find(".")]
    font_filename = args.font
    if args.verbose:
        print("Font: ", font_name)

if args.output:
    output_file = args.output
else:
    output_file = str(cell_size) + "_" + str(cell_size) + "_template.pdf"

draw_sub = not args.remove_subscript

if args.verbose:
    print(">>>Begin processing file ", args.filename)
    print("cell_size: ", cell_size)
    print("num_of_cols: ", num_of_cols)
    print("num_of_rows: ", num_of_rows)
    print("chars_per_page: ", num_of_chars_per_page)
#******************** END COMMAND LINE OPTIONS **************************#

# open the input file
f = open(args.filename, 'r')

# global setting
pdf = FPDF()
pdf.set_author('Leeyukuang')
pdf.set_title('gb2312 Chinese font set template cell size ' + str(cell_size))

pdf.set_margins(margin_left, margin_top)
pdf.add_page()

pdf.set_draw_color(230, 225, 225)
pdf.set_text_color(200, 200, 200)
pdf.add_font(font_name, '', font_filename, uni=True)
pdf.set_font(font_name, '', 14)

chars_of_this_page = []
cnt = 0
total_num = 0
page_num = 0

for line in f:
    char = line.rstrip()

    cnt += 1
    # collect chars from input file until a page is full
    if cnt <= num_of_chars_per_page:
        chars_of_this_page.append(char)

    # page is full now
    if cnt == num_of_chars_per_page:
        fill_one_page(pdf, chars_of_this_page, total_num, page_num, draw_sub)

        if args.verbose:
            print("Finished processing page: ", page_num)

        total_num += num_of_chars_per_page
        page_num += 1
        cnt = 0
        chars_of_this_page = []

# handle those chars not enough for entire page
if len(chars_of_this_page):
    fill_one_page(pdf, chars_of_this_page, total_num, page_num, draw_sub)

pdf.output(output_file, 'F')

if args.verbose:
    print(">>>Finish processing file ", args.filename)
