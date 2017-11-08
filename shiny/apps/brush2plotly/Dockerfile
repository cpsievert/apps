FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# install necessary CRAN packages
RUN R -e "install.packages(c('plotly', 'dplyr', 'reshape2'))"

# copy the app to the image
COPY ./ ./

EXPOSE 3838

CMD R -e 'shiny::runApp()'
