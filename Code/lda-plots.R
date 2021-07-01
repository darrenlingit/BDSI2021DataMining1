newdtm4 = newdtm[,-c(205,206,207)]
newdtm3 = newdtm4[rowSums(newdtm4)!=0 ,]
lda3 = LDA(newdtm3, 3, method = "VEM", control = NULL)
ap_topics <- tidy(lda3, matrix = "beta")
ap_topics

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

ap_documents <- tidy(lda3, matrix = "gamma")
ap_documents

