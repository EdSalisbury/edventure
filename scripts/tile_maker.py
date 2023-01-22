#!/bin/env python3
# PNG -> ASM converter
# Ed Salisbury
# Last Modified: 2022-01-22
#
# Install pypng package to use
#
# To prepare image, change image mode to indexed, and choose custom palette with the 5 colors from your image
# Save as (NOT EXPORT) .PNG with no transparency

import png
import argparse
import os

tile_width = 4
tile_height = 8

parser = argparse.ArgumentParser(description='Generate asm files from png tilesets.')
parser.add_argument('image_file')
args = parser.parse_args()

img = png.Reader(filename=args.image_file)
(width, height, rows, info) = img.read()
row_list = list(rows)

pixels = list()
for row in row_list:
    pixels.append(list(row))

# Blue, yellow, red, white, black
colors = ["11", "11", "10", "01", "00"]

basename = os.path.basename(args.image_file).rsplit('.', 1)[0]
output_filename = basename + ".asm"

f = open(output_filename, "w")
f.write("\torg " + basename)
char = 0
for row in range(int(height / tile_height)):
    for col in range(int(width / tile_width)):
        f.write(f"\t; char {char}\n")
        for y in range(row * tile_height, row * tile_height + tile_height):
            f.write("\t.byte %")
            for x in range(col * tile_width, col * tile_width + tile_width):
                code = colors[pixels[y][x]]
                f.write(code)
            f.write("\n")
        char += 1
f.close()