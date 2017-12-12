rm(list=ls())

# Load MXNet
cran <- getOption("repos")
cran["dmlc"] <- "https://s3-us-west-2.amazonaws.com/apache-mxnet/R/CRAN/"
options(repos = cran)
install.packages("mxnet",dependencies = T)
require(mxnet)

# Train test datasets
train <- read.csv("train_64.csv")
test <- read.csv("test_64.csv")

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
# 1st convolutional layer 5x5 kernel and 20 filters.
#conv_1 <- mx.symbol.Convolution(data= data, kernel = c(5,5), num_filter = 20)
#tanh_1 <- mx.symbol.Activation(data= conv_1, act_type = "tanh")
#pool_1 <- mx.symbol.Pooling(data = tanh_1, pool_type = "max", kernel = c(2,2), stride = c(2,2))
# 2nd convolutional layer 5x5 kernel and 50 filters.
#conv_2 <- mx.symbol.Convolution(data = pool_1, kernel = c(5,5), num_filter = 50)
#tanh_2 <- mx.symbol.Activation(data = conv_2, act_type = "tanh")
#pool_2 <- mx.symbol.Pooling(data = tanh_2, pool_type = "max", kernel = c(2,2), stride = c(2,2))
# 1st fully connected layer
#flat <- mx.symbol.Flatten(data = pool_2)
#fcl_1 <- mx.symbol.FullyConnected(data = flat, num_hidden = 500)
#tanh_3 <- mx.symbol.Activation(data = fcl_1, act_type = "tanh")
# 2nd fully connected layer
#fcl_2 <- mx.symbol.FullyConnected(data = tanh_3, num_hidden = 4)

# Might be a good idea to have the #hiddenNodes in first hidden layer 400, 40 in the secon one and 4 in the thrid one

fc1 <- mx.symbol.FullyConnected(data, name="fc1", num_hidden=25)
act1 <- mx.symbol.Activation(fc1, name="relu1", act_type="relu")
#fc2 <- mx.symbol.FullyConnected(act1, name="fc2", num_hidden=64)
#act2 <- mx.symbol.Activation(fc2, name="relu2", act_type="relu")
fc3 <- mx.symbol.FullyConnected(act1, name="fc3", num_hidden=4)
#softmax <- mx.symbol.SoftmaxOutput(fc3, name="sm")

# Output
NN_model <- mx.symbol.SoftmaxOutput(data = fc3)

# Set seed for reproducibility
mx.set.seed(100)

# Device used. Sadly not the GPU :-(
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

#model <- mx.mlp(train_array, train_y, hidden_node=10, out_node=2, out_activation="softmax",
#                num.round=20, array.batch.size=15, learning.rate=0.07, momentum=0.9, 
#                eval.metric=mx.metric.accuracy)


# Test on 143 samples
predict_probs <- predict(model, test_array)
predicted_labels <- max.col(t(predict_probs)) - 1
table(test__[,1], predicted_labels)
sum(diag(table(test__[,1], predicted_labels)))/143

##############################################
# Output
##############################################
#   predicted_labels
#      0   1
#  0  83  47
#  1  34 149
#
#
# [1] 0.7412141
#