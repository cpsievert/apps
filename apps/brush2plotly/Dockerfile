FROM cpsievert/shiny_apps:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# install necessary CRAN packages
RUN R -e "install.packages('plotly')"

# copy the app to the image
COPY ./ ./

EXPOSE 3838

CMD ["R", "-e shiny::runApp(port=3838, host='0.0.0.0')"]
