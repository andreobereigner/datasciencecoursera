#############################################################################

## Course Project: Getting and Cleaning Data(coursera.org)
## Andre Obereigner
## 14 June 2014

# runAnalysis.r File Description:

# The following link contains the dataset 
# on which the following analyis will be performed: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# The following script will do the following:
# 1) Merge the training and the test sets to create one data set.
# 2) Extract only the measurements on the mean and standard deviation for each measurement. 
# 3) Use descriptive activity names to name the activities in the data set
# 4) Appropriately label the data set with descriptive variable names. 
# 5) Create a second, independent tidy data set with the average of each variable for each activity and each subject.  

#############################################################################

# Set the path to the unzipped dataset
setwd("C:/Users/Andre Obereigner/Documents/_DATA/Career/_C_DataScienceCertification/03_GettingAndCleaningData/CourseProject01/dataset")

############################
### 1) Merge the training and the test sets to create one data set.
##
#

# Import activity labels and feature names, and define columns names
activityLabels  <- read.table("activity_labels.txt", header=FALSE)
featureNames    <- read.table("features.txt")

colnames(activityLabels)  <- c("activityID", "activityType")
colnames(featureNames)    <- c("featureID", "featureName")

# Import TRAIN dataset, define column names, and column-bind datasets
subjectTrain    <- read.table("train/subject_train.txt", header=FALSE)
xTrain          <- read.table("train/X_train.txt", header=FALSE)
yTrain          <- read.table("train/y_train.txt", header=FALSE)

colnames(subjectTrain)    <- "subjectID"
colnames(xTrain)          <- featureNames[ , 2]
colnames(yTrain)          <- "activityID"

datasetTrain    <- cbind(yTrain, subjectTrain, xTrain)

# Import TEST dataset, define column names, and coloumn-bind datasets
subjectTest     <- read.table("test/subject_test.txt", header=FALSE)
xTest           <- read.table("test/X_test.txt", header=FALSE)
yTest           <- read.table("test/y_test.txt", header=FALSE)

colnames(subjectTest)    <- "subjectID"
colnames(xTest)          <- featureNames[ , 2]
colnames(yTest)          <- "activityID"

datasetTest     <- cbind(yTest, subjectTest, xTest)

# Combine (row-bind) both TRAIN and TEST dataset
datasetCombined <- rbind(datasetTrain, datasetTest)


############################
### 2) Extract only the measurements on the mean and standard deviation for each measurement. 
##
#

# Extract the column headers and create a new vector indicating whether
# the header names contain mean or standard deviation data.
columnNames     <- colnames(datasetCombined)
keepColumns     <- (grepl("activityID", columnNames) | grepl("subjectID", columnNames) | (grepl("mean", columnNames) & !grepl("meanFreq", columnNames)) | grepl("std", columnNames))

# Subset the original combined dataset with only the relevant columns
datasetCombined <- datasetCombined[keepColumns]


############################
### 3) Use descriptive activity names to name the activities in the data set
##
#

datasetCombined <- merge(datasetCombined, activityLabels, by="activityID")


############################
### 4) Appropriately label the data set with descriptive variable names.
##
#

# Get the column header names
columnNames     <- colnames(datasetCombined)

# Replace a variety of text strings in the column headers with more descriptive names
columnNames <- gsub("-mean\\(\\)", "Mean", columnNames)
columnNames <- gsub("-std\\(\\)", "StdDev", columnNames)
columnNames <- gsub("^t", "time", columnNames)
columnNames <- gsub("^f", "freq", columnNames)
columnNames <- gsub("Mag", "Magnitude", columnNames)
columnNames <- gsub("Acc", "Accelation", columnNames)
columnNames <- gsub("Gyro", "Gyroscope", columnNames)
columnNames <- gsub("BodyBody", "Body", columnNames)

# Write the new column header names back to the data.frame
colnames(datasetCombined) <- columnNames


############################
### 5) Create a second, independent tidy data set with 
### the average of each variable for each activity and each subject.
##
#

# Remove the field "activityType" from the data.frame
datasetCombined   <- datasetCombined[ , colnames(datasetCombined) != "activityType" ]

# Extract the column headers and create a new vector indicating whether
# the columns ought to be aggregated.
columnNames       <- colnames(datasetCombined)
aggregateColumns  <- !(grepl("activityID", columnNames) | grepl("subjectID", columnNames))

# Aggregate the dataset by "activityID" and "subjectID"
datasetTidy       <- aggregate(datasetCombined[ , aggregateColumns], by=list(activityID = datasetCombined$activityID, subjectID = datasetCombined$subjectID), mean)

# Add the "ActivityType" field again and sort the data.frame
datasetTidy       <- merge(datasetTidy, activityLabels, by="activityID")
datasetTidy       <- datasetTidy[order(datasetTidy$subjectID, datasetTidy$activityID) , ]

# Write the tidy dataset to a file
write.table(datasetTidy, "../tidyDataset.csv", row.names=FALSE, sep="\t")
