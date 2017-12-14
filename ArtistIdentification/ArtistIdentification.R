rm(list=ls())

# Load MXNet
cran <- getOption("repos")
cran["dmlc"] <- "https://s3-us-west-2.amazonaws.com/apache-mxnet/R/CRAN/"
options(repos = cran)
install.packages("mxnet",dependencies = T)
require(mxnet)

# Train test datasets
train <- read.csv("train_64.csv") # 70% = 331 samples
test <- read.csv("test_64.csv") # 30% = 143 samples

# Fix train and test datasets
train <- data.matrix(train)
train_x <- t(train[,-1])
train_y <- train[,1]
train_array <- train_x
dim(train_array) <- c(64, 64, 1, ncol(train_x))

test__ <- data.matrix(test)
test_x <- t(test[,-1])
test_y <- test[,1]
test_array <- test_x
dim(test_array) <- c(64, 64, 1, ncol(test_x))

# Model
data <- mx.symbol.Variable('data')
fc1 <- mx.symbol.FullyConnected(data, name="fc1", num_hidden=25)
act1 <- mx.symbol.Activation(fc1, name="relu1", act_type="relu")
fc3 <- mx.symbol.FullyConnected(act1, name="fc3", num_hidden=4)

# Output
NN_model <- mx.symbol.SoftmaxOutput(data = fc3)

# Set seed for reproducibility
mx.set.seed(100)

device <- mx.cpu()

# Train on 331 samples
model <- mx.model.FeedForward.create(NN_model, X = train_array, y = train_y,
                                     ctx = device,
                                     num.round = 300,
                                     array.batch.size = 100,
                                     learning.rate = 0.05,
                                     momentum = 0.09,
                                     wd = 0.00001,
                                     eval.metric = mx.metric.accuracy,
                                     epoch.end.callback = mx.callback.log.train.metric(100))

# Test on 143 samples
predict_probs <- predict(model, test_array)
predicted_labels <- max.col(t(predict_probs)) - 1
table(test__[,1], predicted_labels)
sum(diag(table(test__[,1], predicted_labels)))/143
