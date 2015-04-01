# run me on the machine serving the apps
serve:
	cd /srv/shiny_apps && git pull origin master

readme:
	Rscript -e 'knitr::knit("README.Rmd")'

all: readme

