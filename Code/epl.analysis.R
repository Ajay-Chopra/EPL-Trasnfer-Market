
# get the libraries we know we're going to need
library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)


# import the data and examine the structure
epl.df <- read.csv(file.choose())
str(epl.df)

summary(epl.df)

# first plot league placement vs. transfer spending to see if there is 
# in fact any correlation
ggplot(epl.df, aes(x = Transfer.Spend, y = Position, color = Season)) + 
  geom_point(size = 1, alpha = 0.75) + 
  labs(x = "Transfer Spending", y = "Position",
       title = "League Position vs. Transfer Spending in the EPL",
       caption = "Data from https://www.transfermarkt.com/") + 
  scale_y_continuous(trans = "reverse")


# then plot points won vs. transfer spending to see if there is 
# any correlation
ggplot(epl.df, aes(x = Transfer.Spend, y = Points, color = Season)) + 
  geom_point(size = 1, alpha = 0.75) + 
  labs(x = "Transfer Spending", y = "Points", 
       title = "Points vs. Transfer Spending in the EPL",
       caption = "Data from https://www.transfermarkt.com/")


# do the same using wage spending to see if there is a greater correlation

ggplot(epl.df, aes(x = Wage.Bill, y = Position, color = Season)) + 
  geom_point(size = 1, alpha = 0.75) + 
  labs(x = "Wage Spending", y = "Position",
       title = "League Position vs. Wage Spending in the EPL",
       caption = "Data from https://www.transfermarkt.com/") + 
  scale_y_continuous(trans = "reverse")

ggplot(epl.df, aes(x = Wage.Bill, y = Points, color = Season)) + 
  geom_point(size = 1, alpha = 0.75) + 
  labs(x = "Wage Spending", y = "Points",
       title = "Points vs. Wage Spending in the EPL",
       caption = "Data from https://www.transfermarkt.com/") 

# Compare the transfer spending of the "Big Six" clubs over time
# begin by subsetting our data
print(levels(epl.df$Team))

bigsix.df <- subset(epl.df, 
                    Team == "Arsenal" | Team == "Chelsea" | Team == "Liverpool" 
                    | Team == "Man City" | Team == "Man Utd" | Team == "Spurs")
head(bigsix.df)

# begin plotting
ggplot(bigsix.df, aes(x = Season, y = Transfer.Spend, color = Team, group = Team)) + 
  geom_point() + geom_line() + 
  labs(x = "Season", y = "Transfer Spending", 
       title = "Transfer Spending for Top 6 Teams by Season",
       caption = "Data from https://www.transfermarkt.com/")

colnames(epl.df)
# actually determine the value of the correlation between spending and success
# by creating a correlation matrix
spend.cor <- cor(epl.df[,3:6], use = "pairwise.complete.obs")

# Currently, positive correlations actually appear negative, since
# 20 is deemed to be a better position than 1, since it is greater

# Here I write a couple of for loops to turn the negative values into 
# positive ones
for (i in 1:4){
  if (spend.cor$Position[i] < 0){
    spend.cor$Position[i] <- spend.cor$Position[i] * (-1)
  }else{
    spend.cor$Position[i] <- spend.cor$Position[i]
  }
}

for (i in 1:4){
  if (spend.cor[4,i] < 0){
    spend.cor[4,i] <- spend.cor[4,i] * (-1)
  }else{
    spend.cor[4,i] <- spend.cor[4,i]
  }
}

getwd()
setwd("/Users/Ajay/Desktop/CSV_Files/ML_Data/Fun")
write.csv(spend.cor, "spend.cor.csv")

# now we can look at a correlation on a lot of different game stats
# let's take a look at offense first
offense.cor <- cor(epl.df[,7:22])
head(offense.cor)
corrplot(corr = offense.cor, method = "number", tl.cex = 0.5,
         number.cex = 0.5)

defense.cor <- cor(epl.df[,23:32])
corrplot(corr = defense.cor, method = "number", tl.cex = 0.75, 
         number.cex = 0.75)

off.def.df <- cbind(epl.df$Position, epl.df$Goals.Scored, 
                    epl.df$Goals.Conceded)
colnames(off.def.df) <- c("Position", "Goals.Scored", "Goals.Conceded")
rownames(off.def.df) <- rownames(epl.df)
head(off.def.df)
off.def.cor <- cor(off.def.df)
corrplot(off.def.cor, method = "number")

colnames(epl.df)
keeping.df <- epl.df[,32:38]
keeping.cor <- cor(keeping.df)
head(keeping.df)
corrplot(keeping.cor, method = "number")
colnames(epl.df)


#----building a linear regression model to predict position in the league
# begin by splitting the data
epl.nums <- epl.df[,3:36]
head(epl.nums)
epl.nums <- epl.nums[,2:34]
colnames(epl.nums)
epl.nums <- epl.nums[,-3]

sample <- sample.split(epl.nums, SplitRatio = 0.7)
epl.train <- subset(epl.nums, sample == TRUE)
epl.test <- subset(epl.nums, sample == FALSE)

epl.model <- lm(Points ~. , data = epl.train)
print(epl.model)
print(summary(epl.model))

epl.res <- residuals(epl.model)
epl.res <- as.data.frame(epl.res)
ggplot(epl.res, aes(epl.res)) + 
  geom_histogram(fill = "blue", alpha=0.5) + 
  labs(title = "Residuals of Linear Regression Model")

# Now look at predictions based on the model
epl.predictions <- predict(epl.model, epl.test)
epl.results <- cbind(epl.predictions, epl.test$Points)
epl.results <- as.data.frame(epl.results)
colnames(epl.results) <- c("predicted", "actual")
epl.results <- epl.results[-6,]
epl.results
# now compute the errors

epl.mse <- mean((epl.results$actual - epl.results$predicted)^2)
print(epl.mse)
epl.me <- mean(epl.results$actual - epl.results$predicted)
print(epl.me)

#-------now let's build a model to predict position
colnames(epl.df)
epl.pos <- epl.df[,3:36]
epl.pos <- epl.pos[,-3]
colnames(epl.pos)

sample <- sample.split(epl.pos, SplitRatio = 0.7)
epl.pos.train <- subset(epl.pos, sample == TRUE)
epl.pos.test <- subset(epl.pos, sample == FALSE)

position.model <- lm(Position ~. , epl.pos.train)
print(summary(position.model))


position.predictions <- predict(position.model, epl.pos.test)
position.results <- cbind(position.predictions, epl.pos.test$Position)
position.results <- as.data.frame(position.results)
colnames(position.results) <- c("predicted", "actual")
print(position.results)

is.na(position.results$predicted[1])

# get rid of NA values
position.results <- subset(position.results, is.na(predicted) == FALSE)
print(position.results)

# now look at mean error values
position.error <- mean(position.results$actual - position.results$predicted)
print(position.error)

# one more model that will try and predict the number of goals scored
# per match

colnames(epl.df)
epl.goals <- epl.df[,7:38]
colnames(epl.goals)
epl.goals <- epl.goals[,-(2:6)]
colnames(epl.goals)

sample <- sample.split(epl.goals, SplitRatio = 0.7)
goals.train <- subset(epl.goals, sample == TRUE)
goals.test <- subset(epl.goals, sample == FALSE)

# build the model

goals.model <- lm(Goals.Scored ~. , goals.train)
print(summary(goals.model))

# make predictions
goals.predictions <- predict(goals.model, goals.test)
goals.results <- as.data.frame(cbind(goals.predictions, goals.test$Goals.Scored))
print(goals.results)
colnames(goals.results) <- c("predicted", "actual")

# calculate mean error
goals.me <- mean(goals.results$actual - goals.results$predicted)
print(goals.me)


# import the larger transfer data csv
transfer.df <- read.csv(file.choose())
str(transfer.df)

# create a frame that does not contain the top six
non.six <- subset(transfer.df, Team != "Man Utd" & Team != "Man City" 
                  & Team != "Chelsea" & Team != "Arsenal" & Team != "Liverpool" 
                  & Team != "Spurs" & Team != "Arsenal ")

# create a new df for the average transfer spending for the other six teams
mean(subset(non.six, Season == "17/18")$Transfer.Spending)
levels(non.six$Season)
length(levels(non.six$Season))
avg.transfer <- as.data.frame(matrix(nrow = 11, ncol = 2))
colnames(avg.transfer) <- c("Season", "Transfer.Spending")
for (i in 1:length(levels(non.six$Season))){
  avg.transfer$Season[i] <- levels(non.six$Season)[i]
  avg.transfer$Transfer.Spending[i] <- mean(subset(non.six, Season == levels(non.six$Season)[i])$Transfer.Spending)
  
}

# Now add the top 6 to this data frame
avg.transfer$Team <- rep("RoL Avg", length(avg.transfer$Season))
head(bigsix.df)
bigsix.transfer <- subset(transfer.df, Team == "Man Utd" | Team == "Man City" 
                          | Team == "Chelsea" | Team == "Arsenal" | Team == "Liverpool" 
                          | Team == "Spurs" | Team == "Arsenal ")

avg.transfer <- avg.transfer[seq(dim(avg.transfer)[1], 1),]

final.transfer <- rbind(avg.transfer, bigsix.transfer)
final.transfer


ggplot(final.transfer, aes(x = Season, y = Transfer.Spending, color = Team, group = Team)) + 
  geom_point() + geom_line() + 
  labs(x = "Season", y = "Transfer Spending", 
       title = "Big Six vs. Rest of the League Transfer Spending",
       caption = "Data from https://www.transfermarkt.com/")

final.transfer <- subset(final.transfer, Season != "7/8" & Season != "8/9" &
                            Season != "9/10")


head(transfer.df)
str(transfer.df)

head(bigsix.transfer)

bigsix.avg <- as.data.frame(matrix(nrow = length(levels(bigsix.transfer$Season)),
                                   ncol = 3))

colnames(bigsix.avg) <- c("Season", "Team", "Transfer.Spending")

for (i in 1:length(levels(bigsix.transfer$Season))){
  bigsix.avg$Season[i] <- levels(bigsix.transfer$Season)[i]
  bigsix.avg$Transfer.Spending[i] <- mean(subset(bigsix.transfer, 
                                                 Season == levels(bigsix.transfer$Season)[i])$Transfer.Spending)
}


bigsix.avg$Team <- rep("Big Six Average", length(bigsix.avg$Season))

final.transfer <- rbind(bigsix.avg, avg.transfer)

final.transfer <- subset(final.transfer, 
                         Season != "9/10" & Season != "8/9" & Season != "7/8")


ggplot(final.transfer, aes(x = Season, y = Transfer.Spending, color = Team, group = Team)) + 
  geom_point() + geom_line() + 
  labs(x = "Season", y = "Transfer Spending", 
       title = "Big Six vs. Rest of the League Transfer Spending",
       caption = "Data from https://www.transfermarkt.com/")



colnames(epl.df)


ggplot(epl.df, aes(x = Avg.Pass.Length, y = Chances.Created, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Avg Pass Length", y = "Chances Created", 
       title = "Chances Created vs. Average Pass Length",
       caption = "http://www2.squawka.com/")

ggplot(epl.df, aes(x = Avg.Pass.Length, y = Shot.Acc, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Avg Pass Length", y = "Shot Accuracy", 
       title = "Shot Accuracy vs. Average Pass Length",
       caption = "http://www2.squawka.com/")

ggplot(epl.df, aes(x = Avg.Pass.Length, y = Points, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Avg Pass Length", y = "Points", 
       title = "Points vs. Average Pass Length",
       caption = "http://www2.squawka.com/")

ggplot(epl.df, aes(x = Tackles.Lost, y = Goals.Conceded, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Tackles.Lost", y = "Goals.Conceded", 
       title = "Goals Conceded vs. Tackels Lost",
       caption = "http://www2.squawka.com/")


epl.df$Total.Tackles <- epl.df$Tackles.Lost + epl.df$Tackles.Won
head(epl.df$Total.Tackles)

ggplot(epl.df, aes(x = Total.Tackles, y = Goals.Conceded, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Total Tackles", y = "Goals.Conceded", 
       title = "Goals Conceded vs. Total Tackles",
       caption = "Data from http://www2.squawka.com/")

ggplot(epl.df, aes(x = Passes.Forward, y = Pass.Acc, color = Season)) + 
  geom_point(size = 0.75) + 
  labs(x = "Forward Passes", y = "Pass Accuracy", 
       title = "Pass Accuracy vs. Forward Passes",
       caption = "Data from http://www2.squawka.com/")


colnames(epl.df)



#First split the data into traiing and test sets

sample <- sample.split(epl.df, SplitRatio = 0.7)
epl.train <- subset(epl.df, sample == TRUE)
epl.test <- subset(epl.df, sample == FALSE)

colnames(epl.train)

# Create model for Goals.Scored
scored.model <- lm(Points ~ Goals.Scored, data = epl.train)
summary(scored.model)

conceded.model <- lm(Points ~ Goals.Conceded, data = epl.train)
summary(conceded.model)

both.model <- lm(Points ~ Goals.Scored + Goals.Conceded, data = epl.train)
summary(both.model)










