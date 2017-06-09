rm(list=ls())
# Loading activity labels text file.
activity_labels<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")
features<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/features.txt")

#Loading test subject data and subject numbers
subject_test<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")

#Loading training subject data and subject numbers
subject_train<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./03 - Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")

# Merge the test and train data together including subjects' details
Data<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)

#Extracting mean and standard deviation variables from the overall data
Data_mean_std<- Data[, grep("mean|std",features$V2)]

#Naming extracted data variables
colnames(Data_mean_std)<- grep("mean|std",features$V2, value=T)

#Merging and naming activity and subject data with extracted data. data_f stands for final data
data_f<- cbind(c(y, subject), Data_mean_std)
colnames(data_f)[1:2] <- c("activity", "subject")
#Naming variables approperiately
colnames(data_f)<-gsub("[- | ()]","",names(data_f))

#Replacing activity numbers by their names
for(i in 1:dim(activity_labels)[1]){
  data_f$activity <- sub(activity_labels[i, 1], activity_labels[i, 2], data_f$activity)
}

#Independent tidy data set with the mean of each variable for each activity and each subject.
library(reshape2)
data_ind<- melt(data_f, id=names(data_f)[1:2], measure.vars=names(data_f)[3:dim(data_f)[2]])
subject_mean<- dcast(data_ind, subject+activity~variable, mean)
write.table(subject_mean, "./03 - Getting and Cleaning Data/DataSet_Mean.txt", row.name=FALSE)