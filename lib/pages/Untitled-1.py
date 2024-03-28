# from flask import Flask, request, jsonify
# import cv2
# import numpy as np
# import os
#
# app = Flask(__name__)
# face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
#
#
# # Function to check if the uploaded image is a dog or cat
# def is_dog_or_cat(image_path):
#     # Load the image
#     img = cv2.imread(image_path)
#
#     # Convert the image to grayscale
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#
#     # Detect faces in the image
#     faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))
#
#     # If faces are detected, it's not a dog or cat
#     if len(faces) > 0:
#         return False
#
#     # Check if the image is a dog or cat (You need to implement this part)
#     # For simplicity, let's assume any image without a face is a dog or cat
#     return True
#
#
# @app.route('/api/data', methods=['POST'])
# def upload_image():
#     # Check if an image is sent in the request
#     if 'image' not in request.files:
#         return jsonify({'error': 'No image found in the request'}), 400
#
#     # Read the image file from the request
#     image_file = request.files['image']
#
#     # Save the image temporarily
#     image_path = 'temp_image.jpg'
#     image_file.save(image_path)
#
#     # Check if the uploaded image is a dog or cat
#     if is_dog_or_cat(image_path):
#         return jsonify({'message': 'Dog or cat image detected', 'image_path': image_path}), 200
#     else:
#         # If the uploaded image is neither a dog nor a cat, return an error
#         os.remove(image_path)  # Remove the temporarily saved image
#         return jsonify({'error': 'Only dog and cat images are allowed'}), 400
#
#
# if __name__ == '__main__':
#     app.run(debug=True)
