# nssp
Access, query and download from RESTful Maine DMR ESRI [Map Service](https://gis2.maine.gov/arcgis/rest/services/dmr).


### Requirements

[sf](https://CRAN.R-project.org/package=sf)
[esri2sf](https://github.com/yonghah/esri2sf)

### Installation

```r
devtools::install_github("yonghah/esri2sf")
devtools::install_github("BigelowLab/nssp")
```

### Usage

```r
library(nssp)

x <- fetch_P90(year = 2013)
sf::st_write(x, "/path/to/P90-2013.geojson")
y <- read_P90(year = 2013, path = 'path/to/P90/files')
identical(x,y)

x <- fetch_nssp(year = 2013)
sf::st_write(x, "/path/to/NSSP-2013.geojson")
y <- read_nssp(year = 2013, path = 'path/to/NSSP/files')
identical(x,y)

x <- fetch_current(path = 'my/path) # automaticall writes
y <- read_current(what = 'local', path = 'my/path')
identical(x,y)

z <- x %>% dplyr::filter(NSSP == 'P') 
dim(x)
dim(z)
```
