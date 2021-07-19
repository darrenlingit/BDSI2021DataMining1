# BDSI 2021 Data Mining Group 1
This is the repository for Data Mining Group 1 in the Summer 2021 Big Data Summer Institute at the University of Michigan. 
Our project focuses on implementing topic modeling methods for textual data obtained from Twitter on the topic of COVID-19 vaccination. 
The goal of our project is to develop a method for incorporating the sentiment of the tweets into clustering algorithms.

### Authors:
Jamie Forschmiedt, Darren Lin, Tannistha Mondal, Jakob Woerner

### Project mentors:
Dr. Johann Gagnon-Bartsch, Juejue Wang, Heather Johnston

### Steps:

0. Download tweets with "Downloading Tweets to a CSV.ipynb" (You can skip this if you already have the tweets downloaded)
1. Determine sentiments with "vader_r_final.Rmd"
2. Classify pro-vaccine or anti-vaccine with "Random Forest Labeling.ipynb"
2.5. Clean up and create document-term matrices with "data preprocessing modified.R"
4. Cluster with "monocle3.R" if DTM has more than 300 observations; cluster with "k medoids.R" if DTM has less than 300 observations
