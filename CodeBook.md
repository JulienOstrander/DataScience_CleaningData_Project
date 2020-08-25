# DataScience_CleaningData_Project
This is the project for the peer-graded assignment in the DataScience course "Getting and Cleaning Data".

## -----------------------------------------------------------------------------
[Overview]

The script performs the following tasks:

    1.  Merges the training and the test sets to create one data set.
    2.  Extracts only the measurements on the mean and standard deviation for each
        measurement.
    3.  Uses descriptive activity names to name the activities in the data set
    4.  Appropriately labels the data set with descriptive variable names.
    5.  From the data set in step 4, creates a second, independent tidy data set 
        with the average of each variable for each activity and each subject.

## -----------------------------------------------------------------------------
[Dependencies]

Requires the dplyr package (v1.0.0)

## -----------------------------------------------------------------------------
[Functions]

run_analysis()  :  Main function that performs the analysis as described above
                   Returns a data frame depending on input value "summary"
                    
                   summary = FALSE :    full set of clean but ungrouped data                                                (default)
                    
                   summary = TRUE :     summary of averages for data grouped                                                according to activity and subject

importData()    :  Internal helper function that imports the various data files 
                   into corresponding data frames in the global environment
                   
                   Uses the input variable "dataDir" as top-level folder 
                   containing the data
                   
getData()       :  helper function that imports the various data files and 
                   merges to a data frame which it returns.
                   
                   Input variables:
                   
                   what     : a string specifying whether the data to obtain is 
                              the "train" (default)  or "test" data
                   
                   xColNames: data frame with the list column headers for the 
                              561 columns in the "x" data 

## -----------------------------------------------------------------------------
[Transformations]

- Merged all y and x data from the train and test data sets
- Reduced the number of columns to show only mean and std values
- Mapped activities and subject to create the working data set
- Cleaned up the variable names:
    - removed all punctuation and white space
    - Expanded acronyms (t => time, Freq => Frequency, etc.), except "Std"
    - Ensured "camel-case" for word differentiation
    
- If "summary" is set to true in the call to run_analisys, the summarized version
  of the data is returned:
    - grouped by subject and activity
    - shows only averages for each variable according to group instead of the
      original values.

                   