# Final Course Project: Getting and Cleaning Data

The repository contains all submission files for the final "Getting and Cleaning Data" course. The CodeBook describes the variables, the data, and any transformations or work that was performed to clean up the data.

## Script

The "run_analysis.R" script performs the following actions:
* Merge the training and the test sets to create one data set.
* Extract only the measurements on the mean and standard deviation for each measurement. 
* Use descriptive activity names to name the activities in the data set
* Appropriately label the data set with descriptive variable names. 
* Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Variables

In order to familiarize yourself with the dataset, please refer to the README.txt and features_info.txt file in the original dataset folder.

## Data Transformations

At the very beginning, the script merges the different raw data files and thereby create ONE original dataset.

* Import activity labels and feature names, and define columns names
* Import TRAIN dataset, define column names, and column-bind datasets
* Import TEST dataset, define column names, and coloumn-bind datasets
* Combine (row-bind) both TRAIN and TEST dataset

Next, the script extracts only the measurements on the mean and standard deviation for each measurement. In other words, the script keeps the columns "activityID", "subjectID" and all columns that contain MEAN and STANDARD DEVIATION measurements. All other columns will be omitted.

* Column "activityID" will be kept
* Column "subjectID" will be kept
* Columns containing "mean" (excluding "meanFreq") will be kept
* Columns containing "std" will be kept

Subsequently, the script relabels the data set with descriptive variable names. In order to do so, the script replaces a variety of text strings in the column headers with more descriptive names.

* "-mean()" will be replaced with "Mean"
* "-std()" will be replaced with "StdDev"
* "t" at the beginning of header names will be replaced with "time"
* "f" at the beginning of header names will be replaced with "freq"
* "Mag" will be replaced with "Magnitude"
* "Acc" will be replaced with "Acceleration"
* "Gyro" will be replaced with "Gyroscope"
* The header name "BodyBody" contains a duplicate and will be replaced with "Body"

In the last step, the mean of each variable for each activity and each subject is being calculated through aggregation.


## Tidy Dataset

The final tidy dataset will be called "tidyDataset.csv". The CSV file will be separated by "," (comma) and will not contain any row names. The dimension of the final tidy dataset is [180, 69], equal to 180 rows and 69 columns.

