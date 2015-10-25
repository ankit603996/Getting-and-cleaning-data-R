Data Set Information (THESE INFORMATIONS are taken out from downloaded text files):- 

These experiments were carried out within a group of 30 volunteers and an age bracket of 19-48 years. Every person performed 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using embedded gyroscope and accelerometer , we have captured 3-axial angular velocity  and 3-axial linear acceleration at a constant rate of 50Hz. These experiments were video-recorded for labelling the data manually. The obtained set of has been randomly partitioned into two different sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The data

The dataset includes the following files (These text are taken from the course webpages ):

1.'README.txt'
2. 'features_info.txt': Shows information about the variables used on the feature vector.
3. 'features.txt': List of all features.
4. 'activity_labels.txt': Links the class labels with their activity name.
5. 'train/X_train.txt': Training set.
6. 'train/y_train.txt': Training labels.
7.  'test/X_test.txt': Test set.
8.  'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent (These text are taken from the text files).


1. 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
2. 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
3. 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.
4. 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

Our code is written to perform following operations:-

1. Extracting Data and keeping in the system directory.
2. Make necessary sorting and cleaning.
3. Merging the training and test data sets.
4. Melting the merged data followed by Lebelling the data variables. 
5. It will create a neat and clean tidy data sets at the end.
