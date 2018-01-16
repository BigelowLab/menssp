# menssp
Access, query and download from RESTful Maine DMR ESRI [Map Service](https://gis2.maine.gov/arcgis/rest/services/dmr).


### Requirements

[sf](https://CRAN.R-project.org/package=sf)
[esri2sf](https://github.com/yonghah/esri2sf)

### Installation

```r
devtools::install_github("yonghah/esri2sf")
devtools::install_github("BigelowLab/menssp")
```

### Global path

Data files are stored in a directory of your chosing. I like to define that directory
path in my ~/.Rprofile file. That way whenever R starts (and reads that file -
be careful when invoking R or Rscript in a way that doesn't read ~/.Rprofile). For example...

```
options(MENSSP_PATH = "/Users/Shared/data/menssp")
```


### Usage

```r
library(sf)
library(dplyr)
library(menssp)

x <- fetch_P90(year = 2013)
sf::st_write(x, "/path/to/P90-2013.geojson")
y <- read_P90(year = 2013)
identical(x,y)

x <- fetch_current() # automatically writes to 'NSSP-YYYY-mm-dd.geojson'
y <- read_nssp()
identical(x,y)

z <- x %>% dplyr::filter(NSSP == 'P')
dim(x)
dim(z)

plot(x %>% dplyr::filter(PA_NUMBER == '14'))
```
