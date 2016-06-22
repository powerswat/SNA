# SNALeadership


> ### Measuring leadership index of an individual user based on the user's message sending patterns and receiving patterns

## Introduction
This program is to quantify the leadership of an individual by analyzing text information that the person left on a online discussion board. This analysis is specialized in a particular online-based class setting provided by the Ohio State University. It applies an AdaBoost classifier to predict a leadership score 


## How to run
To be added


## How the algorithm works (Please ignore this part unless you are interested in the detail structure of this program)

### Data Pre-processing 
It starts its analysis with input data pre-processing by reading and parsing the discussion data from .tsv files. As a result of this pre-processing, it provides a tabular structure of read files. Then, it automatically locates the columns of textual data we want to process by comparing ratio of letters and digits in every column.


### Feature Vector Generation
Once the program locates the column of targted textual data, it generates a matrix of feature vectors for all the appointed leaders and non-appointed leaders and labels each table as a leaders' set and a followers' set respectively. A single row of each matrix represents a single textual posting data from an individual user and a single column of it refers to a feature (= term) included in a set of all postings in the .tsv data file. Each cell element in the matrix contains the number of occurence of a single term appears in a single posting of an individual user. We have collected 57 students' posting data from 4 sections of the abovementioned online discussion class as total. It contains 5235 postings as total which consists of 1664 leaders' postings and 3571 follwers' postings.


### Analysis
The anlaysis process is composed of the following three steps: traning, cross-validation, and testing. An AdaBoost model is used for the analysis. In training phase, the model uses 90% of the whole data set as a training set to learn the pattern of the posting data. Also, the 10% of the training set is used to proceed a 10-fold cross-validation process. Once it achieves a mininum requirement accuracy (which is set to 80% of true positive accuracy as default) it stops the current validation process and move on to the next step which is testing. 
The true positive, predicting the appointed leaders, is set to the default metric to optimize because the goal of this analysis is to explain leaders' characteristics accurately and quantify them precisely. Unlike the traditional cross-validation approach, this program shuffles the whole training data, re-generates a 10-fold cross-validation set, and runs the training and cross-validation again if none of the cross-validation accuracy data does not reach the minimum requirement criterion to secure the generality of this model. 
After completion of the cross-validation, the model is tested by the testing set which inlcudes 10% of the entire data set and each entry of which did not appear in the training data set. Similar to the cross-validation process, it repeats the training and the cross-validation steps until the true positive testing accuracy reaches the minimum requirement true positive accuracy. It means that once the entire analysis steps are over, the model derived from this analysis has reasonable cross-validation accuracy and testing accuracy at the same time. This makes sure not only the model trained has an ability to explain the leadership on a general level but also confirms that this generality of the model was not achieved by just coincidence.


### Application (To be devleoped)
Once the model is well trained so it produces a desired level of cross-validation accuracy and testing accuracy, The program will visualize all the class members in the order of each member's leadership index. It helps a user compare common characteristics of leadership. It can be also combined with other social network models to derive more accurate and more explanable metrics.
