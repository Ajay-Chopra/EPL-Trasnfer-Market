
# Adding libraries
library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)
library(rpart)
library(rpart.plot)

#import data
player.rankings <- as.data.frame(read.csv(file.choose()))
player.rankings <- player.rankings[,1:9]

#remove all NA wage values
player.rankings <- subset(player.rankings, is.na(Wage) == FALSE)
head(player.rankings)
player.rankings$Rank <- as.numeric(player.rankings$Rank)
player.rankings$Age <- as.numeric(player.rankings$Age)
player.rankings$Wage <- as.numeric(player.rankings$Wage)





#examine data
summary(player.rankings)
head(player.rankings)





#reformatting player attributes to be numeric
player.rankings$Acceleration <- as.numeric(player.rankings$Acceleration)
player.rankings$Aggression <- as.numeric(player.rankings$Aggression)
player.rankings$Agility <- as.numeric(player.rankings$Agility)
player.rankings$Balance <- as.numeric(player.rankings$Balance)
player.rankings$Ball.Control <- as.numeric(player.rankings$Ball.Control)
player.rankings$Composure <- as.numeric(player.rankings$Composure)
player.rankings$Crossing <- as.numeric(player.rankings$Crossing)


#reformatting player.rankings into a data.frame
player.rankings <- as.data.frame(player.rankings)


#creating list of teams in EPL for 17/18 season
team.list <- list("Manchester City", "Manchester United", "Tottenham Hotspur",
                  "Liverpool", "Chelsea", "Arsenal", "Burnley", "Everton",
                  "Leicester City", "Newcastle United", "Crystal Palace",
                  "Bournemouth", "West Ham United", "Watford", "Brighton & Hove Albion",
                  "Huddersfield Town", "Southampton", "Swansea City", "Stoke City",
                  "West Bromwich Albion")

#some tests
"Arsenal" %in% team.list
"Huddersfiled" %in% team.list


#save new data frame just for EPL teams
epl.player.rankings <- as.data.frame(player.rankings[player.rankings$Club %in% team.list, ])


#check to make sure only EPL teams are represented
levels(epl.player.rankings$Club)
summary(epl.player.rankings)
head(epl.player.rankings)



getwd()

#note to self: create a two plots: one of league position vs. best player ranking
# and league position vs. worst player ranking
#see which has a stronger correlation


#function that creates a list of the worst ranked
#player for every team in EPL 17/18

wrst_players <- function(teams, rankings){
  ranks.list <- NULL
  for (i in 1:length(teams)){
    ranks.list <- append(ranks.list, max(rankings[rankings$Club == teams[i], ]$Rank))
  }
  return(ranks.list)
}


#function that creates a list of the best ranked
#player for every team in EPL 17/18

bst_players <- function(teams, rankings){
  ranks.list <- NULL
  for (i in 1:length(teams)){
    ranks.list <- append(ranks.list, min(rankings[rankings$Club == teams[i], ]$Rank))
  }
  return(ranks.list)
}



epl.rank.frame <- create_rank_frame(team.list)
head(epl.rank.frame)
tail(epl.rank.frame)
str(epl.rank.frame)
epl.rank.frame$Position <- as.numeric(epl.rank.frame$Position)
epl.rank.frame$Worst.Player <- as.numeric(epl.rank.frame$Worst.Player)
epl.rank.frame$Best.Player <- as.numeric(epl.rank.frame$Best.Player)


#create some plots with this frame
ggplot(epl.rank.frame, aes(x = Worst.Player, y = Position)) + 
  geom_point(size = 1)

# in order to get more data points to make an accurate
# correlation, I am going to repeat this with all five 
# European leagues

la.liga.teams.18 <- list("FC Barcelona", "Atlético Madrid", "Real Madrid CF",
                      "Valencia CF", "Villarreal CF", "Real Betis Balompié",
                      "Sevilla FC", "Getafe CF", "SD Eibar", "Girona CF",
                      "RCD Espanyol", "Real Sociedad", "RC Celta de Vigo",
                      "Deportivo Alavés", "Levante UD", "Athletic Club de Bilbao",
                      "CD Leganés", "RC Deportivo de La Coruña", "UD Las Palmas",
                      "Málaga CF")

bundesliga.teams.18 <- list("FC Bayern Munich", "FC Schalke 04", "TSG 1899 Hoffenheim",
                         "Borussia Dortmund", "Bayer 04 Leverkusen", "RB Leipzig",
                         "VfB Stuttgart", "Eintracht Frankfurt", "Borussia Mönchengladbach",
                         "Hertha BSC Berlin", "SV Werder Bremen", "FC Augsburg",
                         "Hannover 96", "1. FSV Mainz 05", "SC Freiburg", "VfL Wolfsburg",
                         "Hamburger SV", "1. FC Köln")


serie.a.teams.18 <- list("Juventus", "Napoli", "Roma", "Inter", "Lazio",
                      "Milan", "Atalanta", "Fiorentina", "Torino",
                      "Sampdoria", "Sassuolo", "Genoa", "Chievo Verona",
                      "Udinese", "Bologna", "Cagliari", "Ferrara (SPAL)",
                      "Crotone", "Hellas Verona", "Benevento Calcio")

ligue.1.teams.18 <- list("Paris Saint-Germain", "AS Monaco",
                      "Olympique Lyonnais", "Olympique de Marseille",
                      "Stade Rennais FC", "Girondins de Bordeaux",
                      "AS Saint-Étienne", "OGC Nice", "FC Nantes",
                      "Montpellier Hérault SC", "Dijon FCO", "En Avant de Guingamp",
                      "Amiens SC Football", "Angers SCO", "RC Strasbourg",
                      "SM Caen", "LOSC Lille", "Toulouse FC", "ES Troyes AC",
                      "FC Metz")




#as the results of the scatterplots are rather inconclusive
#I am going to create a correlation matrix



#the results of the corrplot show that the ranking of the best player
#is more correlated to league position

#Now look at effect of median ranked player


#edit previous functions to return median players
med_players <- function(teams, rankings){
  ranks.list <- NULL
  for (i in 1:length(teams)){
    ranks.list <- append(ranks.list, median(rankings[rankings$Club == teams[i], ]$Rank))
  }
  return(ranks.list)
}


#create a data frame with four columns
#column 1: name of every team
#column 2: league position
#column 3: ranking of worst player
#column 4: ranking of best player
#column 5: ranking of median player


create_rank_frame <- function(teams, rankings){
  rank.frame <- as.data.frame(cbind(teams, seq(1, length(teams)), 
                                    wrst_players(teams, rankings),
                                    bst_players(teams, rankings),
                                    med_players(teams, rankings)))
  colnames(rank.frame) <- c("Club", "Position", "Worst.Player", "Best.Player", "Med.Player")
  return(rank.frame)
}


#create the data frame for each of the leagues

epl.frame.18 <- create_rank_frame(team.list)

la.liga.frame.18 <- create_rank_frame(la.liga.teams.18)
head(la.liga.frame)

bundesliga.frame.18 <- create_rank_frame(bundesliga.teams.18)
head(bundesliga.frame)

serie.a.frame.18 <- create_rank_frame(serie.a.teams.18)
head(serie.a.frame)

ligue.1.frame.18 <- create_rank_frame(ligue.1.teams.18)


#create large frame for all European leagues
euro.frame.18 <- as.data.frame(rbind(epl.frame.18, la.liga.frame.18, bundesliga.frame.18,
                                  serie.a.frame.18, ligue.1.frame.18))



#once again properly reformat the columns
euro.frame.18$Position <- as.numeric(euro.frame.18$Position)
euro.frame.18$Best.Player <- as.numeric(euro.frame.18$Best.Player)
euro.frame.18$Worst.Player <- as.numeric(euro.frame.18$Worst.Player)
euro.frame.18$Med.Player <- as.numeric(euro.frame.18$Med.Player)



#now create a correlation matrix
euro.frame.18.num <- euro.frame.18[,2:5]

euro.cor <- cor(euro.frame.18.num)

#now create a corrplot
corrplot(corr = euro.cor, method = "number", tl.cex = 0.75,
         number.cex = 0.75)



# use ggplot to look at correlations

#league position vs. best player ranking
ggplot(euro.frame.18, aes(x = Best.Player, y = Position)) + 
  geom_point(size = 1)

#league position vs. worst player ranking
ggplot(euro.frame.18, aes(x = Worst.Player, y = Position)) + 
  geom_point(size = 1)


#save correlation data frame.18
euro.frame.18.num <- euro.frame.18[,2:4]
head(euro.frame.18.num)
euro.cor <- cor(euro.frame.18.num)

#now create a corrplot
corrplot(corr = euro.cor, method = "number", tl.cex = 0.75,
         number.cex = 0.75)


# this data is not very conclusive, so I am also going to
# add data from the 16/17 season as well

# first import the csv
player.rankings.17 <- read.csv(file.choose())


# reformat as data frame
player.rankings.17 <- as.data.frame(player.rankings.17)
head(player.rankings.17)
player.rankings.17$Rank <- as.numeric(player.rankings.17$Rank)


# create teams lists for each of the leagues

epl.teams.17 <- list("Chelsea", "Spurs", "Manchester City",
                     "Liverpool", "Arsenal", "Manchester Utd",
                     "Everton", "Southampton", "Bournemouth",
                     "West Brom", "West Ham", "Leicester City",
                     "Stoke City", "Crystal Palace", "Swansea City",
                     "Burnley", "Watford", "Hull City", "Middlesbrough",
                     "Sunderland")


la.liga.teams.17 <- list("Real Madrid", "FC Barcelona", "Atlético Madrid",
                         "Sevilla FC", "Villarreal CF", "Real Sociedad",
                         "Athletic Bilbao", "RCD Espanyol", "Deport. Alavés",
                         "SD Eibar", "Málaga CF", "Valencia CF", "Celta Vigo",
                         "UD Las Palmas", "Real Betis", "RC Deportivo",
                         "CD Leganés", "Sporting Gijón", "CA Osasuna",
                         "Granada CF")


bundesliga.teams.17 <- list("FC Bayern", "RB Leipzig", "Bor. Dortmund",
                            "1899 Hoffenheim", "1. FC Köln", "Hertha BSC",
                            "SC Freiburg", "Werder Bremen", "Bor. M'gladbach",
                            "FC Schalke 04", "Eint. Frankfurt", "Bayer 04",
                            "FC Augsburg", "Hamburger SV", "1. FSV Mainz 05",
                            "VfL Wolfsburg", "FC Ingolstadt", "SV Darmstadt")


serie.a.teams.17 <- list("Juventus", "Roma", "Napoli", "Atalanta",
                         "Lazio", "Milan", "Inter", "Fiorentina",
                         "Torino", "Sassuolo", "Sampdoria", "Cagliari",
                         "Udinese", "Chievo Verona", "Bologna", "Genoa",
                         "Empoli", "Palermo", "Pescara")
                            

ligue.1.teams.17 <- list("AS Monaco", "PSG", "OGC Nice", "Olym. Lyonnais",
                         "Olym. Marseille", "Giron. Bordeaux", "FC Nantes",
                         "Stade Rennais", "AS Saint-Étienne", "EA Guingamp",
                         "Angers SCO", "LOSC Lille", "Toulouse FC", "FC Metz",
                         "Montpellier HSC", "Dijon FCO", "SM Caen", "FC Lorient",
                         "SC Bastia")



# create data frames for 16/17 season

epl.frame.17 <- create_rank_frame(teams = epl.teams.17,
                                  rankings = player.rankings.17)

la.liga.frame.17 <- create_rank_frame(teams = la.liga.teams.17,
                                      rankings = player.rankings.17)
head(la.liga.frame.17)

bundesliga.frame.17 <- create_rank_frame(teams = bundesliga.teams.17,
                                         rankings = player.rankings.17)


serie.a.frame.17 <- create_rank_frame(teams = serie.a.teams.17, 
                                      rankings = player.rankings.17)

ligue.1.frame.17 <- create_rank_frame(teams = ligue.1.teams.17, 
                                   rankings = player.rankings.17)


# bind into one frame
euro.frame.17 <- rbind(epl.frame.17, la.liga.frame.17, bundesliga.frame.17,
                       serie.a.frame.17, ligue.1.frame.17)

#format columns as numeric
euro.frame.17$Worst.Player <- as.numeric(euro.frame.17$Worst.Player)
euro.frame.17$Best.Player <- as.numeric(euro.frame.17$Best.Player)
euro.frame.17$Med.Player <- as.numeric(euro.frame.17$Med.Player)
euro.frame.17$Position <- as.numeric(euro.frame.17$Position)


# bind 17 and 18 frames together
euro.frame <- rbind(euro.frame.17, euro.frame.18)

# create corrplot
euro.frame.num <- euro.frame[,2:5]
euro.cor <- cor(euro.frame.num)

corrplot(cor = euro.cor, method = "number", tl.cex = 0.75,
         number.cex = 0.75)



# creating a multiple regression model


# splitting data into training and test sets
sample <- sample.split(euro.frame.num, SplitRatio = 0.7)
euro.frame.train <- subset(euro.frame.num, sample == TRUE)
euro.frame.test <- subset(euro.frame.num, sample == FALSE)


# build model
rankings.model <- lm(Position ~ ., data = euro.frame.train)
summary(rankings.model)


# analyzing wage allocation for premier league teams

# first we want the total wage spending for each club


subset(player.rankings, Name == "L. Messi")$Wage / 5

# function to return a list of the wage distribution
# for the worst players in every squad in the EPL

wrst_wages <- function(teams, rankings){
  wage.list <- NULL
  for (i in 1:length(teams)){
    wage.list <- append(wage.list,
           (subset(player.rankings, 
                  Rank == wrst_players(teams, rankings)[i])$Wage / 
              sum(subset(player.rankings, Club == teams[i])$Wage)))
  }
  return(wage.list)
}

epl.worst.wages <- wrst_wages(team.list, player.rankings)
head(epl.worst.wages)


# same function but for best players
bst_wages <- function(teams, rankings){
  wage.list <- NULL
  for (i in 1:length(teams)){
    wage.list <- append(wage.list,
                        (subset(player.rankings, 
                                Rank == bst_players(teams, rankings)[i])$Wage / 
                           sum(subset(player.rankings, Club == teams[i])$Wage)))
  }
  return(wage.list)
}

epl.best.wages <- bst_wages(team.list, player.rankings)

# and last for median players

med_wages <- function(teams, rankings){
  wage.list <- NULL
  for (i in 1:length(teams)){
    wage.list <- append(wage.list,
                        (subset(player.rankings, 
                                Rank == med_players(teams, rankings)[i])$Wage / 
                           sum(subset(player.rankings, Club == teams[i])$Wage)))
  }
  return(wage.list)
}

epl.med.wages <- med_wages(team.list, player.rankings)


# now all that remains is to build a data frame to
# display the data

epl.wage.dist <- as.data.frame(cbind(seq(1,20),
                                     team.list,
                                     epl.best.wages,
                                     epl.med.wages,
                                     epl.worst.wages))

colnames(epl.wage.dist) <- c("Position", "Club",
                             "Best.Player.Wage",
                             "Med.Player.Wage",
                             "Worst.Player.Wage")

head(epl.wage.dist)
tail(epl.wage.dist)
is.list(epl.wage.dist$Best.Player.Wage)

epl.wage.dist$Best.Player.Wage <- as.numeric(epl.wage.dist$Best.Player.Wage)
epl.wage.dist$Med.Player.Wage <- as.numeric(epl.wage.dist$Med.Player.Wage)
epl.wage.dist$Worst.Player.Wage <- as.numeric(epl.wage.dist$Worst.Player.Wage)


print(epl.wage.dist)
# write to csv
getwd()
setwd("/Users/Ajay/Desktop/CSV_Files/ML_data/Fun/Data")

write.csv(epl.wage.dist, "epl-wage-dist.csv")














































































































































































































































