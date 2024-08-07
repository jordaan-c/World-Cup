#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Create an array that contains the target values for regex comparison.
# Placement of this line affects the while loop; ensure it's above.
HEADERS=("year" "round" "winner" "opponent" "winner_goals" "opponent_goals")

# --  Populate the teams table. --

# Import the CSV file, set field separator, and assign variables.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  # Checks for matching values in the first row of the CSV file.
  if [[ $HEADERS[@] =~ ($YEAR|$ROUND|$WINNER|$OPPONENT|$WINNER_GOALS|$OPPONENT_GOALS) ]]    

  then  
    # Skips if a matching value is found.
    continue
  
  else

    # Checks the winner against teams already in the database.
    # Adds the team if they do not exist, and prints a message confirming this.
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    if [[ -z $TEAM_ID_W ]] 
    then
      INSERT_TEAM_RESULT_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
     
      if [[ $INSERT_TEAM_RESULT_W = 'INSERT 0 1' ]]
      then echo Winner Added: $WINNER
      fi

    fi

    # Checks the opponent against teams already in the database.
    # Adds the team if they do not exist, and prints a message confirming this.
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    if [[ -z $TEAM_ID_O ]] 
    then
      INSERT_TEAM_RESULT_O=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
            
      if [[ $INSERT_TEAM_RESULT_O = 'INSERT 0 1' ]]
      then echo Opponent Added: $OPPONENT
      fi

    fi

  fi

done


  # --  Populate the games table. --

# Import the CSV file, set field separator, and assign variables.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  # Checks for matching values in the first row of the CSV file.
  if [[ $HEADERS[@] =~ ($YEAR|$ROUND|$WINNER|$OPPONENT|$WINNER_GOALS|$OPPONENT_GOALS) ]]  

  then  
    # Skips if a matching value is found.
    continue
  
  else

    # Retrieves the IDs for the winner and opponent from teams already in the database.
    # Then inserts the game data into the 'games' table.
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
      VALUES('$YEAR', '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS);")

    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]  
    then
      echo -e Added Match: $WINNER vs $OPPONENT \| Score: $WINNER_GOALS:$OPPONENT_GOALS
    fi

  fi

done