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

## Make it wonderful.
prepped <- prepSetData(train_set, "train")
prepped





