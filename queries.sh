#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

#
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

#
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games;")"

#
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games;")"

#
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games;")"

#
echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games;")"

#
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games;")"

#
echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2;")"

#
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams AS t FULL JOIN games AS g ON g.winner_id=t.team_id WHERE g.round='Final' AND g.year='2018';")"

#
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT name FROM teams, games WHERE games.round='Eighth-Final' AND games.year='2014' AND (team_id = games.winner_id OR team_id = games.opponent_id) ORDER BY name ASC;")"

#
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams AS t INNER JOIN games AS g ON t.team_id=g.winner_id WHERE g.winner_id = t.team_id ORDER BY name ASC;")"

#
echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT g.year, t.name FROM games AS g INNER JOIN teams AS t ON g.winner_id=t.team_id WHERE year IN (2014, 2018) AND round='Final' ORDER BY year ASC;")"

#
echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%';")"
