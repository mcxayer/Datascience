
# Question 1

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


# Question 2

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


# Question 4
# https://blogs.uoregon.edu/rclub/2016/04/05/plotting-your-logistic-regression-models/
# https://www.google.dk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwi5r6Cy6oHYAhVLzqQKHb02CnAQFggpMAA&url=https%3A%2F%2Fwww.jstatsoft.org%2Farticle%2Fview%2Fv032i01%2Fv32i01.pdf&usg=AOvVaw1P6gTDO77we38_vB43kr3f

variables <- c("Accident", "BloodAlcoholLevel")

install.packages("ggplot2")
library("ggplot2", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")

ggplot(aes(x=dataSimple$Accident,y=dataSimple$BloodAlcoholLevel))+geom_point()

qplot(BloodAlcoholLevel, Socioeconomic_status, data=dataSimple, color = "Red")


# Question 6

install.packages("forecast")
library("lda")

Data_Car_accidents_17 <- read_excel("~/Documents/DataScience/Assignment/Data_Car_accidents.xlsx", sheet = "Data_17_subjects")

score <- predict(multinomModelCon, newdata=Data_Car_accidents_17)
actual <- Data_Car_accidents_17$Accident

library("caret", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")
confusionMatrix(score, actual)

