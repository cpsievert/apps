
<!-- README.md is generated from README.Rmd. Please edit that file -->
My shiny apps <img src="https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png" width=100 align="right" />
================================================================================================================

A repo for running my (public) [shiny](http://cran.r-project.org/web/packages/shiny/index.html) apps.

TODO: build/add link to shiny.cpsievert.me with links to all the apps.

Run a shiny server with all these apps via docker
-------------------------------------------------

``` shell
docker run -p 3838:3838 cpsievert/shiny_apps
```

Now visit <http://localhost:3838>

Download, build, and run manually
---------------------------------

``` shell
git clone https://github.com/cpsievert/shiny_apps.git
cd shiny_apps
docker build -t shiny_apps .
docker run -p 3838:3838 shiny_apps
```
