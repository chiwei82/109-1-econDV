params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_map.rds")
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
library(readr)
library(showtextdb)
library(showtext)
library(stringr)
library(svglite)
library(sysfonts)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")#osm_geom_rename()
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows", hash_algorithm = "xxhash64"))
# plan_final_map------------
plan_final_map=drake::drake_plan(
# > plan begins -----------
# >> ChanghuaBBox--------------
ChanghuaBBox={
  osmdata::getbb("Changhua") -> ChanghuaBBox
  ChanghuaBBox
},

# >> dsf_Changhua--------------
dsf_Changhua ={
  dsf_Changhua <- opq(ChanghuaBBox) %>% 
     add_osm_feature(key="admin_level", value="8") %>%
     osmdata::osmdata_sf() 
  dsf_Changhua
},

# >> multpoly_chunghua--------------
multpoly_chunghua = {
  dsf_Changhua$osm_multipolygons %>% osm_geom_rename() %>%
  filter(!str_detect(`name.en`,"Zhushan|Mingjian|Nantou|Caotun|Mailiao|Erlun|Lunbei|Linnei|Citong|Xiluo")) -> multpoly_chunghua
   multpoly_chunghua$name.en %>% 
     str_remove(.," Township|City") %>% str_remove(.," ")->
    multpoly_chunghua$name.en
   multpoly_chunghua
},

# >> raster_cuanghua--------------
raster_cuanghua ={
  get_map(ChanghuaBBox) -> raster_cuanghua 
  raster_cuanghua
},

# >> elec_2020_ch--------------
elec_2020_ch={
  jsonlite::fromJSON("https://s41.aconvert.com/convert/p3r68-cdx67/s4083-ttih8.json") -> elec_2020_ch
  elec_2020_ch
},

# >> elec_2020_ch_pre--------------
elec_2020_ch_pre = {
  elec_2020_ch %>% transmute(
    name = elec_2020_ch$name %>% str_remove(.," "),
    orange = as.numeric(elec_2020_ch$orange) %>% round(3)  ,
    kmt = as.numeric(elec_2020_ch$kmt)  %>% round(3),
    dpp = as.numeric(elec_2020_ch$dpp) %>% round(3)
  ) -> elec_2020_ch_pre
  elec_2020_ch_pre
},

# >> election_DATA_merged--------------
election_DATA_merged = {
  election_DATA_merged <- 
  multpoly_chunghua %>%
    osm_geom_rename() %>%
    left_join(
      elec_2020_ch_pre,
      by=c("name.en"="name")
    )
  election_DATA_merged
},

# >> list_ranges--------------
list_ranges = {
  dppRange = round(range(election_DATA_merged$dpp),1)
list(
  fromRange = c(1-dppRange[[2]], dppRange[[2]]),
  toRange = c(-1,1)) -> list_ranges
  list_ranges
},

# >> electionData--------------
electionData ={
election_DATA_merged %>%
    mutate(
      dpp_rescaled=
        scales::rescale(
          election_DATA_merged$dpp,
          from=list_ranges$fromRange,
          to=list_ranges$toRange)
        ) -> electionData
  electionData
},

# >> scale_fill_election--------------
scale_fill_election = {
  
  breaksPal = seq(
    from=list_ranges$toRange[[1]],
    to=list_ranges$toRange[[2]],
    length.out=5
  )

  labelsPal = seq(
    from=list_ranges$fromRange[[1]],
    to=list_ranges$fromRange[[2]],
    length.out=5
  )
  
  colorspace::scale_fill_continuous_diverging(
    palette="kmt_dpp") -> scale_fill_election 

  scale_fill_election$breaks = breaksPal
  scale_fill_election$labels = labelsPal
  scale_fill_election$name = "民進黨得票率"
  
  scale_fill_election
},

# >> ggmap_changhua--------------
ggmap_changhua={
  raster_cuanghua %>% ggmap() -> ggmap_changhua
  ggmap_changhua
},

# >> ggmap_osm_changuha--------------
ggmap_osm_changuha ={
  ggmap_changhua+
  geom_sf(
    data=multpoly_chunghua %>% osm_geom_rename, 
    inherit.aes = FALSE,
    alpha=0.3, fill="aliceblue"
  )+theme_classic()  -> ggmap_osm_changuha
  ggmap_osm_changuha
},

# >> ggsf_region_text--------------
ggsf_region_text = {
 ggsf_region_text <-
  multpoly_chunghua %>% 
    ggplot()+ geom_sf(alpha= 0.1) +
    geom_sf_text(
    data=multpoly_chunghua,
    aes( label=name.en), size=3 )+
    theme_void()
 ggsf_region_text
},

# >> gg_electionComplete--------------
gg_electionComplete ={
  gg_electionComplete <- ggmap_osm_changuha +
    geom_sf(
      data = electionData,
      mapping = aes(fill = dpp_rescaled), size = 0.2, color = "white", alpha=0.7, 
      inherit.aes = FALSE
    ) +
    scale_fill_election +
  theme(
    legend.title = element_blank(),
    legend.key.width = unit(5,"points"),
    legend.key.height = unit(10,"points"),
    legend.position = c(0.16, 0.8)
  )
  gg_electionComplete
},

# >> ggGrid_changhua_electionMap--------------
ggGrid_changhua_electionMap = {
  gridExtra::grid.arrange(
  gg_electionComplete,
  ggsf_region_text,
  nrow=1,
  top="民進黨2020總統大選彰化市得票率"
) -> ggGrid_changhua_electionMap
  ggGrid_changhua_electionMap
},

# >> myggplot--------------
myggplot = {
  myggplot<- ggGrid_changhua_electionMap
  myggplot
},

# >> save_ggplot--------------
save_ggplot = {
  ggsave(
    plot=myggplot,
    filename=file.path(imageFolder, "elect_changhua.svg"),
    width = 8,
    height = 5
  )
}

# > plan ends ------------
)

mk_plan_final_map= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_map.rds")
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
library(readr)
library(showtextdb)
library(showtext)
library(stringr)
library(svglite)
library(sysfonts)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")#osm_geom_rename()
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows", hash_algorithm = "xxhash64"))
drake::make(plan_final_map,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows"),...)
}
vis_plan_final_map= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_map.rds")
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
library(readr)
library(showtextdb)
library(showtext)
library(stringr)
library(svglite)
library(sysfonts)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder)) dir.create(dataFolder)

xfun::download_file("https://www.dropbox.com/s/8ndtvzqbdb4cb93/data_visulaization_pk.R?dl=1")
source("data_visulaization_pk.R",encoding="UTF-8")#osm_geom_rename()
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows", hash_algorithm = "xxhash64"))
drake::vis_drake_graph(plan_final_map,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows"),...)
}
load_plan_final_map= function(...)
{
drake::loadd(...,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.cache_no_one_knows"), envir = .GlobalEnv)
}
