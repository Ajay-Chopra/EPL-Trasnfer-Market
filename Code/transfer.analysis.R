
# Loading necessary
library("rvest")
library(rvest)
library(purrr)
library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)
library(rpart)
library(rpart.plot)
library(randomForest)




url <- "http://www.soccernews.com/soccer-transfers/english-premier-league-transfers/"

page <- read_html(url)



transfer_scrape <- function(url_1){
  
  page <- read_html(url_1)  
  
  data.frame(Player = html_text(html_nodes(page, ".btm-cnt .player-deals")),
            From = html_text(html_nodes(page, ".btm-cnt td:nth-child(4)")),
            To =  html_text(html_nodes(page, ".btm-cnt td:nth-child(6)")),
            Price =  html_text(html_nodes(page, ".btm-cnt .price-status")))
}


# scrape all transfers data for past three season of EPL
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/english-premier-league-transfers-2017-2018/") -> epl.1718.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/english-premier-league-transfers-2016-2017/") -> epl.1617.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/english-premier-league-transfers-2015-2016/") -> epl.1516.df

# do the same for Bundesliga
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/german-bundesliga-transfers/") -> bund.1819.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/german-bundesliga-transfers-2017-2018/") -> bund.1718.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/german-bundesliga-transfers-2016-2017/") -> bund.1617.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/german-bundesliga-transfers-2015-2016/") -> bund.1516.df


# and lastly for La Liga
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/spanish-la-liga-transfers/") -> liga.1819.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/spanish-la-liga-transfers-2017-2018/") -> liga.1718.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/spanish-la-liga-transfers-2016-2017/") -> liga.1617.df
transfer_scrape(url_1 = "http://www.soccernews.com/soccer-transfers/spanish-la-liga-transfers-2015-2016/") -> liga.1516.df

# now add a season column to all of these 
#EPL
epl.1718.df$Season <- rep("17/18", length(epl.1718.df$Player))
epl.1617.df$Season <- rep("16/17", length(epl.1617.df$Player))
epl.1516.df$Season <- rep("15/16", length(epl.1516.df$Player))
#Bundesliga
bund.1718.df$Season <- rep("17/18", length(bund.1718.df$Player))
bund.1617.df$Season <- rep("16/17", length(bund.1617.df$Player))
bund.1516.df$Season <- rep("15/16", length(bund.1516.df$Player))
# La Liga
liga.1718.df$Season <- rep("17/18", length(liga.1718.df$Player))
liga.1617.df$Season <- rep("16/17", length(liga.1617.df$Player))
liga.1516.df$Season <- rep("15/16", length(liga.1516.df$Player))

# now bind all into one dataframe

transfer_data <- rbind(epl.1718.df, epl.1617.df, epl.1516.df,bund.1718.df,
                       bund.1617.df, bund.1516.df,liga.1718.df,liga.1617.df,
                       liga.1516.df)



# remove all loans and undisclosed fees
transfer_data <- subset(transfer_data, Price != "Loan" & Price != "undisclosed")

getwd()
write.csv(transfer_data, "transfer_data.csv")


# import trasnfer data set
transfer_sheet <- read.csv(file.choose())
transfer_sheet <- as.data.frame(transfer_sheet)

transfer_sheet$From <- as.character(transfer_sheet$From)
transfer_sheet$To <- as.character(transfer_sheet$To)
transfer_sheet$Season <- as.character(transfer_sheet$Season)                               

str(transfer_sheet)

# Add league position data for each team
for (i in 1:109){
  if (transfer_sheet$To[i] == "Crystal Palace" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 14
  }else if (transfer_sheet$To[i] == "Swansea" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 15
  }else if (transfer_sheet$To[i] == "Burnley" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 16
  }else if (transfer_sheet$To[i] == "Watford" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 17
  }else if (transfer_sheet$To[i] == "Hull" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 18
  }else if (transfer_sheet$To[i] == "Middlesbrough" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 19
  }else if (transfer_sheet$To[i] == "Sunderland" & transfer_sheet$Season[i] == "17/18"){
    transfer_sheet$Buying.LP[i] <- 20
  }else{
    transfer_sheet$Buying.LP[i] <- transfer_sheet$Buying.LP[i]
  }
}


head(transfer_sheet)


for (i in 1:109){
  if (transfer_sheet$To[i] == "West Ham"){
    transfer_sheet$Buying.LP <- 1
  }
}


transfer_sheet <- read.csv(file.choose())
str(transfer_sheet)
transfer_sheet$To <- as.character(transfer_sheet$To)


# Add stadium capacity data for each team
for (i in 1:352){
  if (transfer_sheet$To[i] == "Brighton"){
    transfer_sheet$Buying.Capacity[i] <- 30750
  }else if (transfer_sheet$To[i] == "Liverpool"){
    transfer_sheet$Buying.Capacity[i] <- 54074
  }else if (transfer_sheet$To[i] == "Middlesbrough"){
    transfer_sheet$Buying.Capacity[i] <- 26667
  }else if (transfer_sheet$To[i] == "Derby"){
    transfer_sheet$Buying.Capacity[i] <- 18300
  }else if (transfer_sheet$To[i] == "Stoke City"){
    transfer_sheet$Buying.Capacity[i] <- 27740
  }else if (transfer_sheet$To[i] == "Blackpool"){
    transfer_sheet$Buying.Capacity[i] <- 16220
  }else if (transfer_sheet$To[i] == "West Ham"){
    transfer_sheet$Buying.Capacity[i] <- 60000
  } else if (transfer_sheet$To[i] == "Bolton"){
    transfer_sheet$Buying.Capacity[i] <- 22616
  }else if (transfer_sheet$To[i] == "Cardiff"){
    transfer_sheet$Buying.Capacity[i] <- 33280
  }else if (transfer_sheet$To[i] == "Norwich"){
    transfer_sheet$Buying.Capacity[i] <- 27033
  }else if (transfer_sheet$To[i] == "Nottingham"){
    transfer_sheet$Buying.Capacity[i] <- 30602
  }else if (transfer_sheet$To[i] == "Fulham"){
    transfer_sheet$Buying.Capacity[i] <- 25700
  }else if (transfer_sheet$To[i] == "Southampton"){
    transfer_sheet$Buying.Capacity[i] <- 15200
  }else if (transfer_sheet$To[i] == "Leeds"){
    transfer_sheet$Buying.Capacity[i] <- 39460
  }else if (transfer_sheet$To[i] == "Arsenal"){
    transfer_sheet$Buying.Capacity[i] <- 59867
  }else if (transfer_sheet$To[i] == "Manchester Cit"){
    transfer_sheet$Buying.Capacity[i] <- 55097
  }else if (transfer_sheet$To[i] == "Leicester City"){
    transfer_sheet$Buying.Capacity[i] <- 32500
  }else if (transfer_sheet$To[i] == "Everton"){
    transfer_sheet$Buying.Capacity[i] <- 39571
  }else if (transfer_sheet$To[i] == "West Brom"){
    transfer_sheet$Buying.Capacity[i] <- 26445
  }else if (transfer_sheet$To[i] == "Huddersfield"){
    transfer_sheet$Buying.Capacity[i] <- 24500
  }else if (transfer_sheet$To[i] == "Hull" | transfer_sheet$To[i] == "Hull City" ){
    transfer_sheet$Buying.Capacity[i] <- 25400
  }else if (transfer_sheet$To[i] == "Swansea"){
    transfer_sheet$Buying.Capacity[i] <- 20937
  }else if (transfer_sheet$To[i] == "Tottenham"){
    transfer_sheet$Buying.Capacity[i] <- 36284
  }else if (transfer_sheet$To[i] == "Aston Villa"){
    transfer_sheet$Buying.Capacity[i] <- 42682
  }else if(transfer_sheet$To[i] == "Watford"){
    transfer_sheet$Buying.Capacity[i] <- 21977
  }else if (transfer_sheet$To[i] == "Chelsea"){
    transfer_sheet$Buying.Capacity[i] <- 41631
  }else if (transfer_sheet$To[i] == "Manchester United"){
    transfer_sheet$Buying.Capacity[i] <- 75643
  }
}




head(transfer_sheet$Buying.Capacity, n = 20)

getwd()
setwd("/Users/Ajay/Desktop/")
write.csv(transfer_sheet, "transfer_sheet.csv")


transfer_sheet <- read.csv(file.choose())
str(transfer_sheet)


length(subset(transfer_sheet, Season == "16/17")$To)

transfer_sheet$To <- as.factor(transfer_sheet$To)

levels(transfer_sheet$To)


# league positions for the 16/17 season
for (i in 1:352){
  if (transfer_sheet$Season[i] == "16/17"){
    if (transfer_sheet$To[i] == "Chelsea"){
      transfer_sheet$Buying.LP[i] <- 1
    }else if (transfer_sheet$To[i] == "Tottenham"){
      transfer_sheet$Buying.LP[i] <- 2
    }else if (transfer_sheet$To[i] == "Manchester City" | transfer_sheet$To[i] == "Manchester City "){
      transfer_sheet$Buying.LP[i] <- 3
    }else if (transfer_sheet$To[i] == "Liverpool" | transfer_sheet$To[i] == "Liverpool "){
      transfer_sheet$Buying.LP[i] <- 4
    }else if (transfer_sheet$To[i] == "Arsenal"){
      transfer_sheet$Buying.LP[i] <- 5
    }else if (transfer_sheet$To[i] == "Manchester United" | transfer_sheet$To[i] == "Manchester Utd"){
      transfer_sheet$Buying.LP[i] <- 6
    }else if(transfer_sheet$To[i] == "Everton"){
      transfer_sheet$Buying.LP[i] <- 7
    }else if(transfer_sheet$To[i] == "Southampton"){
      transfer_sheet$Buying.LP[i] <- 8
    }else if(transfer_sheet$To[i] == "Bournemouth"){
      transfer_sheet$Buying.LP[i] <- 9
    }else if(transfer_sheet$To[i] == "West Brom" | transfer_sheet$To[i] == "West Bromwich"){
      transfer_sheet$Buying.LP[i] <- 10
    }else if(transfer_sheet$To[i] == "West Ham"){
      transfer_sheet$Buying.LP[i] <- 11
    }else if(transfer_sheet$To[i] == "Leicester City" | transfer_sheet$To[i] == "Leicester"){
      transfer_sheet$To[i] <- 12
    }else if(transfer_sheet$To == "Stoke City" | transfer_sheet$To[i] == "Stoke"){
      transfer_sheet$To[i] <- 13
    }else if(transfer_sheet$To[i] == "Crystal Palace"){
      transfer_sheet$To[i] <- 14
    }else if(transfer_sheet$To[i] == "Swansea" | transfer_sheet$To[i] == "Swansea City"){
      transfer_sheet$To[i] <- 15
    }else if(transfer_sheet$To[i] == "Burnley"){
      transfer_sheet$To[i] <- 16
    }else if(transfer_sheet$To[i] == "Watford"){
      transfer_sheet$To[i] <- 17
    }else if(transfer_sheet$To[i] == "Hull"){
      transfer_sheet$To[i] <- 18
    }else if(transfer_sheet$To[i] == "Middlesbrough" | transfer_sheet$To[i] == "Middlesbrough "){
      transfer_sheet$To[i] <- 19
    }else if(transfer_sheet$To[i] == "Sunderland"){
      transfer_sheet$To[i] <- 20
    }else{
      transfer_sheet$To[i] <- transfer_sheet$To[i]
    }
  }else{
    transfer_sheet$To[i] <- transfer_sheet$To[i]
  }
}


colnames(transfer_sheet)

levels(transfer_sheet$To)


# league positions for the 15/16 season
for (i in 1:352){
  if (transfer_sheet$To[i] == "Leicester" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 1
  }else if (transfer_sheet$To[i] == "Arsenal" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 2
  }else if (transfer_sheet$To[i] == "Tottenham" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP <- 3
  }else if(transfer_sheet$To[i] <- "Manchester City" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 4
  }else if(transfer_sheet$To[i] <- "Manchester City " & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 4
  }else if(transfer_sheet$To[i] == "Manchester United" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 5
  }else if(transfer_sheet$To[i] == "Manchester Utd" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 5
  }else if(transfer_sheet$To[i] == "Southampton" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 6
  }else if(transfer_sheet$To[i] == "West Ham" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 7
  }else if(transfer_sheet$To[i] == "Liverpool" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 8
  }else if(transfer_sheet$To[i] == "Liverpool " & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 8
  }else if(transfer_sheet$To[i] == "Stoke" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 9
  }else if(transfer_sheet$To[i] == "Stoke City" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 9
  }else if(transfer_sheet$To[i] <- "Chelsea" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 10
  }else if(transfer_sheet$To[i] == "Everton" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 11
  }else if(transfer_sheet$To[i] == "Swansea" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 12
  }else if(transfer_sheet$To[i] == "Swansea City" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 12
  }else if(transfer_sheet$To[i] == "Watford" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 13
  }else if(transfer_sheet$To[i] == "West Brom" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 14
  }else if(transfer_sheet$To[i] == "West Bromwich" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 14
  }else if(transfer_sheet$To[i] == "Crystal Palace" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 15
  }else if(transfer_sheet$To[i] == "Bournemouth" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 16
  }else if(transfer_sheet$To[i] == "Sunderland" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 17
  }else if(transfer_sheet$To[i] == "Newcastle United" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 18
  }else if(transfer_sheet$To[i] == "Newcastle United " & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 18
  }else if(transfer_sheet$To[i] == "Norwich" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 19
  }else if(transfer_sheet$To[i] == "Aston Villa" & transfer_sheet$Season[i] == "15/16"){
    transfer_sheet$Buying.LP[i] <- 20
  }else{
    transfer_sheet$Buying.LP[i] <- transfer_sheet$Buying.LP[i]
  }
}


transfer.df <- read.csv(file.choose())

str(transfer.df)
transfer.df$Season <- as.character(transfer.df$Season)
transfer.df$Season[350]
transfer.df$To <- as.factor(transfer.df$To)
levels(transfer.df$To)


for (i in 1:352){
  if (transfer.df$Season[i] == "15/16"){
    if (transfer.df$To[i] == "Leicester" | transfer.df$To[i] == "Leicester City"){
      transfer.df$Buying.LP[i] <- 1
    }else if (transfer.df$To[i] == "Arsenal"){
      transfer.df$Buying.LP[i] <- 2
    }else if (transfer.df$To[i] == "Tottenham"){
      transfer.df$Buying.LP[i] <- 3
    }else if (transfer.df$To[i] == "Manchester City" | transfer.df$To[i] == "Manchester City "){
      transfer.df$Buying.LP[i] <- 4
    }else if (transfer.df$To[i] == "Manchester United" | transfer.df$To[i] == "Manchester Utd"){
      transfer.df$Buying.LP[i] <- 5
    }else if (transfer.df$To[i] == "Southampton"){
      transfer.df$Buying.LP[i] <- 6
    }else if (transfer.df$To[i] == "West Ham"){
      transfer.df$Buying.LP[i] <- 7
    }else if (transfer.df$To[i] == "Liverpool" | transfer.df$To[i] == "Liverpool "){
      transfer.df$Buying.LP[i] <- 8
    }else if (transfer.df$To[i] == "Stoke City" | transfer.df$To[i] == "Stoke"){
      transfer.df$Buying.LP[i] <- 9
    }else if (transfer.df$To == "Chelsea"){
      transfer.df$Buying.LP[i] <- 10
    }else if (transfer.df$To[i] == "Everton"){
      transfer.df$Buying.LP[i] <- 11
    }else if (transfer.df$To[i] == "Swansea" | transfer.df$To[i] == "Swansea City"){
      transfer.df$Buying.LP[i] <- 12
    }else if (transfer.df$To[i] == "Watford"){
      transfer.df$Buying.LP[i] <- 13
    }else if (transfer.df$To[i] == "West Brom" | transfer.df$To[i] == "West Bromwich"){
      transfer.df$Buying.LP[i] <- 14
    }else if (transfer.df$To[i] == "Crystal Palace"){
      transfer.df$Buying.LP[i] <- 15
    }else if (transfer.df$To[i] == "Bournemouth"){
      transfer.df$Buying.LP[i] <- 16
    }else if (transfer.df$To[i] == "Sunderland"){
      transfer.df$Buying.LP[i] <- 17
    }else if (transfer.df$To[i] == "Newcastle" | transfer.df$To[i] == "Newcastle United"){
      transfer.df$Buying.LP[i] <- 18
    }else if (transfer.df$To[i] == "Norwich"){
      transfer.df$Buying.LP[i] <- 19
    }else if (transfer.df$To[i] == "Aston Villa"){
      transfer.df$Buying.LP[i] <- 20
    }
  }
}


tail(transfer.df)

# Export as CSV to make manual additions

write.csv(transfer.df, "transfer_sheet.csv")

# Import the final csv file that we will use
# for data analysis
transfer.df <- read.csv(file.choose())

head(transfer.df)
tail(transfer.df)
# Start cleaning the data
transfer.df$X.1 <- NULL
transfer.df$X <- NULL
str(transfer.df)
# reformat columns

transfer.df$Player <- as.character(transfer.df$Player)
transfer.df$From <- as.character(transfer.df$From)

transfer.df$To <- as.character(transfer.df$To)
head(transfer.df)
transfer.df$Season <- as.character(transfer.df$Season)
transfer.df$Tourney.Performance <- as.character(transfer.df$Tourney.Performance)

# No players purchased in the 15/16 transfer window had
# better than average tournament performances
length(transfer.df$Player)
for (i in 1:308){
  if (transfer.df$Season[i] == "15/16"){
    transfer.df$Tourney.Performance[i] <- "No"
  }else{
    transfer.df$Tourney.Performance[i] <- transfer.df$Tourney.Performance[i]
  }
}

tail(transfer.df)
transfer.df$Season <- as.factor(transfer.df$Season)
transfer.df$Tourney.Performance <- as.factor(transfer.df$Tourney.Performance)
colnames(transfer.df)

# Begin exploratory data analysis using ggplot
ggplot(data = transfer.df, aes(x = Offensive.Rating, y = Price, color = Season)) + 
  geom_point(size = 0.7)

ggplot(data = transfer.df, aes(x = Caps, y = Price, color = Season)) + 
  geom_point(size = 0.7) + 
  labs(x = "International Caps", y = "Transfer Fee", 
       title = "Transfer Fee vs. International Caps")

ggplot(data = transfer.df, aes(x = Age, y = Price, group = Age)) + 
  geom_boxplot() + 
  labs(x = "Age", y = "Transfer Fee", 
       title = "Transfer Fee vs. Age")

ggplot(data = transfer.df, aes(x = Buying.LP, y = Price, group = Buying.LP)) + 
  geom_boxplot() + 
  labs(x = "League Position", y = "Transfer Fee", 
       title = "Transfer Fee vs. Buying Club's League Position")


# Boxplot of transfer fee vs. player position
ggplot(data = transfer.df, aes(x = Position, y = Price, group = Position)) +
  geom_boxplot() +
  labs(x = "Player Position", y = "Transfer Fee",
       title = "Transfer Fee vs. Player Position")



# Construct a correlation matrix

transfer.num <- transfer.df[,-(1:4)]
transfer.num$Season <- NULL
transfer.num$Domestic <- NULL
transfer.num$Nationality <- NULL
transfer.num$Buying.Manager.Change <- NULL
transfer.num$Tourney.Performance <- NULL
colnames(transfer.num)

transfer.cor <- cor(transfer.num, use = "pairwise.complete.obs")
corrplot(corr = transfer.cor, method = "number", number.cex = 0.7, tl.cex = 0.7)


?corrplot()

# Split data into training and testing to build
# regression model

sample <- sample.split(transfer.num, SplitRatio = 0.7)
transfer.train <- subset(transfer.num, sample == TRUE)
transfer.test <- subset(transfer.num, sample == FALSE)

# Initialize the linear regression model
transfer.model <- lm(Price ~. , data = transfer.train)
print(summary(transfer.model))

# Build the data frame for the decision tree algorithm

str(transfer.df)

transfer.tree.df <- transfer.df[,-1]
str(transfer.tree.df)
transfer.tree.df$From <- NULL
transfer.tree.df$To <- NULL
transfer.tree.df$Season <- NULL
transfer.tree.df$Nationality <- NULL

str(transfer.tree.df)

# split new data frame into training and test sets
sample <- sample.split(transfer.tree.df, SplitRatio = 0.7)
transfer.tree.train <- subset(transfer.tree.df, sample == TRUE)
transfer.tree.test <- subset(transfer.tree.df, sample == FALSE)

# Now train the decision tree model
?rpart()
transfer.tree <- rpart(Price ~. , method = "anova", data = transfer.tree.train)
prp(transfer.tree)

plot(transfer.tree, uniform = TRUE, main = "Regression Tree for EPL Transfer Fees")
text(transfer.tree, use.n = TRUE, all = TRUE, cex = 0.6)













