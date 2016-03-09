#course project UCI HAR Dataset, wearable data
#1st col should be who: a subset of 1-30, points to person
#2nd col should be movement: 1-6 for walking_up, walking_down
#from 3rd to 3+561 column are measurements_processed in X_train.txt
# these 561 columns should be titled by measurements_processed_labels in features.txt
#the rows of the three files are the same - number of observations

#1-6 is walking up, walking down, etc 6 types of movements
#this is in the y_train, or y_train, called label

#for another machine path0<-"C:/Users/tonnywilliam/dropbox/0 r/UCI HAR Dataset"

library(data.table)
dataprocessor<-function(wkdir,act.fpath,subj.fpath,data.fpath,subgroup)
{
setwd(wkdir)
act_labels<-fread('./activity_labels.txt')	#this maps 1-6 to walking, walking_up, etc

measurement_processing<-fread('./features.txt')	
mp_names<-measurement_processing[,V2]	#these are the fBodyGyro.mean...Z, fBodyGyro.std...Y
							#they will be field headings later
cols <- grep('mean\\(\\)|std\\(\\)', mp_names, value=TRUE)	#extract only mean and std

act<-fread(act.fpath)	#1-6s
act.name<-lapply(act, function(x) act_labels$V2[x])	#convert 1-6 to descriptive names
act.name<-factor(unlist(act.name))	#convert to factor

subj<-fread(subj.fpath)	#1-30s, subject, volunteers
subj<-factor(unlist(subj$V1))

id<-data.table(subject=subj,activity=act.name,subject_group=subgroup)

data<-fread(data.fpath)	#the main bulky data
setnames(data,mp_names)	#attach names on the variables
data.meanstdsubset<-data[,cols,with=FALSE]	#extract only mean and std
names(data.meanstdsubset)<-make.names(names(data.meanstdsubset))	#remove (), - etc make it normal name

#bind id with data
cbind(id,data.meanstdsubset)
}

testset<-dataprocessor(
	wkdir='C:/Users/tonnywilliam/dropbox/0 r/UCI HAR Dataset',
	act.fpath='./test/y_test.txt',
	subj.fpath='./test/subject_test.txt',
	data.fpath='./test/X_test.txt',
	subgroup='test group'
)
trainset<-dataprocessor(
	wkdir='C:/Users/tonnywilliam/dropbox/0 r/UCI HAR Dataset',
	act.fpath='./train/y_train.txt',
	subj.fpath='./train/subject_train.txt',
	data.fpath='./train/X_train.txt',
	subgroup='train group'
)

#now form the set merging training and test
onetidyset<-rbind(trainset,testset)
onetidyset[,subject_group:=NULL]	#remove a column
avgbysubj_act<-onetidyset[,lapply(.SD,mean),by=list(subject,activity)]	#mean by subject by activity
