import os
import subprocess
from tkinter import Tk, filedialog

def progress_bar(current_value, total_value, bar_length=30):
    percent = current_value / total_value
    filled_length = int(percent * bar_length)
    bar = '#' * filled_length + '-' * (bar_length - filled_length)
    print(f"\r[{bar}] {percent:.1%}", end='', flush=True)


def check_image_magick():
    # Check if ImageMagick is installed
    try:
        subprocess.run(['magick', '-version'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except FileNotFoundError:
        print("ImageMagick is not installed. Please install ImageMagick to use this script.")
        exit(1)


def main(): 
    check_image_magick()
    # Hide the root window
    Tk().withdraw()

    # Open a window to select the directory
    input_dir = filedialog.askdirectory(title="Select a directory")

    # Find all .jpg files in the directory and subdirectories recursively
    jpg_files = []
    for root, dirs, files in os.walk(input_dir):
        for file in files:
            if file.lower().endswith('.jpg'):
                jpg_files.append(os.path.join(root, file))

    print(f"Found {len(jpg_files)} .jpg files in the directory: {input_dir}")

    # Set the output directory
    output_dir = f"{input_dir.rstrip('/')}_resized"

    # Create the output directory if it does not exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Resize images to 1080p using ImageMagick
    for file in jpg_files:
        # Skip directories
        if os.path.isdir(file):
            continue

        # Reduce the size of the image and save it in the output directory
        output_file = os.path.join(output_dir, os.path.basename(file))
        subprocess.run(['magick', file, '-resize', '1920x1080', output_file])

        # Print progress
        progress_bar(jpg_files.index(file) + 1, len(jpg_files))

    # Print completion message that begin with a carriage return
    print("\nAll images have been resized successfully.")


# add main function
if __name__ == "__main__":
    main()
