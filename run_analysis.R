# Cleans up data obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# into a tidy dataset 
# Karthik Padmanabhan   Jan 26, 2022
# v0.1

# import required libraries 
library(tidyr)

# read in test data
test_subject = read.delim2('rawdata/test/subject_test.txt', header=FALSE, col.names=c('subject'))
test_x = read.delim2('rawdata/test/X_test.txt', sep='\t', header=FALSE, strip.white=TRUE)
test_y = read.delim2('rawdata/test/y_test.txt', header=FALSE, col.names=c('activity'))
col_lbls_x = read.delim2('rawdata/features.txt', header=FALSE, sep=' ', strip.white = TRUE)
col_lbls_list = paste(col_lbls_x$V1, col_lbls_x$V2, sep="_")

# clean up the test tables - for Step 4
test_x = separate(test_x, col='V1',  sep=' +', into = col_lbls_list, convert = TRUE)

# bind all test dataframes together
all_test_df = cbind(test_y, test_subject, test_x)

# read in training data
train_subject = read.delim2('rawdata/train/subject_train.txt', header=FALSE, col.names=c('subject'))
train_x = read.delim2('rawdata/train/X_train.txt', sep='\t', header=FALSE, strip.white=TRUE)
train_y = read.delim2('rawdata/train/y_train.txt', header=FALSE, col.names=c('activity'))

# clean up the training tables - for Step 4
train_x = separate(train_x, col='V1',  sep=' +', into = col_lbls_list, convert = TRUE)

# bind all training dataframes together
all_train_df = cbind(train_y, train_subject, train_x)

# merge training and test data into one table - end of step 1
all_data_df = rbind(all_train_df, all_test_df)

# replace activity number with actual activity - required for step 3
all_data_df$activity = gsub(1, 'WALKING', all_data_df$activity)
all_data_df$activity = gsub(2, 'WALKING_UPSTAIRS', all_data_df$activity)
all_data_df$activity = gsub(3, 'WALKING_DOWNSTAIRS', all_data_df$activity)
all_data_df$activity = gsub(4, 'SITTING', all_data_df$activity)
all_data_df$activity = gsub(5, 'STANDING', all_data_df$activity)
all_data_df$activity = gsub(6, 'LAYING', all_data_df$activity)

# keep only cols with mean/std values for each measurement - end of step 2 
all_mean_std_df = cbind(all_data_df[,c(1,2)], all_data_df[,grepl('mean|std', colnames(all_data_df))]) 

# create a new tidy set with average of each variable for each activity and each subject - Step 5
# convert activity and subject into factors 
all_mean_std_df$activity = as.factor(all_mean_std_df$activity)
all_mean_std_df$subject = as.factor(all_mean_std_df$subject)

new_tidy_df = all_mean_std_df %>%
                group_by(activity, subject) %>%
                    summarise(across(everything(), mean, na.rm = TRUE))

write.table(new_tidy_df, file='mean_activity_dataset.txt', sep='\t', col.names = TRUE,
            row.names = FALSE)
