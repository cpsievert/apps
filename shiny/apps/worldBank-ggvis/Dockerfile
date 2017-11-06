FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

RUN R -e "install.packages(c('ggvis', 'dplyr', 'htmltools'))"
RUN R -e "remotes::install_github('tdhock/animint')"

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
