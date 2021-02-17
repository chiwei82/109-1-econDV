params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_plot.rds")
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
library(lubridate)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same", hash_algorithm = "xxhash64"))
# plan_final_plot------------
plan_final_plot=drake::drake_plan(
# > plan begins -----------
# >> downloaded--------------
downloaded = {
  downloaded = 
  jsonlite::fromJSON("https://apiservice.mol.gov.tw/OdService/download/A17000000J-030243-KjC")
  downloaded
},

# >> data_pred--------------
data_pred = {
 downloaded %>% transmute(
   year = paste0(downloaded$年度,"-01-01") %>% as.Date(),
   growthrate = downloaded$經濟成長率 %>% str_remove("p   ") %>%  as.numeric() ,
   gnp = downloaded$`平均每人國民所得毛額（美元）` %>% str_remove("[:alpha:]|,") %>% str_remove("   ") %>% str_remove(",")%>% as.numeric(),
   saving_rate = downloaded$儲蓄率 %>% str_remove("f   ") %>% as.numeric() ,
   unrate = downloaded$失業率 %>% as.numeric() ) -> data_pred
  data_pred
},

# >> majorbreak--------------
major_breaks= {
  data_pred$year %>% unique() %>% sort() -> possibleValues
  starting <- possibleValues[[1]]
  ending <- possibleValues[[length(possibleValues)]]

  major_breaks = {
      possibleValues %>%
        month() %>%
        {.==1} -> pickMajorBreaks
    
      major_breaks <- possibleValues[pickMajorBreaks]
      
      major_breaks %>% year() %% 5 %>%
        {.==0} -> pick05endingYears
      major_breaks <- major_breaks[pick05endingYears]
      
      major_breaks <- c(starting, major_breaks, ending) %>% unique()
      
      major_breaks
  }
  major_breaks  
},

# >> labels--------------
labels = {
  labels = major_breaks %>% year()
  labels
},

# >> ggplot_econgrowth--------------
ggplot_econgrowth ={
  ggplot_econgrowth <- 
    data_pred %>% ggplot() +
    geom_line(
      aes(x = year, y = growthrate), size = 1
    ) +
    scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) +
    labs(
      title = "經濟成長率" ,
      subtitle = "單位: %"
    ) + 
    theme_light()
  ggplot_econgrowth
},

# >> ggplot_saving--------------
 ggplot_saving = {
    ggplot_saving <-
      data_pred %>% ggplot() +
      geom_line(
        aes(x = year, y = saving_rate), size = 1
      ) +
      scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) + 
      labs(
      title = "儲蓄率" ,
      subtitle = "單位: %"
    ) + 
    theme_light()
    ggplot_saving
},

# >> ggplot_gnp--------------
ggplot_gnp ={
  ggplot_gnp <-
    data_pred %>% ggplot() +
    geom_line(
      aes(x= year, y = gnp) ,size = 1
    ) +
      scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) + 
      labs(
      title = "GNP 平均每人國民所得" ,
      subtitle = "單位: 美元"
    ) + 
    theme_light()
  ggplot_gnp
},

# >> ggplot_unempoly--------------
ggplot_unempoly = {
   ggplot_unempoly <-
     data_pred %>% ggplot() +
    geom_line(
      aes(x= year, y = unrate) ,size = 1
    ) +
      scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) + 
      labs(
      title = "失業率" ,
      subtitle = "單位: %"
    ) + 
    theme_light()
   ggplot_unempoly
},

# >> ggplot_growth_unrate--------------
ggplot_growth_unrate = {
 data_pred %>% ggplot() +
    geom_line(
      aes(x = year, y = growthrate), size = 1,color = "#0476D9" 
    ) +
    geom_line(
      aes(x= year, y = unrate) ,size = 1,color = "#F13F33"
    ) +
    geom_text(
      aes(x = year[[24]] , y = 0 , label = "growthrate"),color = "#0476D9" 
      , size = 2
    ) +
    geom_text(
      aes(x = year[[22]] , y = 6  , label = "unemployment"),color = "#F13F33" 
      , size = 2
    ) +
      scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) + 
      labs(
      title = "失業率和經濟成長率之關係" ,
      subtitle = "單位: % | 藍線:經濟成長率; 紅線:失業率"
    ) + theme_light() -> ggplot_growth_unrate
  ggplot_growth_unrate 
},

# >> ggplot_growth_saving--------------
ggplot_growth_saving ={
  ggplot_growth_saving <- 
    data_pred %>% ggplot() +
    geom_line(
      aes(x = year, y = growthrate), size = 1,color = "#0476D9"
    ) +
    geom_line(
      aes(x= year, y = saving_rate) ,size = 1,color = "#D9BA23"
    ) +
    geom_text(
      aes(x = year[[24]] , y = 10 , label = "growth rate"),color = "#0476D9" 
      , size = 2
    ) +
    geom_text(
      aes(x = year[[21]] , y = 25 , label = "saving rate"),color = "#D9BA23"
      , size = 2
    ) +
      scale_x_date(
      breaks = major_breaks,
      labels = labels
    ) + 
      labs(
      title = "儲蓄率和經濟成長率之關係" ,
      subtitle = "單位: %| 藍色:經濟成長率; 黃色:儲蓄率"
    ) + theme_light()
  ggplot_growth_saving
},

# >> myggplot--------------
myggplot = {
  myggplot <- 
  gridExtra::grid.arrange(
    ggplot_econgrowth,
    ggplot_gnp,
    ggplot_unempoly,
    ggplot_saving,
    ggplot_growth_unrate,
    ggplot_growth_saving,
    nrow = 2,
    top = "國內經濟指標合集"
  )
  myggplot
},

# >> save_ggplot--------------
save_ggplot = {
  ggsave(
    plot=myggplot,
    filename=file.path(imageFolder,"Econindex.svg"),
    width = 8,
    height = 5
  )
}

# > plan ends ------------
)

mk_plan_final_plot= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_plot.rds")
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
library(lubridate)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same", hash_algorithm = "xxhash64"))
drake::make(plan_final_plot,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same"),...)
}
vis_plan_final_plot= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_final_plot.rds")
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
library(lubridate)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same", hash_algorithm = "xxhash64"))
drake::vis_drake_graph(plan_final_plot,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same"),...)
}
load_plan_final_plot= function(...)
{
drake::loadd(...,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.no_one_is_same"), envir = .GlobalEnv)
}
