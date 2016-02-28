# CODEBOOK 
It describes the variables, the data, and any transformations or work that I performed to clean up the data.

Data Set Information:
The experiments have been carried out with a group of 30 volunteers (SUBJECTS). 
Each person performed six ACTIVITIES (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
(Samsung Galaxy S II) on the waist. Using its embedded ACCELEROMETER and GYROSCOPE, 3-axial linear acceleration and 3-axial angular 
velocity are recordered. The obtained dataset has been partitioned into two sets: the training data (TRAIN) and the test data (TEST). 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled.
The sensor acceleration signal has gravitational and body motion components. A vector of FEATURES was obtained by calculating variables 
from the TIME and FREQUENCY domain.

In the data we can find:
 - activity_labels.txt  (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
 - features.txt         (name of the variables in X_test and X_train)
 - X_train.txt and X_test.txt    (values of variables of train and test)
 - y_train.txt and y_test.txt    (activities ID in train and test, ranging between 1 and 6)
 - subject_train.txt and subject_test.txt (subjects ID in train and test, ranging between 1 and 30)

1. DOWNLOAD AND EXTRACTION OF DATA
  - download.file()
  - unzip()

2. MERGE OF TRAINING AND TEST DATA
  - read.table() Read the data in X_train.txt and X_test.txt 
  - rbind()      Concatenates the train and test files by row, to get the whole set of measurements 10299 obs per 561 variables
  - names()      Set the names of the variables taking features.txt  

3. EXTRACTION OF MEAN() AND STD() 
  - grepl()     It takes all the variables of AllSet and returns TRUE is the variable name contains std and mean
  - AllSet[, which...] it subsets the file, taking only the variables which name contains std and mean,  
                   file name: filteredMeanStdSet, 10299 obs. x 66 variables

4. USE DESCRIPTIVE NAMES FOR ACTIVITY
Before we read the data in subject_train.txt and subject_test.txt and concatenate them by row (AllSubjects), and set the name,
"Subject". The same has been done for the activities in y_train.txt and y_test.txt (AllLabels), name column "Activity". 

  - cbind()       Concatenate the filtered file filteredMeanStdSet, AllLabels ('Activity'), AllSubjects ('Subject') by column 
              10299 obs. x 68 variables
Read the 'activities_labels', 6 obs per 2 variables, nr.1 corresponds to Walking activity, nr.2 Walking_upstairs, etc.
  - factor_activity   is the vector that describes the Activity in AllMeasures encoded as a factor
  - levels(factor_activity) The activity labels are associated to the level attribute of factor_activity variable
  - Finally the Activity variable is described by descriptive names. 
 
5.  DESCRIPTIVE VARIABLE NAMES
The ID names of the variables are explicited by replacing the abbreviated name through gsub()

6. CREATION OF AN INDIPENDENT TIDY DATA SET
Necessary the use of reshape2 library.

  - melt()  The long-data format, newData file, is obtained by melting the AllMeasures data set, "Activity" and "Subject"
        are the ID variables, which identify individual rows of data.
  - dcast() uses a formula to describe the shape of data. It shapes newData into a wide-format tidy_data, in which the average 
        of each variable for each activity and subject.
  - tidydataset.txt the indipendent tidy data set




