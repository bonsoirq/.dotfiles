#!/usr/bin/env python


class Color:
    def __init__(self, red, green, blue):
        self.red = red
        self.green = green
        self.blue = blue

    @staticmethod
    def from_hex(hex_color: str) -> Color:
        hex_color = hex_color.lstrip("#")

        if len(hex_color) == 3:
            hex_color = "".join(c * 2 for c in hex_color)

        if len(hex_color) != 6:
            raise ValueError(f"Invalid hex color: {hex_color}")

        red = int(hex_color[0:2], 16)
        green = int(hex_color[2:4], 16)
        blue = int(hex_color[4:6], 16)

        return Color(red, green, blue)

    def to_hexstr(self):
        return f"#{self.to_purehexstr()}"

    def to_purehexstr(self):
        red_hex = format(self.red, "02x")
        green_hex = format(self.green, "02x")
        blue_hex = format(self.blue, "02x")

        return f"{red_hex}{green_hex}{blue_hex}"

    def to_rgbstr(self):
        return f"{self.red},{self.green},{self.blue}"


petal = Color.from_hex("#fec5bb")
coral = Color.from_hex("#ff8fa3")
blush = Color.from_hex("#ffcbf2")
amethyst = Color.from_hex("#7848c7")
crimson = Color.from_hex("#db4d50")
garnet = Color.from_hex("#a22246")
apricot = Color.from_hex("#f9844a")
amber = Color.from_hex("#fccc5d")
verdant = Color.from_hex("#9fdf82")
lagoon = Color.from_hex("#9cefd8")
aether = Color.from_hex("#7ccae1")
cerulean = Color.from_hex("#627fff")
azure = Color.from_hex("#19527b")
lilac = Color.from_hex("#dfb0fc")

shade1 = Color.from_hex("#f4f5f5")
shade2 = Color.from_hex("#dde0e1")
shade3 = Color.from_hex("#c6cccd")
shade4 = Color.from_hex("#b0b8ba")
shade5 = Color.from_hex("#99a3a6")
shade6 = Color.from_hex("#828f92")
shade7 = Color.from_hex("#6d7a7d")
shade8 = Color.from_hex("#596366")
shade9 = Color.from_hex("#454d4f")
shade10 = Color.from_hex("#323739")
shade11 = Color.from_hex("#1e2122")
shade12 = Color.from_hex("#0a0b0b")

print(f"""
[colors.hex.light]
petal = "{petal.to_hexstr()}"
coral = "{coral.to_hexstr()}"
blush = "{blush.to_hexstr()}"
amethyst = "{amethyst.to_hexstr()}"
crimson = "{crimson.to_hexstr()}"
garnet = "{garnet.to_hexstr()}"
apricot = "{apricot.to_hexstr()}"
amber = "{amber.to_hexstr()}"
verdant = "{verdant.to_hexstr()}"
lagoon = "{lagoon.to_hexstr()}"
aether = "{aether.to_hexstr()}"
cerulean = "{cerulean.to_hexstr()}"
azure = "{azure.to_hexstr()}"
lilac = "{lilac.to_hexstr()}"

primary = "{shade12.to_hexstr()}"
secondary = "{shade11.to_hexstr()}"
tertiary = "{shade10.to_hexstr()}"

edge2 = "{shade9.to_hexstr()}"
edge1 = "{shade8.to_hexstr()}"
edge0 = "{shade7.to_hexstr()}"

layer2 = "{shade6.to_hexstr()}"
layer1 = "{shade5.to_hexstr()}"
layer0 = "{shade4.to_hexstr()}"

base = "{shade1.to_hexstr()}"
foundation = "{shade2.to_hexstr()}"
bedrock = "{shade3.to_hexstr()}"

[colors.hex.dark]
petal = "{petal.to_hexstr()}"
coral = "{coral.to_hexstr()}"
blush = "{blush.to_hexstr()}"
amethyst = "{amethyst.to_hexstr()}"
crimson = "{crimson.to_hexstr()}"
garnet = "{garnet.to_hexstr()}"
apricot = "{apricot.to_hexstr()}"
amber = "{amber.to_hexstr()}"
verdant = "{verdant.to_hexstr()}"
lagoon = "{lagoon.to_hexstr()}"
aether = "{aether.to_hexstr()}"
cerulean = "{cerulean.to_hexstr()}"
azure = "{azure.to_hexstr()}"
lilac = "{lilac.to_hexstr()}"

primary = "{shade1.to_hexstr()}"
secondary = "{shade2.to_hexstr()}"
tertiary = "{shade3.to_hexstr()}"

edge2 = "{shade4.to_hexstr()}"
edge1 = "{shade5.to_hexstr()}"
edge0 = "{shade6.to_hexstr()}"

layer2 = "{shade7.to_hexstr()}"
layer1 = "{shade8.to_hexstr()}"
layer0 = "{shade9.to_hexstr()}"

base = "{shade12.to_hexstr()}"
foundation = "{shade11.to_hexstr()}"
bedrock = "{shade10.to_hexstr()}"

[colors.rgb.light]
petal = "{petal.to_rgbstr()}"
coral = "{coral.to_rgbstr()}"
blush = "{blush.to_rgbstr()}"
amethyst = "{amethyst.to_rgbstr()}"
crimson = "{crimson.to_rgbstr()}"
garnet = "{garnet.to_rgbstr()}"
apricot = "{apricot.to_rgbstr()}"
amber = "{amber.to_rgbstr()}"
verdant = "{verdant.to_rgbstr()}"
lagoon = "{lagoon.to_rgbstr()}"
aether = "{aether.to_rgbstr()}"
cerulean = "{cerulean.to_rgbstr()}"
azure = "{azure.to_rgbstr()}"
lilac = "{lilac.to_rgbstr()}"

primary = "{shade12.to_rgbstr()}"
secondary = "{shade11.to_rgbstr()}"
tertiary = "{shade10.to_rgbstr()}"

edge2 = "{shade9.to_rgbstr()}"
edge1 = "{shade8.to_rgbstr()}"
edge0 = "{shade7.to_rgbstr()}"

layer2 = "{shade6.to_rgbstr()}"
layer1 = "{shade5.to_rgbstr()}"
layer0 = "{shade4.to_rgbstr()}"

base = "{shade1.to_rgbstr()}"
foundation = "{shade2.to_rgbstr()}"
bedrock = "{shade3.to_rgbstr()}"

[colors.rgb.dark]
petal = "{petal.to_rgbstr()}"
coral = "{coral.to_rgbstr()}"
blush = "{blush.to_rgbstr()}"
amethyst = "{amethyst.to_rgbstr()}"
crimson = "{crimson.to_rgbstr()}"
garnet = "{garnet.to_rgbstr()}"
apricot = "{apricot.to_rgbstr()}"
amber = "{amber.to_rgbstr()}"
verdant = "{verdant.to_rgbstr()}"
lagoon = "{lagoon.to_rgbstr()}"
aether = "{aether.to_rgbstr()}"
cerulean = "{cerulean.to_rgbstr()}"
azure = "{azure.to_rgbstr()}"
lilac = "{lilac.to_rgbstr()}"

primary = "{shade1.to_rgbstr()}"
secondary = "{shade2.to_rgbstr()}"
tertiary = "{shade3.to_rgbstr()}"

edge2 = "{shade4.to_rgbstr()}"
edge1 = "{shade5.to_rgbstr()}"
edge0 = "{shade6.to_rgbstr()}"

layer2 = "{shade7.to_rgbstr()}"
layer1 = "{shade8.to_rgbstr()}"
layer0 = "{shade9.to_rgbstr()}"

base = "{shade12.to_rgbstr()}"
foundation = "{shade11.to_rgbstr()}"
bedrock = "{shade10.to_rgbstr()}"
""")
