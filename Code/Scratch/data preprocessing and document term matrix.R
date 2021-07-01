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
tweet_data$stripped_text <- gsub("(^')|('$)|'|''", "" ,  tweet_data$stripped_text)

#till now, basically the relevant libraries were called and urls and  
#apostrophes or quotation marks were removed

#now the document term matrix will be created
dtm<- CreateDtm(tweet_data$stripped_text,
                ngram_window = c(1, 1),
                lower = TRUE,
                remove_punctuation = TRUE,
                remove_numbers = TRUE,
                stem_lemma_function = wordStem)

#i tried to incorporate the criteria for removing stop words before wordStem using the stem_lemma_function
#argument (i saw an example in R documentation that was like
# stem_lemma_function = function(x) SnowballC::wordStem(x, "porter"), so basically i tried
# to write a function with anti_join(stop_words) before calling wordStem but i probably
#didnt understand how to work it out so it kept on showing errors)
#so now we have to remove columns corresponding to stop words from the matrix

#for this purpose i turned it into a dataframe so that i couse use anti_join
#the output from CreateDtm was a sparse matrix and hence i used as.matrix to turn it into a matrix
#i also turned into a term document matrix so tat i could have the processed words corresponding
#to the rows.This was necessary for the anti_join function which removes rows with matched items
dtm2 = as.data.frame(as.matrix(t(dtm)))

#now, R's list of stopwords contained apostrophes and were not in root forms. So i did the same
#set of operations to them. Removed apostrophes, punctuation, converted to lower case and stemmed them
#This was done in steps 41 to 46 
stop_words$clean <- gsub("(^')|('$)|'|''", "" ,  stop_words$word)
stopwords <- stop_words %>%
  dplyr::select(clean) %>%
  unnest_tokens(word, clean)
stopwordsnew = stopwords %>%
  mutate(stem = wordStem(word))

dtm2$words = rownames(dtm2)  #this was an unnecessary step
dtm2$stem = rownames(dtm2)
newmat <- dtm2 %>%
  anti_join(stopwordsnew)

newmat = subset(newmat, select = -c(2861,2862)) 
#for some reason in the newmat matrix i coult take means of rows. So i converted it again to a 
#document-term matrix using as.matrix and transpose operations
dtm = as.data.frame(t(as.matrix(newmat)))
#calculating proportion of words across all documents
frac=c()
for(i in 1:(dim(dtm)[2])){
  frac[i] = mean(dtm[,i])
}
newmat$frac = frac
newmat$words = rownames(newmat) # 61,62 for plottingthe proportions

newmat %>%
  arrange(desc(frac)) %>%
  top_n(15) %>%
  ggplot(aes(x=words, y=frac)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Proportion",
       y = "words",
       title = "Proportion of words found in tweets")
#my laptop shut down unexpectedly i couldn't save the plot.
#i dont know if it runs correctly, but i think it should

new_code <- vector()