library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
library(textmineR)
library(SnowballC)
tweet_data=read.csv("vaccine_college_500.csv", header=TRUE)
tweet_data$stripped_text <- gsub("http.*","",  tweet_data$text)


dtm<- CreateDtm(tweet_data$stripped_text,
                       ngram_window = c(1, 1), stopword_vec = c(tm::stopwords("english"), tm::stopwords("SMART")),
                      lower = TRUE,
                     remove_punctuation = TRUE,
                     remove_numbers = TRUE,
                     stem_lemma_function = wordStem)

dtm.df = as.data.frame(as.matrix(dtm)) #in case we want it as a dataframe