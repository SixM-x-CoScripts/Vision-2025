import os
from PIL import Image, ImageEnhance

def crop_to_content(img):
    img = img.convert("RGBA")
    bbox = img.getbbox()
    return img.crop(bbox)

def enhance_image(img):
    """Améliore les couleurs et la chaleur de l'image."""
    enhancer = ImageEnhance.Color(img)
    img = enhancer.enhance(1.7)  # Augmente la saturation des couleurs
    enhancer = ImageEnhance.Brightness(img)
    img = enhancer.enhance(1.4)  # Augmente la luminosité
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.2)  # Améliore légèrement le contraste
    return img

def resize_with_margins(img, final_size=(125, 125), margin=(17, 18)):
    available_width = final_size[0] - 2 * margin[0]
    available_height = final_size[1] - 2 * margin[1]

    img.thumbnail((available_width, available_height), Image.LANCZOS)

    new_img = Image.new("RGBA", final_size, (0, 0, 0, 0))
    paste_x = (final_size[0] - img.width) // 2
    paste_y = (final_size[1] - img.height) // 2
    new_img.paste(img, (paste_x, paste_y), img)

    return new_img

def calculate_margins(final_size, original_size=(125, 125), original_margins=(17, 18)):
    margin_x = int(original_margins[0] * final_size[0] / original_size[0])
    margin_y_clothing = int(original_margins[1] * final_size[1] / original_size[1])
    margin_y_other = int(29 * final_size[1] / original_size[1])
    return (margin_x, margin_y_clothing), (margin_x, margin_y_other)

def process_image(input_path, output_path, final_size, margin):
    img = Image.open(input_path)
    cropped_img = crop_to_content(img)
    
    # Amélioration des couleurs et de la chaleur
    enhanced_img = enhance_image(cropped_img)
    
    final_img = resize_with_margins(enhanced_img, final_size=final_size, margin=margin)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    final_img.save(output_path, format="PNG")

def process_directory(input_dir, output_dir, final_size=(125, 125)):
    clothing_margins, other_margins = calculate_margins(final_size)

    for root, dirs, files in os.walk(input_dir):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                input_path = os.path.join(root, file)
                relative_path = os.path.relpath(input_path, input_dir)
                output_path = os.path.join(output_dir, relative_path)
                
                if 'clothing' in os.path.split(os.path.dirname(input_path)):
                    margin = clothing_margins
                else:
                    margin = other_margins

                process_image(input_path, output_path, final_size, margin)

def get_final_size():
    while True:
        try:
            size = int(input("Entrer la taille de l'image de sortie (doit être un carré): "))
            if size > 0:
                return (size, size)
            else:
                return (125, 125)
        except ValueError:
            print("Entrée invalide. Merci d'entrer un entier valide.")

input_dir = r"images"
output_dir = r"output"
final_size = get_final_size()

process_directory(input_dir, output_dir, final_size)
