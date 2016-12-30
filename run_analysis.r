#INPUT

#Set the Project Directory (on your computer)
#If it is not set, the script will use the Current Directory, 
#set up in the R console
project_dir = ""

#END OF INPUT

##############################################################

# MERGE THE TRAIN AND TEST DATA SETS

#URL to download the data (given)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Use Project Directory is not set (above), use the current working directory, 
#set in the R console
if (project_dir =="") { project_dir = getwd() }

#Working directory (wd) is TidyData
#It is created as a subdirectory to the Project Directory
wd <- paste0(project_dir, "/TidyData")
if(!file.exists(wd) { dir.create(wd)}
setwd(wd)

#Download the zipped data file into the directory, TidyData
#Version of data.table package: 1.10.0
download.file(url, destfile="FUCIDataset.zip")
unzip("FUCIDataset.zip")

#Install packages to read the data into R
install.packages("data.table")
library(data.table)

#set current working directory to the test data and read the data
wd_test <- paste0(wd, "/UCI HAR Dataset/test")
setwd(wd_test)
test_set <- fread("X_test.txt")

#set current working directory to the train data and read the data
wd_train <- paste0(wd, "/UCI HAR Dataset/train")
setwd(wd_train)
train_set <- fread("X_train.txt")

#merge the train and test dataframes
data_set <- rbind(train_set, test_set)

###############################################

# GET MEAN AND STANDARD DEVIATION COLUMNS

#read the features file
wd_features <- paste0(wd, "/UCI HAR Dataset")
setwd(wd_features)
features <- fread("features.txt")

#subset the mean and the standard deviation feature
#names, (Note: the meanfrequency() features are also 
#selected, as means in the frequency domain)
features_mean_sd <- features[grepl("mean|std", features$V2)]

#Transform the subset feature names (features_mean_sd) to the 
#column names in the merged train and test data table 
#(i.e., change (1, 2, ...) to  ("V1", "V2", ...)
mean_sd_index <- dput(as.character(features_mean_sd$V1))
mean_sd_index <- gsub("(.*)", "V\\1", mean_sd_index) 

#subset the merged train and data set (data_set). 
#By projecting out the columns using the column names 
#(mean_sd_index), generated above
data_set_mean_sd <- data_set[ ,mean_sd_index, with=FALSE ]

############################################################

# MERGE ACTIVITY NAMES TO EACH OBSERVATION

#read the y_train.txt file. Activities for the train data set
setwd(wd_train)
activity_train <- fread("y_train.txt")

#read the y_test.txt file. Activities for the test data set
setwd(wd_test)
activity_test <- fread("y_test.txt")

#merge the train and test activity
activity <- rbind(activity_train, activity_test)

#read the activity labels (there are 6 distinct activities)
setwd(wd_features)
activity_labels <- fread("activity_labels.txt")

#Attach activity column to the data
library(dplyr)
labels <- activity_labels[activity$V1,2]
data_set_mean_sd <- mutate(data_set_mean_sd, activity=labels$V2)

#####################################################################

# ASSOCIATE A SUBJECT TO AN OBSERVATION

#read the subject_train.txt file. Subjects for the train data set
setwd(wd_train)
subject_train <- fread("subject_train.txt")

#read the subject_test.txt file. Subjects for the test data set
setwd(wd_test)
subject_test <- fread("subject_test.txt")

#merge the train and test subjects
subjects <- rbind(subject_train, subject_test)

#Attach a subject to an observation
data_set_mean_sd <- mutate(data_set_mean_sd, subject=subjects$V1)

#######################################################################

# AVERAGE OF EACH FEATURE FOR EACH ACTIVITY AND EACH SUBJECT

tidy2 <- data_set_mean_sd %>% group_by(activity,subject) %>% summarize_each(funs(mean))

#write the output into file, tidydata.txt
setwd(wd)
write.table(tidy2, file="tidydata.txt", row.name=FALSE)


