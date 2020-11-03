library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
library(stringr)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics", hash_algorithm = "xxhash64"))
# no params in the frontmatter
# plan_drake_graphing_basics_test------------
plan_drake_graphing_basics_test=drake::drake_plan(
# > plan begins -----------
# >> datadownload--------------
income=fromJSON("https://quality.data.gov.tw/dq_download_json.php?nid=44218&md5_url=5108938196a413ee42cca40b2e599084"),

# >> myggplot--------------
myggplot = {
  canvas ={
    ggplot()
  }
},

# >> subset_of_income--------------


{
  income$Item_VALUE <- as.integer(income$Item_VALUE) 

  pick <- income$Item == "國內生產毛額GDP(名目值，百萬元)" & income$TYPE == "原始值"

  Item_VALUE <- income$Item_VALUE[pick]

  TIME_PERIOD <- income$TIME_PERIOD[pick]

  subset_of_income <- data.frame(
    `年` = TIME_PERIOD ,
    `國內生產毛額GDP(名目值，百萬元)` = Item_VALUE
    )
  
},

# >> ggpath--------------
ggpath = {
  myggplot +
    geom_point(
      mapping =  aes(x = `年`, y = `國內生產毛額GDP.名目值.百萬元.`  ),
      subset_of_income
    )
},

# >> save_ggplot--------------
save_ggplot = {

  ggsave(
    plot=ggpath,
    filename=file.path(imageFolder, "myPlot.svg"),
    width = 8,
    height = 5
  )
}

# > plan ends ------------
)

mk_plan_drake_graphing_basics_test= function()
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
library(stringr)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics", hash_algorithm = "xxhash64"))
# no params in the frontmatter
drake::make(plan_drake_graphing_basics_test,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics"))
}
vis_plan_drake_graphing_basics_test= function(...)
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
library(stringr)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics", hash_algorithm = "xxhash64"))
# no params in the frontmatter
drake::vis_drake_graph(plan_drake_graphing_basics_test,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics"),...)
}
load_plan_drake_graphing_basics_test= function(...)
{
drake::loadd(...,
cache=drake::drake_cache(
  path="C:/Users/tonyf/Documents/GitHub/109-1-econDV/drakeplan/.graphingBasics"), envir = .GlobalEnv)
}
