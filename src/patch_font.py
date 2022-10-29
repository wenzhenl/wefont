#!/usr/bin/python

import sys
import fontforge
import string
import argparse


def patch_font(old_font_file, patched_glyph_file, family_name):

    f = open("config/unicode_to_gb2312.txt", 'r')

    dic = {}
    for line in f:
        line = line.rstrip()
        dic[line[10:14].lower()] = line[2:6].lower()

    font = fontforge.open(old_font_file)
    if family_name and family_name == font.familyname:
        raise Exception(
            "Patched font family name must be different if you want to change it, you can keep it empty to keep the original family name"
        )
    if family_name:
        font.familyname = family_name
        font.fontname = family_name
        font.fullname = family_name

    f2 = open(patched_glyph_file, 'r')
    for line in f2:
        line = line.rstrip()
        font['uni' + line[3:-4].upper()].clear()
        font['uni' + line[3:-4].upper()].importOutlines(line)
    if family_name:
        font.generate(family_name + '.ttf')
    else:
        font.generate(font.familyname + "_patched.ttf")


if __name__ == "__main__":
    #******************* COMMAND LINE OPTIONS *******************************#
    parser = argparse.ArgumentParser(
        description="patch existing font with new glyphs from template")
    parser.add_argument("font_file", help="path of the existing font")
    parser.add_argument(
        "patched_glyph_file",
        help="path of the file with the list of patched glyphs")
    parser.add_argument(
        "-fn",
        "--family_name",
        help=
        "the family name of the patched font, keep the same as old font if not provided"
    )
    parser.add_argument("-v",
                        "--verbose",
                        action="store_true",
                        help="print more info")
    args = parser.parse_args()
    patch_font(args.font_file, args.patched_glyph_file, args.family_name)
