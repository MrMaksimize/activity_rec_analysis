# Auto Install Packages
list.of.packages <- c("dplyr", "tidyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

## Bring in the libs.
library(dplyr)
library(tidyr)

## Set WD to the location of file
setwd(dirname(parent.frame(2)$ofile))

## Bring in the helpers file.
source("./helpers.R")

## Download the data and unzip, if needed.
dlData()

## Read in data common to both test and train.
commonData <- loadCommonData()

## Cache raw version of X data
if (!exists('train_cache')) 
  train_cache <- loadSetData("train")

if (!exists('test_cache')) 
  test_cache <- loadSetData("test")


## Load training set
train_set <- train_cache
## Load the test set
test_set <- test_cache

## Prepare each dataset separately
prepped_train <- prepSetData(train_set, "train")
prepped_test <- prepSetData(test_set, "test")

## Finally, combine the two rows.
prepped_complete <- bind_rows(prepped_train, prepped_test)


## Create second, independent grouped set.
prepped_summarized <- prepped_complete %>%
  group_by(activity_id, activity_label, subject_id, feature_name) %>%
  summarise(feature_mean = mean(feature_value))

write.table(prepped_summarized, "grouped_means.txt", row.names = TRUE)




