import png

tile_width = 4
tile_height = 8

img = png.Reader(filename="edventure.png")
(width, height, rows, info) = img.read()
row_list = list(rows)

pixels = list()
for row in row_list:
    pixels.append(list(row))


f = open("data.s", "w")
char = 0
f.write("\t.local charset\n")
f.write(f"\t; char {char}\n")
f.write("\t.byte 0, 0, 0, 0, 0, 0, 0, 0\n")
char += 1
f.write(f"\t; char {char}\n")
f.write("\t.byte 0, 0, 0, 0, 0, 0, 0, 0\n")
char += 1
for row in range(int(height / tile_height)):
    for col in range(int(width / tile_width)):
        f.write(f"\t; char {char}\n")
        for y in range(row * tile_height, row * tile_height + tile_height):
            f.write("\tdta %")
            for x in range(col * tile_width, col * tile_width + tile_width):
                code = "00"
                if pixels[y][x] == 1:
                    code = "01"
                elif pixels[y][x] == 2:
                    code = "10"
                elif pixels[y][x] == 3 or pixels[y][x] == 4:
                    code = "11"
                f.write(code)
            f.write("\n")
        char += 1  
f.write("\t.endl\n")
f.close()