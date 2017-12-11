#install.packages("Mass")
library("MASS")

data("Boston")


normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }
Boston_n <- as.data.frame(lapply(Boston[2:14], normalize))


median_value = median(Boston[,1])
for(i in  1:nrow(Boston)) {
  if(Boston[i,1] < median_value) {
    Boston[i,1] = "below"
  } else {
    Boston[i,1] = "above"
  }
}

#install.packages("caret")
library(caret)
library(class)

folds <- createFolds(Boston$crim, k = 10, list = TRUE, returnTrain = FALSE)
for(n in 1:length(folds)) {
  train_data <- as.data.frame(lapply(folds[n], function(ind, dat) dat[-ind,], dat = Boston_n))
  validation_data <- as.data.frame(lapply(folds[n], function(ind, dat) dat[ind,], dat = Boston_n))
  classes_train <- as.data.frame(lapply(folds[n], function(ind, dat) dat[-ind], dat = Boston$crim))[,1]
  classes_validation <- as.data.frame(lapply(folds[n], function(ind, dat) dat[ind], dat = Boston$crim))[,1]
  k_results <- data.frame(k=numeric(0),accuracy=numeric(0),precision=numeric(0),sensitivity=numeric(0),specificity=numeric(0))
  for(i in 1:10){
    test_results = knn(train = train_data, test = validation_data,cl = classes_train, k=i)
    confusion_matrix = confusionMatrix(test_results,classes_validation,positive="below")
    k_results[i,1] = i
    k_results[i,2] = confusion_matrix$overall["Accuracy"]
    k_results[i,3] = confusion_matrix$byClass["Precision"]
    k_results[i,4] = confusion_matrix$byClass["Sensitivity"]
    k_results[i,5] = confusion_matrix$byClass["Specificity"]
  }
  cat(paste("\nFold\t ", n, "\nk\t ", which(k_results$accuracy == max(k_results$accuracy))[1], "\nError\t ", 1 - max(k_results$accuracy)[1],"\nAccuracy ",max(k_results$accuracy)[1],"\n--------"))
  
}
