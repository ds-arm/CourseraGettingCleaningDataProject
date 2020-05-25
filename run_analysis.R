### Load the libraries needed
library(stringr)
library(dplyr)

### Set up the working directory
# Assume that this R script will be executed either:
#  - In the 'UCI HAR Dataset' directory, where the structure is unchanged 
#       from the zip file contents
#  - In a directory where the 'UCI HAR Dataset' is a sub-directory, again 
#       unchanged from the structure in the zip file.
#  - Test to see which is the case and change working directory as required.
#  - If neither, print a message and exit.

desiredDir <- 'UCI HAR Dataset'
currDirPath <- getwd()
# Split path into directories - last directory in list is the one to test
dirParts <- strsplit(currDirPath, '/')[[1]]
currDir <- dirParts[length(dirParts)]
if (currDir != desiredDir) {
    if (desiredDir %in% dir()) {
        print(paste0('Changing working directory to ', desiredDir), quote=FALSE)
        setwd(desiredDir)
    }
    else {
        print(paste0(
            'Data directory not found - change to directory \"', 
            desiredDir, '\" and try again'), 
            quote=FALSE
        )
        stop()
        
    }
}

### Read in the data and labels from the files in the directories

## Source the labels for the 561 features from the file 'features.txt'
featureLabelsFile <- 'features.txt'
featureLabels <- read.table(featureLabelsFile)
featureLabels <- featureLabels$V2

## Read in data from the test directory
#  Set filenames for subjects, activity ('y') and the measurement data ('X') 
testSubFile <- 'test/subject_test.txt'
testYfile <- 'test/y_test.txt'
testXfile <- 'test/X_test.txt'

# Read in the test data from the files and label the columns
testSubj <- read.table(testSubFile)
names(testSubj) <- c('subject')

testActy <- read.table(testYfile)
names(testActy) <- c('activity')

testX <- read.table(testXfile)
names(testX) <- featureLabels

# Use column bind to combine subject, activity and measurements into one object
testComplete <- cbind(testSubj, testActy, testX)

# Remove the individual datasets
rm(list=c('testSubj', 'testActy', 'testX'))

## Read in data from the train directory
#  set filenames for subjects, activity ('y') and the measurement data ('X') 
trainSubFile <- 'train/subject_train.txt'
trainYfile <- 'train/y_train.txt'
trainXfile <- 'train/X_train.txt'

# Read in the test data from the files and label the columns
trainSubj <- read.table(trainSubFile)
names(trainSubj) <- c('subject')

trainActy <- read.table(trainYfile)
names(trainActy) <- c('activity')

trainX <- read.table(trainXfile)
names(trainX) <- featureLabels

# Use column bind to combine subject, activity and measurements into one object
trainComplete <- cbind(trainSubj, trainActy, trainX)

# Remove the individual datasets
rm(list=c('trainSubj', 'trainActy', 'trainX'))

## Combine test and training data so we have one data.frame with complete data 
dataComplete <- rbind(testComplete, trainComplete)
rm(list=c('testComplete', 'trainComplete'))

### Filter the data down to the desired columns based on their names
## Identify the columns that are means based on the presence of 'mean()'
#  (Note - this deliberately omits columns with meanFreq in the label)
meanVars <- grep('mean\\(\\)', featureLabels, value=TRUE)

## Identify the columns that are means based on the presence of 'std()'
stdVars <- grep('std\\(\\)', featureLabels, value=TRUE)

## Combine these but alternate between mean and std
#  This gives columns ordered: V1-mean(), V1-std(), V2-mean(), V2-std(), etc
#  This presentation brings together mean and std for each variable measured
reqdCols <- c(rbind(meanVars, stdVars))

# Add columns for subject and activity so they are the first two columns
reqdCols <- c('subject', 'activity', reqdCols)

## Use these columns to subset the full dataset down to that required
reqdData <- dataComplete[,reqdCols]
rm(dataComplete)

### This object contains the measurement data that is required

### Next stages modify columns and their labels to improve use in analysis

##  Replace numerical codes for 'activity' with descriptive labels as supplied
# Use the associations in 'activity_labels.txt' to give descriptive labels 
# to the activities in the dataset
# The numerical labels are in column 'V1' in ascending order
# The descriptive labels are in column 'V2' 
actyLabelsFile <- 'activity_labels.txt'
actyLabels <- read.table(actyLabelsFile)

# In the dataset the activity column is 'int'.  Convert to 'factor' and map  
# to the descriptive labels.  
reqdData$activity <- factor(as.factor(reqdData$activity), 
                            levels=actyLabels$V1, 
                            labels=actyLabels$V2)

### Continue to modify the measurement column names to be more descriptive.  
#   Next steps:
#   - make modest changes to the variable names so they are more descriptive
#       but not too different to ensure that original meaning is not affected
#       * This includes fixing six instances where 'fBodyBody' should be 'fBody'
#           as described in 'features_info.txt'
#   - every variable for measurement of a mean ends with .mean
#   - every variable for measurement of a standard deviation ends with .std
#   - remove parentheses: '(' and ')'
#   - replace '-' with '.' and retain the axis of measurement (X,Y,Z) in names
#   - revised naming convention will be documented in the Code Book

# Practice note:  Using the current column names rather than assuming earlier 
#       variables have not been changed by code revisions
colsToClean <- names(reqdData)

# First replace error in coding labels: replace 'fBodyBody' with 'fBody'
colsToClean <- gsub('fBodyBody', 'fBody', colsToClean)

# Variables starting with 't': replace with 'time.'
colsToClean <- gsub('^t', 'time\\.', colsToClean)

# Variables starting with 'f': replace with 'freq.'
colsToClean <- gsub('^f', 'freq\\.', colsToClean)

## Modify variables with 'mean()' so '.mean' is a suffix in all cases
# First, deal with case where '-mean()-' is not at the end of the name
elsToMod <- grepl('-mean\\(\\)-', colsToClean)  # Find which elements to change
# Replace 'mean()-' with '' then paste '.mean' to end of name
colsToClean[elsToMod] <- paste0(
    gsub('mean\\(\\)-', '', colsToClean[elsToMod]), 
    '.mean'
)  

# Deal with case where variable name ends '-mean()' and replace with '.mean'
colsToClean <- gsub('-mean\\(\\)', '.mean', colsToClean)

## Modify variables with 'std()' so 'std' is a suffix in all cases
# First, deal with case '-std()-' is not at the end of the name
elsToMod <- grepl('-std\\(\\)-', colsToClean)  # Find which elements to change
# Replace 'std()-' with '' then paste '.std' to end of name
colsToClean[elsToMod] <- paste0(
    gsub('std\\(\\)-', '', colsToClean[elsToMod]), 
    '.std'
)  
# Deal with case where variable name ends '-std()' and replace with '.std'
colsToClean <- gsub('-std\\(\\)', '.std', colsToClean)

# Finally, replace the '-' with '.' which occurs with axis specific measurements
colsToClean <- gsub('-', '.', colsToClean)

# Replace the existing column names with these cleaned versions.
names(reqdData) <- colsToClean

### This has produced the tidy dataset required
#   (Note - assignment does not require this be written to file.  It is used 
#   for the next step.)
###

### Step 5 - group by (subject) AND (activity) and determine the mean 
#   of each variable
#   As the data is now 'tidy', this is well suited to chaining using 'dplyr' 
#   functions. 
meanBySubjActy <- reqdData %>% 
    group_by(subject, activity) %>% 
    summarise_all(mean)

# Write out the file as required by the assignment instructions
outFile_step5 <- 'DataCleaningProject_step5_output.txt'
write.table(meanBySubjActy, file=outFile_step5, row.names = FALSE)

print(paste0('Script completed. Output written to ', outFile_step5), quote=FALSE)