from PIL import Image, ImageDraw

im = Image.open("snake_head_3bit.png")
n = Image.new('RGBA', (16, 16))
d = ImageDraw.Draw(n)

pix = im.load()
size = im.size

data = []

code = "sp[1][{i}][{j}] = 3'b{RGB};\n"

with open("snake_head.txt", 'w') as f:
    for i in range(size[0]):
        tmp = []
        for j in range(size[1]):
            clr = im.getpixel((i, j))
            d.point((i, j), fill=(clr[0], clr[1], clr[2]))
            if clr[-1] == 0:
                tmp.append("000")
            else:
                vg = "{0}{1}{2}".format(int(clr[0] / 128),
                                        int(clr[1] / 128),
                                        int(clr[2] / 128))
                tmp.append(vg)
                f.write(code.format(i=i, j=j, RGB=vg))
                d.point((i,j), tuple([int(vg[0]) * 255, int(vg[1]) * 255, int(vg[2]) * 255]))
                # print(code.format(i=i, j=j, RGB=vg), end='')
        data.append(tmp)

# print(data)

#n.show()
n.save("snake_head_3bit_1.png")

for el in data:
    print(" ".join(el))
