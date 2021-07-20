# BDSI 2021 Data Mining Group 1
This is the repository for Data Mining Group 1 in the Summer 2021 Big Data Summer Institute at the University of Michigan. 
Our project focuses on implementing topic modeling methods for textual data obtained from Twitter on the topic of COVID-19 vaccination. 
The goal of our project is to develop a method for incorporating the sentiment of the tweets into clustering algorithms.

### Research Question:
How do people's thoughts on vaccine mandates for college campuses vary between different levels of vaccine sentiments and vaccine acceptance?

### Authors:
Jamie Forschmiedt, Darren Lin, Tannistha Mondal, Jakob Woerner

### Project mentors:
Dr. Johann Gagnon-Bartsch, Juejue Wang, Heather Johnston

### Steps:

0. Download tweets with `0_Downloading Tweets to a CSV.ipynb` (You can skip this if you already have the tweets downloaded)
1. Determine sentiments with `1_vader_r.Rmd`
2. Classify pro-vaccine or anti-vaccine with `2_Random Forest Labeling.ipynb`
3. Clean up and create document-term matrices with `3_data preprocessing modified.R`. After this, you should get 5 data files
   
   1. `dtm_all.csv` contains all the tweets, the document-term matrix, the vaccine acceptance labels, and the vaccine sentiment labels.
   2. `df_VA1_s1.csv`, `df_VA0_s1.csv1`, `df_VA1_s0.csv`, and `df_VA0_s0.csv` contain tweets separated by vaccine acceptance (positive = 1, negative = 0) and sentiment label (positive = 1, negative = 0)

4. Cluster using the files from step 3. Use `4_monocle3.R` if the file has more than 300 observations; use `4_k medoids.R` if DTM has less than 300 observations.
5. *(Optional) If you find that a cluster created in* `4_monocle3.R` *is much larger than the other clusters, you rerun* `4_monocle3.R` *on just the large cluster.*
