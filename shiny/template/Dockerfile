FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# IDEA: use `rsconnect::appDependencies()` to automatically infer/install dependencies of the app!?

# copy the app to the image
COPY ./ ./

CMD R -e 'shiny::runApp()'
