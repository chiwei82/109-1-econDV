params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_homework02.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggplot2)
library(econDV)
library(jsonlite)
library(lubridate)
library(showtext)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw", hash_algorithm = "xxhash64"))
# plan_homework02------------
plan_homework02=drake::drake_plan(
# > plan begins -----------
# >> raw_data--------------
raw_data=fromJSON("https://quality.data.gov.tw/dq_download_json.php?nid=44218&md5_url=5108938196a413ee42cca40b2e599084"),

# >> data_subset--------------
population = {
   raw_data$Item_VALUE <- as.integer( raw_data$Item_VALUE)
   raw_data$TIME_PERIOD <- as.Date( paste0(raw_data$TIME_PERIOD,"-01-01"))

   pick <- raw_data$Item == "期中人口(人)" & raw_data$TYPE == "原始值"

   Item_VALUE <- raw_data$Item_VALUE[pick]

   TIME_PERIOD <- raw_data$TIME_PERIOD[pick]

  population <- data.frame(
    `年` = TIME_PERIOD ,
    `期中人口` = Item_VALUE)
  population
},

# >> myggplot--------------
myggplot = {
  ggplot()
},

# >> gg_base_line--------------
gg_base_line = {
  myggplot + 
    geom_area(
      mapping = aes(x=`年`,y=`期中人口`),
      population, alpha = 0.5, color= rgb(1,1,0), fill = rgb(1,1,0)
    )
},

# >> majorbreak--------------
major_breaks= {
  population$年 %>% unique() %>% sort() -> possibleValues
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
  major_breaks %>% year() -> breakYears
},

# >> labeled--------------

labeled = {
  gg_base_line+
    scale_x_date(
      breaks = major_breaks,
      labels = labels
    )+
    theme(
      axis.text.x = element_text(angle =45 , hjust = 1)
    )
},

# >> ggvert--------------
ggvert = {
  x_intercept = data.frame(
  intercept = major_breaks)
  
  labeled+
    geom_vline(
      mapping = aes(xintercept = intercept),
      x_intercept, alpha= 0.3, color = rgb(0,0,1)
    )
},

# >> ggPath--------------
ggPath = {
  pick_path = population$年 %in% major_breaks
  for_path = data.frame(
  x_path = major_breaks, y_path = population$期中人口[pick_path])
  
  ggvert +
    geom_path(
      lineend="butt", linejoin="round", linemitre=1,
      mapping = aes(x = x_path ,y= y_path ),
      for_path
    )
},

# >> ggPopulayionTrend--------------
ggPopulayionTrend= {
    ggPath+
    labs(
      title="中華民國:人口走勢圖(1951-2019)",
      subtitle=" X軸:年, Y軸:人口數量(人) ",
      caption="資料出處: 政府開放資料平台https://data.gov.tw/dataset/10359",
      y="",
      x=""
    )
},

# >> save_ggplot--------------
save_ggplot = {
  ggsave(
    plot=ggPopulayionTrend,
    filename=file.path(imageFolder, "homework02.svg" ),
    width = 8,
    height = 5
  )
}

# > plan ends ------------
)

mk_plan_homework02= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_homework02.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggplot2)
library(econDV)
library(jsonlite)
library(lubridate)
library(showtext)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw", hash_algorithm = "xxhash64"))
drake::make(plan_homework02,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw"),...)
}
vis_plan_homework02= function(...)
{
params=readRDS("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/params_homework02.rds")
library(dplyr)
library(tidyr)
library(stringr)
library(googledrive)
library(readr)
library(ggplot2)
library(econDV)
library(jsonlite)
library(lubridate)
library(showtext)

font_families_google() %>%
  stringr::str_subset(regex("noto", ignore_case = T))  
font_add_google("Noto Sans TC") 

rprojroot::is_rstudio_project -> .pj
.pj$make_fix_file() -> .root

imageFolder <- file.path(.root(),"img")
dataFolder <- file.path(.root(),"data")

if(!dir.exists(imageFolder)) dir.create(imageFolder)
if(!dir.exists(dataFolder))dir.create(dataFolder)
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw", hash_algorithm = "xxhash64"))
drake::vis_drake_graph(plan_homework02,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw"),...)
}
load_plan_homework02= function(...)
{
drake::loadd(...,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drake/.chart_cw"), envir = .GlobalEnv)
}
