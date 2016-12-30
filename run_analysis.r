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

# ATTACH ACTIVITY LABELS TO THE COLUNM  --OLD  (WRONG)

#read the y_train.txt file. This file holds the mapping between 
#activity labels and the columns of the train and set data.
#The y_train file of either train or test may be used.
#WHY? This file has 7352 mappings, however they all map to 6 unique 
#values, and there are 6 activites.  So, I am assuming this 
#file holds the activity mappings.
#Based on this assumption, the row# in the y_train file corresponds 
#to the column number in the train/test data file.
setwd(wd_train)
labels_to_column_map <- fread("y_train.txt")

#read the activity labels (there are 6 distinct activities)
setwd(wd_features)
activity_labels <- fread("activity_labels.txt")

#subset the activity labels for mean and standard deviation coulmns
a <- labels_to_column_map[features_mean_sd$V1,1]
labels_mean_sd <- activity_labels[a$V1,2]

#Attach activity labels to the mean/sd column names
library(dplyr)
f1 <- mutate(f, V2=paste(labels_mean_sd$V2, V2, sep="_"))

#Associate the [activity names + mean/sd colunm names] combination
#to each column in the mean/sd data table 

colnames(data_set_mean_sd) <- f1$V2

#####################################################################

#LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES

colnames(data_set_mean_sd) <- features_mean_sd$V2

#####################################################################

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


