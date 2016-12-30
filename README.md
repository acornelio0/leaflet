# HANDS-ON ASSIGNMENT DATA SCIENCE, COURSE 3, WEEK 3, TIDY DATA

### DATA INPUT
* Human Activity Recognition Using Smartphones Dataset Version 1.0
* URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### ASSUMPTIONS AND PLATFORM
* Windows 10
* R Version 3.2.2
* The data in the Inertial Signals directories were not used.

### INPUT TO THE SCRIPT
* Project Directory. Can be set in R Console, or in the script itself, project_dir.

### Question 1:
* The X_test.txt, X_train.txt files were the test and train data sets respectively.
* They were merged to give one data set, data_set, using the rbind function.

### Question 2:
* The features.txt file has the feature descriptive names for the data.
* The feature names with the pattern "mean", and "std" were selected, features_mean_sd.
* The meanfrequency was also included, as these are means in the frequency domain.
* The features selected above were used to project out the columns from data_set, to give, data_set_mean_sd

### Question 4:
* The feature names, features_mean_sd, are made the column names for the data_set_mean_sd.

### Question 3:
* The y_test.txt, and y_train.txt files have the activity associated with each observation.
* These data files were merged, and the data in activity_labels.txt was used to get the descriptive activity name.
* These descriptive activity names were attached as a column "activity" to the data set, data_set_mean_sd. 

### Question 5:
* The subject_test.txt, and subject_train.txt files have the subject associated with each observation.
* These data files were merged, and attached as a new column "subject" to the data set, data_set_mean_sd.
* The data_set_mean_sd data set was grouped by (activity, subject) columns and each feature in the group averaged
* The result is in tidy2.