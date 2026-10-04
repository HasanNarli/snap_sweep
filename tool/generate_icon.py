from PIL import Image, ImageDraw, ImageFilter
SS = 4
BG = (249, 248, 245, 255)
BACK = (226, 210, 193, 255)
FRONT = (255, 255, 255, 255)
BORDER = (235, 230, 223, 255)
ACCENT = (138, 90, 54, 255)
SUN = (243, 237, 229, 255)
HILL = (176, 128, 90, 255)

def card(w, h, fill, rot, photo=False):
    pad = 80 * SS
    im = Image.new('RGBA', (w + 2 * pad, h + 2 * pad), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    r = int(w * 0.12)
    box = (pad, pad, pad + w, pad + h)
    d.rounded_rectangle(box, r, fill=fill, outline=BORDER if photo else None, width=3 * SS)
    if photo:
        m = int(w * 0.075)
        inner = (pad + m, pad + m, pad + w - m, pad + h - int(h * 0.2))
        mask = Image.new('L', im.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle(inner, int(r * 0.6), fill=255)
        art = Image.new('RGBA', im.size, ACCENT)
        a = ImageDraw.Draw(art)
        iw, ih = inner[2] - inner[0], inner[3] - inner[1]
        cx, cy, cr = inner[0] + iw * 0.7, inner[1] + ih * 0.3, iw * 0.12
        a.ellipse((cx - cr, cy - cr, cx + cr, cy + cr), fill=SUN)
        a.polygon([(inner[0], inner[3]), (inner[0] + iw * 0.38, inner[1] + ih * 0.5),
                   (inner[0] + iw * 0.62, inner[1] + ih * 0.75), (inner[0] + iw * 0.78, inner[1] + ih * 0.6),
                   (inner[2], inner[1] + ih * 0.8), (inner[2], inner[3])], fill=HILL)
        im.paste(art, (0, 0), mask)
    return im.rotate(rot, resample=Image.BICUBIC, expand=True)

def shadow(layer, blur, alpha):
    a = layer.split()[3].point(lambda v: v * alpha / 255)
    s = Image.new('RGBA', layer.size, (40, 25, 10, 0))
    s.putalpha(a)
    return s.filter(ImageFilter.GaussianBlur(blur))

def mark(size):
    # Two stacked photo cards; drawn at size*SS then downsampled.
    S = size * SS
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    w, h = int(S * 0.52), int(S * 0.65)
    back = card(w, h, BACK, 12)
    front = card(w, h, FRONT, -6, photo=True)
    def place(layer, dx, dy):
        x = (S - layer.width) // 2 + int(S * dx)
        y = (S - layer.height) // 2 + int(S * dy)
        im.alpha_composite(shadow(layer, 18 * SS, 40), (x, y + 10 * SS))
        im.alpha_composite(layer, (x, y))
    place(back, 0.07, -0.02)
    place(front, -0.04, 0.02)
    return im.resize((size, size), Image.LANCZOS)

def framed(size, scale, bg):
    out = Image.new('RGBA', (size, size), bg)
    m = mark(int(size * scale))
    out.alpha_composite(m, ((size - m.width) // 2, (size - m.height) // 2))
    return out

# Run from the repo root: python3 tool/generate_icon.py (needs Pillow).
out = 'assets/icon/'
framed(1024, 0.84, BG).convert('RGB').save(out + 'icon.png')
framed(1024, 0.9, (0, 0, 0, 0)).save(out + 'icon_foreground.png')
framed(1152, 0.56, (0, 0, 0, 0)).save(out + 'splash.png')
