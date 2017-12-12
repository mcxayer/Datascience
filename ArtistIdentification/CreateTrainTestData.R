# source: https://www.r-bloggers.com/image-recognition-tutorial-in-r-using-deep-convolutional-neural-networks-mxnet-package/

# Clean environment and load required packages
rm(list=ls())
require(EBImage)

# Set wd where resized greyscale images are located
setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images_resized")

# Out file
out_file <- "/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images_resized/images_28.csv"

# List images in path
images <- list.files()

# Set up df
df <- data.frame()

# Set image size. In this case 28x28
img_size <- 28*28

# Set label
label <- 1

# Main loop. Loop over each image
for(i in 1:length(images))
{
  # Read image
  img <- readImage(images[i])
  # Get the image as a matrix
  img_matrix <- img@.Data
  # Coerce to a vector
  img_vector <- as.vector(t(img_matrix))
  # Add label
  vec <- c(label, img_vector)
  # Bind rows
  df <- rbind(df,vec)
  # Print status info
  print(paste("Done ", i, sep = ""))
}

# Set names
names(df) <- c("label", paste("pixel", c(1:img_size)))

# Write out dataset
write.csv(df, out_file, row.names = FALSE)

#-------------------------------------------------------------------------------
# Test and train split and shuffle

# Load datasets
images <- read.csv("images_28.csv")

# Bind rows in a single dataset
new <- rbind(images) # don't think we need this

# Shuffle new dataset
shuffled <- new[sample(1:16),]

# Train-test split
train_28 <- shuffled[1:12,] # 75%
test_28 <- shuffled[13:16,] # 25%

# Save train-test datasets
write.csv(train_28, "train_28.csv",row.names = FALSE)
write.csv(test_28, "test_28.csv",row.names = FALSE)
