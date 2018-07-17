all: shiny-images

shiny-images:
	docker build -t cpsievert/apps:shiny shiny
	docker build -t cpsievert/apps:shiny-template shiny/template
	docker build -t cpsievert/apps:shiny-3Dnormal shiny/apps/3Dnormal
	docker build -t cpsievert/apps:shiny-bcviz shiny/apps/bcviz 
	docker build -t cpsievert/apps:shiny-brush2plotly shiny/apps/brush2plotly 
	docker build -t cpsievert/apps:shiny-cdf shiny/apps/cdf 
	docker build -t cpsievert/apps:shiny-clearBrush shiny/apps/clearBrush 
	docker build -t cpsievert/apps:shiny-CLT shiny/apps/CLT 
	docker build -t cpsievert/apps:shiny-eechidna shiny/apps/eechidna 
	docker build -t cpsievert/apps:shiny-ggtree shiny/apps/ggtree 
	docker build -t cpsievert/apps:shiny-intervals shiny/apps/intervals 
	docker build -t cpsievert/apps:shiny-LDAelife shiny/apps/LDAelife 
	docker build -t cpsievert/apps:shiny-lmGadget shiny/apps/lmGadget 
	docker build -t cpsievert/apps:shiny-pitchRx shiny/apps/pitchRx 
	docker build -t cpsievert/apps:shiny-pitchRx-db shiny/apps/pitchRx-db 
	docker build -t cpsievert/apps:shiny-pitchRx2 shiny/apps/pitchRx2 
	docker build -t cpsievert/apps:shiny-plotlyAg shiny/apps/plotlyAg 
	docker build -t cpsievert/apps:shiny-plotlyEvents shiny/apps/plotlyEvents 
	docker build -t cpsievert/apps:shiny-plotlyLinkedBrush shiny/apps/plotlyLinkedBrush 
	docker build -t cpsievert/apps:shiny-plotlyLinkedClick shiny/apps/plotlyLinkedClick 
	docker build -t cpsievert/apps:shiny-plotlyViewer shiny/apps/plotlyViewer 
	docker build -t cpsievert/apps:shiny-regInf shiny/apps/regInf 
	docker build -t cpsievert/apps:shiny-sampling shiny/apps/sampling 
	docker build -t cpsievert/apps:shiny-testing shiny/apps/testing 
	docker build -t cpsievert/apps:shiny-testing2 shiny/apps/testing2 
	docker build -t cpsievert/apps:shiny-topnames shiny/apps/topnames 
	docker build -t cpsievert/apps:shiny-worldBank-ggvis shiny/apps/worldBank-ggvis 
	docker build -t cpsievert/apps:shiny-zikar shiny/apps/zikar 


# build a new shiny app (from a template)
# use like `make shiny app=genius`
shiny:
	mkdir shiny/apps/${app}
	cp shiny/template/* shiny/apps/${app}
	
# publish all the images!
# TODO: will this automatically push all tags?
push:
	docker push cpsievert/apps

# pull down all the images
# http://www.googlinux.com/list-all-tags-of-docker-image/index.html
pull:
	curl 'https://registry.hub.docker.com/v2/repositories/cpsievert/apps/tags/' | jq '."results"[]["name"]' | xargs -I {} echo cpsievert/apps:{} | xargs -L1 sudo docker pull
	
readme:
	Rscript -e 'knitr::knit("README.Rmd")'

