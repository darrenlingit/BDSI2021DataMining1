newdtm4 = newdtm[,-c(231,232,233)]
newdtm3 = newdtm4[rowSums(newdtm4)!=0 ,]
row = dim(newdtm3)[1]
col = dim(newdtm3)[2]
wordco = matrix(rep(0,col*col), nrow = col)

#word co-occurrence matrix
wordco[col,col]=sum(newdtm3[,col])
for(i in 1:(col-1)){
  wordco[i,i]=sum(newdtm3[,i])
  for(j in (i+1):col){
    wordco[i,j] = length(which(newdtm3[,i]*newdtm3[,j]!=0))
    wordco[j,i] = wordco[i,j]
    }
}

#word distance matrix

wdist = matrix(rep(0,col*col), nrow = col)
wdist[col,col] = 0
for (i in 1:(col-1)) {
  wdist[i,i] = 0
  for(j in (i+1):col){
    wdist[i,j] = 2 - ((length(which(newdtm3[,i]*newdtm3[,j]!=0)))/(length(which(newdtm3[,i]!=0)))) - ((length(which(newdtm3[,i]*newdtm3[,j]!=0)))/(length(which(newdtm3[,j]!=0)))) 
    wdist[j,i] = wdist[i,j]
  }
}

rownames(wordco) = colnames(newdtm3)
rownames(wdist) = colnames(newdtm3)
colnames(wdist)=rownames(wdist)
colnames(wordco)=rownames(wordco)
write.csv(as.data.frame(wordco), "word_co-occurrence_matrix.csv")
write.csv(as.data.frame(wdist), "word_distance_matrix.csv")

#tweet distance matrix

tdist = matrix(rep(0,row*row), nrow = row)
tdist[row,row] = 0
for (i in 1:(row-1)) {
  tdist[i,i] = 0
  for(j in (i+1):row){
    c = which(newdtm3[i,]>0 & newdtm3[j,] == 0)
    d = which(newdtm3[j,]>0 & newdtm3[i,] == 0)
    a = length(c)
    b = length(d)
    tdist[i,j] = ifelse((a == 0 | b == 0), 0, mean(wdist[d,c]))
    tdist[j,i] = tdist[i,j]
  }
}
rownames(tdist) = rownames(newdtm3)
colnames(tdist)=rownames(tdist)
write.csv(as.data.frame(tdist), "tweet_distance_matrix.csv")


install.packages("factoextra", "FCPS", "kmed", "cluster")
library(factoextra)
library(FCPS)
library(kmed)
library(cluster)
library(text2vec)
library(textmineR)

#tdist1 = dist2(as.matrix(newdtm3), y = NULL, method = "cosine",
 #              norm = "none")
#write.csv(tdist1, "tweet_distance_matrix_cosine.csv")

#tdist2 = dist2(as.matrix(newdtm3), y = NULL, method = "euclidean",
 #              norm = "none")
#write.csv(tdist2, "tweet_distance_matrix_euclid.csv")

fviz_nbclust( wdist, FUNcluster = kmeans, method = "silhouette", diss = NULL, k.max = 50,nboot = 100,
  verbose = interactive(),barfill = "steelblue",barcolor = "steelblue",linecolor = "steelblue",print.summary = TRUE)

#word3 = kmeansDist(wdist, ClusterNo=3,Centers=NULL, RandomNo=1,maxIt = 2000, PlotIt=TRUE,verbose = F)

word2 <- kmeans(t(newdtm3), centers = 2, nstart = 25)
fviz_cluster(word2, data = t(newdtm3))
word6 <- kmeans(t(newdtm3), centers = 6, nstart = 25)
fviz_cluster(word6, data = t(newdtm3))
word3 <- kmeans(t(newdtm3), centers = 3, nstart = 25)
fviz_cluster(word3, data = t(newdtm3))

fviz_nbclust(t(newdtm3), kmeans, method = "wss")
fviz_nbclust(t(newdtm3), kmeans, method = "silhouette")
fviz_nbclust(t(newdtm3), kmeans, method = "gap_stat")


fviz_nbclust(newdtm3, kmeans, method = "wss")
fviz_nbclust(newdtm3, kmeans, method = "silhouette")

tweet2 <- kmeans(newdtm3, centers = 2, nstart = 25)
fviz_cluster(tweet2, data = newdtm3)

word2_med = pam(t(newdtm3),2)
fviz_cluster(word2_med, data = t(newdtm3))

tweet2_med = pam(newdtm3,2)
fviz_cluster(tweet2_med, data = newdtm3)

distance <- get_dist(t(newdtm3))
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))





















