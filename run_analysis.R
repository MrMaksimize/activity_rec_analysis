
## Set WD

setwd("/Users/MrMaksimize/Code/R/coursework/coursera_getdata_14/project")

if (!file.exists('./data')) {
  if (!file.exists('har_data.zip')) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile="./har_data.zip", method="curl")
  }
  unzip("./har_data.zip", exdir = ".", overwrite = TRUE)
  file.rename("./UCI HAR Dataset", "./data")
}
training <- read.csv('data/train/')