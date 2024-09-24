create database IPL;
use ipl;
-- Print only 20 rows 

-- Step 1: Check the value of 'secure_file_priv'
SHOW VARIABLES LIKE 'secure_file_priv';

-- Step 2: Enable local infile if it's disabled
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- Step 5: Create the table for Match-level data
CREATE TABLE matches (
    id INT,
    season VARCHAR(255),
    city VARCHAR(255),
    date DATE,
    team1 VARCHAR(255),
    team2 VARCHAR(255),
    toss_winner VARCHAR(255),
    toss_decision VARCHAR(255),
    result VARCHAR(255),
    dl_applied TINYINT,
    winner VARCHAR(255),
    win_by_runs INT,
    win_by_wickets INT,
    player_of_match VARCHAR(255),
    venue VARCHAR(255),
    umpire1 VARCHAR(255),
    umpire2 VARCHAR(255)
);

-- Step 6: Load the CSV file into the 'matches' table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\IPL_Matches_2008-2020.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * from matches
limit 20;
-- Output is given only first 20 records from table.


-- Print data for this date (02-05-2013).

select * from matches
where date = '02-05-2013';
-- Output prints all column from table and only rows where date is "02-05-2013".


-- Print all the tie matches are there start from latest match played.

select * from matches
where result = 'tie'
order by season desc;
-- Output prints all column from table where the match result is tie and arranged according to latest season is on top. 


-- Calculate how many cities have hosted matches.
 
select count(distinct city) 
from matches;
-- Output gives a count of total cities.


-- Print 50 records, sorted by city, winner, and venue in descending order, and include all columns.

select * from matches
order by city desc, winner desc, venue desc
limit 50;
-- Output prints all column from table in order to city , winner & venu is in descending order with only 50 records in it. 


-- Print stadiums only had 'Association' in their name and city.

select distinct venue as  Stadium, city from matches
where venue like '%Association%'
order by venue desc, city desc;
-- Output prints only 2 columns. Stadium & city in which Stadium consist only those names that have "Association" in the name, and both columns are in descending order. 


-- Team that wons the most tosses.

select toss_winner, count(*) as toss_wins
from matches
group by toss_winner
order by toss_wins desc
limit 5;
-- Output prints only 2 columns. toss_winner & toss_wins in which toss_wins is in descending order so the highest toss winner is on top and only top 5 records are there.


-- Who won the most "Man of the Match" awards top 5 players.

select player_of_match, count(*) as awards
from matches
group by player_of_match
order by awards desc
limit 5;
-- Output prints only 2 columns. player_of_match & awards so player_of_match with there number of awards are printed with only top 5 records.  


-- The matches that were decided by a DL method.

select id, team1, team2, winner, dl_applied, player_of_match
from matches
where dl_applied != 0;
-- Output prints id, team1, team2, winner, dl_applied, and player_of_match where the only rows are printed who has dl_applied is not equal to zero.


-- Teams that played the most matches only top 10.

select team, count(*) as matches_played
from (select team1 as team from matches
    union all
select team2 as team from matches) as all_teams
group by team
order by matches_played desc
limit 10; 
-- Output prints only 2 columns. team & matches_played where only top 10 teams are displayed in descending order.


-- Find the number of matches that tie.

select id, season, team1, team2, count(*) as tied_matches
from matches
where result = 'tie'
group by season, team1, team2;
-- Output prints id, season, team1, team2, and tied_matches, and output only shows those teams in which matches are tied.


-- Umpires Who Officiated the Most Matches

select umpire1 as umpire, count(id) as matches
from matches
group by umpire1
union
select umpire2 as umpire, count(id) as matches
from matches
group by umpire2
order by matches desc;
-- Output prints only 2 columns.umpire & matches in which it shows that an umpire officiated how many matches.


-- Determine each match's average margin of victory in runs.

select 
avg(win_by_runs) as avg_win_by_runs 
from matches;
-- Output shows average that matches is win by run only. 


-- The total number of matches won by wickets and by runs.

select SUM(case when win_by_runs > 0 then 1 else 0 end) as win_by_runs,
       SUM(case when win_by_wickets > 0 then 1 else 0 end) as win_by_wickets
from matches;
-- Output shows the count of how may matches are win by wickets & win by runs. 


-- The player who has won the most Player of the Match awards.

select player_of_match, count(*) as awards_count 
from matches 
group by player_of_match 
order by awards_count desc 
limit 1;
-- Output shows that which player received player of the match and it's awards count. 


-- Matches where Royal Challengers Bangalore played either as team1 or team2.

select *
from matches 
where team1 = 'Royal Challengers Bangalore' or team2 = 'Royal Challengers Bangalore';
-- Output shows that all the records where 'Royal Challengers Bangalore' team is either in team 1 or in team 2,


-- Query: Identify all matches where the toss winner did not win the match.

select * 
from matches 
where toss_winner != winner;
-- Output shows that only data where who won the toss but not win the match. 
 

-- ----------------------------------------------------------- BALLS ---------------------------------------------------------------

create database IPL;

use IPL;

show tables;

-- Secure File Privileges
-- Retrieve information about the secure_file_priv variable
SHOW VARIABLES LIKE 'secure_file_priv';
-- The secure_file_priv variable is used to control where files can be loaded or saved from within MySQL.
-- It is often employed for security purposes to restrict access to certain file locations on your computer or server.

-- Local Infile Configuration
-- Check the current value of the local_infile system variable
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Enable the use of LOAD DATA INFILE statement for loading data from local files
SET GLOBAL local_infile = 1;

-- The local_infile system variable determines whether the MySQL server allows or disallows the use of the LOAD DATA INFILE statement to load data from local files.
CREATE TABLE balls(
    id INT,
    inning INT,
    ball_over INT,
    ball INT,
    batsman VARCHAR(255),
    non_striker VARCHAR(255),
    bowler VARCHAR(255),
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    non_boundary INT,
    is_wicket INT,
    dismissal_kind VARCHAR(255),
    player_dismissed VARCHAR(255),
    fielder VARCHAR(255),
    extras_type VARCHAR(255),
    batting_team VARCHAR(255),
    bowling_team VARCHAR(255)
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\IPL_Ball-by-Ball_2008-2020.csv'
INTO TABLE balls
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select count(*) as total_data from balls;

-- Discover the Top 5 Batsmen by Total Runs Scored in Matches.

select batsman, sum(batsman_runs) as total_runs
from balls
group by batsman
order by total_runs desc
limit 5;
-- Output prints only 2 columns.batsman & total_runs it displays only top 5 records of highest scores batsman. 


-- Find top 5 Bowlers Who Has Taken the Most Wickets

select bowler, count(*) as wickets
from balls
where is_wicket = 1
group by bowler
order by wickets desc
limit 5;
-- Output prints only 2 columns.bowler & wickets it displays only top 5 records of highest wicket taken by bowlers.


-- Find Matches with the Highest Total Runs Scored in a Single Inning

select id, inning, sum(total_runs) as inning_total
from balls
group by id, inning
order by inning_total desc
limit 5;
-- Output prints id, inning, & inning_total where only top 5 inning_total means total run has been printed in descending order. 


-- Find the Most Common Type of Dismissal

select dismissal_kind, count(*) as dismissal_count
from balls
where dismissal_kind is not null
group by dismissal_kind
order by dismissal_count desc;
-- Output prints only 2 columns. dismissal_kind & dismissal_count in which it shows that how many players got out by caught,bowled,run out,etc with 
-- dismissal_count is in descending Order. 


-- Calculate the Strike Rate of a Specific Batsman ('V Kohli') Across All Matches

select batsman,(sum(batsman_runs) / count(*)) * 100 as strike_rate
from balls
where batsman = 'V Kohli';
-- Output shows the strikr_rate of the batsman 'V kohli'. 


-- List of Batsmen Who Scored 100 or More Runs in a Single Match

select id, batsman, sum(batsman_runs) as runs
from balls
group by id, batsman
having runs >= 100;
-- Output shows the batsman who scores 100 and more than 100 in matches. 

-- Find the Team with the Most Extras Given runs

select bowling_team, sum(extra_runs) as total_extras
from balls
group by bowling_team
order by total_extras desc;
-- Output shows that how many extra run given by the bowling teams 


-- Identify the Bowler Who Has Bowled the Most Dot Balls

select bowler, count(*) as dot_balls
from balls
where batsman_runs = 0 and extra_runs = 0
group by bowler
order by dot_balls DESC
limit 5;
-- Output shows that which bowler is given number of dot balls. 


-- Determine the Average Runs Per Over Allowed to Each Bowler.

select bowler,
(sum(total_runs) / count(distinct concat(id , 'over'))) as average_runs_per_over
from balls
group by bowler
order by average_runs_per_over asc;
-- Output shows that which bowler is given average run per over. 


-- The number of sixes hit by each batsman.

select batsman, count(*) as sixes 
from balls 
where batsman_runs = 6 
group by batsman 
order by sixes desc;
-- Output shows that number of sixes hit by each batsman. 


-- Total number of boundaries (4s and 6s) hit in each match.

select id, 
sum(case when batsman_runs = 4 or batsman_runs = 6 then 1 else 0 end) as total_boundaries 
from balls 
group by id;
-- Output shows that how many boundaries are hit in every matches. 


-- The match where the highest total number of runs were scored.

select id, 
sum(total_runs) as match_total_runs 
from balls
group by id 
order by match_total_runs desc 
limit 1;
-- Output shows that in this match the heighest number of run is been scored.


-- Players Who Got Out to the Same Bowler Twice in a Match

select b.player_dismissed, b.bowler, count(*) as dismissals
from Balls b
join matches m on b.id = m.id
where b.is_wicket = 1
group by b.player_dismissed, b.bowler
having dismissals >= 2;
-- Output shows no data because it not possible to join table 'Matches ' & 'balls'.


-- 7. 
select matches.id, matches.player_of_match, balls.batsman, balls.bowler
from matches
left join balls
on matches.id = balls.id
limit 50;
-- Output shows null values because id isn't match. 








