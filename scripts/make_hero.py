#!/usr/bin/env python3
"""Build a styled hero image for the Everyday Dose Frother Fridge Holder README."""
from PIL import Image, ImageDraw, ImageFont
import os

ROOT = r"e:\Documents\Working\3d-prints\everyday-dose-frother-fridge-holder"
IMG = os.path.join(ROOT, "images")
W, H = 1600, 900
CANVAS = (24, 26, 32)      # near-black
PANEL = (40, 44, 54)       # card bg
ACCENT = (255, 122, 0)     # orange accent
TEXT = (238, 238, 240)
SUBTEXT = (160, 164, 175)


def load_panel(src, dest_box, radius=24):
    im = Image.open(os.path.join(IMG, src)).convert("RGB")
    im.thumbnail((dest_box[2] - dest_box[0], dest_box[3] - dest_box[1]), Image.LANCZOS)
    # paste with rounded mask
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, im.size[0], im.size[1]], radius=20, fill=255)
    return im, mask


def rounded_panel(draw, box, radius=24, fill=PANEL):
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def main():
    canvas = Image.new("RGB", (W, H), CANVAS)
    d = ImageDraw.Draw(canvas)

    # Title bar
    rounded_panel(d, [50, 40, W - 50, 180], radius=20)
    title_font = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", 52)
    sub_font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 26)
    d.text((90, 62), "Everyday Dose Frother Fridge Holder", fill=TEXT, font=title_font)
    d.text((92, 128), "A 3D-printable magnetic holder for your milk frother  •  OpenSCAD parametric", fill=SUBTEXT, font=sub_font)

    # Hero three-quarter render (left, large)
    hero_box = [50, 210, 1020, 840]
    hero, hmask = load_panel("render-threequarter.png", [60, 220, 1010, 830])
    rounded_panel(d, hero_box, radius=24, fill=PANEL)
    canvas.paste(hero, (60, 220), hmask)

    # Right column: front + rear stacked, label caption
    right_x = 1060
    r1 = [right_x, 210, W - 50, 500]
    r2 = [right_x, 525, W - 50, 820]
    rounded_panel(d, r1, radius=24, fill=PANEL)
    rounded_panel(d, r2, radius=24, fill=PANEL)
    f1, m1 = load_panel("render-front-16x9.png", [right_x + 15, 220, W - 65, 490])
    f2, m2 = load_panel("render-rear-angle.png", [right_x + 15, 535, W - 65, 810])
    canvas.paste(f1, (right_x + 15, 225), m1)
    canvas.paste(f2, (right_x + 15, 540), m2)

    # Caption strip under hero
    cap_font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 24)
    d.text((70, 852), "Left: three-quarter view   •   Right top: front   •   Right bottom: rear (magnet holes)", fill=SUBTEXT, font=cap_font)

    out = os.path.join(IMG, "hero.png")
    canvas.save(out, "PNG")
    print("saved", out, canvas.size)


if __name__ == "__main__":
    main()