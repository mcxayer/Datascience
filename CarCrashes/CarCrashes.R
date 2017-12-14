
# Task 1

library(readxl)
Data_Car_accidents <- read_excel("~/Documents/DataScience/Assignment/Data_Car_accidents.xlsx", sheet = "Data_196_subjects")

install.packages("tableone")
library("tableone", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")

listVar <- c("Gender", "Accident", "Age", "AgeGap", "Socioeconomic_status", "BloodAlcoholLevel")
catVars <- c("Gender", "Socioeconomic_status", "AgeGap")

# Total Population
totalPopulation <- CreateTableOne(vars = listVar, data = Data_Car_accidents, factorVars = catVars)
totalPopulation

# Removing Accident from list of variables 
listVar <- c("Gender", "Age",  "AgeGap", "Socioeconomic_status", "BloodAlcoholLevel")
populationByAccident <- CreateTableOne(listVar, Data_Car_accidents, catVars, strata = c("Accident"))
populationByAccident


# Task 2

library("nnet")

# Model relating BloodAlcoholLevel and Accidents 
variables <- c("Accident","BloodAlcoholLevel")
data <- Data_Car_accidents[variables]
multinomModel <- multinom(Accident ~ ., data=data)
summary(multinomModel)

# Model relating BloodAlcoholLevel and Accidents with confounding variables
variablesCon <- c("Gender", "Accident", "Age", "BloodAlcoholLevel")
dataCon <- Data_Car_accidents[variablesCon]
multinomModelCon <- multinom(Accident ~ ., data=dataCon)
summary(multinomModelCon)


# Task 6

install.packages("forecast")
library("forecast")
library("lda")

Data_Car_accidents_17 <- read_excel("~/Documents/DataScience/Assignment/Data_Car_accidents.xlsx", sheet = "Data_17_subjects")

score <- predict(multinomModelCon, newdata=Data_Car_accidents_17)
actual <- Data_Car_accidents_17$Accident

library("caret", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")
confusionMatrix(score, actual)

