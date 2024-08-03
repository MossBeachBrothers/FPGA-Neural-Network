import numpy as np
import matplotlib.pyplot as plt

def read_image(file_name, width, height):
    image = np.zeros((height, width, 3), dtype=np.uint8)
    with open(file_name, 'r') as f:
        for y in range(height):
            for x in range(width):
                line = f.readline().strip()
                if line:
                    values = line.split()
                    if len(values) == 3:  # Ensure the line has exactly 3 values
                        try:
                            r, g, b = map(int, values)
                            image[y, x] = [r, g, b]
                        except ValueError as e:
                            print(f"Error reading line: {line}. Skipping this line.")
                    else:
                        print(f"Invalid line format at y={y}, x={x}: {line}")
    return image

def show_images_stacked(image1, title1, image2, title2):
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 20))
    
    ax1.imshow(image1)
    ax1.set_title(title1)
    ax1.axis('off')
    
    ax2.imshow(image2)
    ax2.set_title(title2)
    ax2.axis('off')
    
    plt.tight_layout()
    plt.show()

# Read the images
gradient_image = read_image("bird_rgb_values.txt", 1280, 720)
output_image = read_image("output_720p.txt", 1280, 720)

# Display the images stacked on top of each other
show_images_stacked(gradient_image, "Original Rainbow Gradient Image", 
                    output_image, "Processed Output Image")