import numpy as np
import matplotlib.pyplot as plt

from keras import Sequential
from keras.layers import Conv2D
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import load_img


def visualize_image(image_batch):
    image = image_batch.reshape(image_batch.shape[2:4])
    plt.imshow(image)


dimensions = [64, 64, 3]
batch_size = 16

image = load_img('./Images/Test/Unknown/image3.png', target_size=(dimensions[0], dimensions[1]))
image_array = img_to_array(image)
image_array = image_array.reshape((1,) + image_array.shape)
#image_array = np.expand_dims(image, axis=0)

model = Sequential()
model.add(Conv2D(32, 3, input_shape=(dimensions[0], dimensions[1], dimensions[2]), data_format="channels_last"))

step1_batch = model.predict(image_array)

visualize_image(step1_batch)