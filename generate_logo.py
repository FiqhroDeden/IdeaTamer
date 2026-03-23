#!/usr/bin/env python3
"""Generate IdeaTamer app logo: Bulb + Progress Ring with liquid glass effect."""

from PIL import Image, ImageDraw, ImageFilter
import math


def draw_rounded_bulb(draw, cx, cy, scale, stroke_color=(255, 255, 255, 230), stroke_width=None):
    """Draw a clean lightbulb icon with proper shape."""
    sw = stroke_width or int(12 * scale)

    # Bulb dimensions — LARGE, fills the ring
    bulb_r = int(190 * scale)  # radius of the round part
    neck_w = int(115 * scale)  # width of the neck/base
    neck_h = int(80 * scale)   # height of neck

    top_cy = cy - int(40 * scale)  # shift bulb up slightly

    # Draw the round bulb top (arc from ~210° to ~330°)
    bulb_bbox = [cx - bulb_r, top_cy - bulb_r, cx + bulb_r, top_cy + bulb_r]
    draw.arc(bulb_bbox, 210, 330, fill=stroke_color, width=sw)

    # Left side curve from bulb to neck
    left_bulb_x = cx - int(165 * scale)
    left_bulb_y = top_cy + int(95 * scale)
    left_neck_x = cx - neck_w // 2
    neck_top_y = top_cy + int(148 * scale)

    draw.line([left_bulb_x, left_bulb_y, left_neck_x, neck_top_y],
              fill=stroke_color, width=sw)

    # Right side curve from bulb to neck
    right_bulb_x = cx + int(165 * scale)
    right_bulb_y = top_cy + int(95 * scale)
    right_neck_x = cx + neck_w // 2

    draw.line([right_bulb_x, right_bulb_y, right_neck_x, neck_top_y],
              fill=stroke_color, width=sw)

    # Base horizontal lines (screw threads)
    base_y1 = neck_top_y + int(20 * scale)
    base_y2 = neck_top_y + int(46 * scale)
    base_y3 = neck_top_y + int(70 * scale)
    bw = neck_w // 2

    draw.line([cx - bw, base_y1, cx + bw, base_y1],
              fill=stroke_color, width=int(9 * scale))
    draw.line([cx - bw + int(7*scale), base_y2, cx + bw - int(7*scale), base_y2],
              fill=stroke_color, width=int(9 * scale))
    # Bottom rounded cap
    draw.line([cx - bw + int(16*scale), base_y3, cx + bw - int(16*scale), base_y3],
              fill=stroke_color, width=int(9 * scale))

    # Filament — a clean chevron "^" inside the bulb
    fil_y = top_cy + int(25 * scale)
    fil_w = int(52 * scale)
    fil_h = int(40 * scale)
    fil_sw = int(10 * scale)
    draw.line([cx - fil_w, fil_y + fil_h, cx, fil_y],
              fill=(255, 255, 255, 200), width=fil_sw)
    draw.line([cx, fil_y, cx + fil_w, fil_y + fil_h],
              fill=(255, 255, 255, 200), width=fil_sw)


def create_logo(size=1024, transparent_bg=False):
    """Create the IdeaTamer logo at the given size."""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2
    scale = size / 1024.0

    # === BACKGROUND ===
    if not transparent_bg:
        # Rich blue gradient
        for y in range(size):
            t = y / size
            r = int(20 + 8 * t)
            g = int(90 - 30 * t)
            b = int(220 - 80 * t)
            draw.line([(0, y), (size, y)], fill=(r, g, b, 255))

        # Subtle radial glow
        glow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        for i in range(int(350 * scale), 0, -3):
            alpha = int(20 * (i / (350 * scale)))
            gd.ellipse([cx - i, cy - i - int(50*scale), cx + i, cy + i - int(50*scale)],
                       fill=(80, 140, 255, alpha))
        img = Image.alpha_composite(img, glow)
        draw = ImageDraw.Draw(img)

    # === PROGRESS RING ===
    ring_r = int(330 * scale)
    ring_w = int(32 * scale)
    ring_bbox = [cx - ring_r, cy - ring_r, cx + ring_r, cy + ring_r]

    # Track (subtle, dim)
    draw.arc(ring_bbox, 0, 360, fill=(255, 255, 255, 20), width=ring_w)

    # Active arc: 70% = 252° starting from 12 o'clock (-90°)
    start = -90
    sweep = 252
    segments = 120

    for i in range(segments):
        t = i / segments
        s = start + t * sweep
        e = start + (i + 1) / segments * sweep

        # White → Rival Red gradient
        r = 255
        g = int(255 - 188 * t)   # 255 → 67
        b = int(255 - 213 * t)   # 255 → 42
        a = int(210 + 45 * t)

        draw.arc(ring_bbox, s, e + 0.5, fill=(r, g, b, a), width=ring_w)

    # End caps
    cap = ring_w // 2
    sx = cx + ring_r * math.cos(math.radians(start))
    sy = cy + ring_r * math.sin(math.radians(start))
    draw.ellipse([sx - cap, sy - cap, sx + cap, sy + cap], fill=(255, 255, 255, 230))

    ea = math.radians(start + sweep)
    ex = cx + ring_r * math.cos(ea)
    ey = cy + ring_r * math.sin(ea)
    draw.ellipse([ex - cap, ey - cap, ex + cap, ey + cap], fill=(229, 67, 42, 255))

    # Ring outer glow
    rg = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    rgd = ImageDraw.Draw(rg)
    gw = ring_w + int(24 * scale)
    rgd.arc(ring_bbox, start, start + sweep, fill=(255, 255, 255, 15), width=gw)
    rg = rg.filter(ImageFilter.GaussianBlur(int(10 * scale)))
    img = Image.alpha_composite(img, rg)
    draw = ImageDraw.Draw(img)

    # === LIGHTBULB ===
    # Glass body fill (subtle transparency)
    glass = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glass)
    bulb_r = int(190 * scale)
    top_cy = cy - int(40 * scale)
    gd.ellipse([cx - bulb_r, top_cy - bulb_r, cx + bulb_r, top_cy + bulb_r],
               fill=(255, 255, 255, 25))
    neck_w = int(115 * scale)
    gd.rectangle([cx - neck_w//2, top_cy + int(95*scale),
                  cx + neck_w//2, top_cy + int(220*scale)],
                 fill=(255, 255, 255, 20))
    glass = glass.filter(ImageFilter.GaussianBlur(int(5 * scale)))
    img = Image.alpha_composite(img, glass)
    draw = ImageDraw.Draw(img)

    # Bulb outline
    draw_rounded_bulb(draw, cx, cy, scale)

    # === GLASS HIGHLIGHTS ===
    hl = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    hld = ImageDraw.Draw(hl)

    # Top-left shine spot
    sx = cx - int(50 * scale)
    sy = top_cy - int(40 * scale)
    sr = int(30 * scale)
    hld.ellipse([sx - sr, sy - sr, sx + sr, sy + sr], fill=(255, 255, 255, 50))

    # Broad top highlight
    hr = int(250 * scale)
    hld.arc([cx - hr, int(60 * scale), cx + hr, int(60 * scale) + hr * 2],
            210, 330, fill=(255, 255, 255, 15), width=int(50 * scale))

    hl = hl.filter(ImageFilter.GaussianBlur(int(18 * scale)))
    img = Image.alpha_composite(img, hl)

    return img


def main():
    import os
    base = "/Users/zoldy/Development/IdeaTamer/IdeaTamerApp/IdeaTamer/IdeaTamer"

    # App icon 1024x1024
    icon = create_logo(1024, transparent_bg=False)
    p = os.path.join(base, "Assets.xcassets/AppIcon.appiconset/AppIcon1024.png")
    icon.save(p, "PNG")
    print(f"Saved: {p}")

    # In-app logo transparent 256
    logo = create_logo(256, transparent_bg=True)
    p2 = os.path.join(base, "Resources/logo.png")
    logo.save(p2, "PNG")
    print(f"Saved: {p2}")

    # In-app logo transparent 512
    logo2 = create_logo(512, transparent_bg=True)
    p3 = os.path.join(base, "Resources/logo@2x.png")
    logo2.save(p3, "PNG")
    print(f"Saved: {p3}")

    # Logo with background for share cards
    logo_bg = create_logo(512, transparent_bg=False)
    p4 = os.path.join(base, "Resources/logo_bg.png")
    logo_bg.save(p4, "PNG")
    print(f"Saved: {p4}")


if __name__ == "__main__":
    main()
