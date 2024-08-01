import numpy as np
from PIL import Image

def read_png_and_save_rgb(input_filename, output_filename):
    # Open the PNG file
    try:
        with Image.open(input_filename) as img:
            # Ensure the image is in RGB mode
            img = img.convert('RGB')
            
            # Check if the image dimensions are correct
            if img.size != (1280, 720):
                raise ValueError(f"Image dimensions should be 1280x720, but got {img.size}")
            
            # Convert the image to a numpy array
            img_array = np.array(img)
            
            # Reshape the array to be 2D (each row is a pixel, columns are R, G, B values)
            rgb_values = img_array.reshape(-1, 3)
            
            # Save the RGB values to a text file
            np.savetxt(output_filename, rgb_values, fmt='%d', delimiter=' ')
            
            print(f"Successfully created {output_filename}")
    except FileNotFoundError:
        print(f"Error: The file {input_filename} was not found.")
    except ValueError as e:
        print(f"Error: {str(e)}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")

# Specify the input PNG filename (assumes it's in the same directory)
input_filename = "test_image_edges_gradients.png"  # Change this to your PNG filename

# Specify the output text filename
output_filename = "test_gradients_720p.txt"

# Run the function
read_png_and_save_rgb(input_filename, output_filename)