params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_pactice_ch7.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggmap)
library(osmdata)
library(ggplot2)
library(econDV)
library(sf)
library(tibble)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/7b3nbgfx5bgft8g/drake_annotationmaps.Rdata?dl=1")
load("C:/Users/tonyf/Desktop/drake_annotationmaps.Rdata")

stringr::str_replace(
drake$process2get$storr_rdsOptions,
"(?<=(storr_rds\\())[\"[:graph:]]+(?=,)",
'file.path(.root(),".map")'
) -> drake$process2get$storr_rdsOptions
drake$activeRmd$frontmatter$drake_cache <- file.path(.root(),".map")

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny", hash_algorithm = "xxhash64"))
# plan_pactice_ch7------------
plan_pactice_ch7=drake::drake_plan(
# > plan begins -----------
# > plan ends ------------
)

mk_plan_pactice_ch7= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_pactice_ch7.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggmap)
library(osmdata)
library(ggplot2)
library(econDV)
library(sf)
library(tibble)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/7b3nbgfx5bgft8g/drake_annotationmaps.Rdata?dl=1")
load("C:/Users/tonyf/Desktop/drake_annotationmaps.Rdata")

stringr::str_replace(
drake$process2get$storr_rdsOptions,
"(?<=(storr_rds\\())[\"[:graph:]]+(?=,)",
'file.path(.root(),".map")'
) -> drake$process2get$storr_rdsOptions
drake$activeRmd$frontmatter$drake_cache <- file.path(.root(),".map")

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny", hash_algorithm = "xxhash64"))
drake::make(plan_pactice_ch7,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny"),...)
}
vis_plan_pactice_ch7= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_pactice_ch7.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggmap)
library(osmdata)
library(ggplot2)
library(econDV)
library(sf)
library(tibble)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/7b3nbgfx5bgft8g/drake_annotationmaps.Rdata?dl=1")
load("C:/Users/tonyf/Desktop/drake_annotationmaps.Rdata")

stringr::str_replace(
drake$process2get$storr_rdsOptions,
"(?<=(storr_rds\\())[\"[:graph:]]+(?=,)",
'file.path(.root(),".map")'
) -> drake$process2get$storr_rdsOptions
drake$activeRmd$frontmatter$drake_cache <- file.path(.root(),".map")

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny", hash_algorithm = "xxhash64"))
drake::vis_drake_graph(plan_pactice_ch7,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny"),...)
}
load_plan_pactice_ch7= function(...)
{
drake::loadd(...,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart1_sunny"), envir = .GlobalEnv)
}
