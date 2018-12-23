# Analyzing Transfer Market Inefficiencies in the English Premier League #

	
  
  In this project, I aim to highlight prevalent inefficiencies in the player transfer market of the English Premier League (EPL), the most popular professional soccer league in the world. During the winter and summer transfer windows, clubs in the EPL spend an average of $1.5 billion purchasing players from other teams. However, consistent analysis shows that transfer spending has little correlation with competitive success, suggesting that many clubs spend their money inefficiently.
	
  I use three main data sets for analysis. The first tracks wage spending, transfer spending, final league position and performance statistics (compiled by Opta Sports) of clubs in the EPL over the past five seasons. The second is a list of all players purchased by clubs in the EPL over the same period along with their transfer fee, provided it was disclosed. Each player is measured on parameters of age, number of games played and the same set of performance statistics used in the team-level data. The last data set is a comprehensive ranking of all professional soccer players using data from the videogame FIFA 2018, published by EA Sports.
  
 
### Summary of Results ###

  Upon analyzing the data, I conclude that clubs in the EPL engage in three major transfer market inefficiencies. First, they consistently undervalue defensive players, while overvaluing offensive players. Second, they misjudge the offensive value of strikers, using misleading statistics such as number of goals scored instead of more accurate measurements. Lastly, clubs focus too highly on spending a large amount of money on one player, even though such a purchase does not lead to a higher league position. 



## The Data ##

#### Team Performance Statistics ####
I compiled the in-game statsitcs of each team in the EPL for every season from 13/14 to 17/18 using data from Opta Sports, henceforth referred to as the "team-stats" data set. These include offensive, possession-based, defensive and goalkeeping statiscs for each team on a per game basis. I then merged these with data for each club's transfer spending, final points total and final league position for each season. The image below gives a brief snapshot of the data.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Competitve%20Stats%20Data-Set.png)

I also compiled a data set that tracks goal statistics at different game states, henceforth referred to as the "game-state" data set. Similar to the team-stats data set, it combines league results with performance statistics, specifically the number of goals scored/conceded in a given 15-minute interval of every game as well as goals scored/conceded based on score difference.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Game-State-Data.png)

For instance, in the snapshot above, we see that out of all the goals that Arsenal scored in the 17/18 season, 12 came in minutes 1-15 of the game. Similarly, Arsenal allowed 9 goals in the first fifteen minutes of games for that season. The full data set can be found here. 


#### Transfer Data ####
The second data set was compiled from Opta Sports data and data from https://www.transfermarkt.com/. It lists all the players pruchased by EPL clubs during the seasons from 13/14 to 17/18 and their transfer fee. Additional parameters include player attributes that I hypothesized would be highly likley to influence the tranfser fee. The list was based on reviewing current literature on the subject, which I have compiled here. From the literature, it seems that the player attributes that most greatly affect trasnfer fee are age, number of games played in the previous season, number of international caps, nationality and height. I combined these with offensvie, defensive and possession-based ratings to create the final data set. A snapshot is shown below, and the full data set can be found here.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer-Data.png)

#### Player Rankings ####

The last data set is the the full ranking of every professional footballer as used in the FIFA 2018 videogame. While the exact methodology that EA Sports uses to construct its rankings is obsucre, the FIFA 2018 rankings are the best we have in terms of current, comprehensive player valuations. The full data set can be found here.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Player-Rankings.png)


## Understanding the Transfer Market ##

In order to get a sense of the current mechanics of the EPL transfer market, one ought to begin by separating big and small spenders. Currently, transfer spending in the EPL is dominated by the league's wealthiest and most successful clubs--Arsenal, Chelsea, Liverpool, Manchester United, Manchester City and Tottenham Hotspur. This group is commonly referred to as the "Big 6." The figure below shows average transfer spending for Big 6 clubs over the past seven seasons compared to the average for the rest of the league.


![alt text](
https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Big%20Six%20vs.%20Rest%20of%20League%20Transfer%20Spending.png
)

Clearly, Big 6 teams spend far more on average than their peers. This gulf has led many pundits and fans to believe that success in the league and transfer spending are highly correlated with one another. However, this is not the case. 

The graph below plots final league position against transfer spending for every team in the EPL by season.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Position%20vs.%20Transfer%20Spending%20Plot.png)


From a simple visual test, it is easy to see that higher transfer spending is not highly correlated with a better league position. In fact, after creating a corrplot for the data, I found that there is only a 0.07 correlation between transfer spending and final league position. This is not only less than many members of the footballing community would likely suggest, but also far less than it ought to be, given the sums of money spent and the importance placed on trasnfer windows. In other words, it seems as if football clubs are often receiving a poor return on their trasnsfer investments. 


## How Clubs Buy Players ##

In order to understand where inefficienices arise in the transfer market, one must first understand what criteria clubs use to value players. I analyze the transfer-data set in order to answer this question.

First, I look at transfer price based on player position. The plot is shown below.


![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer%20Fee%20vs.%20Player%20Position.png)

As we can see, attackers and midfielders fetch the highest transfer fees amongst EPL clubs, while defenders and goalkeepers are bought for less on average. In fact, after creating a corrplot for the transfer-data, one sees that a player's offensive rating is more highly correlated to a higher transfer price than is his defensive rating.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer%20CorrPlot.png)

Thus, several surface-level indicators show that clubs value offensive players more highly than they do their defensive counterparts. However, in order to more accurately determine the difference in variability caused by offensive vs. defensive ratings, I found it better to build a more robust statistical learning algorithm.

#### The Model ####

The model used for analysis was a multiple linear regression of player transfer fees. After building the first model, it was clear that the attributes of height, international caps and number of games played were statistically irrelevant in predicting transfer fee. After removing them and further tuning the model, I arrived at a fairly accurate predictor.





















































