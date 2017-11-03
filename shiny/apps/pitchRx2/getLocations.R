# nse version of -- https://gist.github.com/cpsievert/da555f08f3c9ba2c0b8e
getLocations <- function(dat, ..., summarise = TRUE) {
  # select and group by columns specified in ...
  params <- c("x0", "y0", "z0", "vx0", "vy0", "vz0", "ax", "ay", "az")
  tb <- dat %>%
    select_(.dots = c(..., params)) %>%
    na.omit %>%
    group_by_(.dots = c(...), add = TRUE)
  vars <- as.character(attr(tb, "vars"))
  if (summarise) {
    # average the PITCHf/x parameters over variables specified in ...
    labs <- attr(tb, "labels")
    tb <- tb %>% summarise_each(funs(mean))
  } else {
    # another (more complex way to get variables names)
    # vars <- as.character(as.list(match.call(expand.dots = FALSE))$...)
    dat$pitch_id <- seq_len(dim(dat)[1])
    vars <- c(vars, "pitch_id")
    labs <- dat[vars]
  }
  # returns 3D array of locations of pitches over time
  value <- pitchRx::getSnapshots(as.data.frame(tb))
  idx <- labs %>% unite_("id", ..., sep = "@&")
  dimnames(value) <- list(idx = idx[, 1],
                          frame = seq_len(dim(value)[2]),
                          coordinate = c("x", "y", "z"))
  # tidy things up in a format that ggplot would expect
  value %>% as.tbl_cube(met_name = "value") %>% as.data.frame %>%
    separate(idx, vars, sep = "@&") %>%
    spread(coordinate, value)
} 