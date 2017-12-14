import numpy as np
from keras.models import load_model
from keras.preprocessing.image import load_img, img_to_array, ImageDataGenerator

dimensions = [64, 64, 3]

model = load_model("cnn_model_v2_500epoch.h5")

# Manual testing
image = load_img('./Images/Test/Unknown/image4.png', target_size=(dimensions[0], dimensions[1]))
image_array = img_to_array(image)
image_array *= 1./255
image_array = image_array.reshape((1,) + image_array.shape)

print(model.predict(image_array))
