import numpy as np
from keras.models import load_model
from keras.preprocessing.image import load_img, img_to_array, ImageDataGenerator

dimensions = [64, 64, 3]

model = load_model("cnn_model_v6_50epoch.h5")

# Manual testing
def test(path):
    image = load_img(path, target_size=(dimensions[0], dimensions[1]))
    image_array = img_to_array(image)
    image_array *= 1. / 255
    image_array = image_array.reshape((1,) + image_array.shape)
    print(model.predict(image_array))

test('./Images/Test/Unknown/image1.png')
test('./Images/Test/Unknown/image2.png')
test('./Images/Test/Unknown/image3.png')
test('./Images/Test/Unknown/image4.png')