# run me on the machine serving the apps
serve:
	cd /srv/shiny_apps && git pull origin master

# update links
local:
	Rscript -e 'knitr::knit("README.Rmd")'

