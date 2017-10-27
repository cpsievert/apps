dats <- list.files()[grep("*rda$", list.files())]
for (i in 1L:length(dats)){
  load(file = dats[i])
}

