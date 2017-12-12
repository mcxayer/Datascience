# source: https://www.r-bloggers.com/image-recognition-tutorial-in-r-using-deep-convolutional-neural-networks-mxnet-package/

# Set names. The first columns are the labels, the other columns are the pixels.
names(rs_df) <- c("label", paste("pixel", c(1:784)))

# Train-test split
#-------------------------------------------------------------------------------
# Simple train-test split. No crossvalidation is done in this tutorial.

# Set seed for reproducibility purposes
set.seed(100)

# Shuffled df
shuffled <- rs_df[sample(1:400),]

# Train-test split
train_28 <- shuffled[1:360, ]
test_28 <- shuffled[361:400, ]

# Save train-test datasets
write.csv(train_28, "C://train_28.csv", row.names = FALSE)
write.csv(test_28, "C://test_28.csv", row.names = FALSE)

# Done!
print("Done!")