FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('ggplot2', 'shinyAce'))"

# copy the app to the image
COPY ./ ./

# run the app
CMD ["R", "-e shiny::runApp(port=3838, host='0.0.0.0')"]
