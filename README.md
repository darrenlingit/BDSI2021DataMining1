# BDSI 2021 Data Mining Group 1
This is the repository for Data Mining Group 1 in the Summer 2021 Big Data Summer Institute at the University of Michigan. 
Our project focuses on implementing topic modeling methods for textual data obtained from Twitter on the topic of COVID-19 vaccination. 
The goal of our project is to develop a method for incorporating the sentiment of the tweets into clustering algorithms.

### Authors:
Jamie Forschmiedt, Darren Lin, Tannistha Mondal, Jakob Woerner

### Project mentors:
Dr. Johann Gagnon-Bartsch, Juejue Wang, Heather Johnston

### Steps:

0. Download tweets with "0_Downloading Tweets to a CSV.ipynb" (You can skip this if you already have the tweets downloaded)
1. Determine sentiments with "1_vader_r.Rmd"
2. Classify pro-vaccine or anti-vaccine with "2_Random Forest Labeling.ipynb"
2.5. Clean up and create document-term matrices with "3_data preprocessing modified.R"
4. Cluster with "4_monocle3.R" if DTM has more than 300 observations; cluster with "4_k medoids.R" if DTM has less than 300 observations
