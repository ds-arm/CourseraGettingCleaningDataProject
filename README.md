## README

This README describes the contents of this github repository.  

This repository contains the required material for the final project of the 
Johns Hopkins University 'Getting and Cleaning Data' course, offered through 
Coursera.  

The objective of this project is to demonstrate the principles of 'tidy data', 
which in short are:  

- Each column is a variable  
- Each row is an observation  
- Each type of observation is its own dataset  

### Contents of the repository

#### *run_analysis.R*

This R-script contains the code for preparing the raw data by transforming it 
into a tidy data form for further analysis.  The steps it performs are 
described in more detail in *Codebook.md*.

#### *Codebook.md*

This holds descriptions of the output data and the variables.  It also outlines 
the actions performed on the raw data to produce the output.

The raw data used can be sourced at the Coursera link [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
which also contains descriptions of the original data collection and the 
variables.  
 
#### *DataCleaningProject_step5_output.txt*

Step 5 of the project requires generation of a dataset with the mean for each 
variable aggregated (grouped) by activity and subject.  This file contains 
this dataset, in tidy form.  An extract is shown below containing the first 10 
rows and first four columns:  

```{r echo=FALSE}
head(read.table('./DataCleaningProject_step5_output.txt', header=TRUE)[,1:4], n=10)
```

To load and View the full dataset into R, use:  
`data <- read.table('./DataCleaningProject_step5_output.txt', header = TRUE)`  
`View(data)`


Date: 25 May 2020