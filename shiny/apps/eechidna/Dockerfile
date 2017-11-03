FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "remotes::install_github('ropenscilabs/eechidna')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp(port=3838, host="0.0.0.0")'
