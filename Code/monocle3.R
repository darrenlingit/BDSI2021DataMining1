library(monocle3)
library(dbscan)
library(fpc)
library(cluster)

#read in a dtm file "XXXX.csv"

df = read.csv("XXXX.csv", header = TRUE)

#creating the cell (document) metadata and gene (term) annotation data frames
cell_names = df[,1]
rownames(df) = df[,1]
df = df[,-1]
cell_metadata = as.data.frame(matrix(cell_names, ncol = 1))

colnames(cell_metadata) = c("tweets")
rownames(cell_metadata) = cell_names

df = df[,colSums(df)>2] #removing terms that occur less than 2 times in the tweets 
#(for the original datasets. We skipped this for subsequent steps of clustering)

gene = colnames(df)
gene_annotation = as.data.frame(matrix(gene, ncol = 1))
colnames(gene_annotation) = c("gene_short_name")
rownames(gene_annotation) = gene

#from the next line on, replace df with any of the previous dataframes created
cds <- new_cell_data_set(t(df),
                         cell_metadata = cell_metadata,
                         gene_metadata = gene_annotation)
#estimate size factors:
cds <- cds[,Matrix::colSums(exprs(cds)) != 0]
cds <- estimate_size_factors(cds)
#size_factors(cds)

#preprocess the cell dataset and reduce dimensions. We haven't specified
#any particular method for dimension reduction. So by default PCA will be chosen
cds <- preprocess_cds(cds, num_dim = 100)
plot_pc_variance_explained(cds)
cds <- reduce_dimension(cds)
plot_cells(cds)
#We marked the tweets by 4 particular words belonging to our dataset
#plot_cells(cds, genes=c("student","requir", "mandat", "univ"))

cds1 = cds
cds1 = cluster_cells(cds1, k, resolution=1e-5)
plot_cells(cds1)  #clustering with default value of k =20

#determining k:

#now before clustering, we may want to use dbscan for detecting small communities and noise.
#In our case, dbscan detected most of the tweets as noise and 
#since we already had a small dataset to begin with, we skipped this step to apply the 
#phenograph algorithm of monocle3 to the entire dataset
#but depending on the data, this step may be necessary

#for dbscan, we need to specify tuning parameters eps and minPts. For minPts,
#take ln(n) (n is the number of tweets) and for eps, take the value at which 
#there is a knee in the knn dist plot
kNNdistplot(df[names(cds1@clusters@listData$UMAP$cluster_result$optim_res$membership),], minPts)
#names(cds1@clusters@listData$UMAP$cluster_result$optim_res$membership) gives the vector of tweets
#involved in clustering; can use rownames as well
#set the tuning parameters of dbscan to these 2 values
ds = fpc::dbscan(df[names(cds1@clusters@listData$UMAP$cluster_result$optim_res$membership),],eps,minPts)

#now we have to determine the optimal value of k for the k nearest neighbours parameter
#for clustering. This may be done by calculating and plotting the average silhouette width for varying k
#for large k, number of clusters decreases and for small k, the reverse happens. For our data, 
#we mostly considered k=4,8,12,16,20 (because our dataset was small, and for k=20 in most cases
#the number of clusters became 1 or 2) and looking at the clustering results, chose the optimal one
#depending upon how large the smallest cluster was and what we intended to do from the clustering results
#In our case, the highest silhouette width was for k=4, but sometimes we chose higher values of k
#as for k=4 there were often too many clusters, with smallest clusters containing not many tweets.
#So, i guess, this step depends a lot on what we intend to do with the clustering results.
#silhouette analysi:

library(text2vec)
#calculate the tweet distance matrix using euclidean distance
tdist = dist2(as.matrix(df), y = NULL, method = "euclidean", norm = "none")
rownames(tdist) = cell_names
colnames(tdist) = rownames(tdist)

sil = c(); i = 1
while(i <= 10){
  cdsi = cds
  cdsi = cluster_cells(cdsi, k=4*i, resolution=1e-5)
  s = silhouette(cdsi@clusters@listData$UMAP$cluster_result$optim_res$membership , 
                 dmatrix = tdist[names(cdsi@clusters@listData$UMAP$cluster_result$optim_res$membership),
                                 names(cdsi@clusters@listData$UMAP$cluster_result$optim_res$membership)])
  sil[i] = summary(s)$avg.width
  print(sil[i])
  i = i+1
}
plot(sil)

#if optimal value of k is k:
cds1 = cds
cds1 = cluster_cells(cds1, k, resolution=1e-5)
plot_cells(cds1)

#save the tweets in the largest cluster, cluster 1
y = which(cds1@clusters@listData$UMAP$cluster_result$optim_res$membership == 1)
df_new = df[y,]
rownames(df_new) = rownames(df)[y]
#save it as a dataframe for recursive clustering
write.csv(df_new, "XXXX_cluster1.csv")

#finding feauture words and plotting them:
marker_test_res <- top_markers(cds1, group_cells_by="cluster")

top_specific_markers <- marker_test_res %>%
  filter(fraction_expressing >= 0.10) %>%
  group_by(cell_group) %>%
  top_n(1, pseudo_R2)

top_specific_marker_ids <- unique(top_specific_markers %>% pull(gene_id))

plot_genes_by_group(cds1,
                    top_specific_marker_ids,
                    group_cells_by="cluster",
                    ordering_type="maximal_on_diag",
                    max.size=3)

