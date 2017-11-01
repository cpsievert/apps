FROM rocker/r-ver:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

COPY Rprofile.site /usr/lib/R/etc/

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

# install necessary CRAN packages
RUN R -e "install.packages(c('shiny', 'remotes', 'mvtnrom'))"

# install tourbrush
RUN R -e "remotes::install_github('cpsievert/tourbrush')"

# copy over the app
COPY ./ ./

EXPOSE 3838

CMD ["R", "-e shiny::runApp()"]
