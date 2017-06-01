#This code does the following:
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Load Libraries
library("plyr")
library("data.table")

#Read the file with the variables for dataset
columnsNames<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/features.txt",sep="")

#Read data set in test folder and apply column names
testSet<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/test/x_test.txt",sep="")
colNames(testSet)<-columnsNames$V2

#Read data set in train folder and apply column names
trainSet<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/train/x_train.txt",sep="")
colNames(trainSet)<-columnsNames$V2

#Merge data set in test and train folders
mergeSet<-rbind(testSet,trainSet)

#Takes only the meassurement wanted and save it in new data frame
meassurementsWanted <- grep(".*mean.*|.*std.*", columnsNames[,2]) 
setMeassurementsWanted<-mergeSet[,meassurementsWanted]

#Read activity labels and activities data in train and test folder
activity_Labels<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/activity_labels.txt",sep="")
testActivities<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/test/y_test.txt",sep="")
trainActivities<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/train/y_train.txt",sep="")

#Merge both activities data frames
mergeActivities<-rbind(testActivities,trainActivities)

#Assign activity labels to the data frame
activitiesLabelledJoined<-join(mergeActivities,activity_Labels)

#Read subject labels and subjects data in train and test folder
testSubject<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/test/subject_test.txt",sep="")
trainSubject<-read.table("C:/Users/mvillalt/Documents/Getting and Cleaning Data Course Project/UCI HAR Dataset/train/subject_train.txt",sep="")

#Merge both subject data frames
subjectMerge<-rbind(testSubject,trainSubject)

#Combine subject data fram, activity data frame and data sets
finalData<-cbind(subjectMerge,activitiesLabelledJoined[,2],setMeassurementsWanted)

#Apply variable names
colNames(finalData)<-c("Subject","Activity Label",colNames(setMeassurementsWanted))

#Create new data table to calculate means
dataTable<-data.table(finalData)

#Calculate mean by Subject and Activities and save it into new data frame
summarizeAllData<-data.frame(dataTable[,lapply(.SD, mean, na.rm=TRUE), by=c("Activity Label","Subject") ])

#Create tidy data set
write.table(summarizeAllData, file =  "tidydataset.txt", row.names = FALSE)

