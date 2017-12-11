#install.packages("MASS")
library(MASS)

#install.packages("caret")
library(caret)

set.seed(1234)

printStats <- function(predictions, validation_data) {
  cat(paste("Fold", i, "\n"))
  model.error <- mean(predictions != validation_data$crim)
  cat(paste("Error","\t\t", model.error, "\n"))
  model.accuracy <- 1 - model.error
  cat(paste("Accuracy", "\t",model.accuracy, "\n"))
}

data <- Boston
# put in console to determine amount of missing values: sapply(data,function(x)sum(is.na(x)))

median_value = median(data[,1])
for(i in 1:nrow(data)) {
  if(data[i,1] < median_value) {
    data[i,1] = 0
  } else {
    data[i,1] = 1
  }
}

folds <- createFolds(data$crim, k = 10, list = TRUE, returnTrain = FALSE)

for(i in 1:length(folds)) {
  train_data <- as.data.frame(lapply(folds[i], function(ind, dat) dat[-ind,], dat = data))
  validation_data <- as.data.frame(lapply(folds[i], function(ind, dat) dat[ind,], dat = data))
  
  names(train_data) <- names(data)
  names(validation_data) <- names(data)
  
  model <- glm(crim~., data=train_data, family = binomial())
  model.predict <- predict(model, validation_data, type="response")
  model.predict.binary <- ifelse(model.predict > 0.5, 1, 0)
  
  cat(paste("--------------", "\n"))
  printStats(model.predict.binary, validation_data)
}
cat(paste("--------------", "\n"))

#data_index <- createDataPartition(data$crim, p=0.65, list=FALSE)
#train_data <- data[data_index,]
#validation_data <- data[-data_index,]

# put in console to get summary: summary(logistic_model)