library(rvest)
library(tidyverse)
library(stringr)
library(purrr)

# input url for search results
# add page numbers of the search results in the url
hitap <- stringr::str_c("http://db.hitap.net/searches/advanced?&resource%5Bstart_year%5D=1980&resource%5Bto_year%5D=2024&commit=%E0%B8%84%E0%B9%89%E0%B8%99%E0%B8%AB%E0%B8%B2%E0%B8%82%E0%B8%B1%E0%B9%89%E0%B8%99%E0%B8%AA%E0%B8%B9%E0%B8%87&keywords=%E0%B8%AD%E0%B8%A3%E0%B8%A3%E0%B8%96%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B9%82%E0%B8%A2%E0%B8%8A%E0%B8%99%E0%B9%8C++++%E0%B8%84%E0%B8%B8%E0%B8%93%E0%B8%A0%E0%B8%B2%E0%B8%9E%E0%B8%8A%E0%B8%B5%E0%B8%A7%E0%B8%B4%E0%B8%95++++qaly++++quality-adjusted+++utility+&page=",
                        1:50, "&research_types%5B%5D=1&research_types%5B%5D=3&utf8=%E2%9C%93")

# extract all urls from search results
n <- list()
for (i in 1:length(hitap)){
  data <- hitap[i] %>% read_html() %>%
    html_nodes("td:nth-child(3) a") %>%
    html_attr("href")
  n <- append(n, data)
}

urls <- as.character(n)

main_url <- "http://db.hitap.net"
wbpg <- data.frame(xml2::url_absolute(urls, main_url))


for (i in 1:nrow(wbpg)){
  a <- read_html(wbpg[i,1])
  
  # extract title
  wbpg[i, 2] <- a %>% html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "post-title", " " ))]//h5') %>%
    html_text()
  
  # extract abstract
  # wbpg[i, 3] <- a %>% html_element(xpath = '//*[(@id = "abstract")]//div') %>%
  #   html_text2()
  wbpg[i, 3] <- a %>% html_element(xpath = '//*[(@id = "abstract")]') %>%
    html_text2()
}

colnames(wbpg) <- c("url","title", "abstract")

wbpg$abstract <- str_squish(wbpg$abstract)

write_csv(wbpg, "hitap.csv")
