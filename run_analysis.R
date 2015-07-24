
#Download zip file
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile="C:/Users/trimble/Documents/UCI.zip"


#Step 1) Merge the training and the test sets to create one data set.

#Read in data 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
Activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
Activity_test <- read.table("C:/Users/trimble/Documents/UCI HAR Dataset/test/y_test.txt")

#Merge test and training
x_data=rbind(x_train,x_test)
Subject_data=rbind(Subject_train,Subject_test)
Activity_data=rbind(Activity_train,Activity_test)


#Step 2) Extract only the measurements on the mean and standard deviation for each measurement. 
features_names <- read.table("UCI HAR Dataset/features.txt")
get_features=grep("-(mean|std)\\(\\)", features_names[,2]) # remove "()"
x_data <- x_data[,get_features]
colnames(x_data)=tolower(features_names[get_features,2])


#Step 3) Use descriptive activity names to name the activities in the data set.
activity_names <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity_match=join(Activity_data,activity_names)
Activity_match=as.data.frame(tolower(Activity_match[,2])) #extract activity names as lowercase 



#Step 4) Appropriately label the data set with descriptive activity names
names(Subject_data)<-"subject"
names(Activity_match)<-"activity"
Tidy_data=cbind(Subject_data,Activity_match,x_data)
colnames(Tidy_data)=make.names(colnames(Tidy_data),unique=TRUE)



#Step 5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Tidy_data_summary=aggregate(Tidy_data[3:ncol(Tidy_data)],by=Tidy_data[1:2],FUN=mean)
write.table(Tidy_data_summary, "Tidy_data_summary.txt",row.name=FALSE)

