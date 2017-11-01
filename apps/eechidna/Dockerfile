FROM cpsievert/shiny_apps:latest
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages('remotes'); remotes::install_github('ropenscilabs/eechidna')"

# copy the app to the image
COPY ./ ./

# run the app
CMD ["R", "-e shiny::runApp()"]
