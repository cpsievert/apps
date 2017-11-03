# zip up apps on the user gallery to send to RStudio...
# devtools::install_github("ropensci/git2r")
library(git2r)
tmp <- tempfile()
dir.create(tmp)
repo <- clone("https://github.com/cpsievert/shiny_apps.git", tmp)
apps <- file.path(tmp, "apps", c("ggtree", "LDAelife"))
zip("cpsievert-apps.zip", apps)
unlink(tmp)
