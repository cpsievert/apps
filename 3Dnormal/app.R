library(mvtnorm)

s <- matrix(c(1, .5, .5, .5, 1, .5, .5, .5, 1), ncol = 3)
m <- rmvnorm(500, sigma = s)
d <- dmvnorm(m)

dat <- data.frame(x = m[, 1], y = d)

source("run_tour.R")
run_tour(dat, m)
