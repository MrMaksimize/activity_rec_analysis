# Understanding the Assignment
## Resources Used
* [FAQ](https://class.coursera.org/getdata-014/forum/thread?thread_id=30)
* [Tidy Data](https://class.coursera.org/getdata-014/forum/thread?thread_id=31)
* [Data Wrangling Cheatsheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
* [README advice](https://class.coursera.org/getdata-014/forum/thread?thread_id=213)
* [Codebook](https://class.coursera.org/getdata-014/forum/thread?thread_id=137)
* [Notes](http://sux13.github.io/DataScienceSpCourseNotes/3_GETDATA/Getting_and_Cleaning_Data_Course_Notes.html#reading-from-other-sources)
* [Reshape Guide](http://seananderson.ca/2013/10/19/reshape.html)

## Tidy Data Principles
  1. Each variable forms a column.
  2. Each observation forms a row.
  3. Each type of observational unit forms a table.

## Objectives
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* Both generated data sets comply to the tidy data principles:

## Files to Be Used
(based on this [FAQ](https://class.coursera.org/getdata-014/forum/thread?thread_id=30))

* `subject_test.txt`
* `y_test.txt`
* `X_test.txt`
* `subject_train.txt`
* `y_train.txt`
* `X_train.txt`
* `features.txt`
* `activity_labels.txt`

# Setup
## Environment
* OS Version: `MacOSX Yosemite 10.10.3`
* R Version: `3.1.3 (2015-03-09)`
* R Studio Version: `0.98.1102`

## Package Dependencies
? Try to install them automatically?
* `dplyr`
* `tidyr`

# Steps and Methodology
## Overview
* Read in files Common to both Test and Train.
* Combine and prepare the test and train datasets separately.
* Combine test and train data.

### Read In Files Common to Both Test and Train.
* `activity_labels.txt`
    * contains data referencing `activity id` to activity name.
* `features.txt`
    * contains data referencing `feature_id` to feature name

I read those into a list so they're easier to use.

### Combining Data Inside Test and Train
Before combining testing and training datasets, we need to first combine 
data within those folders into one, creating a complete "test" dataset, and a complete "train" dataset.

*I'm using `train` below as an example, but the same is true for the `test` folder.*

#### Understanding the test/train data.
There are three files here:

* `y_train`
    - Label linking the datasets to activity id.
* `X_train`
    - Training data, arranged in columns in the order described in features.txt
* `subject_train`
    - The id of subject (1-30)

In addition, I made several more observations:

* `features.txt` from above has the same number of rows as there are columns in `X_train`.  It makes sense for them to be column labels.
* `y_train` has the same number of rows as `X_Train` which tells me they are corresponding and need to be combined with `X_Train`. I had trouble figuring out what it was at first, I read them in and did a summary.  Once I realized that the range was `1-6` I realized they were references to activity labels (activity_labels.txt).
* `y_train` also corresponds to the `activity_labels`.

#### Pre-Processing of Test and Train Data
Perform the following for each dataset (test and train), separately:
* `loadSetData <- function(setName)`
    - load in `y_` activity data
    - load in `subjects_` subject data
    - load in (cached) the `X_` data -- this is the main dataset
    - return list with loaded data.
* `prepSetData <- function(setData, setName) {`
    - Take subjects, a 1 col df
    - Take set_activities.  Join them with `activity_labels`
    - Prepare X_data for merging
        + create a logic vector that returns true is value contains "std" or "mean"
        + apply logic vector to features_labels
        + use the filtered list of IDs now available to extract only the needed columns from X_data
        + set the colnames of X_data to the feature labels from the filtered dataframe of features.
    - Merge it all together
        + merge the set activities and labels we generated above into the subjects list
        + use mutate to create another colum called `data_type`. Once the merge is made, we'll know if the data came from training or testing.
        + merge X_data

# Combining Test and Train.
Once

# Random Notes
#### Caching Mechanism
It was driving me crazy loading in the large files each time, so I created some cache variables in the global space, and a function

