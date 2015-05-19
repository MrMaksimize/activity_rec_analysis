library(dplyr)
library(reshape2)

## Set WD to the location of file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
print(getwd())

dlData <- function() {
  if (!file.exists('./data')) {
    if (!file.exists('har_data.zip')) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile="./har_data.zip", method="curl")
    }
    unzip("./har_data.zip", exdir = ".", overwrite = TRUE)
    file.rename("./UCI HAR Dataset", "./data")
  }
}

loadCommonData <- function() {
  ## Read in Features Labels
  ## Assign column names during initial read.
  activity_labels <- read.table(
    './data/activity_labels.txt', 
    header = FALSE, 
    sep = " ", 
    #row.names = 1,
    col.names = c("id", "activity_label")
  );
  
  ## Read in Features Labels
  ## Assign column names during initial read.
  features_labels <- read.table(
    'data/features.txt', 
    header = FALSE, 
    sep = " ", 
    #row.names = 1,
    col.names = c("id", "feature_label")
  );
  
  list(activity_labels = activity_labels, features_labels = features_labels);
}

## Cache loading the large files otherwise it takes too long.
loadFileCached <- function(setName, reset = FALSE) {
  varName <- paste0(setName, "_cache")
  if (nrow(get(varName)) == 0 || reset == TRUE) {
    set_data <- read.table(paste0("./data/", setName, "/X_", setName, ".txt"), header = FALSE)
    assign(varName, set_data, envir = .GlobalEnv)
  }
  else
    set_data <- get(varName)
  
  set_data
}

## Repeats operations for both train and test datasets, separately.
## Returns a list containing a train and test dataset, ready for meging.
getSetData <- function(sets = c("train", "test")) {
  setList = list()
  for(setName in sets) {
    ## Load activity data (y_) for the dataset
    set_activities <- read.table(
      paste0("./data/", setName, "/y_", setName, ".txt"),
      header = FALSE, 
      sep = " ",
      col.names = c("activity_id")
    );
    ## Load the subject data (subject_) for the dataset
    set_subjects <- read.table(
      paste0("./data/", setName, "/subject_", setName, ".txt"),
      header = FALSE, 
      sep = " ",
      col.names = c("subject_id")
    );
    
    ## Load the full set data (X_) using a caching mechanism.
    set_data <- loadFileCached(setName)
    
    ## First, apply the features as column names.
    names(set_data) <- commonData$features_labels$feature_label
    
    ## Add subject trained column
    set_data$subject_id <- set_subjects$subject_id
    
    ## Merge set_activities with activity names.  
    set_activities <- merge(set_activities, commonData$activity_labels, by.x = "activity_id", by.y = "id")
    
    ## Bind the activities data to the main set.
    set_data <- cbind(set_data, set_activities)
    
    ## Put in a marker labeling whether this is test data or 
    ## train data so we know after we merge.
    set_data$data_type <- setName
    
    set_data <- melt(set_data, id.vars = c("activity_id", "activity_label", "subject_id", "data_type"))
    setList[[setName]] <- set_data
  }
  setList
}

## Cache Variables - global
train_cache <- data.frame()
test_cache <- data.frame()

## Download the data and unzip, if needed.
dlData()

## Read in data common to both test and train.
commonData <- loadCommonData()

## Read in both sets of data and pre-format them.
## Takes forever, so don't do it twice!
#if (!exists("sets"))
#sets <- getSetData();

## Merge the training 

#combinedSets <- merge(sets$train, sets$test, by.x="a")




