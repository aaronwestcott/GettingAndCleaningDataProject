#getwd()
#"C:/Main/Courses/DS_03_GettingAndCleaningData/data/UCI HAR Dataset/test"
#setwd("C:\\Main\\Courses\\DS_03_GettingAndCleaningData\\data\\Project")

#1
dataX_train <- read.table("X_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
dataX_test <- read.table("X_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
features <- read.table("features.txt", sep = "" , header = F ,  na.strings ="", stringsAsFactors= F)
labels <- read.table("activity_labels.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
subjects <- read.table("subject_test.txt", sep = "" , header = F ,  na.strings ="", stringsAsFactors= F)
dataY_test <- read.table("y_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
dataY_train <- read.table("y_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
subject_test <- read.table("subject_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
subject_train <- read.table("subject_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
activity_labels <- read.table("activity_labels.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)

#2
#bind the data together one set on top of the other
dataX_full<-rbind(dataX_train, dataX_test)
dataY_full<-rbind(dataY_train, dataY_test)


subject_full<-rbind(subject_train, subject_test)

#3
activity_labels_full_step1<-merge(activity_labels, dataY_full, by.x="V1", by.y="V1")
activity_labels_final<-activity_labels_full_step1[,2]

#4
ftc<-cbind(subject_full, activity_labels_final)


#5  &6
# Get all the feature names into a list
featurelist<-features[,2]

#make feature labels more descriptive

#Still to do


#extract any feature name with the word 'mean' embeded
#This creates a logical vector but still the same length as the feature list
columns_mean<-grepl("mean",featurelist)

#extract any feature name with the word 'std' embeded
#This creates a logical vector but still the same length as the feature list
columns_std<-grepl("std",featurelist)


#7
#using the logical vector to slice the data set by the columns corresponding
#to the true values for the mean and std
dataX_full_means<-dataX_full[,columns_mean]
dataX_full_std<-dataX_full[,columns_std]

#8 apply names to columns

mean_names<-features[columns_mean,2]
std_names<-features[columns_std,2]

#9
mean_names<-gsub("^t", "Time", mean_names)
mean_names<-gsub("^f", "FrequencyDomainSignal", mean_names)
mean_names<-gsub("\\()", "", mean_names)
mean_names<-gsub("Acc", "Acceleration", mean_names)
mean_names<-gsub("Freq", "Frequency", mean_names)
mean_names<-gsub("Gyro", "Acceleration", mean_names)

std_names<-gsub("^f", "FrequencyDomainSignal", std_names)
std_names<-gsub("^t", "Time", std_names)
std_names<-gsub("\\()", "", std_names)
std_names<-gsub("Acc", "Acceleration", std_names)
std_names<-gsub("Freq", "Frequency", std_names)
std_names<-gsub("std", "StandardDeviation", std_names)

#10
names(dataX_full_std)[1:length(std_names)]<-std_names
names(dataX_full_means)[1:length(mean_names)]<-mean_names

114 Combine the data
#This is the dataset with means grouped and std grouped
#Here we bind the smaller dataset back together
dataX_full_reduced<-cbind(dataX_full_means,dataX_full_std)

#12 Merge the activity labels with the y datasets
data_processed<-cbind(ftc,dataX_full_reduced)

#13
names(data_processed)[1]<-"Subject"
names(data_processed)[2]<-"Activity"



library(data.table)
#14
for (i in 3:81 ) {data_processed[,i] <- as.numeric(as.character(data_processed[,i])) }
dt<-data_processed
#15
dt.agg <- aggregate(dt, by=list(dt$Subject, dt$Activity), FUN=mean)
#16
dt.agg$Activity.1<-NULL
dt.agg$Subject.1<-NULL
#17 
dt.sort<-dt.agg[order(dt.agg$Subject, dt.agg$Activity),]
#18 
dt.sort$Subject<-NULL
dt.sort$Activity<-NULL
names(dt.sort)[1:2]<-c("Subject", "Activity")
write.table(dt.sort, "DataFile.txt", row.name=FALSE)
