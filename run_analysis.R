## PROJECT ASSIGNMENT
library(data.table)
library(dplyr)
library(tidyr)
library(lubridate)

#       1. It creates a folder called 'data' if it doesn't exist
if(!file.exists("data")){
        dir.create("data")
}
# it downloads and extract the dataset 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/DataSet.zip", method = "curl")
unzip(zipfile="./data/DataSet.zip",exdir="./data")
path <- file.path("./data" , "UCI HAR Dataset")

##      2. Merges the training and the test sets to create one data set.
## read data (test and train) files
train_set <- read.table(file.path(path, "train", "X_train.txt"))
test_set <- read.table(file.path(path, "test", "X_test.txt"))

## concatenate the data by rows
AllSet <- rbind(train_set, test_set)
features <- read.table(file.path(path, "features.txt"))
names(AllSet) <- features$V2

##      3. Extracts only the measurements on the mean and standard deviation for each measurement.
MeanStdData  <- grepl("(std\\(\\)|mean\\(\\))",names(AllSet))
filteredMeanStdSet <- AllSet[, which(MeanStdData == TRUE)]

## 4. Uses descriptive activity names to name the activities in the data set

# combine the labels and Subjects files by column
## read subject files
train_subject <- read.table(file.path(path, "train", "subject_train.txt"))
test_subject <- read.table(file.path(path, "test", "subject_test.txt"))

## read activities files
train_labels <- read.table(file.path(path, "train", "y_train.txt"))
test_labels <- read.table(file.path(path, "test", "y_test.txt"))

AllSubjects <- rbind(train_subject, test_subject)
AllLabels <- rbind(train_labels, test_labels)

## set the name of the variables
names(AllLabels) <- c("Activity")
names(AllSubjects) <- c("Subject")

Labels_Subjects <- cbind(AllLabels, AllSubjects)
AllMeasures <- cbind(filteredMeanStdSet, Labels_Subjects)

activities_labels <- read.table(file.path(path, "activity_labels.txt"))
factor_activity <- factor(AllMeasures$Activity)
levels(factor_activity) <- activities_labels$V2
AllMeasures$Activity <- factor_activity

## 4. Appropriately labels the data set with descriptive variable names.

names(AllMeasures) <- gsub("^t", "time", names(AllMeasures))
names(AllMeasures) <- gsub("^f", "frequency", names(AllMeasures))
names(AllMeasures) <- gsub("Acc", "Acceleration", names(AllMeasures))
names(AllMeasures) <- gsub("Gyro", "Gyroscope", names(AllMeasures))
names(AllMeasures) <- gsub("Mag", "Magnitude", names(AllMeasures))

## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.\

library(reshape2)

newData <- melt(AllMeasures, id = c("Activity", "Subject"))
# check the data
head(newData)
tail(newData)
## cast the newData cast(data, formula, fucntion)
tidy_data <- dcast(newData, Activity + Subject ~ variable, mean)
# write the data set in a txt file
write.table(tidy_data, "tidydataset.txt", sep="\t", row.names = FALSE)

