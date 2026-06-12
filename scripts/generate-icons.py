from pathlib import Path
import struct
import sys
from PIL import Image


def generate_icons(source_icon: str, project_root: str):
    src = Path(source_icon).resolve()
    root = Path(project_root).resolve()

    if not src.exists():
        print(f"Error: source icon not found: {src}", file=sys.stderr)
        sys.exit(1)

    img = Image.open(src)

    # ---- Android ----
    android_res = root / "android" / "app" / "src" / "main" / "res"
    android_sizes = [
        ("mipmap-mdpi", 48),
        ("mipmap-hdpi", 72),
        ("mipmap-xhdpi", 96),
        ("mipmap-xxhdpi", 144),
        ("mipmap-xxxhdpi", 192),
    ]

    for dirname, size in android_sizes:
        out_dir = android_res / dirname
        out_dir.mkdir(parents=True, exist_ok=True)
        resized = img.resize((size, size), Image.LANCZOS)
        resized.save(out_dir / "ic_launcher.png")
        resized.save(out_dir / "ic_launcher_round.png")
        print(f"  [OK] android/{dirname}/ic_launcher.png ({size}x{size})")
        print(f"  [OK] android/{dirname}/ic_launcher_round.png ({size}x{size})")

    # ---- iOS ----
    ios_dir = root / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    ios_sizes = [
        ("Icon-App-20x20@1x.png", 20),
        ("Icon-App-20x20@2x.png", 40),
        ("Icon-App-20x20@3x.png", 60),
        ("Icon-App-29x29@1x.png", 29),
        ("Icon-App-29x29@2x.png", 58),
        ("Icon-App-29x29@3x.png", 87),
        ("Icon-App-40x40@1x.png", 40),
        ("Icon-App-40x40@2x.png", 80),
        ("Icon-App-40x40@3x.png", 120),
        ("Icon-App-60x60@2x.png", 120),
        ("Icon-App-60x60@3x.png", 180),
        ("Icon-App-76x76@1x.png", 76),
        ("Icon-App-76x76@2x.png", 152),
        ("Icon-App-83.5x83.5@2x.png", 167),
        ("Icon-App-1024x1024@1x.png", 1024),
    ]

    if ios_dir.exists():
        for filename, size in ios_sizes:
            resized = img.resize((size, size), Image.LANCZOS)
            resized.save(ios_dir / filename)
            print(f"  [OK] ios/{filename} ({size}x{size})")

    # ---- macOS ----
    macos_dir = root / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    macos_sizes = [
        ("app_icon_16.png", 16),
        ("app_icon_32.png", 32),
        ("app_icon_64.png", 64),
        ("app_icon_128.png", 128),
        ("app_icon_256.png", 256),
        ("app_icon_512.png", 512),
        ("app_icon_1024.png", 1024),
    ]

    if macos_dir.exists():
        for filename, size in macos_sizes:
            resized = img.resize((size, size), Image.LANCZOS)
            resized.save(macos_dir / filename)
            print(f"  [OK] macos/{filename} ({size}x{size})")

    # ---- Windows (ICO) ----
    windows_ico = root / "windows" / "runner" / "resources" / "app_icon.ico"
    ico_sizes = [(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]

    entries = []
    header_size = 6 + len(ico_sizes) * 16
    current_offset = header_size

    for w, h in ico_sizes:
        resized = img.resize((w, h), Image.LANCZOS)
        r, g, b, a = resized.split()
        bgra = Image.merge("RGBA", (b, g, r, a))
        raw = bgra.tobytes()

        and_row_size = ((w + 31) // 32) * 4
        and_mask = b"\x00" * (and_row_size * h)

        dib_header = struct.pack(
            "<IiiHHIIiiII",
            40, w, h * 2, 1, 32, 0, 0, 0, 0, 0, 0,
        )

        entry_data = dib_header + raw + and_mask
        entries.append((w, h, entry_data))

    with open(windows_ico, "wb") as f:
        f.write(struct.pack("<HHH", 0, 1, len(ico_sizes)))
        for w, h, data in entries:
            f.write(struct.pack(
                "<BBBBHHII",
                w if w < 256 else 0,
                h if h < 256 else 0,
                0, 0, 1, 32, len(data), current_offset,
            ))
            current_offset += len(data)
        for _, _, data in entries:
            f.write(data)

    print(f"  [OK] windows/app_icon.ico ({', '.join(f'{w}x{h}' for w, h in ico_sizes)})")

    # ---- Web ----
    web_dir = root / "web"
    web_icons_dir = web_dir / "icons"
    web_icons_dir.mkdir(parents=True, exist_ok=True)

    web_sizes = [
        ("favicon.png", 32),
        ("icons/Icon-192.png", 192),
        ("icons/Icon-512.png", 512),
        ("icons/Icon-maskable-192.png", 192),
        ("icons/Icon-maskable-512.png", 512),
    ]

    for rel_path, size in web_sizes:
        resized = img.resize((size, size), Image.LANCZOS)
        resized.save(web_dir / rel_path)
        print(f"  [OK] web/{rel_path} ({size}x{size})")

    # ---- Linux ----
    linux_icons_dir = root / "linux" / "runner" / "icons"
    linux_icons_dir.mkdir(parents=True, exist_ok=True)
    linux_sizes = [32, 64, 128, 256, 512]
    for size in linux_sizes:
        resized = img.resize((size, size), Image.LANCZOS)
        filename = f"app_icon_{size}.png"
        resized.save(linux_icons_dir / filename)
        print(f"  [OK] linux/icons/{filename} ({size}x{size})")

    print()
    print("All icons generated successfully for all platforms!")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Generate app icons for all platforms")
    parser.add_argument(
        "--source",
        default="dart/construct_manager/assets/icon.png",
        help="Path to source icon (default: dart/construct_manager/assets/icon.png)",
    )
    parser.add_argument(
        "--project",
        default="dart/construct_manager",
        help="Path to Flutter project root (default: dart/construct_manager)",
    )
    args = parser.parse_args()
    generate_icons(args.source, args.project)
