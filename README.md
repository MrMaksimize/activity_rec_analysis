
## Running the code.
Most of the things you need done, like installing packages and downloading data the script will do for you.  If you have trouble, see the more detailed descriptions below.  
Otherwise, running:
`source('path/to/where/you/cloned/run_analysis.R')` 
will do the trick.

You could also set the working directory to the folder where the project resides, but the script should do that for you:

`setwd('path/to/where/you/cloned/the/project')`

## Environment when this script was created.
* OS Version: `MacOSX Yosemite 10.10.3`
* R Version: `3.1.3 (2015-03-09)`
* R Studio Version: `0.98.1102`

## Files
There are two R files included:
Both are very heavily commented, so please read through the comments to see what it's doing.
#### R Files
* `run_analysis.R`
    - This is the main file and the one you need to run.  Once you source it, it will execute.
* `helpers.R`
    - This file contains all the functions needed to complete the tasks.

#### Data Files
* `grouped_means.txt`
    - Tidy data that can be read into R with `read.table("grouped_means.txt", header=TRUE)`
* The rest of the data files (the actual dataset) is downloaded when you run `run_analysis.R`

#### Documentation Files
* `README.md` 
    - This file.  Explains the overall information about the repository, how to run and what the files are.  
* `CODEBOOK.md` 
    - The codebook which defines the column names, methodology and how the data was processed.
* `raw_data_docs/feature_info.txt` and `raw_data_docs/README.txt`
    - Files from the dataset.  I refer to them a bit in the codebook, so thought it would make sense to include them in the repo.

## Package Dependencies
The packages should get auto-installed if you don't have them. 
* `dplyr`
* `tidyr`

If you find yourself having trouble, just run:
`install.packages(c("dplyr", "tidyr"))`

## Downloading the data
The script should automatically set the working directory to the folder where it's located, then download the zip file from [cloudfront](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  It will then extract it, and create ./data directory in your working directory where it will extract itself.  

This method uses CURL so if you are having trouble with it, or are running Windows, you can download the file from the aforementioned link, extract it to a folder named `./data` within the working directory (the directory `run_analysis.R` is in), and it should work.  It checks for the existence of that directory.

## What happens when you source run_analysis.r

Please see the code for more details -- it's heavily commented.

* If you don't have either `dplyr` or `tidyr` installed, it will install those.
* It will load those libraries
* Set the working directory for the script to the working directory of the `run_analysis` file.
* Load in the `helpers.R` file with helper functions.
* Check if `./data` directory exists.  If it doesn't, it will download the zip file and unzip it to that directory.
* The data is then processed according to the [Processing the Data](https://github.com/MrMaksimize/activity_rec_analysis/blob/master/CODEBOOK.md#processing-the-data) section in the Codebook.
* A file is generated to complete Objective 5 that conforms to the tidy data principles.

## How to read the generated tidy data file for evaluation.
Assuming RStudio:

`View(read.table("grouped_means.txt", header=TRUE))`

