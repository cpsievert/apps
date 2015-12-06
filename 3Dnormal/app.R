library(tourbrush)
library(mvtnorm)
s <- matrix(c(1, .5, .5, .5, 1, .5, .5, .5, 1), ncol = 3)
m <- rmvnorm(500, sigma = s)
# take 1D slice of the 3D density
d <- setNames(data.frame(m), c("x", "y", "z"))
d$density <- dmvnorm(m)
tourbrush(d)
