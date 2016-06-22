# SNALeadership


> ### Measuring leadership index of an individual user based on the user's message sending patterns and receiving patterns

## Introduction
This program is to quantify the leadership of an individual by analyzing message sending patterns and receving patterns that the person in every session of his/her discussion. This analysis is specialized in a particular online-based class setting provided by the Ohio State University. It applies an AdaBoost classifier to predict a leadership score.


## How to run
To be added


## How the algorithm works (Please ignore this part unless you are interested in the detail structure of this program)

### Data Pre-processing 
It starts its analysis with input data pre-processing by reading tables of message communication data from .tsv files. The i-th row of the table represents the message sending history of student i in a one-week discussion and j-th column represents the message receiving history of student j in the same discussion. Therfore, an element (i,j) in the table refers to the number of messages student i sent to student j during a single discussion. We were able to collect 40 of those tables collected from 4 sections of 10 weekly discussions.


### Feature Vector Generation
Once the program reads the tables, it generates a matrix of feature vectors for a group of all the appointed leaders and that of the other students and labels each table as a leaders' set and a followers' set respectively. We have collected 57 students' posting data from 4 sections of the abovementioned online discussion class as total. It contains 656 message sending/receiving records as total which consists of 52 records from the leaders and 604 records from the followers.


### Analysis
The anlaysis process is composed of traning and testing steps. Since the volume of data was not large enough, we were not able to prepare another portion of training data for a validation set. An AdaBoost model is used for the analysis. In training phase, the model uses 90% of the whole data set as a training set to learn the pattern of the posting data. Once the model fully learns the training data, it starts testing with the rest 10% of the whole data that did not appear in the training set. 
The true positive, predicting the appointed leaders, is set to the default metric to optimize because the goal of this analysis is to explain leaders' characteristics accurately and quantify them precisely. Unlike the traditional testing approach, this program shuffles the whole training data, re-generates a training and a testing set, and runs the training and cross-validation again if the testing accuracy data does not reach the minimum requirement criterion (which is set to 90% as default) to capture the general characteristics of leadership.


### Application (To be devleoped)
Once the model is well trained so it produces a desired level of testing accuracy, the program will visualize all the class members in the order of each member's leadership index. It helps a user compare the common characteristics of leadership. It can be also combined with other social network models to derive more accurate and more explanable metrics.
