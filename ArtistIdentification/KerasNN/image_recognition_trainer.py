from keras import Sequential
from keras.layers import Conv2D, Activation, MaxPooling2D, Flatten, Dense, Dropout
from keras.preprocessing.image import ImageDataGenerator

dimensions = [64, 64, 3]
batch_size = 16

model = Sequential()
model.add(Conv2D(32, (3, 3), input_shape=(dimensions[0], dimensions[1], dimensions[2]), data_format="channels_last"))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Flatten())

model.add(Dense(32))
model.add(Activation("relu"))
model.add(Dropout(0.5))

model.add(Dense(4))
model.add(Activation("softmax"))

model.compile(loss="categorical_crossentropy",
              optimizer="rmsprop",
              metrics=["accuracy"])

train_image_data_generator = ImageDataGenerator(
    rescale=1. / 255,
    rotation_range=45,
    shear_range=0.2,
    zoom_range=0.2
)

train_image_data_flow = train_image_data_generator.flow_from_directory(
    "./Images/Training",
    target_size=(dimensions[0], dimensions[1]),
    batch_size=batch_size,
    class_mode="categorical"
)

validation_image_data_generator = ImageDataGenerator(
    rescale=1. / 255
)

validation_image_data_flow = validation_image_data_generator.flow_from_directory(
    "./Images/Validation",
    target_size=(dimensions[0], dimensions[1]),
    batch_size=batch_size,
    class_mode="categorical"
)

model.fit_generator(
    train_image_data_flow,
    steps_per_epoch=2000 // batch_size,
    epochs=50,
    validation_data=validation_image_data_flow,
    validation_steps=800 // batch_size
)

model.save("cnn_model.h5")
