# Codebook Design
This codebook is loosely modeled on the [ICPSR Guide](http://www.icpsr.umich.edu/icpsrweb/ICPSR/support/faqs/2006/01/what-is-codebook) and the [2006 Data Housing Dictionary from Quiz 1](https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf)
# Resources Used for Project
This is not all inclusive, but some of the main supporting factors my thinking.

* **Coursera Threads**
    * [David's Project FAQ](https://class.coursera.org/getdata-014/forum/thread?thread_id=30)
    * [David's Tidy Data and the Assignment Thread](https://class.coursera.org/getdata-014/forum/thread?thread_id=31)
    * [README advice](https://class.coursera.org/getdata-014/forum/thread?thread_id=213)
    * [Codebook Advice](https://class.coursera.org/getdata-014/forum/thread?thread_id=137)
* **Other Sources**
    * [Hadley Wickham's Tidy Data Paper](http://vita.had.co.nz/papers/tidy-data.pdf)
    * [dplyr intro](http://seananderson.ca/2014/09/13/dplyr-intro.html)
    * [tidying data](http://garrettgman.github.io/tidying/)

# Understanding the Assignment
### Tidy Data
Since this assignment is heavily based on the concept of Tidy Data, it's reasonable to include some very basic points of `what makes data tidy`.

However, a better reference is [Hadley Wickham's Tidy Data Paper](http://vita.had.co.nz/papers/tidy-data.pdf) and the [Tidy Data description pertaining to this assignment](https://class.coursera.org/getdata-014/forum/thread?thread_id=31)

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

### Objectives
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Understanding the Data
The test and train folders each have 3 files.  I will use `train` as an example, but this applies to the test folder as well.

*Files used are based on [David's Project FAQ](https://class.coursera.org/getdata-014/forum/thread?thread_id=30)) and README.txt included with the data, and also in this repository in the raw_data_docs folder*

##### Files outside the test and train folders -- AKA Common Data.

* `features`
    - List of feature names.  
    - Has the same count of rows as there are columns in `X_train` and `Y_train`
* `activity_labels`
    - Links the class labels with their activity name.
    - Can be used in a join to reference the `y_train` and `y_test` activity to its name.

##### Files inside the test and train folders -- AKA Set Data.

* `y_train`
    - Each row identifies the ID of the activity performed.  
    - Range is 1-6.
    - Can be referenced to `activity_labels.txt` to get the activity label names that match the ids.
    - Has the same # of rows as `X_train` and `subject_train`.
* `X_train`
    - Training set containing all the features collected.  
    - No headers
    - The column count is equal to the count of rows in `features.txt`
    - Has the same # of rows as `subject_train` and `y_train`
* `subject_train`
    - Each row identifies the subject who performed the activity for each window sample. 
    - Range is from 1 to 30.
    - 1 column.
    - Has the same # of rows as `X_train` and `y_train`

# Processing the data
** I will use *common data* to refer to the data outside of the test and train folders, and *set data* to refer to the data inside of those folders.

## Overview
Only an overview of the processing is provided here.  For more information please see `helpers.R` and `run_analysis.R` -- they are very heavily commented.

* Load common data
    - `loadCommonData` function, located in `helpers.R`
* Load set data (performed separately for train and test).
    - `loadSetData` function located in `helpers.R`
* For each set of data (train and test), perform the following:
    - `prepSetData` function in `helpers.R`
* When they have been merged within their respective directories, bring the datasets together by bind_rows.
* To create the independent dataset for part 5 of the Objectives:
    - Group by: 
        - `subject_id`, 
        - `activity_label`, 
        - `feature_name`
    * Summarize, creating a new column called `feature_mean`
    * Generate the tidy text file, called `grouped_means.txt` that meets the principles of tidy data mentioned above, and can be read with `read.table(header=TRUE)`

## Tidy Data Generation
This is the narrow form of Tidy Data.  Features were gathered into a single column called `feature_name` and their measurements into `feature_value`. 
I reviewed it against Section 3 of [Hadley Wickham's Tidy Data Paper](http://vita.had.co.nz/papers/tidy-data.pdf) and the various messy datasets use cases and could not match them.  It effectively contains each of the features that are standard deviation or mean of a measurement at every potential combination of subject and activity label.  It is grouped in this order:

* `subject_id`,
* `activity_label`, 
* `feature_name`

The `feature_mean` column created is the result of a `dplyr` `summarize` function and is a value of the mean value of that feature for that activity for that subject.

Lastly, I chose not to include `activity_id` in the generated data because it's always 1:1 with activity label, and the labels are machine friendly enough (consistent strings) that unless we were going to cross reference `activity_id`'s in another dataset or database, I felt like they didn't need to be there.

# Variables:

* `subject_id` 
    - ID of the subject who performed the activity.
    - Range 1:30
    - Integer
* `activity_label`
    - Name of the activity performed
    - String
    - One of:
        + `WALKING`
        + `WALKING_UPSTAIRS`
        + `WALKING_DOWNSTAIRS`
        + `SITTING`
        + `STANDING`
        + `LAYING`
* `feature_name`  
    - The name of the measurement.  See features_info below for more scientific description of the measurements
    - String
    - One of:
        + `tBodyAcc-mean()-X`
        + `tBodyAcc-mean()-Y`
        + `tBodyAcc-mean()-Z`
        + `tBodyAcc-std()-X`
        + `tBodyAcc-std()-Y`
        + `tBodyAcc-std()-Z`
        + `tGravityAcc-mean()-X`
        + `tGravityAcc-mean()-Y`
        + `tGravityAcc-mean()-Z`
        + `tGravityAcc-std()-X`
        + `tGravityAcc-std()-Y`
        + `tGravityAcc-std()-Z`
        + `tBodyAccJerk-mean()-X`
        + `tBodyAccJerk-mean()-Y`
        + `tBodyAccJerk-mean()-Z`
        + `tBodyAccJerk-std()-X`
        + `tBodyAccJerk-std()-Y`
        + `tBodyAccJerk-std()-Z`
        + `tBodyGyro-mean()-X`
        + `tBodyGyro-mean()-Y`
        + `tBodyGyro-mean()-Z`
        + `tBodyGyro-std()-X`
        + `tBodyGyro-std()-Y`
        + `tBodyGyro-std()-Z`
        + `tBodyGyroJerk-mean()-X`
        + `tBodyGyroJerk-mean()-Y`
        + `tBodyGyroJerk-mean()-Z`
        + `tBodyGyroJerk-std()-X`
        + `tBodyGyroJerk-std()-Y`
        + `tBodyGyroJerk-std()-Z`
        + `tBodyAccMag-mean()`
        + `tBodyAccMag-std()`
        + `tGravityAccMag-mean()`
        + `tGravityAccMag-std()`
        + `tBodyAccJerkMag-mean()`
        + `tBodyAccJerkMag-std()`
        + `tBodyGyroMag-mean()`
        + `tBodyGyroMag-std()`
        + `tBodyGyroJerkMag-mean()`
        + `tBodyGyroJerkMag-std()`
        + `fBodyAcc-mean()-X`
        + `fBodyAcc-mean()-Y`
        + `fBodyAcc-mean()-Z`
        + `fBodyAcc-std()-X`
        + `fBodyAcc-std()-Y`
        + `fBodyAcc-std()-Z`
        + `fBodyAcc-meanFreq()-X`
        + `fBodyAcc-meanFreq()-Y`
        + `fBodyAcc-meanFreq()-Z`
        + `fBodyAccJerk-mean()-X`
        + `fBodyAccJerk-mean()-Y`
        + `fBodyAccJerk-mean()-Z`
        + `fBodyAccJerk-std()-X`
        + `fBodyAccJerk-std()-Y`
        + `fBodyAccJerk-std()-Z`
        + `fBodyAccJerk-meanFreq()-X`
        + `fBodyAccJerk-meanFreq()-Y`
        + `fBodyAccJerk-meanFreq()-Z`
        + `fBodyGyro-mean()-X`
        + `fBodyGyro-mean()-Y`
        + `fBodyGyro-mean()-Z`
        + `fBodyGyro-std()-X`
        + `fBodyGyro-std()-Y`
        + `fBodyGyro-std()-Z`
        + `fBodyGyro-meanFreq()-X`
        + `fBodyGyro-meanFreq()-Y`
        + `fBodyGyro-meanFreq()-Z`
        + `fBodyAccMag-mean()`
        + `fBodyAccMag-std()`
        + `fBodyAccMag-meanFreq()`
        + `fBodyBodyAccJerkMag-mean()`
        + `fBodyBodyAccJerkMag-std()`
        + `fBodyBodyAccJerkMag-meanFreq()`
        + `fBodyBodyGyroMag-mean()`
        + `fBodyBodyGyroMag-std()`
        + `fBodyBodyGyroMag-meanFreq()`
        + `fBodyBodyGyroJerkMag-mean()`
        + `fBodyBodyGyroJerkMag-std()`
        + `fBodyBodyGyroJerkMag-meanFreq()`
        + `angle(tBodyAccMean,gravity)`
        + `angle(tBodyAccJerkMean),gravityMean)`
        + `angle(tBodyGyroMean,gravityMean)`
        + `angle(tBodyGyroJerkMean,gravityMean)`
        + `angle(X,gravityMean)`
        + `angle(Y,gravityMean)`
        + `angle(Z,gravityMean)`

* `feature_mean`
    - Numeric
    - Average of the features value grouped by subject and activity.


## Features Info

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
angle(): Angle between tow vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean



