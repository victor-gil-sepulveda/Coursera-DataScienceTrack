
# Loads one dataset and adds the subject and activity columns.
# - dataset_type : can be one of ["test","train"]
# - feature_names_path : is the path where the feature names reside 
load_data_set <- function(dataset_type,
                          feature_names_path = "data/features.txt"){
    # TODO: check if dataset_type is one of ["test","train"]
    feature_names = read.table(feature_names_path, sep = " ")
    df <- as.data.frame(read.table(paste("data",
                           dataset_type,
                           paste("X_",dataset_type,".txt", sep=""),
                           sep= "/")))
    names(df) <- feature_names[,2]
    
    # Append subject
    df["subject"] <- as.integer(read.table(paste("data",
                           dataset_type,
                           paste("subject_",dataset_type,".txt", sep=""),
                           sep= "/"))[,1])
    # Append activity
    df["activity"] <- as.integer(read.table(paste("data",
                                dataset_type,
                                paste("y_",dataset_type,".txt", sep=""),
                                sep= "/"))[,1])
    df
}

# Encapsulates the loading of the training and test datasets. 
load_data_sets <- function(){
    
    training.df = load_data_set("train")
    test.df = load_data_set("test")
    
    list(training = training.df, test = test.df)
}


# Merges the training and the test sets to create one data set.
merge_data_sets <- function(training_set, test_set){
    # Is the intersection of both == {} ?
    rbind(training_set, test_set)
}

# Extracts the columns with mean and std calculations
# and creates a new data frame
extract_mean_and_std<-function(df){
    df[,grep("mean\\(|std\\(|activity|subject",names(df))]
}

# Changes activity numbers by its labels
change_activity_labels <- function(df, label_dict_path = "data/activity_labels.txt"){
    activity_labels <- read.table(label_dict_path, sep = " ")
    activity_labels[,1] <- as.integer(activity_labels[,1])
    df["activity"] <- lapply(df["activity"], function(x){activity_labels[x,2]})
    df
}

# Changes data labels by more appropriate ones
# 1st use only lowercase
# 2nd expand names
# 3rd consistently use points to separate meaningful words
normalize_labels <- function(df){
    all_labels <- names(df)
    all_labels <- lapply(all_labels, tolower)
    all_labels <- sub("^f","frec.",all_labels)
    all_labels <- sub("^t","time.",all_labels)
    all_labels <- gsub("body","body.",all_labels)
    all_labels <- sub("gravity","gravity.",all_labels)
    all_labels <- sub("acc","accelerometer.",all_labels)
    all_labels <- sub("gyro","gyroscope.",all_labels)
    all_labels <- sub("-mean\\(\\)","mean.",all_labels)
    all_labels <- sub("-std\\(\\)","std.",all_labels)
    all_labels <- sub("mean.$","mean",all_labels)
    all_labels <- sub("std.$","std",all_labels)
    all_labels <- sub("jerk","jerk.",all_labels)
    all_labels <- sub("mag","mag.",all_labels)
    all_labels <- sub("-x","x",all_labels)
    all_labels <- sub("-y","y",all_labels)
    all_labels <- sub("-z","z",all_labels)
    names(df) <- all_labels
    df
}

# After the mean has been calculated, modifies the column names c
append_mean_to_all_but_subject_and_activity <- function(df){
    names(df) <- lapply(names(df), function(x){
        if(!x %in% c("subject","activity")){
            paste("mean(",x,")")
        }else{
            x
        }})
    df
}

# This is were the job is actually done. I am following
# the assignment steps:
# 1 - Merge the training and the test sets to create one data set.
dsets <- load_data_sets()
merged <- merge_data_sets(dsets$training, dsets$test)
# 2 - Extracts only the measurements on the mean and standard deviation.
# for each measurement. 
df <- extract_mean_and_std(merged)
# 3 - Use descriptive activity names to name the activities in the data set.
df <- change_activity_labels(df)
# 4 - Appropriately label the data set with descriptive variable names. 
df <- normalize_labels(df)
# 5 - From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
result <- aggregate(df[,names(df) != "subject" & names(df) != "activity"] ,
                    list(activity = df$activity, subject = df$subject), 
                    mean, 
                    na.rm = TRUE)
result <- append_mean_to_all_but_subject_and_activity(result)