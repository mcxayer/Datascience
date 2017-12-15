#Network 2

from keras import Sequential
from keras.layers import Conv2D, Activation, MaxPooling2D, Flatten, Dense, Dropout
from keras.preprocessing.image import ImageDataGenerator

dimensions = [64, 64, 3]
batch_size = 32

model = Sequential()
model.add(Conv2D(32, 3, input_shape=(dimensions[0], dimensions[1], dimensions[2]),
                 data_format="channels_last"))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=2))

model.add(Conv2D(32, 3))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=2))

model.add(Conv2D(64, 3))
model.add(Activation("relu"))
model.add(MaxPooling2D(pool_size=2))

model.add(Flatten())
model.add(Dense(64))
model.add(Activation("relu"))
model.add(Dropout(0.5))

model.add(Dense(4))
model.add(Activation("softmax"))

model.compile(loss="categorical_crossentropy",
              optimizer="rmsprop",
              metrics=["accuracy"])

train_image_data_generator = ImageDataGenerator(
    rescale=1. / 255,
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

sample_amount = 3399
validation_sample_amount = 1021
epochs = 50
epoch_steps = sample_amount // batch_size
validation_steps = validation_sample_amount // batch_size

history = model.fit_generator(
    train_image_data_flow,
    steps_per_epoch=epoch_steps,
    epochs=epochs,
    validation_data=validation_image_data_flow,
    validation_steps=validation_steps
)

print(history.history)

model.save("cnn_model_v7_50epoch.h5")
