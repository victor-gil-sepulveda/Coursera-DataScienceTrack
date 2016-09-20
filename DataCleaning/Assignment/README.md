# Programming assignment for Coursera Data Cleaning Course

## First steps

1 - Downloading the data set (not included in the repo):
```bash
mkdir data
cd data
wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
unzip getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
```

2 - Check the feature names and meanings in the website (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the features info file.

3 - Initial exploration of the data set using bash:
```bash
> head -n 1 train/X_train.txt| wc 
      1     561    8978
> wc train/X_train.txt 
    7352  4124472 66006256 train/X_train.txt
> wc features.txt 
  561  1122 15785 features.txt
> wc train/y_train.txt 
 7352  7352 14704 train/y_train.txt
```

X\_train is the dataset itself. Features holds the name of each feature in X\_train. y\_train contains a label per training record.

## Working with the R script

I have coded a single R script (run\_analysis.R) in which each of the required steps has been programmed in one (or more than one) separate functions. In order to get the results first load and unzip the dataset in the __data__ folder. Then load and execute the whole script in R studio. 
You will be able to modify the expected paths by changing the function parameters. 

## References
 - Data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 - Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 



