rm(list=ls())
require(EBImage)

writeOutImagesInExcel <- function(images, out_file, label) {
  df <- data.frame()
  img_size <- 64*64
  
  for(i in 1:length(images))
  {
    img <- readImage(images[i])
    img_matrix <- img@.Data
    img_vector <- as.vector(t(img_matrix))
    vec <- c(label, img_vector)
    df <- rbind(df,vec)
    print(paste("Done ", i, sep = ""))
  }
  
  names(df) <- c("label", paste("pixel", c(1:img_size)))
  write.csv(df, out_file, row.names = FALSE)
}


setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Degas_resized")
out_file_degas <- "/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/degas_64.csv"
label_degas <- 0
images_degas <- list.files()
writeOutImagesInExcel(images_degas, out_file_degas, label_degas)

setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Manet_resized")
out_file_manet <- "/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/manet_64.csv"
label_manet <- 1
images_manet <- list.files()
writeOutImagesInExcel(images_manet, out_file_manet, label_manet)

setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Monet_resized")
out_file_monet <- "/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/monet_64.csv"
label_monet <- 2
images_monet <- list.files()
writeOutImagesInExcel(images_monet, out_file_monet, label_monet)

setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/Renior_resized")
out_file_renior <- "/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images/renior_64.csv"
label_renior <- 3
images_renior <- list.files()
writeOutImagesInExcel(images_renior, out_file_renior, label_renior)

#-------------------------------------------------------------------------------
# Test and train split and shuffle

setwd("/Users/maria/Documents/GitHub/Datascience/ArtistIdentification/images")
degas <- read.csv("degas_64.csv") # 121 samples
manet <- read.csv("manet_64.csv") # 121 samples
monet <- read.csv("monet_64.csv") # 121 samples
renior <- read.csv("renior_64.csv") # 121 samples

# Bind rows in a single dataset
new <- rbind(degas, manet, monet, renior) # 474 samples

# Shuffle new dataset
shuffled <- new[sample(1:474),]

# Train-test split
train_28 <- shuffled[1:331,] # 70%
test_28 <- shuffled[332:474,] # 30%

# Save train-test datasets
write.csv(train_28, "train_64.csv",row.names = FALSE)
write.csv(test_28, "test_64.csv",row.names = FALSE)
