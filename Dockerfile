FROM rocker/r-ver:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# By default, shinyproxy runs on port 2375 of the docker host
# https://www.shinyproxy.io/getting-started/
# Note that this port can be changed in application.yml
ENV DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix://"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    wget

RUN R -e "update.packages(ask=F); install.packages(c('shiny', 'remotes', 'curl'))"

# https://www.shinyproxy.io/downloads/shinyproxy-1.0.1.jar
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-1.0.1.jar

EXPOSE 3838
