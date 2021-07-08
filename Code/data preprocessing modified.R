library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
library(textmineR)
library(SnowballC)
setwd("C:/Users/STST/Downloads")
tweet_data=read.csv("vaccine_college_500.csv", header=TRUE)
tweet_data2=read.csv("vaccine_college_500_2.csv", header=TRUE)
tweet_data3=read.csv("vaccine_college_500_3.csv", header=TRUE)
tweet_datatemp = rbind(tweet_data, tweet_data2)
tweet_data = rbind(tweet_datatemp,tweet_data3)
tweet_data = tweet_data[!duplicated(tweet_data$text),]
tweet_data$stripped_text <- gsub("http.*","",  tweet_data$text)


dtm<- CreateDtm(tweet_data$stripped_text,
                       ngram_window = c(1, 1), stopword_vec = c(tm::stopwords("english"), tm::stopwords("SMART")),
                      lower = TRUE,
                     remove_punctuation = TRUE,
                     remove_numbers = TRUE,
                     stem_lemma_function = wordStem)

dtm.df = as.data.frame(as.matrix(dtm)) #in case we want it as a dataframe
write.csv(dtm.df , "dtm_updated.csv")

dtm50 = dtm[,(colSums(dtm)>50)]
dtm50.df = as.data.frame(as.matrix(dtm50)) #in case we want it as a dataframe
write.csv(dtm50.df , "dtm50_week3.csv")

tweet_data$slot_tweet <- str_count(tweet_data$text, "Navale Medical College")
tweet_data_new = tweet_data[-(which(tweet_data$slot_tweet > 0)),]
tweet_data_new$newslot_tweet <- str_count(tweet_data$text, "BMCC-DEENANATH HOSPITAL PVT")
tweet_data_new2 = tweet_data_new[-(which(tweet_data_new$newslot_tweet > 0)),]
dtm<- CreateDtm(tweet_data_new2$stripped_text, tweet_data_new2$text,
                             ngram_window = c(1, 1), stopword_vec = c(tm::stopwords("english"), tm::stopwords("SMART")),
                            lower = TRUE,
                                 remove_punctuation = TRUE,
                +                 remove_numbers = TRUE,
                +                 stem_lemma_function = wordStem)

dtm.df = as.data.frame(as.matrix(dtm)) #in case we want it as a dataframe
write.csv(dtm.df , "dtm_restricted_tweets.csv")
dtm = dtm[, colSums(dtm)>50]
dtmnew50.df = as.data.frame(as.matrix(dtm)) #in case we want it as a dataframe
write.csv(dtmnew50.df , "dtm_restricted_tweets50.csv")























