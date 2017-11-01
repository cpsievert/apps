FROM rocker/r-ver:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'))"

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev

# install dependencies of the euler app
RUN R -e "install.packages('Rmpfr')"

# copy the app to the image
RUN mkdir /root/euler
COPY euler /root/euler

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e shiny::runApp()"]
