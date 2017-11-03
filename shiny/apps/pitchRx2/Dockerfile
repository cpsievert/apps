FROM cpsievert/shiny_apps:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('pitchRx', 'DBI', 'dplyr', 'tidyr'))"

RUN R -e "remotes::install_github('tdhock/animint')"

# copy the app to the image
COPY ./ ./

# run the app
CMD ["R", "-e shiny::runApp(port=3838, host='0.0.0.0')"]
