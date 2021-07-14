library(monocle3)
library(dbscan)
library(fpc)
library(cluster)
df = read.csv("tweet_dtm.csv", header = TRUE)
df_VA1 = df[which(df[,6] == 1), -c(1:6)]
df_VA0 = df[which(df[,6] == 0), -c(1:6)]
df_sent1 = df[which(df[,4] == 1), -c(1:6)]
df_sent0 = df[which(df[,4] == 0), -c(1:6)]
tdist_VA1 = dist2(as.matrix(df_VA1), y = NULL, method = "euclidean", norm = "none") #instead of df
#use appropriate dtm
tdist_VA0 = dist2(as.matrix(df_VA0), y = NULL, method = "euclidean", norm = "none")
tdist_sent1 = dist2(as.matrix(df_sent1), y = NULL, method = "euclidean", norm = "none")
tdist_sent0 = dist2(as.matrix(df_sent0), y = NULL, method = "euclidean", norm = "none")
cell_names_VA1 = df[which(df[,6] == 1), 1]
cell_names_VA0 = df[which(df[,6] == 0), 1]
cell_names_sent1 = df[which(df[,4] == 1), 1]
cell_names_sent0 = df[which(df[,4] == 0), 1]
gene_VA1 = colnames(df_VA1)
gene_VA0 = colnames(df_VA0)
gene_sent1 = colnames(df_sent1)
gene_sent0 = colnames(df_sent0)
gene_annotation = as.data.frame(matrix(gene_VA1, ncol = 1))
colnames(gene_annotation) = c("gene_short_name")
rownames(gene_annotation) = gene_VA1
cell_metadata_VA1 = as.data.frame(matrix(cell_names_VA1, ncol = 1))
cell_metadata_VA0 = as.data.frame(matrix(cell_names_VA0, ncol = 1))
cell_metadata_sent1 = as.data.frame(matrix(cell_names_sent1, ncol = 1))
cell_metadata_sent0 = as.data.frame(matrix(cell_names_sent0, ncol = 1))

colnames(cell_metadata_VA1) = c("tweets")
rownames(cell_metadata_VA1) = cell_names_VA1
colnames(cell_metadata_VA0) = c("tweets")
rownames(cell_metadata_VA0) = cell_names_VA0
colnames(cell_metadata_sent1) = c("tweets")
rownames(cell_metadata_sent1) = cell_names_sent1
colnames(cell_metadata_sent0) = c("tweets")
rownames(cell_metadata_sent0) = cell_names_sent0

rownames(tdist_VA1) = cell_names_VA1
colnames(tdist_VA1) = rownames(tdist_VA1)
rownames(df_VA1) = rownames(tdist_VA1)
rownames(tdist_VA0) = cell_names_VA0
colnames(tdist_VA0) = rownames(tdist_VA0)
rownames(df_VA0) = rownames(tdist_VA0)
rownames(tdist_sent1) = cell_names_sent1
colnames(tdist_sent1) = rownames(tdist_sent1)
rownames(df_sent1) = rownames(tdist_sent1)
rownames(tdist_sent0) = cell_names_sent0
colnames(tdist_sent0) = rownames(tdist_sent0)
rownames(df_sent0) = rownames(tdist_sent0)

#from the next line on, replace df with any of the previous dataframes created
cds <- new_cell_data_set(t(df),
                         cell_metadata = cell_metadata,
                         gene_metadata = gene_annotation)
cds <- cds[,Matrix::colSums(exprs(cds)) != 0]
cds <- estimate_size_factors(cds)
size_factors(cds)

#cds <- new_cell_data_set(t(df),cell_metadata = df,gene_metadata = t(df))
#colData(cds)$Size_Factor = rep(1, length(df[,1]))
#size_factors(cds)
cds <- preprocess_cds(cds, num_dim = 100)
plot_pc_variance_explained(cds)
cds <- reduce_dimension(cds)
plot_cells(cds)
plot_cells(cds, genes=c("student","requir", "mandat", "univ"))

cds1 = cds
cds1 = cluster_cells(cds1, resolution=1e-5)
plot_cells(cds1)

#for dbscan, need to specify tuning parameters eps and minPts. For minPts,
#take ln(n) and for eps, take the value at which there is a knee in the knn dist plot
#set the tuning parameters of dbscan to these 2 parameters and from the results of dbscan,
#remove the noise, if necessary
kNNdistplot(df[names(cdsi@clusters@listData$UMAP$cluster_result$optim_res$membership),])
 #silhouette analysis for deciding upon the number of k nearest neighbours
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

marker_test_res <- top_markers(cds, group_cells_by="partition")

top_specific_markers <- marker_test_res %>%
  filter(fraction_expressing >= 0.10) %>%
  group_by(cell_group) %>%
  top_n(1, pseudo_R2)

top_specific_marker_ids <- unique(top_specific_markers %>% pull(gene_id))

plot_genes_by_group(cds,
                    top_specific_marker_ids,
                    group_cells_by="partition",
                    ordering_type="maximal_on_diag",
                    max.size=3)

