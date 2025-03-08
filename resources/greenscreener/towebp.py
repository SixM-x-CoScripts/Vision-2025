import os
from PIL import Image

def process_image(input_path, output_path):
	img = Image.open(input_path)

	os.makedirs(os.path.dirname(output_path), exist_ok=True)

	img.save(output_path, format="webp", lossless=True)

def process_directory(input_dir, output_dir):
	processed = 0
	batch = 50

	for root, dirs, files in os.walk(input_dir):
		for file in files:
			if file.lower().endswith(('.png', '.jpg', '.jpeg')):
				input_path = os.path.join(root, file)
				relative_path = os.path.relpath(input_path, input_dir)
				output_path = os.path.join(output_dir, relative_path).split('.')[0] + ".webp"
				
				process_image(input_path, output_path)

				processed += 1

				if processed % batch == 0 and processed > 0 or processed == len(files):
					print(f"Processed {processed} images")

if __name__ == "__main__":
	input_dir = "output/"
	output_dir = "webp/"


	print("Processing images...")
	print("Input directory: ", input_dir)
	print("Output directory: ", output_dir)
	
	process_directory(input_dir, output_dir)