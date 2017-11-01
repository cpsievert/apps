
# use like `make new app=genius`
new:
	mkdir apps/${app}
	cp template/* apps/${app}

readme:
	Rscript -e 'knitr::knit("README.Rmd")'

