# Getting Started
## Objectives
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* [FAQ](https://class.coursera.org/getdata-014/forum/thread?thread_id=30)
* [Tidy Data](https://class.coursera.org/getdata-014/forum/thread?thread_id=31)
* [README advice](https://class.coursera.org/getdata-014/forum/thread?thread_id=213)
* [Codebook](https://class.coursera.org/getdata-014/forum/thread?thread_id=137)
* [Notes](http://sux13.github.io/DataScienceSpCourseNotes/3_GETDATA/Getting_and_Cleaning_Data_Course_Notes.html#reading-from-other-sources)
* [Reshape Guide](http://seananderson.ca/2013/10/19/reshape.html)
## Environment
OS Version
R Version
R Studio Version
## Package Deps
? Try to install them automatically?
## Files to Be Used
* `subject_test.txt`
* `y_test.txt`
* `X_test.txt`
* `subject_train.txt`
* `y_train.txt`
* `X_train.txt`
* `features.txt`
* `activity_labels.txt`

## Read In Files Common to Both Test and Train.
* `activity_labels.txt`
    * contains data referencing `activity id` to activity name.
* `features.txt`
    * contains data referencing `feature_id` to feature name

I read those into a list so they're easier to use.

## Combining Data Inside Test and Train
#### Some Notes
Before combining testing and training datasets, we need to first combine 
data within those folders into one, creating a complete "test" dataset, and a complete "train" dataset.

*I'm using `train` below as an example, but the same is true for the `test` folder.*

First, it was unclear from the README what `y_train` were.  I read them in and did a summary.  Once I realized that the range was `1-6` I realized they were references to activity labels (activity_labels.txt).


There are three files here:
* `y_train`
    - Label linking the datasets to activity id.
* `X_train`
    - Training data, arranged in columns in the order described in features.txt
* `subject_train`
    - The id of subject (1-30)

#### A few more observations
* `features.txt` from above has the same number of rows as there are columns in `X_train`.  It makes sense for them to be column labels.
* `y_train` has the same number of rows as `X_Train` which tells me they are corresponding and need to be combined with `X_Train`. I had trouble figuring out what it was at first, I read them in and did a summary.  Once I realized that the range was `1-6` I realized they were references to activity labels (activity_labels.txt).
* `y_train` also corresponds to the `activity_labels`.

#### Pre-Process of Test and Train Data
Perform the following for each dataset (test and train), separately:
* load in `y_` activity data
* load in `subjects_` subject data
* load in (cached) the `X_` data -- this is the main dataset
* apply the `features.txt` as column names
* add in the `subjects_` data to the main dataset
* take the activities list (`y_`), and merge it with `activities_labels`
* `cbind` the result to the main dataset
* melt it down with only `"activity_id", "activity_label", "subject_id"` as IDs.
* add to list for return

The function then returns a list contains the prepared test and train data.

## Combining Test and Train.
Once

## Random Notes
#### Caching Mechanism
It was driving me crazy loading in the large files each time, so I created some cache variables in the global space, and a function

