FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# so many system dependencies https://github.com/ropenscilabs/eechidna#readme
RUN sudo apt-get install -y libgdal-dev libgeos-dev libjq-dev libprotobuf-dev protobuf-compiler libv8-3.14-dev libudunits2-dev 

RUN R -e "install.packages('eechidna')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
