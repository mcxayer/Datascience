# source: http://firsttimeprogrammer.blogspot.dk/2016/07/image-recognition-in-r-using.html
# source: https://www.r-bloggers.com/image-recognition-in-r-using-convolutional-neural-networks-with-the-mxnet-package/

# Resize images and convert to grayscale

rm(list=ls())
source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")
library("EBImage")
#require(EBImage)

# At the moment we run this 4 times, once for each artist and change the name by hand in the following paths

# NOTE: path for Maria's MacBookPro
setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Renior")

# Set d where to save images
save_in <- "../Renior_resized" # for some reason it isn't saving the images in the resized folder but in images instead - will have to be fixed
# Load images names
images <- list.files()
# Set width
w <- 64
# Set height
h <- 64

# Main loop resize images and set them to greyscale
for(i in 1:length(images))
{
  # Try-catch is necessary since some images
  # may not work.
  result <- tryCatch({
    # Image name
    imgname <- images[i]
    # Read image
    img <- readImage(imgname)
    # Resize image 28x28
    img_resized <- resize(img, w = w, h = h)
    # Set to grayscale
    grayimg <- channel(img_resized,"gray")
    # Path to file
    path <- paste(save_in, imgname, sep = "")
    # Save image
    writeImage(grayimg, path, quality = 70)
    # Print status
    print(paste("Done",i,sep = " "))},
    # Error function
    error = function(e){print(e)})
}


