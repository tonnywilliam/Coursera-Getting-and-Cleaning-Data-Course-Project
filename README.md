# Coursera-Getting-and-Cleaning-Data-Course-Project
This course project requires students to
a. assemble data from a zip folder source and compile them to a specified format
b. calculate average for about 60 variables by 30 subjects and 6 activities categories

the R script 'run_analysis.R' accomplish this by

1. defining and using a function dataprocessor to 
  * reads in activity labels (from 'activity_labels.txt') eg Walking, Walking_up, Walking_down
  * reads in measurement names (from 'features.txt') such as fBodyGyro.mean...Z, fBodyGyro.std...Y
  * reads train and test data sets (X_train.txt,X_test.txt), their respective subject (subject_train.txt, subject_test.txt) index and activity index (y_train.txt,y_test.txt)
  * select only measurements which has either a 'mean()' or 'std()' in their names
  * join subject, activity and measurement together, put column names to the measurements
2. result of above are two data sets: trainset and testset, these are then rbind to give a tidy data set, which is output into file 'tidydatahuang.txt' (attached)
3. from the tidy data set, data.table function is used to calculate average of measurements by subject and activity, result is recorded in file 'dataavghuang.txt' (attached)
  
