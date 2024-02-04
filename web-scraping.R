library(rvest)
library(tidyverse)
hitap <- read_html("http://db.hitap.net/searches/advanced?utf8=%E2%9C%93&keywords=%E0%B8%AD%E0%B8%A3%E0%B8%A3%E0%B8%96%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B9%82%E0%B8%A2%E0%B8%8A%E0%B8%99%E0%B9%8C++++%E0%B8%84%E0%B8%B8%E0%B8%93%E0%B8%A0%E0%B8%B2%E0%B8%9E%E0%B8%8A%E0%B8%B5%E0%B8%A7%E0%B8%B4%E0%B8%95++++qaly++++quality-adjusted+++utility+&research_types%5B%5D=1&research_types%5B%5D=3&resource%5Bjournal%5D%5B%5D=&resource%5Bstart_year%5D=1980&resource%5Bto_year%5D=2024&commit=%E0%B8%84%E0%B9%89%E0%B8%99%E0%B8%AB%E0%B8%B2%E0%B8%82%E0%B8%B1%E0%B9%89%E0%B8%99%E0%B8%AA%E0%B8%B9%E0%B8%87")

urls <- hitap %>%
  html_nodes("td:nth-child(3) a") %>%
  html_attr("href")
urls

main_url <- "http://db.hitap.net"
wbpg <- data.frame(xml2::url_absolute(urls, main_url))


for (i in 1:nrow(wbpg)){
  a <- read_html(wbpg[i,1])
  wbpg[i, 2] <- a %>% html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "hentry", " " ))]') %>%
    html_text()
}

write_csv(wbpg, "hitap.csv")
