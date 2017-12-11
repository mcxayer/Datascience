# Linear Discriminant Analysis with Jacknifed Prediction 
library(MASS)
data("Boston")

median_value = median(Boston[,1])
for(i in  1:nrow(Boston)) {
  if(Boston[i,1] < median_value) {
    Boston[i,1] = 0
  } else {
    Boston[i,1] = 1
  }
}

set.seed(1234)

folds <- createFolds(Boston$crim, k = 10, list = TRUE, returnTrain = FALSE)
for(i in 1:length(folds)) {
  train_data <- as.data.frame(lapply(folds[i], function(ind, dat) dat[-ind,], dat = Boston))
  validation_data <- as.data.frame(lapply(folds[i], function(ind, dat) dat[ind,], dat = Boston))
  names(train_data) <- names(Boston)
  names(validation_data) <- names(Boston)
  
  test.lda <- lda(crim ~ ., data=train_data)
  test_pred.lda =predict(test.lda, Boston)
  cat(paste("\nFold", i, "\n"))
  test.lda.error <- mean(test_pred.lda$class != validation_data$crim)
  cat(paste("Error","\t\t", test.lda.error, "\n"))
  test.lda.accuracy <- 1 - test.lda.error
  cat(paste("Accuracy", "\t",test.lda.accuracy, "\n"))
  cat("------------------")
}