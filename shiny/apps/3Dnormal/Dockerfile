FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# install necessary CRAN packages
RUN R -e "install.packages('mvtnorm')"

# install tourbrush
RUN R -e "remotes::install_github('cpsievert/tourbrush')"

# copy over the app
COPY ./ ./

CMD R -e 'shiny::runApp()'
