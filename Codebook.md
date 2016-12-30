# CODEBOOK FOR HANDS-ON ASSIGNMENT DATA SCIENCE, COURSE 3, WEEK 3, TIDY DATA

### DATA INPUT
* Human Activity Recognition Using Smartphones Dataset Version 1.0
* URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### ASSUMPTIONS AND PLATFORM
* Windows 10
* R Version 3.2.2
* The data in the Inertial Signals directories were not used.

### SCRIPT NAME
* run_analysis.R

### INPUT TO THE SCRIPT
* Project Directory. Can be set in R Console, or in the script itself, project_dir.

### VARIABLES AND UNITS
* All features are numeric, except the "activity" feature which is a charater string
* All features projected from the input data set are either means or standard deviations.
* There are two new features added: "activity", and "subject."
* The "activity" feature has the descripitive activity names. It came from the activity_labels.txt file
* The "subject" feature has the subject ids from the subject_test.txt and the subject_train.txt files
* The explaination of all the other features are given in the features_info.txt file in data input.

### SCRIPT DESCRIPTION
* set up the Project Directory from the project_dir=..., in the script (supplied by the user),
or from the Current working directory set up in the R Console.
* create a sub-directory, TidyData.
* download the URL into a file FCUIDataset.zip, and unzips it into the TidyData directory
* load the data.table library
* go to the "test" directory and read in the X_test.txt file into the test_set data frame. (2947x561)
* go to the "train" directory and read in the X_train.txt file for the train_set data frame. (7352x561)
* merge the train_set and the test_set data into one data set, data_set, using rbind. (10299x561)
* --
* read the features.txt file to get the feature names into the "features" data frame. (561x2)
* select the mean and std rows from "features", using grepl, into "features_mean_sd" data frame. (79x2)
* the above operation gives the column numbers, feature name pairs for the data_set data frame. (79x2)
* transform the column numbers to column names by prepending a "V", and placing them in mean_sd_index" variable
* project out the mean_sd_index features from data_set, and place the data into data_set_mean_sd. (10299x79)
* --
* label the data_set_mean_sd with the column names in features_mean_sd. Gives the descriptive feature names for the data. (10299x79)
* --
* read the y_train.txt, y_test.txt files to get the activity for each observation. (7352x1) and (2947x1)
* merge these data sets using rbind, to give a combimed "activity" data frame. (10299x1)
* read the activity_label.txt file to get the 6 descriptive activity labels, store in activity_labels data frame. (6x2)
* get the list of descriptive activity labels for the observation set, store it in labels. (10299x1)
* load the dplyr library
* add a new column "activity" that has the descriptive active label to the data_set_mean_sd data set, using the mutate function. (10299x80)
* --
* read subject_train.txt and subject_test.txt files to get the subjects information. (7352x1) and (2947x1)
* merge these data sets using rbind, to get the subjects, store in "subjects" data frame. (10299x1)
* add a new column "subject" that has links an observation to a subject in the data_set_mean_sd, using mutate function. (10299x81)
* find the average of all the features in data_set_mean_sd, grouped by activity and subject, and store in tidy2 data frame. (180x81)


