from PIL import Image, ImageDraw

filename = "snake_head"

im = Image.open(filename + ".png")
n = Image.new('RGB', (16, 16))
d = ImageDraw.Draw(n)

pix = im.load()
size = im.size

data = []

code = "sp[1][{i}][{j}] = 3'b{RGB};\\\n"

with open("code_" + filename + ".txt", 'w') as f:
    for i in range(size[0]):
        tmp = []
        for j in range(size[1]):
            clr = im.getpixel((i, j))
            vg = "{0}{1}{2}".format(int(clr[0] / 128),  # an array representation for pixel
                                    int(clr[1] / 128),  # since clr[*] in range [0, 255],
                                    int(clr[2] / 128))  # clr[*]/128 is either 0 or 1
            tmp.append(vg)
            f.write(code.format(i=i, j=j, RGB=vg))  # Verilog code to initialization
            d.point((i, j), tuple([int(vg[0]) * 255, int(vg[1]) * 255, int(vg[2]) * 255]))  # Visualize final image
        data.append(tmp)

n.save(filename + "_3bit.png")

for el in data:
    print(" ".join(el))
