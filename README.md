shiny_apps
=======

A collection of some [shiny](http://cran.r-project.org/web/packages/shiny/index.html) apps. 

## View the live version!

Click on any of the links below to view the app hosted on my server. If you see anything that doesn't look right, [please let me know](https://github.com/cpsievert/shiny_apps/issues/new)!

* [3Dnormal](http://104.131.111.111:3838/3Dnormal)
* [brush2plotly](http://104.131.111.111:3838/brush2plotly)
* [cdf](http://104.131.111.111:3838/cdf)
* [CLT](http://104.131.111.111:3838/CLT)
* [ggtree](http://104.131.111.111:3838/ggtree)
* [intervals](http://104.131.111.111:3838/intervals)
* [LDAelife](http://104.131.111.111:3838/LDAelife)
* [pitchRx](http://104.131.111.111:3838/pitchRx)
* [pitchRx-db](http://104.131.111.111:3838/pitchRx-db)
* [pitchRx2](http://104.131.111.111:3838/pitchRx2)
* [plotlyAg](http://104.131.111.111:3838/plotlyAg)
* [regInf](http://104.131.111.111:3838/regInf)
* [sampling](http://104.131.111.111:3838/sampling)
* [testing](http://104.131.111.111:3838/testing)
* [testing2](http://104.131.111.111:3838/testing2)
* [topnames](http://104.131.111.111:3838/topnames)

## Download and run these apps locally.

You can also run any of these apps on your local machine if you have the right things installed. At the very least you'll need [R](http://cran.r-project.org/) and [shiny](http://cran.r-project.org/web/packages/shiny/index.html) installed. Different apps make use of different packages, so you may need to install those as well. For instance, the [cdf](http://104.131.111.111:3838/cdf) app requires [ggplot2](http://cran.r-project.org/web/packages/ggplot2/index.html), so you'll need to:

```s
install.packages("shiny")
install.packages("ggplot2")
```

Now you can use shiny's `runGitHub()` function to download and serve apps all in one shot:

```s
shiny::runGitHub('shiny_apps', 'cpsievert', subdir='cdf')
```

If you have [git](http://en.wikipedia.org/wiki/Git_%28software%29) on your machine, you could also clone the repo:

```s
system("git clone https://github.com/cpsievert/shiny_apps.git")
shiny::runApp("cdf")
```

### LICENSE

The MIT License (MIT)

Copyright (c) 2013 Carson Sievert

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


