#install.packages("Mass")
library("MASS")

data("Boston")

set.seed(1234)

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

Boston_train <- Boston_n[1:354,]
Boston_test <- Boston_n[355:506,]
Boston_train_labels <- Boston[1:354, 1]
Boston_test_labels <- Boston[355:506, 1]

#install.packages("caret")
library(caret)
library(class)

k_results <- data.frame(k=numeric(0),accuracy=numeric(0),precision=numeric(0),sensitivity=numeric(0),specificity=numeric(0))
for(i in 1:10){
  test_results = knn(train = Boston_train, test = Boston_test,cl = Boston_train_labels, k=i)
  confusion_matrix = confusionMatrix(test_results,Boston_test_labels,positive="below")
  k_results[i,1] = i
  k_results[i,2] = confusion_matrix$overall["Accuracy"]
  k_results[i,3] = confusion_matrix$byClass["Precision"]
  k_results[i,4] = confusion_matrix$byClass["Sensitivity"]
  k_results[i,5] = confusion_matrix$byClass["Specificity"]
}

print("Highest accuracy:")
print(paste("k=",which(k_results$accuracy == max(k_results$accuracy)), "(",max(k_results$accuracy),")"))
print("Highest precision:")
print(paste("k=",which(k_results$precision == max(k_results$precision)),"(",max(k_results$precision),")"))
print("Highest sensitivity:")
print(paste("k=",which(k_results$sensitivity == max(k_results$sensitivity)), "(",max(k_results$sensitivity),")"))
print("Highest specificity:")
print(paste("k=",which(k_results$specificity == max(k_results$specificity)), "(",max(k_results$specificity),")"))

accurate_k = which(k_results$accuracy == max(k_results$accuracy))

for(n in 1:11) {
  k_results <- data.frame(k=numeric(0),accuracy=numeric(0),precision=numeric(0),sensitivity=numeric(0),specificity=numeric(0))
  for(i in 1:ncol(Boston_train)){
    train_data = Boston_train[,-i]
    train_test = Boston_test[,-i]
    test_results = knn(train = train_data, test = train_test,cl = Boston_train_labels, k=accurate_k)
    confusion_matrix = confusionMatrix(test_results,Boston_test_labels,positive="below")
    k_results[i,1] = i
    k_results[i,2] = confusion_matrix$overall["Accuracy"]
  }
  column_to_remove = which(k_results$accuracy == max(k_results$accuracy))
  if(length(column_to_remove) > 1) {
    column_to_remove = column_to_remove[1]
  }
  print(paste("Removed: ", colnames(Boston_train)[column_to_remove]))
  
  print("Highest accuracy:")
  print(max(k_results$accuracy))
  
  Boston_train = Boston_train[,-column_to_remove]
  Boston_test = Boston_test[,-column_to_remove]
  
}
print(colnames(Boston_train))