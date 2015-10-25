#necessary packages.
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
#Set route.
route <- getwd()
route
#Getting the data
#Downloading the file. 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataset <- "Dataset.zip"
if (!file.exists(route)) {dir.create(route)}
download.file(url, file.path(route, dataset))
#an unzipped folder will be UCI HAR Dataset
newroute <- file.path(route, "UCI HAR Dataset")
#looking into subject files.
readSubjectTrain <- fread(file.path(newroute, "train", "subject_train.txt"))
head(readSubjectTrain)
nrow(readSubjectTrain)
ncol(readSubjectTrain)
readSubjectTest  <- fread(file.path(newroute, "test" , "subject_test.txt" ))
#looking into the activity text files.
readActivityTrain <- fread(file.path(newroute, "train", "Y_train.txt"))
readActivityTest  <- fread(file.path(newroute, "test" , "Y_test.txt" ))
#Reading the data files.
fileToDataTable <- function (f) {
  df <- read.table(f)
  dt <- data.table(df)
}
dataframeTrain <- fileToDataTable(file.path(newroute, "train", "X_train.txt")) ###this will convert file into dataframe
dataframeTest  <- fileToDataTable(file.path(pathIn, "test" , "X_test.txt" ))
#now Merge the test and training sets
dataframeSubject <- rbind(readSubjectTrain, readSubjectTest)
setnames(dataframeSubject, "V1", "subject")
dataframeActivity <- rbind(readActivityTrain, readActivityTest)
names(dataframeActivity)
setnames(dataframeActivity, "V1", "activityNum")
head(dataframeActivity)
nrow(dataframeActivity)
ncol(dataframeActivity)
head(dataframeActivity)
dataframe <- rbind(dataframeTrain, dataframeTest)
nrow(dataframe)
ncol(dataframe)
#Merging of columns.
dataframeSubject <- cbind(dataframeSubject, dataframeActivity)
dataframe <- cbind(dataframeSubject, dataframe)
head(dataframe$subject)
head(dataframeActivity$activityNum)
ncol(dataframe)
names(dataframe)
#Setting the key.
setkey(dataframe, subject, activityNum)
names(dataframe)
#Now we will Extract only the mean and standard deviation data
dataframeFeatures <- fread(file.path(newroute, "features.txt"))
setnames(dataframeFeatures, names(dataframeFeatures), c("featureNum", "featureName"))
#Now we will only Subset the measurements for the mean and standard deviation data.
dataframeFeatures <- dataframeFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dataframeFeatures
#Now we will Convert the column numbers to a set of vector of variable names which matche columns in dataframe.
dataframeFeatures$featureCode <- dataframeFeatures[, paste0("V", featureNum)]
head(dataframeFeatures)
dataframeFeatures$featureCode
#Now we will Subset above variables using their variable names.
select <- c(key(dataframe), dataframeFeatures$featureCode)
dataframe <- dataframe[, select, with=FALSE]
names(dataframe)
#We will Use descriptive activity names
dataframeActivityNames <- fread(file.path(newroute, "activity_labels.txt"))
setnames(dataframeActivityNames, names(dataframeActivityNames), c("activityNum", "activityName"))
names(dataframeActivityNames)
##We will Label with descriptive activity names
# Let's Merge activity labels.
dataframe <- merge(dataframe, dataframeActivityNames, by="activityNum", all.x=TRUE)
#Now we will Add activityName as a key.
setkey(dataframe, subject, activityNum, activityName)
#Now we Melt the data table for reshapeping our data to bring into a long data .
dataframe <- data.table(melt(dataframe, key(dataframe), variable.name="featureCode"))
#Now we will Merge activity name.
dataframe <- merge(dataframe, dataframeFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
#Now we will Create a new variable named activity_new that is equivalent to activityName as a factor class. Create a new variable, feature that is converted from featureName as a factor class of featurename.
dataframe$activity_new <- factor(dataframe$activityName)
dataframe$feature <- factor(dataframe$featureName)
#Now we wull Seperate features from variable featureName by function grepthis.
grepthis <- function (regex) {
  grepl(regex, dataframe$feature)
}
## Featuring with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow=n)
y
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y))
x
dataframe$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol=nrow(y))
x
dataframe$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol=nrow(y))
dataframe$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol=nrow(y))
dataframe$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))
## Features with 1 category
dataframe$featJerk <- factor(grepthis("Jerk"), labels=c(NA, "Jerk"))
dataframe$featMagnitude <- factor(grepthis("Mag"), labels=c(NA, "Magnitude"))
## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
dataframe$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))
#Check to make sure all possible combinations of feature are accounted for by all possible combinations of the factor class variables.
r1 <- nrow(dataframe[, .N, by=c("feature")])
r2 <- nrow(dataframe[, .N, by=c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2
##Now we will Create a tidy data set with the average of each variable for each activity and each subject
setkey(dataframe, subject, activity_new, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
Tidydata <- dataframe[, list(count = .N, average = mean(value)), by=key(dataframe)]
new <- file.path(path, "Tidydata.txt")
write.table(Tidydata, new, quote = FALSE, sep = "\t", row.names = FALSE)
#Make codebook.
knit("makeCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)
#Make READme
knit("README.Rmd", output="README.md", encoding="ISO8859-1", quiet=TRUE)
