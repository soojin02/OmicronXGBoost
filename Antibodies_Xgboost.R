rm(list = ls())
library(data.table)
library(caret)
library(lubridate)
set.seed(77)

# Prep Data for Modeling
#read csv file
train <- fread("./project/volume/data/raw/Stat_380_train.csv")
test <- fread("./project/volume/data/raw/Stat_380_test.csv")
covar <- fread("./project/volume/data/raw/covar_data.csv")
example_sub <- fread("./project/volume/data/raw/Example_Sub.csv")

sample_id <- test$sample_id
test$ic50_Omicron <- 0
# Remove 'sample_id' column
train <- subset(train, select = -c(sample_id))
test <- subset(test, select = -c(sample_id))
#take target 'ic50_Omicron' from train 
train_y <- train$ic50_Omicron
# missing values in train data= 2
missing_index <- which(is.na(train), arr.ind = TRUE)
train[missing_index] <- 2
# missing values in test data= 2
missing_index <- which(is.na(test), arr.ind = TRUE)
test[missing_index] <- 2

# Create dummy variables
dummies <- dummyVars(ic50_Omicron ~ ., data = train)
saveRDS(dummies, "./project/volume/models/dummies")
train <- predict(dummies, newdata = train)
test <- predict(dummies, newdata = test)

# Remove 'dose_3mRNA1272' column from the training set
train <- subset(train, select = -c(dose_3mRNA1272))
# data table
train <- data.table(train)
test <- data.table(test)
# matrix
train <- as.matrix(train)
test <- as.matrix(test)


#write interim csv
fwrite(train, "./project/volume/data/interim/train.csv")
fwrite(test, "./project/volume/data/interim/test.csv")
