FROM cpsievert/apps:shiny
MAINTAINER Carson Sievert "cpsievert1@gmail.com"

# IDEA: use `rsconnect::appDependencies()` to automatically infer/install dependencies of the app!?

# copy the app to the image
COPY ./ ./

# run the app
CMD R -e 'shiny::runApp(port=3838, host="0.0.0.0")'
