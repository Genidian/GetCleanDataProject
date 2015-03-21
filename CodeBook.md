CodeBook.md

This codebook is to document and explain the steps that are taken, as part of Coursera Getting and Cleaning Data Course Project 2.

The script run_analysis.R does the 5 steps as outlined by the course project:

1.Merges the training and the test sets to create one data set.
   a. First, it reads the relevant training data sets: subject_train, x_train, y_train which are downloaded in txt format.
   b. Then, it cleans them up by labelling the variables accordingly.
   c. The same steps are then applied to the test data sets: subject_test, x_test, y_test.
   d. Last but not least, the now-cleaned-up training and test data sets are combined using rbind to form a complete set called "data".

2.Extracts only the measurements on the mean and standard deviation for each measurement. 
   a. Use grepl function to pick up column names which contain "mean" and "std", as well as the identifiers.
   b. Doing so would capture measures such as "meanfreq" too, to be sure.
   c. However, since the question is not clear on whether this is needed to, I decided might as well err on having more (which the end-user can delete later)
then to have too little (which the user won't even know is missing).
   d. The resulting data is saved as "data.mean.std".
   
3.Uses descriptive activity names to name the activities in the data set
   a. Use the action label data which we have from earlier to merge
   b. The column containing the action id (i.e. action numbers) is then dropped, since the action labels such as walking, etc. are more useful than just pure numbers - and make for a tidier data set which is our ultimate aim.
   c. The data is then saved as "data.label".
   
4.Appropriately labels the data set with descriptive variable names. 
   a. Variable names are cleaned up here to be more descriptive to users.
   b. By using gsub command in R, I have changed variable name components such as "t" to become "time", "Acc" to become "Accelerometer", "Mag" to become "Magnitude", etc. Moreover, "()" portions are dropped because they do not do anything except make things look clunky and unwieldy.
   c. For a full set of changes to variable names, please refer to the run_analysis.R script.
   d. The data set is (re)saved under "data.label"

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
   a. Here, I am using the aggregate function, to calculate means per every subject and activity combination.
   b. I saved the compressed data set in "data2"
   c. Then, I send the resulting data set via write.table command, as suggested by the project guidelines, to tidydata.txt in the working folder.
   
Thanks for your time.