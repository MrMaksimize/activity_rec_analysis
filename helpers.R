
## Download datasets if needed.
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

## Cache loading the large files otherwise it takes too long.
# loadFileCached <- function(setName, reset = FALSE) {
#   varName <- paste0(setName, "_cache")
#   if (!exists(paste0(setName, "_cache"), where = globalenv()) || reset == TRUE) {
#     print("exists")
#     ##set_data <- read.table(paste0("./data/", setName, "/X_", setName, ".txt"), header = FALSE)
#     set_data <- data.frame(c(1:300))
#     assign(varName, set_data, pos = globalenv())
#   }
#   else
#     set_data <- get(varName, pos = globalenv())
#   
#   set_data
# }

## Load in data that's common to both test and train.
loadCommonData <- function() {
  ## Read in Activity Labels
  ## Assign column names during initial read.
  activity_labels <- read.table(
    './data/activity_labels.txt', 
    header = FALSE, 
    sep = " ",
    col.names = c("id", "activity_label")
  );
  
  ## Read in Features Labels
  ## Assign column names during initial read.
  features_labels <- read.table(
    './data/features.txt', 
    header = FALSE, 
    sep = " ",
    col.names = c("id", "feature_label")
  );
  
  list(activity_labels = activity_labels, features_labels = features_labels);
}

## Loads a single set (train / test) and all supporting files.
## Returns a list with the loaded data.
loadSetData <- function(setName) {
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
  set_data <- read.table(
    paste0("./data/", setName, "/X_", setName, ".txt"), 
    header = FALSE,
  )
  
  list(activities = set_activities, subjects = set_subjects, data = set_data);
}

prepSetData <- function(setData, setName) {
  ## First, prepare everything to merge together.
  
  ## Start the combined set with just subjects, a 1 col df.
  combinedSet <- tbl_df(setData$subjects)
  
  ## Merge set_activities with activity names.  
  setActivities <- inner_join(
    setData$activities, 
    commonData$activity_labels, 
    by = c("activity_id" = "id"), 
    copy = TRUE
  )
  
 
  ## Apply the features labels df as column names.
  ## Avoid assigning names for now since it 
  ## freaks out with duplication errors in columns.
  ## Get the features_labels subset that has the strings "mean" or "std" in them.
  ## Filter out that vector before assining it as names.
  logicVector <- grepl("std|mean",commonData$features_labels$feature_label);
  #relevantFeatures <- commonData$features_labels[logicVector, ]
  relevantFeatures <- commonData$features_labels[1:6, ]
  ## Get only the columns that match the filter in the X_ data.
  xData <- select(setData$data, relevantFeatures$id)
  ## Apply filtered labels to filtered columns.
  colnames(xData) <- relevantFeatures$feature_label
  
  ## Now we have everything.  
  ## Activity data df, subject data df and a df with X_ data 
  ## of relevant cols and labels.
  ## Lets bring it all together.
  
  
  combinedSet <- combinedSet %>%
    ## Merge the setActivities into our combined set.
    bind_cols(setActivities) %>%
    ## Create a col for holdng the type of set.
    mutate(data_type = setName) %>%
    ## Merge the X_ data and our combined set from above.
    bind_cols(xData) 
  
  combinedSet
}

## Repeats operations for both train and test datasets, separately.
## Returns a list containing a train and test dataset, ready for meging.
getSetData2 <- function(sets = c("train", "test")) {
  setList = list()
  for(setName in sets) {
    
    ## First, apply the features as column names.
    names(set_data) <- commonData$features_labels$feature_label
    
    ## Add subject trained column
    set_data$subject_id <- set_subjects$subject_id
    
    
    
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