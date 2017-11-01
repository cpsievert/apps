FROM rocker/r-ver:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# set some sensible (global) R options
# TODO: is this safe for shiny.host? I got it from here
# https://github.com/openanalytics/shinyproxy-template/blob/master/Rprofile.site
RUN R -e "cat(\"options(shiny.port = 3838, shiny.host = '0.0.0.0')\", file = file.path(R.home(), 'etc', 'Rprofile.site'), append = TRUE)"

RUN R -e "update.packages(ask=F); install.packages('shiny')"

EXPOSE 3838
