# Getting Started
## Environment
OS Version
R Version
R Studio Version
## Package Deps
? Try to install them automatically?
## Files to Be Used
* subject_test.txt
* y_test.txt
* X_test.txt
* subject_train.txt
* y_train.txt
* X_train.txt
* features.txt
* activity_labels.txt

## Read In Files Common to Both Test and Train.
* activity_labels.txt
    * contains data referencing activity id to activity name.
* features.txt
    * contains data referencing feature_id to feature name

## Combining Data Inside Test and Train
Before combining testing and training datasets, we need to first combine 
data within those folders into one.

First, it was unclear from the README what y_train were.  I read them in and did a summary.  Once I realized that the range was 1-6 I realized they were references to labels.

There are three files here:
* y_train
    - Label linking the datasets to activity id.
* X_train
    - Training data, arranged in columns in the order described in features.txt
* subject_train
    - The id of subject




