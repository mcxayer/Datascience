from keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img

image_data_generator = ImageDataGenerator(
    rotation_range=40,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest')

img = load_img("./Images/Training/Degas/a-carriage-at-the-races-1872.jpg!PinterestLarge.jpg")
x = img_to_array(img)
x = x.reshape((1,) + x.shape)

i = 0
for batch in image_data_generator.flow(x, batch_size=1, save_to_dir="./Images/Preview",
                                       save_prefix="degas", save_format="jpeg"):
    i += 1
    if i > 20:
        break
