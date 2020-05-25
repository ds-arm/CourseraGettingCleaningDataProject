## Codebook

### Data

As required for step 5, the data has the following structure:

The first two column variables were used to form groups from which aggregate 
statistics (**mean** values) were calculated.  

- *subject*:  Numerical value coded for individual volunteers in the study
- *activity*: One of six physical activities subjects undertook, during which 
measurements were collected.  

The remaining 66 column variables corresponding to **mean** values taken over 
each *subject* and *activity* for the measurement values represented from the 
original raw data, hosted by Cloudera [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  Consult the files 'readme.txt' and 'features_info.txt' in the archive for 
original descriptions of these features.  (These have not been reproduced here 
to minimise misinterpretation - any interested party is encouraged to read 
the orignal source in conjunction with this code to tidy the data.)

There resulting dataset contains 68 columns in total, with 2 denoting 
*subject* and *activity* and 66 containing the specified **mean** measurements.

The variable names in the output have been cleaned to be more systematic to 
assist subsequent analysis.  The naming format used in this data is:  

`domain.type.axis.stat`

where:  

- `domain` = 'time' or 'freq'
- `type` = the measurement and/or sensor that the value relates to.  Consult 
original description for more detailed explanation.
- `axis` = (optional).  If present, denotes X, Y, or Z axis of the measurement.  
- `stat` = mean or std (standard deviation).

Each row therefore corresponds to each subject (numbered 1 to 30) in each of 
6 activities, and the values are the **mean** of each measurement required. 
There are a total of 180 rows of data.  


### Preparing output data from raw

The following steps were taken in preparing the output data:  

- Test and training data were combined into a single dataset  
- Columns were filtered to retain variables that were either measurement means 
or standard deviations (as indicated by mean() or std() respectively in the 
name)  
- Names of retained column were transformed into the standardised format shown 
above  
- Descriptive names given for the six classes of activity  
- Dataset was grouped by subject and activity, and each variable reduced to its 
mean value.  
- Resultant dataset written to 'DataCleaningProject_step5_output.txt'





