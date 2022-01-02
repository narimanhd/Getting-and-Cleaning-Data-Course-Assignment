getwd()
library(data.table)
library(dplyr)
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
Traininglabels <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
Trainingsets <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
Testlabels <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
Testsets <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

subject <- rbind(subject_Train, subject_Test)
Labels <- rbind(Traininglabels, Testlabels)
sets <- rbind(Trainingsets, Testsets)

colnames(sets) <- t(featureNames[2])

colnames(Labels) <- "Activity"
colnames(subject) <- "Subject"


C_mean_STD <- grep(".*Mean.*|.*Std.*", names(sets), ignore.case=TRUE)

data <- cbind(sets[,C_mean_STD], Labels, subject)
dim(data)


data$Activity <- as.character(data$Activity)
for (i in 1:6){
  data$Activity[data$Activity == i] <- as.character(activityLabels[i,2])
}

data$Activity <- as.factor(data$Activity)

names(data)

names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

names(data)

data$Subject <- as.factor(data$Subject)
data <- data.table(data)

tidyData <- aggregate(. ~Subject + Activity, data, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

