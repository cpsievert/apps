library(babynames)
library(dplyr)
popular <- babynames %>%
  group_by(name) %>%
  summarise(N = sum(n)) %>%
  arrange(desc(N))

top <- top_n(popular, 1000)
topnames <- subset(babynames, name %in% top[["name"]])
saveRDS(topnames, file = "topnames.rds")
