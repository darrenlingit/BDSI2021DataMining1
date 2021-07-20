library(factoextra)
library(FCPS)
library(kmed)
library(cluster)
library(text2vec)
library(textmineR)

#in our case, since the data set was small, 2 of the 4 subgroups had about 300 tweets
#monocle3 does not work well with less observations. So we decided to do k-medoids clustering
#when the number of tweets was small.

df =  read.csv("XXXX.csv", header = TRUE)
rownames(df) = df[,1]
df = df[,-1]
df = df[, colSums(df)>0]
df = df[rowSums(df)>0,]
#find the optimal number of clusters using silhouette analysis

fviz_nbclust(df, pam, method = "silhouette")

#suppose the optimal number of clusters is k
#do k medoids clustering with k clusters:
d = df
rownames(d) = c(1:length(rownames(df))) #for better visualization with tweet ids, instead of the text
tweet <- pam(d, k) 
#visualize the clusters:
fviz_cluster(tweet, data = d)