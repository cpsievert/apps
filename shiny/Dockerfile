FROM rocker/r-ver:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# ---------------------------------------------------------------------------
# Install some (additional) system/R dependencies, that most, if not all
# of the apps in this repo will utilize
# ---------------------------------------------------------------------------

RUN apt-get update && apt-get install -y \
    sudo \
    software-properties-common \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

RUN R -e "update.packages(ask=F); install.packages(c('shiny', 'remotes', 'curl'))"

# set host and port
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838
