library(monocle3)
df = read.csv("dtm_updatedweek3.csv", header = TRUE)
cell_names = df[,1]
df = df[,-1]
gene = colnames(df)
gene_annotation = as.data.frame(matrix(gene, ncol = 1))
colnames(gene_annotation) = c("gene_short_name")
rownames(gene_annotation) = gene
cell_metadata = as.data.frame(matrix(cell_names, ncol = 1))
colnames(cell_metadata) = c("tweets")
rownames(cell_metadata) = cell_names
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

cds = cluster_cells(cds, resolution=1e-5)
plot_cells(cds)

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

