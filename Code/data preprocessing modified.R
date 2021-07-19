library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
library(textmineR)
library(SnowballC)
#setwd("C:/Users/STST/Downloads")
#tweet_data=read.csv("vaccine_college_500.csv", header=TRUE)
#tweet_data2=read.csv("vaccine_college_500_2.csv", header=TRUE)
#tweet_datatemp = rbind(tweet_data, tweet_data2)
#tweet_data = rbind(tweet_datatemp,tweet_data3)
#tweet_data = tweet_data[!duplicated(tweet_data$text),]
#tweet_data$stripped_text <- gsub("http.*","",  tweet_data$text)

#since the processed tweets (from which we are going to form a dtm) have all apostrophes removed,
#we are removing apostrophes from the list of stopwords.We checked the source code of CreateDtm
#and if the arguments lower, remove_punctuation and remove_numbers are set to TRUE
#then all of these are applied to both the vector of characters and the vector containing stopwords.

y = c(tm::stopwords("english"), tm::stopwords("SMART"))
x <- gsub("'", '', y)

df = read.csv("../Data/tweet_dtm.csv", header = TRUE)
dtm<- CreateDtm(df$text, df$text,
                ngram_window = c(1, 1), stopword_vec = x,
                lower = TRUE,
                remove_punctuation = TRUE,
                remove_numbers = TRUE,
                stem_lemma_function = wordStem)

dtm.df = as.data.frame(as.matrix(dtm)) #we want it as a dataframe

#If remove_punctuation is set to TRUE, it coverts all non-alpha-numeric characters to spaces.
#So, some stopwords with punctuation marks right after them, might not be recognised as stopwords
#as after removal of punctuation, they will be converted to character string with a space at the end.
#For this, after the dtm has been created, we will check which columns correspond to words
#from the stopwords list and remove them. In our data, some words like "shouldn", "wasn" still remained
#but they occurred very few times (most of the words occurred once or twice) and were mostly 
#due to spelling errors or abbreviations in the
#original tweets, so they were left like that, for words with such small occurrences are assumed not to 
#influence clustering greatly.

a = which(colnames(dtm.df) %in% x == TRUE)
#apply(dtm.df[a], 2, sum)
dtm.df = dtm.df[, -a]

#shall remove keywords "colleg", "vaccin" and also "covid" from our dtm, as they occur very frequently

b = c(which(colnames(dtm.df) == "colleg"), which(colnames(dtm.df) == "vaccin"), which(colnames(dtm.df) == "covid"))
dtm.df = dtm.df[, -b]

#add columns corresponding to Vaccine Attitude (VA) and Vade Sentiment, each with weights of 5
#for the Vader sentiment column, the positive sentiment score returned by the vader algorithm
#has been used, multiplied by 5 and rounded off to the nearest integer.

dtm.df$VA = 5*(df[,6])
dtm.df$VaderSenti = round(5*(df[,2]))
write.csv(dtm.df , "../Data/dtm_all.csv")

#Shall create dtms for VA = 1 and positive vader sentiment (1)
#VA = 0 and positive vader sentiment(1)
#VA = 1 and negative vader sentiment (0)
#VA = 0 and negative vader sentiment (0)

v1 = which(df[,6] == 1 & df[,4] == 1)
v2 = which(df[,6] == 0 & df[,4] == 1)
v3 = which(df[,6] == 1 & df[,4] == 0)
v4 = which(df[,6] == 0 & df[,4] == 0)
 
df1 = dtm.df[v1,-c(6621,6622)]
df1 = df1[,colSums(df1)>0]
write.csv(df1, "../Data/df_VA1_s1.csv")
df2 = dtm.df[v2,-c(6621,6622)]
df2 = df2[,colSums(df2)>0]
write.csv(df2, "../Data/df_VA0_s1.csv")
df3 = dtm.df[v3,-c(6621,6622)]
df3 = df3[,colSums(df3)>0]
write.csv(df3, "../Data/df_VA1_s0.csv")
df4 = dtm.df[v4,-c(6621,6622)]
df4 = df4[,colSums(df4)>0]
write.csv(df4, "../Data/df_VA0_s0.csv")



















