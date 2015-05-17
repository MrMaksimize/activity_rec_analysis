library(dplyr)

## Set WD to the location of file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
print(getwd())

getData <- function() {
  if (!file.exists('./data')) {
    if (!file.exists('har_data.zip')) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile="./har_data.zip", method="curl")
    }
    unzip("./har_data.zip", exdir = ".", overwrite = TRUE)
    file.rename("./UCI HAR Dataset", "./data")
  }
}



## Download the data and unzip, if needed.
getData()

## Read in data common to both test and train.

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



# Training data only
train_activities <- read.table(
  "./data/train/y_train.txt",
  header = FALSE, 
  sep = " "
);

train_subjects <- read.table(
  "./data/train/subject_train.txt",
  header = FALSE, 
  sep = " "
);

## Use a caching mechanism here. (TODO abstract to fxn, use proper caching)
if (!exists("train_set")) {
  train_set <- read.table(
    "./data/train/X_train.txt",
    header = FALSE
  )
}



