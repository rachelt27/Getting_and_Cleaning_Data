
#Download zip file
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile="C:/Users/trimble/Documents/UCI.zip"


##Step 1) Merges the training and the test sets to create one data set.

#Read in data 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
Activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
Activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")

#Merge test and training
x_data=rbind(x_train,x_test)
Subject_data=rbind(Subject_train,Subject_test)
Activity_data=rbind(Activity_train,Activity_test)


##Step 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

features_names <- read.table("UCI HAR Dataset/features.txt") #Read in features names
get_features=grep("-(mean|std)\\(\\)", features_names[,2]) # remove "()" form data
x_data <- x_data[,get_features] #Extract data from x_data for mean and standard deviation measurements
colnames(x_data)=tolower(features_names[get_features,2]) #Label x_data with corresponding feature names


#Step 3) Uses descriptive activity names to name the activities in the data set.

activity_names <- read.table("UCI HAR Dataset/activity_labels.txt") #Read in activity names
Activity_match=join(Activity_data,activity_names) #Match activity numerical codes to their corresponding names 
Activity_match=as.data.frame(tolower(Activity_match[,2])) #extract activity names as lowercase 


#Step 4) Appropriately labels the data set with descriptive activity names

#insert column names for subject and activity data
names(Subject_data)<-"subject" 
names(Activity_match)<-"activity"

Tidy_data=cbind(Subject_data,Activity_match,x_data) #combine the 3 data sets
colnames(Tidy_data)=make.names(colnames(Tidy_data),unique=TRUE) #tidy the column names


#Step 5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Tidy_data_summary=aggregate(Tidy_data[3:ncol(Tidy_data)],by=Tidy_data[1:2],FUN=mean) #computes the mean of the features
write.table(Tidy_data_summary, "Tidy_data_summary.txt",row.name=FALSE,quote=FALSE) #saves txt file to working directory

