import cv2
import numpy as np
import os

def detect_and_remove_pink_square(img_path):
	image = cv2.imread(img_path, cv2.IMREAD_UNCHANGED)

	bgr_image = image[:, :, :3]
	alpha_channel = image[:, :, 3]
	
	hsv_image = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2HSV)
	
	lower_pink = np.array([140, 50, 50])
	upper_pink = np.array([180, 255, 255])

	mask = cv2.inRange(hsv_image, lower_pink, upper_pink)

	contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
	
	for contour in contours:
		if cv2.contourArea(contour) > 500:
			x, y, w, h = cv2.boundingRect(contour)
			alpha_channel[y:y+h, x:x+w] = 0
	
	processed_image = np.dstack([bgr_image, alpha_channel])
	
	return processed_image

def process_images(input_folder, output_folder):
	if not os.path.exists(output_folder):
		os.makedirs(output_folder)
	
	for filename in os.listdir(input_folder):
		if filename.endswith(".png"):
			img_path = os.path.join(input_folder, filename)
			
			processed_image = detect_and_remove_pink_square(img_path)
			
			output_path = os.path.join(output_folder, filename)
			cv2.imwrite(output_path, processed_image, [cv2.IMWRITE_PNG_COMPRESSION, 9])

	print(f"Toutes les images ont été traitées et enregistrées dans {output_folder}.")


if __name__ == "__main__":
	input_folder = "test"
	output_folder = "test/output"
	
	process_images(input_folder, output_folder)