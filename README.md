# Analyzing Transfer Market Inefficiencies in the English Premier League #

	
  
  In this project, I aim to highlight prevalent inefficiencies in the player transfer market of the English Premier League (EPL), the most popular professional soccer league in the world. During the winter and summer transfer windows, clubs in the EPL spend an average of $1.5 billion purchasing players from other teams. However, consistent analysis shows that transfer spending has little correlation with competitive success, suggesting that many clubs spend their money inefficiently.
	
  I use three main data sets for analysis. The first tracks wage spending, transfer spending, final league position and performance statistics (compiled by Opta Sports) of clubs in the EPL over the past five seasons. The second is a list of all players purchased by clubs in the EPL over the same period along with their transfer fee, provided it was disclosed. Each player is measured on parameters of age, number of games played and the same set of performance statistics used in the team-level data. The last data set is a comprehensive ranking of all professional soccer players using data from the videogame FIFA 2018, published by EA Sports.
  
 
### Summary of Results ###

  Upon analyzing the data, I conclude that clubs in the EPL commit two fundamental errors in the transfer market. First, they consistently undervalue defensive players, while overvaluing offensive players. 


## The Data ##

#### Team Performance Statistics ####
I compiled the in-game statsitcs of each team in the EPL for every season from 13/14 to 17/18 using data from Opta Sports, henceforth referred to as the "team-stats" data set. These include offensive, possession-based, defensive and goalkeeping statiscs for each team on a per game basis. I then merged these with data for each club's transfer spending, final points total and final league position for each season. The image below gives a brief snapshot of the data. The raw data set can be viewed ![here](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Data/EPL_stats.csv) 

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Competitve%20Stats%20Data-Set.png" width="650">

 
#### Transfer Data ####
The second data set was compiled from Opta Sports data and data from https://www.transfermarkt.com/. It lists all the players pruchased by EPL clubs during the seasons from 13/14 to 17/18 and their transfer fee. Additional parameters include player attributes that I hypothesized would be highly likley to influence the tranfser fee. The list was based on reviewing current literature on the subject, which I have compiled here. From the literature, it seems that the player attributes that most greatly affect trasnfer fee are age, number of games played in the previous season, number of international caps, nationality and height. I combined these with offensvie, defensive and possession-based ratings to create the final data set. A snapshot is shown below, and the raw data set can be found ![here](https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Data/transfer-data.csv).

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer-Data.png" width="650">


#### Player Rankings ####

The last data set is the the full ranking of every professional footballer as used in the FIFA 2018 videogame. While the exact methodology that EA Sports uses to construct its rankings is obsucre, the FIFA 2018 rankings are the best we have in terms of current, comprehensive player valuations. The full data set can be found here.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Player-Rankings.png" width="650">


## Understanding the Transfer Market ##

In order to get a sense of the current mechanics of the EPL transfer market, one ought to begin by separating big and small spenders. Currently, transfer spending in the EPL is dominated by the league's wealthiest and most successful clubs--Arsenal, Chelsea, Liverpool, Manchester United, Manchester City and Tottenham Hotspur. This group is commonly referred to as the "Big 6." The figure below shows average transfer spending for Big 6 clubs over the past seven seasons compared to the average for the rest of the league.


<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Big%20Six%20vs.%20Rest%20of%20League%20Transfer%20Spending.png" width="450">


Clearly, Big 6 teams spend far more on average than their peers. This gulf has led many pundits and fans to believe that success in the league and transfer spending are highly correlated with one another. However, this is not the case. 

The graph below plots final league position against transfer spending for every team in the EPL by season.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Position%20vs.%20Transfer%20Spending%20Plot.png" width="450">


From a simple visual test, it is easy to see that higher transfer spending is not highly correlated with a better league position. In fact, after creating a corrplot for the data, I found that there is only a 0.07 correlation between transfer spending and final league position. This is not only less than many members of the footballing community would likely suggest, but also far less than it ought to be, given the sums of money spent and the importance placed on trasnfer windows. In other words, it seems as if football clubs are often receiving a poor return on their trasnsfer investments. 


## How Clubs Buy Players ##

In order to understand where inefficienices arise in the transfer market, one must first understand what criteria clubs use to value players. I analyze the transfer data set in order to answer this question.

First, I look at transfer price based on player position. The plot is shown below.


<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer%20Fee%20vs.%20Player%20Position.png" width="450">

As we can see, attackers and midfielders fetch the highest transfer fees amongst EPL clubs, while defenders and goalkeepers are bought for less on average. In fact, after creating a corrplot for the transfer-data, one sees that a player's offensive rating is more highly correlated to a higher transfer price than is his defensive rating.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/Transfer%20CorrPlot.png" width="450">

Thus, several surface-level indicators show that clubs value offensive players more highly than they do their defensive counterparts. However, in order to more accurately determine the difference in variability caused by offensive vs. defensive ratings, I found it better to build a more robust statistical learning algorithm.

#### The Model ####

The model used for analysis was a multiple linear regression of player transfer fees. After building the first model, it was clear that the attributes of height, international caps and number of games played were statistically irrelevant in predicting transfer fee. After removing them and further tuning the model, I arrived at a fairly accurate predictor.

#### Results ####

A summary of the model results is shown below.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/transfer-model-summary.png" width="650">

The final model had an R-squared value of 0.9645.

As we can see, a player's age, with a p-value of 0.000109, is the most likely to affect his transfer fee. This is not especially surprising, given the small window in which most footballers achieve their peak performance. However, what is more interesting is that a player's offensive ability is far more likely to affect his transfer fee than is his defensive ability. 
This confirms trends identified in the initial data analysis showing that a offensive ratings are highly correlated to transfer fee, or at least more so than defensive ratings.

Thus, given the combination of high-level analysis and results from the model, it is safe to say that **football managers in the EPL value offensive capability more than defensive skill**. This supports results from Sally & Anderson (2013).

## Why Defense Is Undervalued ##

Having now established that EPL clubs tend to value offensive more than defense, I will now show that they in fact *undervalue* defense. In other words, I will illustrate that a quality defense is *highly significant* in improving final league position. 

### Analyzing Team Performance Statistics ###

Here, I analyze the team performance statistics in order to determine which attributes of team performance improve league position at the end of the season.

The first natural thing to do is to look at the correlation between final league position and relevant offensive and defensive statistics. Simply speaking, the "end product" of a high quality offense is a goal scored, while the end product of a low quality defense is a goal conceded. Thus, I decided to look at the correlation between goals scored, goals conceded and final league position. The result is shown below.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/offense%20vs.%20defense%20correlation.png" width="450">

Based on the plot, it seems that, in absolute value terms, goals scored and goals conceded have roughly equal correlations to a team's final league position. Hence, one might assume that conceding fewer goals would be nearly as beneficial as scoring more of them. However, instead of relying on assumption, I once again return to a more robust method of statistical analysis--a multiple linear regression.

#### The Model ####

Unlike the previous regression model, there is an extremely large (37) set of predictors to consider. Thus, the model required far more tuning in order to remove noise and identify predictors that were likeley to vary final league position. The summaries of two most accurate models are shown below.

**Model 1**

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/position-model-summary.png" width="650">


**Model 2**

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/position-model2-summary.png" width="650">

The two models had an R-squared value of 0.9675 and 0.9567 respectively. In model 1, the parameters most likely to affect final league position are in fact goals conceded (Goals.Conceded) and defensive errors (Def.Errors), while in model 2, they are tackles lost (Tackles.Lost) and goals from corner kicks (Goals.Corn). While there is unfortunately not much overlap in terms of statistically relevant parameters between the two models, one thing that is common is the high variance of league position based on defensive statsitics, rather than offensive statistics. More specifically, defensive mistakes and errors seem to have a high probability of affecting league position than do other measures of defensive play.

### Conclusions From Model Results ###

Both of the models show us that a team's defensive performance, specifically the limiting of defensive errors, is extremely impactful in determining league performance. In a performance sense, defense seems to be just as valuable as offense, if not more so. Rationally, one would expect that quality defensive players would be in high demand in the transfer market, thus making their transfer fees at least on par with that of attackers and midfielders. However, as we know from looking at the transfer data in the previous section, this is not the case at all.

The conclusion seems to be that **defense is undervalued** by EPL teams. Managers and scouts consistently use offensive performance rather than defensive performance in order to determine transfer fees, thus spending their money inefficiently. 

This supports similar arguments from Sally & Anderson, as well as Soccernomics authors Kuper and Szymanski that defense is undervalued by many professional football clubs. Hence, we have one potential cause for the inefficiency observed in the EPL transfer market. 

## Why Clubs Overvalue Their Best Player ##

### Strong-Link vs. Weak-Link ###

In economic terminology, the performance of a **strong-link** system is most dependent on its best performing component, while the performance of a **weak-link** system is most dependent on its worst performing component. This categorization can be applied to several contexts including the U.S. transportation network, education system and of course, sports. Several analysts, such as economist David Sally, have argued that football is a weak-link game--that a team's performance is most dependent on the skill of its weakest player. However, there have also been those who argue that it is trong-link--that a strong enough star player can lead an otherwise mediocre team to success. I use the player-rankings data to examine the merits of each of these arguments.

### How EPL Clubs Value Talent ###

The best way to see how clubs in the EPL value their players is to look at their wages. Using publicly available wage data for every club in the EPL and correlating it with data found from the FIFA player rankings, I looked at the percentage of the total wage bill that each club pays to its best, median and worst ranked player. The results are shown below.

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/epl-wage-dist.png" width="500">

From this data set, we can see that Manchester City spends about 9.6% of its total wage bill on its best player and about 3.7% on its worst player. In fact, a majority of EPL clubs spend over 8% of their wage bill on their best player. This is quite a skewed distribution, considering there is an average of 26 players in each squad.

Clearly, it seems that EPL clubs value their best player highly, which makes sense on face value. However, a closer look at relevant data suggests otherwise. 

### Analyzing the Player-Rankings Data ###

Using the FIFA player rankings from 2018 and 2017, I examined how final league position of clubs Europe's top five leagues was affected based on the rankings of the club's best, median and worst ranked player.

#### Building the Model ####

Once again, I use a multiple linear regression to examine the effects of the three parameters. As there were not a large amount of predictors to consider, the model did not need to be tuned very much. A summary of the results are shown below. 

<img src="https://github.com/Ajay-Chopra/EPL-Trasnfer-Market/blob/master/Images/player.rankings.summary.png" width="500">

From the summary, we can see that it is in fact a team's median player that most greatly affects its final league position. 






































































