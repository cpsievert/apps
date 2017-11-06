FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "remotes::install_github('cpsievert/zikar')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
