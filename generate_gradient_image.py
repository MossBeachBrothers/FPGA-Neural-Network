import numpy as np
from PIL import Image

def generate_gradient_image(width, height):
    img = np.zeros((height, width, 3), dtype=np.uint8)

    for y in range(height):
        for x in range(width):
            img[y, x] = [x % 256, y % 256, (x + y) % 256]

    return img

def save_image(img, filename):
    image = Image.fromarray(img)
    image.save(filename)

if __name__ == "__main__":
    width = 1280  # 720p image width
    height = 720  # 720p image height
    img = generate_gradient_image(width, height)
    save_image(img, 'gradient_720p.png')
    np.savetxt('gradient_720p.txt', img.reshape(-1, 3), fmt='%d')
