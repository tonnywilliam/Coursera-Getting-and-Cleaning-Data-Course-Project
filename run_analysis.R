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

#output to file
write.table(onetidyset, "tidydatahuang.txt", sep="\t",row.name=FALSE)
write.table(avgbysubj_act, "dataavghuang.txt", sep="\t",row.name=FALSE)

