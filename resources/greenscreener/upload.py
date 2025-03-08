from minio import Minio
import os
import io

clothingDict = {
	0: "face", 
	1: "mask", 
	2: "hair", 
	3: "torso", 
	4: "leg", 
	5: "bag", 
	6: "shoes", 
	7: "accessory", 
	8: "undershirt", 
	9: "kevlar", 
	10: "badge", 
	11: "torso2"
}

propsDict = {
	0: "hat",
	1: "glasses",
	2: "ear",
	6: "watch",
	7: "bracelet"
}

def upload_image(root, file, client):
	sex = 'male' if file.lower().startswith(('male')) else 'female'
	clothing = 'clothing' if file.lower().find('_prop') == -1 else 'props'
	
	component = clothingDict[int(file.split('_')[1])] if clothing == 'clothing' else propsDict[int(file.split('_')[2])]

	name = '_'.join(file.split('_')[2:]) if clothing == 'clothing' else '_'.join(file.split('_')[3:])

	file_path = os.path.join(root, file)
	result = client.fput_object("vision-cdn", f"outfits/{sex}/{clothing}/{component}/{name}", file_path, content_type="image/webp")
	print(f"{root}/{file}", result.bucket_name, result.object_name)

if __name__ == "__main__":
	ACCESS_KEY = "I4KXnOdzQrZc3JoQADoi"
	SECRET_KEY = "U6rqrMGGto7Js0R2LKj96pPKQ1rsHz8wu3LyhWuc"

	client = Minio("89.234.183.46:9000", ACCESS_KEY, SECRET_KEY, secure=False)

	dir = f"webp"

	for root, dirs, files in os.walk(dir):
		for file in files:
			if file.lower().endswith(('.webp')):
				upload_image(root, file, client)