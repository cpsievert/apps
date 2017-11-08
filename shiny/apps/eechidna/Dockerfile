FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# system dependencies for rgdal https://github.com/ropenscilabs/eechidna#readme
RUN sudo apt-get update
RUN sudo apt-get install -y libgdal-dev libgeos-dev 

RUN R -e "install.packages('eechidna')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
