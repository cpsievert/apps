From rocker/geospatial:latest
Maintainer "Carson Sievert" cpsievert1@gmail.com

RUN apt-get update \
  && apt-get upgrade -y \
  # install add-apt-repository command, so can install libjq
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:opencpu/jq \
  && apt-get install -y --no-install-recommends \
  # for library(protolite)
  libprotobuf-dev protobuf-compiler \
  # for installing shiny server & apps
  gdebi-core git libjq-dev \
  # now download the latest shiny server
  # https://hub.docker.com/r/rocker/shiny/~/dockerfile/
  && wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" \
  && VERSION=$(cat version.txt) \
  && wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb \
  && gdebi -n ss-latest.deb \
  && rm -f version.txt ss-latest.deb \
  && Rscript -e "update.packages(ask=FALSE)" \
  && Rscript -e "devtools::install_github('cpsievert/shiny_apps')"
  
EXPOSE 3838

