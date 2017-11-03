
# use like `make shiny app=genius`
shiny:
	mkdir shiny/apps/${app}
	cp shiny/template/* shiny/apps/${app}

readme:
	Rscript -e 'knitr::knit("README.Rmd")'

