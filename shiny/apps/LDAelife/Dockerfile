FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('MASS', 'reshape2', 'plyr', 'proxy'))"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
