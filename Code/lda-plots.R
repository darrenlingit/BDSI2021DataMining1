set.seed(123)
newdtm =  read.csv("dtm50_week3.csv", header = TRUE)
newdtm=newdtm[,-1]
newdtm4 = newdtm[,-c(231, 232, 233)]
newdtm3 = newdtm4[rowSums(newdtm4)!=0 ,]
library(topicmodels)
library(reshape2)
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

ap_top_docus <- ap_documents %>%
  group_by(topic) %>%
  slice_max(gamma, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -gamma)

ap_top_docus %>%
  mutate(document = reorder_within(document, gamma, topic)) %>%
  ggplot(aes(gamma, document, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

newdtm =  read.csv("dtm_restricted_tweets50.csv", header = TRUE)
newdtm=newdtm[,-1]
newdtm4 = newdtm[,-c(211,212,213)]
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

ap_top_docus <- ap_documents %>%
  group_by(topic) %>%
  slice_max(gamma, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -gamma)

ap_top_docus %>%
  mutate(document = reorder_within(document, gamma, topic)) %>%
  ggplot(aes(gamma, document, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

lda2 = LDA(newdtm3, 2, method = "VEM", control = NULL)
ap_topics <- tidy(lda2, matrix = "beta")
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

ap_documents <- tidy(lda2, matrix = "gamma")
ap_documents

ap_top_docus <- ap_documents %>%
  group_by(topic) %>%
  slice_max(gamma, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -gamma)

ap_top_docus %>%
  mutate(document = reorder_within(document, gamma, topic)) %>%
  ggplot(aes(gamma, document, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()
