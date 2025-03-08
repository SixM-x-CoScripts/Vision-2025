import os
import argparse
import shutil
from PIL import Image

def resize_and_convert_image(image_path, output_path, max_size=(96, 96)):
    with Image.open(image_path) as img:
        img.thumbnail(max_size)
        img.save(output_path, format="WEBP")

def process_images(directory, backup_directory):
    if not os.path.exists(backup_directory):
        os.makedirs(backup_directory)

    for file in os.listdir(directory):
        if file.lower().endswith(".png") or file.lower().endswith(".jpg") or file.lower().endswith(".jpeg"):
            file_path = os.path.join(directory, file)
            output_path = os.path.splitext(file_path)[0] + ".webp"
            resize_and_convert_image(file_path, output_path)
            print(f"Processed {file_path} -> {output_path}")

            # Move original PNG to backup directory
            shutil.move(file_path, os.path.join(backup_directory, file))
            print(f"Moved {file_path} to {os.path.join(backup_directory, file)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Resize and convert PNG images to WEBP format")
    parser.add_argument("folder", help="The folder containing PNG images to be processed")
    parser.add_argument("backup_folder", help="The folder to move original PNG images to")
    args = parser.parse_args()

    process_images(args.folder, args.backup_folder)
