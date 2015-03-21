#Coursera Cleaning and Getting Data
#Course Project 2

#Purpose of this script is to accomplish the following, w.r.t. UCI HAR dataset
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation 
#  for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.

#clean up workspace and set working directory
rm(list=ls())
setwd("/Users/wellianwiranto/Documents/Coursera/UCI HAR Dataset")

# TO COMPLETE STEP 1
#The first substep: merge the various pieces of "training" sub-dataset

#Starting with reading the relevant training txt files.
act.label <- read.table("./activity_labels.txt", header=FALSE)
feature <- read.table("./features.txt", header=FALSE)
subj.train <- read.table("./train/subject_train.txt", header=FALSE)
x.train <- read.table("./train/X_train.txt", header=FALSE)
y.train <- read.table("./train/Y_train.txt", header=FALSE)

#Name columns appropriately, for easy identification to help merging
colnames(act.label) = c('act.id', 'act.name')
colnames(subj.train) = "subj.id"
colnames(x.train) = feature[,2]
colnames(y.train) = "act.id"

#Create 'Training' data set
training <- cbind(y.train, subj.train, x.train)

#Do the same to the 'Test' sub-dataset now
#Reading in the relevant Test txt files
subj.test <- read.table("./test/subject_test.txt", header=FALSE)
x.test <- read.table("./test/X_test.txt", header=FALSE)
y.test <- read.table("./test/Y_test.txt", header=FALSE)

#Column names
colnames(subj.test) = "subj.id"
colnames(x.test) = feature[,2]
colnames(y.test) = "act.id"

#Create 'Test' data set 
test <- cbind(y.test, subj.test, x.test)

#Merge the training and test subsets, to complete STEP 1
data <- rbind(training, test)

#STEP2: Extract only mean and std dev for each measurement
#Use grepl function to pick up column names which contain "mean" and "std",
#as well as the identifiers
#This would capture measures such as "meanfreq" too, to be sure
#Since the question is not clear on whether this is needed to,
#decided might as well err on having more (which the end-user can delete later)
#then to have too little (which the user won't even know is missing)

data.mean.std <- data[,grepl("mean|std|subj.id|act.id", names(data))]

#STEP3: Use descriptive activity names to name activities in data
#Use the act.label data which we have from earlier to merge

data.label <- merge(act.label, data.mean.std)
#drop the action id, since it's the worse duplicate of action label
data.label <- data.label[,-1]

#STEP4: Label data with descriptive variable names
names(data.label)<-gsub("^t", "time", names(data.label))
names(data.label)<-gsub("^f", "frequency", names(data.label))
names(data.label)<-gsub("Acc", "Accelerometer", names(data.label))
names(data.label)<-gsub("Gyro", "Gyroscope", names(data.label))
names(data.label)<-gsub("Mag", "Magnitude", names(data.label))
names(data.label)<-gsub("BodyBody", "Body", names(data.label))
names(data.label)<-gsub('\\(|\\)',"", names(data.label), perl=TRUE)

#STEP5:
library(plyr)
data2 <- aggregate(. ~subj.id + act.name, data.label, mean)
data2 <- data2[order(data2$subj.id, data2$act.name),]
rename(data2, c("subj.id"="subject", "act.name"="action"))
write.table(data2, file = "tidydata.txt", row.name = FALSE)