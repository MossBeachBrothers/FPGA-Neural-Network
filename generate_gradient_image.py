import numpy as np
from PIL import Image

def generate_gradient_image(width, height):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for y in range(height):
        for x in range(width):
            img[y, x] = [255, x % 256, y % 256]  # Yellow gradient
    return img

def generate_solid_color_image(width, height):
    return np.full((height, width, 3), [255, 255, 0], dtype=np.uint8)  # Solid yellow

def generate_checkerboard_image(width, height, block_size):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for y in range(height):
        for x in range(width):
            if (x // block_size) % 2 == (y // block_size) % 2:
                img[y, x] = [255, 255, 0]  # Yellow
            else:
                img[y, x] = [255, 200, 0]  # Dark yellow
    return img

def generate_vertical_stripes_image(width, height, stripe_width):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for x in range(width):
        if (x // stripe_width) % 2 == 0:
            img[:, x] = [255, 255, 0]  # Yellow
        else:
            img[:, x] = [255, 200, 0]  # Dark yellow
    return img

def generate_horizontal_stripes_image(width, height, stripe_height):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for y in range(height):
        if (y // stripe_height) % 2 == 0:
            img[y, :] = [255, 255, 0]  # Yellow
        else:
            img[y, :] = [255, 200, 0]  # Dark yellow
    return img

def generate_diagonal_stripes_image(width, height, stripe_width):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for y in range(height):
        for x in range(width):
            if ((x + y) // stripe_width) % 2 == 0:
                img[y, x] = [255, 255, 0]  # Yellow
            else:
                img[y, x] = [255, 200, 0]  # Dark yellow
    return img

def generate_circles_image(width, height, radius):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    img[:, :] = [255, 200, 0]  # Dark yellow background
    for y in range(height):
        for x in range(width):
            if ((x - width // 2) ** 2 + (y - height // 2) ** 2) ** 0.5 % radius < radius // 2:
                img[y, x] = [255, 255, 0]  # Yellow circles
    return img

def generate_random_noise_image(width, height):
    return np.random.randint(200, 256, (height, width, 3), dtype=np.uint8)  # Random yellow noise

def generate_gradient_with_noise_image(width, height):
    img = generate_gradient_image(width, height)
    noise = np.random.randint(0, 50, (height, width, 3), dtype=np.uint8)
    noise[:, :, 0] = 0  # No red noise
    img = np.clip(img + noise, 0, 255)
    return img
def generate_rainbow_gradient(width, height):
    img = np.zeros((height, width, 3), dtype=np.uint8)
    for x in range(width):
        # Calculate hue based on x position
        hue = x / width
        # Convert HSV to RGB
        if hue < 1/6:
            r, g, b = 255, int(1530 * hue), 0
        elif hue < 2/6:
            r, g, b = int(1530 * (1/3 - hue)), 255, 0
        elif hue < 3/6:
            r, g, b = 0, 255, int(1530 * (hue - 1/3))
        elif hue < 4/6:
            r, g, b = 0, int(1530 * (2/3 - hue)), 255
        elif hue < 5/6:
            r, g, b = int(1530 * (hue - 2/3)), 0, 255
        else:
            r, g, b = 255, 0, int(1530 * (1 - hue))
        img[:, x] = [r, g, b]
    return img
def generate_spiral_image(width, height):
    img = np.full((height, width, 3), [255, 200, 0], dtype=np.uint8)  # Dark yellow background
    center_x, center_y = width // 2, height // 2
    for r in range(min(center_x, center_y)):
        for theta in range(360):
            x = int(center_x + r * np.cos(np.deg2rad(theta)))
            y = int(center_y + r * np.sin(np.deg2rad(theta)))
            if 0 <= x < width and 0 <= y < height:
                img[y, x] = [255, 255, 0]  # Yellow spiral
    return img

def save_image(img, filename):
    image = Image.fromarray(img)
    image.save(filename)

def save_text(img, filename):
    np.savetxt(filename, img.reshape(-1, 3), fmt='%d')

if __name__ == "__main__":
    width = 1280  # 720p image width
    height = 720  # 720p image height
    types = [
        "gradient",
        "solid_yellow",
        "checkerboard",
        "vertical_stripes",
        "horizontal_stripes",
        "diagonal_stripes",
        "circles",
        "random_noise",
        "gradient_with_noise",
        "spiral",
        "rainbow_gradient"  # Add this new type
    ]

    for img_type in types:
        if img_type == "gradient":
            img = generate_gradient_image(width, height)
        elif img_type == "solid_yellow":
            img = generate_solid_color_image(width, height)
        elif img_type == "checkerboard":
            img = generate_checkerboard_image(width, height, 40)
        elif img_type == "vertical_stripes":
            img = generate_vertical_stripes_image(width, height, 40)
        elif img_type == "horizontal_stripes":
            img = generate_horizontal_stripes_image(width, height, 40)
        elif img_type == "diagonal_stripes":
            img = generate_diagonal_stripes_image(width, height, 40)
        elif img_type == "circles":
            img = generate_circles_image(width, height, 40)
        elif img_type == "random_noise":
            img = generate_random_noise_image(width, height)
        elif img_type == "gradient_with_noise":
            img = generate_gradient_with_noise_image(width, height)
        elif img_type == "spiral":
            img = generate_spiral_image(width, height)
        elif img_type == "rainbow_gradient":
            img = generate_rainbow_gradient(width, height)

        save_image(img, f'{img_type}_720p.png')
        save_text(img, f'{img_type}_720p.txt')