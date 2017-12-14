import numpy as np
from keras.models import load_model
from keras.preprocessing.image import load_img, img_to_array, ImageDataGenerator

dimensions = [64, 64, 3]
batch_size = 16

model = load_model("cnn_model.h5")

test_image_data_generator = ImageDataGenerator(
    rescale=1. / 255
)

test_image_data_flow = test_image_data_generator.flow_from_directory(
    "./Images/Test",
    target_size=(dimensions[0], dimensions[1]),
    batch_size=batch_size,
    class_mode="categorical"
)

for batch in test_image_data_flow:
    image_array = img_to_array(batch)
    image_array = image_array.reshape((1,) + image_array.shape)
    print(model.predict(image_array))

#image = load_img('./Images/Test/Unknown/image4.png', target_size=(dimensions[0], dimensions[1]))
#image_array = img_to_array(image)
#image_array = image_array.reshape((1,) + image_array.shape)

#print(model.predict(image_array))
