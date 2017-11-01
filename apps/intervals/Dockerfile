FROM cpsievert/shiny_apps:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('ggplot2', 'MASS'))"

# copy the app to the image
COPY ./ ./

# run the app
CMD ["R", "-e shiny::runApp()"]
