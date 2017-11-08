FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# system dependencies for sf https://github.com/r-spatial/sf#linux
RUN sudo apt-get update
RUN sudo apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev 

RUN R -e "remotes::install_github('cpsievert/housing-data-challenge-plotly')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
