# CodeBook 

This Code Book explains the various variable names used in the code - run_analysis.R and the transformations used in the process of creating the final tidy dataset (mean_activity_dataset.txt). 

## Libraries used

tidyR - https://tidyr.tidyverse.org/

## Variables used 

**col_lbls_x** - dataframe containing the list of features 
**col_lbls_list** - list that merges the two columns from col_lbls_x, will eventually be used as the col labels for X

### Test data 
**test_subject** - dataframe containing the subject file of the test dataset 
**test_x** - dataframe containing the X values of the test dataset, eventually cleaned up using dplyr separate and labeled using col_lbls_list
**test_y** - dataframe containing the Y values of the test dataset 
**all_test_df** - dataframe created using cbind of the prior three test dataframes 

### Training data
**train_subject** - dataframe containing the subject file of the training dataset 
**train_x** - dataframe containing the X values of the training dataset, , eventually cleaned up using dplyr separate and labeled using col_lbls_list
**train_y** - dataframe containing the Y values of the training dataset
**all_train_df** - dataframe created using cbind of the prior three training dataframes 

**all_data_df**- merged dataframe containing data from both all_train_df and all_test_df

### Data transformations

- **train_x** and **test_x** were created using dplyr separate on spaces, and columns labeled using col_lbls_list (feautures)
- Activity numbers in **all_data_df** were replaced with actual activity names using gsub
- **all_mean_std_df** was created by keeping only the columns in **all_data_df** that containg mean or standard deviation values along with the subject and activity columns 
- After converting the subject and activity columns to factors, **new_tidy_df** was created from **all_mean_std_df**  using group_by on the two columns and summarised across everything using the mean function. 
- The final output file **mean_activity_dataset.txt** was created using the write.table function with a tab separation. 

