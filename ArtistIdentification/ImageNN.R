# Simple neural network

#install.packages("magick")
library(magick)

#cran <- getOption("repos")
#cran["dmlc"] <- "https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/CRAN/"
#options(repos = cran)
#install.packages("mxnet")
library(mxnet)

# Setup training and test data
#download.file('https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/data/mnist_csv.zip', destfile = 'mnist_csv.zip')
#unzip('mnist_csv.zip', exdir = '.')
train <- read.csv("DegasData/red.csv", header=TRUE)
test <- read.csv("DegasData/redTest.csv", header=TRUE)
train <- data.matrix(train)
test <- data.matrix(test)

train.x <- train[,-1]
train.y <- train[,1]

train.x <- t(train.x/255)
test <- t(test/255)

# Setup neural network layers
input.layer <- mx.symbol.Variable("data")
hidden.layer.1 <- mx.symbol.FullyConnected(input.layer, name="hidden.layer.1", num_hidden=128)
hidden.activation.1 <- mx.symbol.Activation(hidden.layer.1, name="hidden.activation.1", act_type="relu")
hidden.layer.2 <- mx.symbol.FullyConnected(hidden.activation.1, name="hidden.layer.2", num_hidden=64)
hidden.activation.2 <- mx.symbol.Activation(hidden.layer.2, name="hidden.activation.2", act_type="relu")
output.layer <- mx.symbol.FullyConnected(hidden.activation.2, name="output.layer", num_hidden=2)
output <- mx.symbol.SoftmaxOutput(output.layer, name="output")

# Train neural network
device.context <- mx.cpu()
mx.set.seed(1234)
model <- mx.model.FeedForward.create(output, X = train.x, y = train.y, 
                                     ctx = device.context, num.round = 5,
                                     array.batch.size = 100, learning.rate = 0.07, 
                                     momentum = 0.9, eval.metric = mx.metric.accuracy,
                                     initializer = mx.init.uniform(0.07),
                                     batch.end.callback = mx.callback.log.train.metric(100))

# Predict
preds <- predict(model, test)
dim(preds)

pred.label <- max.col(t(preds)) - 1
table(pred.label)

submission <- data.frame(ImageId=1:ncol(test), Label=pred.label)
write.csv(submission, file='submission.csv', row.names=FALSE, quote=FALSE)