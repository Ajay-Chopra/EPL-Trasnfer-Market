# Analyzing Transfer Market Inefficiencies in the English Premier League #

	
  
  In this project, I aim to highlight prevalent inefficiencies in the player transfer market of the English Premier League (EPL), the most popular professional soccer league in the world. During the winter and summer transfer windows, clubs in the EPL spend an average of $1.5 billion purchasing players from other teams. However, consistent analysis shows that transfer spending has little correlation with competitive success, suggesting that many clubs spend their money inefficiently.
	
  I use three main data sets for analysis. The first tracks wage spending, transfer spending, final league position and performance statistics (compiled by Opta Sports) of clubs in the EPL over the past five seasons. The second is a list of all players purchased by clubs in the EPL over the same period along with their transfer fee, provided it was disclosed. Each player is measured on parameters of age, number of games played and the same set of performance statistics used in the team-level data. The last data set is a comprehensive ranking of all professional soccer players using data from the videogame FIFA 2018, published by EA Sports.
  
 
### Summary of Results ###

  Upon analyzing the data, I conclude that clubs in the EPL engage in three major transfer market inefficiencies. First, they consistently undervalue defensive players, while overvaluing offensive players. Second, they misjudge the offensive value of strikers, using misleading statistics such as number of goals scored instead of more accurate measurements. Lastly, clubs focus too highly on spending a large amount of money on one player, even though such a purchase does not lead to a higher league position. 



## The Data ##

I compiled the in-game statsitcs of each team in the EPL for every season from 13/14 to 17/18 using data from Opta Sports, henceforth referred to as the "team-stats" data set. These include offensive, possession-based, defensive and goalkeeping statiscs for each team on a per game basis. I then merged these with data for each club's transfer spending, final points total and final league position for each season. The image below gives a brief snapshot of the data.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Competitve%20Stats%20Data-Set.png)

I also compiled a data set that tracks goal statistics at different game states, henceforth referred to as the "game-state" data set. Similar to the team-stats data set, it combines league results with performance statistics, specifically the number of goals scored/conceded in a given 15-minute interval of every game as well as goals scored/conceded based on score difference.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Game-State-Data.png)

For instance, in the snapshot above, we see that out of all the goals that Arsenal scored in the 17/18 season, 12 came in minutes 1-15 of the game. Similarly, Arsenal allowed 9 goals in the first fifteen minutes of games for that season. The full data set can be found here. 

The second data set was compiled from Opta Sports data and data from https://www.transfermarkt.com/. It lists all the players pruchased by EPL clubs during the seasons from 13/14 to 17/18, their position, transfer fee, as well as offensive, possession, and defensive ratings compiled by Opta Sports. The full data set can be found here.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer-Data.png)

The last data set is the the full ranking of every professional soccer player as used in the FIFA 2018 videogame. While the exact methodology that EA Sports uses to construct its rankings is obsucre to say the least, the FIFA 2018 rankings are the best we have in terms of comprehensive player valuations. The full data set can be found here.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Player-Rankings.png)


## Preliminary Data Analysis ##

In order to get a sense of the current mechanics of the EPL transfer market, one ought to begin by separating big and small spenders. Currently, transfer spending in the EPL is dominated by the league's wealthiest and most successful clubs--Arsenal, Chelsea, Liverpool, Manchester United, Manchester City and Tottenham Hotspur. This group is commonly referred to as the "Big 6." The figure below shows average transfer spending for Big 6 clubs over the past seven seasons compared to the average for the rest of the league.


![alt text](
https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Big%20Six%20vs.%20Rest%20of%20League%20Transfer%20Spending.png
)

Clearly, Big 6 teams spend far more during every transfer window than their peers. This gulf has led many pundits and fans to believe that success in the league and transfer spending are highly correlated with one another. However, this is not the case. 

The graph below plots final league position against transfer spending for every team in the EPL by season.

![alt text](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Position%20vs.%20Transfer%20Spending%20Plot.png)


From a simple visual test, it is easy to see that higher transfer spending is not highly correlated with a better league position. In fact, after creating a corrplot for the data, I found that there is only a 0.07 correlation between transfer spending and final league position. This is not only less than many members of the footballing community would likely suggest, but also far less than it ought to be, given the sums of money spent and the importance placed on trasnfer windows. In other words, it seems as if football clubs are often receiving a poor return on their trasnsfer investments. 
















































