rm(list=ls())
source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")
library("EBImage")

# At the moment we run this 4 times, once for each artist and change the name by hand in the following paths

# NOTE: path for Maria's MacBookPro
setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Renior")

save_in <- "../Renior_resized" # for some reason it isn't saving the images in the resized folder but in images instead - will have to be fixed
images <- list.files()
w <- 64
h <- 64

# Main loop resize images and set them to greyscale
for(i in 1:length(images))
{
  # Try-catch is necessary since some images may not work.
  result <- tryCatch({
    imgname <- images[i]
    img <- readImage(imgname)
    img_resized <- resize(img, w = w, h = h)
    grayimg <- channel(img_resized,"gray")
    path <- paste(save_in, imgname, sep = "")
    writeImage(grayimg, path, quality = 70)
    print(paste("Done",i,sep = " "))},
    error = function(e){print(e)})
}
