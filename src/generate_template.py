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
DEFAULT_CELL_SIZE = 20
DEFAULT_FONT_SIZE = 14

# set margins
PAPER_LEFT_MARGIN = 15
PAPER_TOP_MARGIN = 10

# set the margin of the CELL_INNER_MARGIN cell
CELL_INNER_MARGIN = 3

# set the position of the sub
subx = 6
suby = 2

# NOTE THE VALS 180, 260 HERE MAYBE SYSTEM DEPENDENT
PAPER_LENGTH = 180
PAPER_WIDTH = 260


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


def fill_one_page(pdf, chars, total_num, page_num, cell_size, num_of_cols,
                  num_of_rows, font_name, font_size, draw_sub):

    cols_of_first_row = num_of_cols - 3
    cols_of_second_row = num_of_cols - 2
    cols_of_last_row = num_of_cols - 2

    qrstr = str(cell_size) + " "
    for char in chars:
        qrstr += char

    qrname = id_generator(10) + ".png"

    draw_qrcode(qrstr, qrname)

    # first cell is solid black location indicator
    pdf.set_fill_color(0, 0, 0)
    pdf.cell(cell_size, cell_size, "", 0, 0, 'C')

    # draw a finder pattern on the top left
    pdf.image('config/finder.png', PAPER_LEFT_MARGIN + CELL_INNER_MARGIN,
              PAPER_TOP_MARGIN + CELL_INNER_MARGIN,
              cell_size - 2 * CELL_INNER_MARGIN,
              cell_size - 2 * CELL_INNER_MARGIN)

    # draw a finder pattern on the bottom right
    pdf.image(
        'config/finder.png',
        PAPER_LEFT_MARGIN + (num_of_cols - 1) * cell_size + CELL_INNER_MARGIN,
        PAPER_TOP_MARGIN + (num_of_rows - 1) * cell_size + CELL_INNER_MARGIN,
        cell_size - 2 * CELL_INNER_MARGIN, cell_size - 2 * CELL_INNER_MARGIN)

    # draw a black square at the bottom left
    pdf.image(
        'config/finder.png', PAPER_LEFT_MARGIN + CELL_INNER_MARGIN,
        PAPER_TOP_MARGIN + (num_of_rows - 1) * cell_size + CELL_INNER_MARGIN,
        cell_size - 2 * CELL_INNER_MARGIN, cell_size - 2 * CELL_INNER_MARGIN)

    # draw a qrcode graph on the top right
    pdf.image(
        qrname,
        PAPER_LEFT_MARGIN + (num_of_cols - 2) * cell_size + CELL_INNER_MARGIN,
        PAPER_TOP_MARGIN + CELL_INNER_MARGIN,
        2 * cell_size - CELL_INNER_MARGIN, 2 * cell_size - CELL_INNER_MARGIN)

    os.remove(qrname)

    pdf.set_fill_color(255, 255, 255)

    line_num = 1
    processed_chars_num = 0
    for char in chars:

        total_num = total_num + 1

        pdf.cell(cell_size, cell_size, char, 0, 0, 'C')

        factor = 0
        if line_num == 1:
            factor = 1

        # draw the square
        x1 = PAPER_LEFT_MARGIN + cell_size * (processed_chars_num +
                                              factor) + CELL_INNER_MARGIN
        y1 = PAPER_TOP_MARGIN + cell_size * (line_num - 1) + CELL_INNER_MARGIN
        x2 = x1 + cell_size - 2 * CELL_INNER_MARGIN
        y2 = y1 + cell_size - 2 * CELL_INNER_MARGIN
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
            pdf.set_font(font_name, '', font_size)

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
    px = PAPER_LEFT_MARGIN + num_of_cols * cell_size
    py = PAPER_TOP_MARGIN + num_of_rows * cell_size + 4
    pdf.text(px, py, str(page_num))
    pdf.set_font(font_name, '', font_size)

    # draw end of page location indicator
    pdf.set_fill_color(0, 0, 0)
    pdf.cell(cell_size, cell_size, "", 0, 0, 'C')
    pdf.ln()


def main():
    #******************* COMMAND LINE OPTIONS *******************************#
    parser = argparse.ArgumentParser(
        description="generate template based on gb2312")
    parser.add_argument("filename",
                        help="input file containing the characters")
    parser.add_argument("-cs",
                        "--cell_size",
                        type=int,
                        default=DEFAULT_CELL_SIZE,
                        help="the size of cell, default is 20")
    parser.add_argument("-f",
                        "--font",
                        default="config/fireflysung.ttf",
                        help="the Chinese font used, default is fireflysung")
    parser.add_argument("-fs",
                        "--font_size",
                        type=int,
                        help="the font size, default is based on cell size")
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

    cell_size = args.cell_size
    num_of_cols = PAPER_LENGTH // cell_size
    num_of_rows = PAPER_WIDTH // cell_size
    num_of_chars_per_page = num_of_cols * num_of_rows - 7

    font_filename = args.font
    font_name = os.path.splitext(os.path.basename(font_filename))[0]
    if args.font_size:
        font_size = args.font_size
    else:
        font_size = int(cell_size / DEFAULT_CELL_SIZE * DEFAULT_FONT_SIZE)

    if args.output:
        output_file = args.output
    else:
        output_file = str(cell_size) + "_" + str(cell_size) + "_template.pdf"

    draw_sub = not args.remove_subscript

    if args.verbose:
        print(">>>Begin processing file ", args.filename)
        print("cell size: ", cell_size)
        print("num of cols per page: ", num_of_cols)
        print("num of rows per page: ", num_of_rows)
        print("chars per page: ", num_of_chars_per_page)
        print("font file name: ", font_filename)
        print("font name: ", font_name)
        print("font size: ", font_size)
        print("output file name: ", output_file)
        #******************** END COMMAND LINE OPTIONS **************************#

    # open the input file
    with open(args.filename, 'r') as file:
        lines = file.read().splitlines()
    chars_of_template = "".join(lines)

    # global setting
    pdf = FPDF()
    pdf.set_author('Leeyukuang')
    pdf.set_title('gb2312 Chinese font set template cell size ' +
                  str(cell_size))

    pdf.set_margins(PAPER_LEFT_MARGIN, PAPER_TOP_MARGIN)
    pdf.add_page()

    pdf.set_draw_color(230, 225, 225)
    pdf.set_text_color(200, 200, 200)
    pdf.add_font(font_name, '', font_filename, uni=True)
    pdf.set_font(font_name, '', font_size)

    chars_of_this_page = []
    cnt = 0
    total_num = 0
    page_num = 0

    for char in chars_of_template:

        cnt += 1
        # collect chars from input file until a page is full
        if cnt <= num_of_chars_per_page:
            chars_of_this_page.append(char)

        # page is full now
        if cnt == num_of_chars_per_page:
            fill_one_page(pdf, chars_of_this_page, total_num, page_num,
                          cell_size, num_of_cols, num_of_rows, font_name,
                          font_size, draw_sub)

            if args.verbose:
                print("Finished processing page: ", page_num)

            total_num += num_of_chars_per_page
            page_num += 1
            cnt = 0
            chars_of_this_page = []

    # handle those chars not enough for entire page
    if len(chars_of_this_page):
        fill_one_page(pdf, chars_of_this_page, total_num, page_num, cell_size,
                      num_of_cols, num_of_rows, font_name, font_size, draw_sub)

    pdf.output(output_file, 'F')

    if args.verbose:
        print(">>>Finish processing file ", args.filename)


if __name__ == "__main__":
    main()
