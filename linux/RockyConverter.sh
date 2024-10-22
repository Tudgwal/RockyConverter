#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it and try again."
    exit 1
fi

# Check if a directory path is provided as an argument
if [ $# -eq 0 ]; then
    echo "No directory path provided. Do you want to use the current directory? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        input_dir=$(pwd)
    else
        echo "Error: No directory path provided. Usage: $0 /path/to/directory"
        exit 1
    fi
else
    input_dir=$1
fi

# Get the provided directory path
input_dir=$1

# Find all image files in the directory and subdirectories recursively. It can be JPG, PNG, TIFF, etc.
image_files=$(find "$input_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tiff" \))


echo "Found $(echo "$image_files" | wc -l) images in the directory: $input_dir"

# set the output directory
output_dir="$(echo "$input_dir" | sed 's:/*$::')_resized"

# Create the output directory if it does not exist
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi


# Resize images to 1080p
total_files=$(echo "$image_files" | wc -l)
current_file=0

for file in $image_files; do
    # Skip directories
    if [ -d "$file" ]; then
        continue
    fi

    # Reduce the size of the image and save it in the output directory
    convert "$file" -resize 1920x1080 "$output_dir/$(basename "$file")"
    
    # Update progress
    current_file=$((current_file + 1))
    progress=$((current_file * 100 / total_files))
    echo -ne "Progress: ["
    for ((i=0; i<progress; i+=2)); do
        echo -ne "#"
    done
    for ((i=progress; i<100; i+=2)); do
        echo -ne " "
    done
    echo -ne "] $progress% ($current_file/$total_files)\r"
done

echo -ne "\n"

echo "All operations completed successfully!"