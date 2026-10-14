#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == "year" ]]
  then
    continue
  fi

  $PSQL "INSERT INTO teams (name) VALUES ('$WINNER'), ('$OPPONENT') ON CONFLICT (name) DO NOTHING;
  INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  SELECT $YEAR, '$ROUND', winner.team_id, opponent.team_id, $WINNER_GOALS, $OPPONENT_GOALS
  FROM teams AS winner
  JOIN teams AS opponent ON opponent.name = '$OPPONENT'
  WHERE winner.name = '$WINNER';"
done < games.csv
