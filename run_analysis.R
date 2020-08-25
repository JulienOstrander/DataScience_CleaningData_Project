## ----------------------------------------------------------------------------
## run_analysis.R
##
## This my R script for the peer-graded assignment project in the "Getting and 
## Cleaning Data" course of the Data-Science Specialization.
## 
## It performs the following tasks:
## 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each
##    measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
## 
## ----------------------------------------------------------------------------

## ----------------------------------------------------------------------------
## run_analysis()
## 
## Main function that performs the analysis as described in the file header
## 
## Returns a data frame depending on input value "summary"
## 
## summary = FALSE: full set of clean but ungrouped data (default)
## summary = TRUE:  summary of averages for data grouped according to activity 
##                  and subject
##                   
## ------------------------
run_analysis <- function(summary = FALSE)
{
    dataDir <- paste0(getwd(), "\\UCI HAR Dataset")
    
    # Merge the training and the test sets to create one data set.
    mergedData <- importData(dataDir)
    
    # Extract only the measurements on the mean and standard deviation for each
    # measurement.
    cleanData <- select(mergedData, subject, activity, matches("mean|std"))
    
    # Use descriptive activity names to name the activities in the data set
    activities <- read.table( paste0( dataDir, "\\activity_labels.txt"))

    for( i in 1: nrow(cleanData) ){
        cleanData$activity[i] <- activities[cleanData$activity[i],2]
    }

    # Appropriately labels the data set with descriptive variable names
    names(cleanData) <- gsub("^t", "time", names(cleanData))
    names(cleanData) <- gsub("^f", "frequency", names(cleanData))
    names(cleanData) <- gsub("[\\(|\\)|,|-]", "", names(cleanData))
    names(cleanData) <- gsub("mean", "Mean", names(cleanData))
    names(cleanData) <- gsub("std", "Std", names(cleanData))
    names(cleanData) <- gsub("gravity", "Gravity", names(cleanData))
    names(cleanData) <- gsub("Acc", "Acceleration", names(cleanData))
    names(cleanData) <- gsub("Freq", "Frequency", names(cleanData))
    names(cleanData) <- gsub("Mag", "Magnitude", names(cleanData))
    names(cleanData) <- gsub("BodyBody", "Body", names(cleanData))
    names(cleanData) <- gsub("^B", "b", names(cleanData))
    names(cleanData) <- gsub("^G", "g", names(cleanData))
    names(cleanData) <- gsub("anglet", "angle", names(cleanData))
    
    #return the desired data
    if( summary == TRUE){
        # create a second, independent tidy data set with the average of each 
        # variable for each activity and each subject         
        groupedData <- group_by(cleanData, subject, activity )
        
        #return the summarized data
        summarise(groupedData, across(3:86, mean))
    }
    else {
        #return the full data set
        cleanData
    }

}

## ----------------------------------------------------------------------------
## importData()
## 
## Internal helper function that imports the various data files into 
## corresponding data frames in the global environment
## 
## Uses the input variable "dataDir" as top-level folder containing the data
## 
## ------------------------
importData <- function(dataDir)
{
    # store original working directory so we can restore it later then move to 
    # the specified directory where the data is located
    orgDir <- getwd()
    setwd(dataDir)
    
    # Get feature list includes time and frequency domain signals, prefixed
    # with t and f accordingly
    features <- read.table("features.txt")

    # Get train and test data
    train <- getData("train", features)
    test <- getData("test", features)

    # restore original working directory
    setwd(orgDir)
    
    # merge and return
    bind_rows(train,test)
}
## ----------------------------------------------------------------------------
## getData(what)
## 
## Internal helper function that imports the various data files and merges to
## a data frame which it returns.
## 
## Input variable:
## 
## - what:      a string specifying whether the data to obtain is the (default) 
##              "train" or "test".
## - xColNames: data frame with the list column headers for the x data
## 
## ------------------------
getData <- function(what = "train", xColNames)
{
    # get the corresponding x, y and subject data (train or test)
    x <- read.table(paste0(what,"\\X_", what, ".txt"))
    y <- read.table(paste0(what,"\\Y_", what, ".txt"))
    subject <- read.table(paste0(what,"\\subject_", what, ".txt"))

    # set appropriate column labels
    names(subject) <- "subject"
    names(y) <- "activity"
    colnames(x) <- xColNames[[2]]

    # return the merged data frame
    bind_cols(subject, y, x)
}


