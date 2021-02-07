library(rvest)
library(dplyr)
library(purrr)

page<- (1:58)

urls <- list()

for (i in 1:length(page)) {
  url<- paste0("https://www.fitbastats.com/stranraer/team_results_list.php?page=",page[i])
  urls[[i]] <- url
}

tbl <- list()

#j <- 1

for (j in seq_along(urls)) {

  tbl[[j]] <- urls[[j]] %>%
  read_html() %>%
  html_table() 
  #bind_rows()
  
 #tbl[[j]]$j <- j
  #j <- j+1 
}

tbl1 <- do.call(rbind, tbl)

result <- list()

result <- purrr::keep(tbl1, ~ ncol(.x) == 6)

final <- do.call(rbind, result)

final$Date <- as.Date(final$Date, '%d/%m/%Y')

final01 <- distinct(final)

final01$goalsFor <- gsub("-.*","",final01$Score)
final01$goalsAgainst <- gsub(".*-","",final01$Score)
final01$Competition <- gsub("\\([^][]*)", "", final01$`Competition (Round)`)
final01$Round <- gsub("\\(old)", "[old]", final01$`Competition (Round)`)
final01$Round <- gsub(".*\\(", "", final01$Round)
final01$Round <- gsub("\\)", "", final01$Round)
final01$Round_no <- sub(".*\\/ ", "", final01$Round)
final01[,7:8] <- sapply(final01[,7:8],as.numeric)
final01$Year <- substr(final01$Date, start = 1, stop = 4)

str(final01)


setwd('/Users/paulgoodship/Documents/Data Projects/Football/Stranraer/All Results')
getwd()
write.csv(final01, 'Stranraer_all_data.csv')
getwd()
