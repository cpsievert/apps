From rocker/geospatial:latest
Maintainer "Carson Sievert" cpsievert1@gmail.com

# update/install system libraries, install shiny server, and update R packages
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
  && Rscript -e "update.packages(ask=FALSE)" 

# transfer over source code for the apps from host
# (this assumes the default config sets `site_dir /srv/shiny-server`)
# http://docs.rstudio.com/shiny-server/#default-configuration
ADD apps /srv/shiny-server/

# copy over DESCRIPTION file which has all the R packages
# required to run the apps
COPY DESCRIPTION /srv/shiny-server/DESCRIPTION
RUN Rscript -e "devtools::install('/srv/shiny-server')"

# Expose the port shiny is listening to
# TODO: make pretty URLs https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/
EXPOSE 3838

# copy over a shim for starting up the shiny server process,
# grant permissions, and start-up
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh
CMD ["/usr/bin/shiny-server.sh"]