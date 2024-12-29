create database imdb_movies;
use imdb_movies;

CREATE TABLE Moviess (
    Poster_Link VARCHAR(255),
    Series_Title VARCHAR(100),
    Released_Year varchar(20),
    Certificate VARCHAR(10),
    Runtime VARCHAR(20),
    Genre VARCHAR(100),
    IMDB_Rating varchar(50),
    Overview varchar(255),
    Meta_score varchar(50),
    Director VARCHAR(100),
    Star1 VARCHAR(100),
    Star2 VARCHAR(100),
    Star3 VARCHAR(100),
    Star4 VARCHAR(100),
    No_of_Votes varchar(50),
    Gross varchar(150)
);

describe moviess;

show global variables like 'local_infile';

SET GLOBAL local_infile = 1;
show tables;


ALTER TABLE Movie MODIFY COLUMN Gross VARCHAR(255);
ALTER TABLE Movie MODIFY COLUMN Meta_score VARCHAR(50);
UPDATE Movie SET Gross = REPLACE(Gross, ',', '');

SELECT CAST(REPLACE(Gross, ',', '') AS DECIMAL(15, 2)) AS GrossValue
FROM Movie;

select * from moviess limit 5;

ALTER TABLE Moviess MODIFY COLUMN Overview VARCHAR(2000);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\movie_imdb.csv"
INTO TABLE imdb_movies.Moviess
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

  select * from Moviess;
  --  Retrieve all movie titles and their release years.
  select Series_Title,Released_Year from moviess
  order by released_year asc;
 
--   List all movies with an IMDb rating above 9.

select Series_Title,IMDB_Rating from moviess where IMDB_Rating >9;

-- Display movies released after the year 2000, sorted by the year in ascending order
select  Series_Title, Released_Year from moviess where Released_Year >200
order by Released_Year asc;

-- Find all movies with a runtime longer than 150 minutes
select Series_Title, Runtime from moviess where Runtime>150;

-- Calculate the average IMDb rating of all movies.
select Series_Title, avg(IMDB_Rating) as avg_rating from moviess
group by Series_Title;

select avg(IMDB_Rating) as avg_rating from moviess;

select * from Moviess;
 
-- Certification information about the movie
--  A:- This movie is only for adult

-- Count the number of movies released with an 'A' certificate

select Certificate,count(Series_Title) as total_released_movie from moviess
group by Certificate;


select count(Series_Title) as total_released_movie from moviess where Certificate = 'A';
SELECT  count(*)  as Certificate_movie from moviess where Certificate = 'A';

-- Find the total number of votes received across all movies
select count(No_of_Votes) as total_votes from moviess;
select count(*) as total_recoads from moviess;

-- List movies directed by "Christopher Nolan" that have an IMDb rating over 8.5.
select Series_Title,  Director, IMDB_Rating
from moviess
where   Director = "Christopher Nolan" and IMDb_rating <8.5;

 
       
-- Find movies in the "Drama" genre with a Metascore over 85.
select Series_Title, Genre  from moviess where Meta_score >85;

-- Display all movies starring "Al Pacino" in the top three starring positions.

select Series_Title, St from moviess where Star3 = 'Al Pacino' limit 3;
 select  Series_Title, Star1 from moviess where Star1 = 'Al Pacino' limit 3;
select Star1, Star2, Star3, Star4 from moviess where Star1= "Al Pacino";


-- Top Movies by IMDB Rating and Gross
 SELECT
    Series_Title, IMDB_Rating, Gross
FROM
    moviess
ORDER BY IMDB_Rating DESC , Gross DESC
LIMIT 5;

-- Most Common Certificate
select max(Certificate) as most_Certificate from moviess;

 -- Most Common Certificate
select Certificate, max(Certificate) as most_Certificate from moviess
group by Certificate order by Certificate desc limit 5;

-- Top 5 Directors by Number of Movies
select  Director, count(Series_Title) as  movie_count from moviess
 group by Director order by  movie_count desc limit 5;


-- Movies by Genre and Certificate:
select Series_Title, Genre, Certificate from moviess;
select  Genre,  Certificate, count(Series_Title) as movies_count from moviess
group by  Genre,  Certificate order by movies_count desc limit 5;
   select * from Moviess;

--  Create a column named Revenue_Class that categorizes movies as "Low Gross"
--  if the Gross is less than 50,000,000, "Medium Gross"
-- if between 50,000,000 and 100,000,000, and "High Gross" if above 100,000,000.
select Series_Title, Gross,
case
when Gross< 50000000 then 'low Gross'
when Gross between  50000000 and 100000000 then 'medium Gross'
else 'high Gross'
end as  Revenue_Class from moviess;
select * from moviess;
 
--    Extract the year from the Released_Year column and list the distinct year
select distinct substring(Released_Year,1,4) as year from moviess;

 -- Find all movies where the overview contains the word "bond
 select Series_Title from moviess where Overview like '%bond%';
 
 -- List all movies released between 1990 and 2000, along with their IMDB_Rating and Gross
 select Series_Title, Released_Year, IMDB_Rating, Gross from moviess
 where Released_Year between 1990 and 2000;
 
 -- Display the Series_Title, Director, and Meta_score for movies where the Meta_score is greater than the average Meta_score
select Series_Title,  Director, Meta_score from moviess
where Meta_score > (select avg(Meta_score) as meta_scor_avg from moviess);
select * from moviess;
 -- Extract the first word from the Series_Title of all movies.
 select   substring_index(Series_Title, ' ',1) as first_word from moviess;

 -- List the top 3 movies with the highest IMDB rating
 select Series_Title, IMDB_Rating from moviess  order by IMDB_Rating desc limit 3;
 
 -- How many movies have "Crime" as one of their genres?
 select count(*) as crime_movies from moviess
 where Genre like '%Crime%';

-- Find the total number of votes for movies released before 2000
 select sum(No_of_Votes) as total_votes from moviess where released_year <2000;
 
 -- Get the average Meta_score of movies in the dataset.
 select avg(Meta_score)  as avg_movies from moviess;
 
 -- Which genre combination has the highest average IMDB rating
 select genre, avg(IMDB_rating) as avg_reting from moviess
 group by genre  
 order by  avg_reting desc
 limit 1;
 
--  Find the movie(s) with the highest gross revenue per vote
select  Series_Title, (Gross / No_of_Votes) as revenue_per_vote from moviess
 order by revenue_per_vote desc limit 1;
 
 select Series_Title, round(Gross / No_of_Votes,2) as per_revenue_vote from moviess
 order by per_revenue_vote desc limit 1;
 
 -- retrieve movies released after 2000 with a runtime longer than 150 minutes
 
 -- Sort the movies by Gross revenue in descending order:
 select Series_Title, Gross  from moviess order by Gross  desc limit 5;
 
  -- Rank movies based on their IMDB_Rating
  select Series_Title, IMDB_Rating, rank() over (order by IMDB_Rating desc) as rank_movies
  from moviess;

-- Retrieve the top 3 highest-rated movies.
select Series_Title, IMDB_Rating from moviess order by Series_Title desc limit 3;

--  Count the number of movies in each genre
select Genre, count(*) as movies_count from moviess
group by Genre order by movies_count desc;

 -- Retrieve movies where Meta_score is above 85.
 select Series_Title, Meta_score from moviess
 where Meta_score < 85;

-- Find movies where Morgan Freeman was one of the stars
select Series_Title , IMDB_Rating from moviess
where Star1 =  'Morgan Freeman'
or Star2 =  'Morgan Freeman'
or Star3 =  'Morgan Freeman'
 or Star4= 'Morgan Freeman';

 select * from moviess;

-- Find the top 3 directors with the highest total gross earnings from their movies.
select Director , sum(Gross) as total_gross from moviess  
group by Director order by total_gross desc limit 3;
 
 -- Extract the first name of the star actors (Star1) and count how many movies each first name appears in.
  select substring_index(Star1, ' ', 1) as first_name, count(*) as count_movies
  from moviess group by  first_name order by count_movies desc;
 
  -- Calculate the average meta score for movies grouped by decade (1950s, 1960s, etc.).
 
 -- Which movie has the longest runtime among the top 5 highest-rated movies
WITH Top_Rated AS (
    SELECT Series_Title, Runtime
    FROM movies
    ORDER BY IMDB_Rating DESC
    LIMIT 5
)
SELECT Series_Title, Runtime
FROM  moviess
ORDER BY CAST(SUBSTRING(Runtime, 1, LOCATE(' ', Runtime) - 1) AS UNSIGNED) DESC
LIMIT 1;
 
WITH Top_Rated AS (
    SELECT Series_Title, Runtime
    FROM movies
    ORDER BY IMDB_Rating DESC
    LIMIT 5
)
SELECT Series_Title, Runtime
FROM Top_Rated
ORDER BY CAST(SUBSTRING(Runtime, 1, LOCATE(' ', Runtime) - 1) AS UNSIGNED) DESC
LIMIT 1;
 
-- Which genre of movies has the highest average IMDB rating?
SELECT Genre, AVG(IMDB_Rating) AS Avg_Rating
FROM movies
GROUP BY Genre
ORDER BY Avg_Rating DESC
LIMIT 1;

select * from moviess;

-- Which movie has the longest runtime among the top 5 highest-rated movies?
with top_rate as (select Series_Title,  Runtime
from moviess
order by  IMDB_Rating desc limit 5)
select Series_Title,  Runtime
from moviess order by cast(substring( Runtime, 1, locate(' ',  Runtime) - 1) as unsigned) desc
limit 1;

-- Rank all movies by IMDB rating within each genre.
select  Series_Title, Genre, IMDB_Rating,
rank() over (partition by Genre order by IMDB_Rating desc) as genre_rank
from moviess;

select * from moviess;

-- get the list of the actors who have appeared in more then 10 movies?
 select actor, count(*) as movie_count
 from (
 select Star1  as actor from moviess
 union all
 select  Star2 as actor from moviess
 union all
 select Star3 as actor from moviess
 union all
 select Star4 as actor from moviess
 ) as al_actors
 group by actor
 having  count(*) >10;

select * from moviess;

--  Calculate the average IMDB rating and the total number of votes for movies directed by "Francis Ford Coppola."
 select Director, avg(IMDB_Rating) as avg_reting, sum(No_of_Votes) as total_votes from moviess
 where Director = "Francis Ford Coppola"
 group by Director;
 
 -- Find the movies with a gross higher than the average gross of all movies
 select Series_Title, avg(Gross) as avg_gross from moviess
 group by Series_Title order by avg_gross desc;
 
 select Series_Title, Gross  from moviess
 order by Gross desc limit 1;
 
 select Series_Title,  Gross from moviess
 where  Gross > (select avg(Gross) from moviess);
 
 select floor(IMDB_Rating) as floor_reting from moviess;
 
 select * from moviess;
 
 select Series_Title, IMDB_Rating,
 rank() over (order by  IMDB_Rating desc)  as rank_gross  from moviess;
 
 select Series_Title,Gross,
 row_number() over (order by Gross desc)  as rank_gross  from moviess;
 
 
  select Series_Title,IMDB_Rating,Gross,
  DENSE_RANK() over (order by Gross desc)  as rank_gross  from moviess;
 
select * from moviess;

-- Retrieve all movie titles from the Movies table where the revenue is greater than the average revenue of all movies.
select Series_Title, avg(Gross) as highest_revenue from moviess
 group by Series_Title order by   highest_revenue desc;

select Series_Title,Gross from moviess
 where Gross >(select avg(Gross) from moviess);
 
 -- Write a query to list the oldest movie (by release year) for each genre using a subquery.
select Series_Title, Released_Year, Genre from moviess
 where Released_Year =(select max(Released_Year) from moviess);
 
--  it is showing the oldest movie by years with genre

 select Director, No_of_Votes, Gross from moviess where Gross;
 
 select * from moviess;
 select concat('Star1', ' ', 'Star2') as result from moviess;
 
 select length(Star2) as length from moviess;
 
select length( IMDB_Rating) as length from moviess;

select substring('Drama', 1,4) as result from moviess;
select substring('IMDB_Rating', 1, 7) as result from moviess;


select * from moviess;
select upper(Genre) as upper_genre from moviess;
select lower(Genre) as lower_ganre from moviess;

select * from moviess where Certificate =(select Certificate from moviess
where Series_Title ='The Godfather');

-- Extract the first 10 characters from the Overview of the movie The Shawshank Redemption.
select substring(Overview,1,10) as caractor_oveview from moviess
 where Series_Title = 'The Shawshank Redemption';
 
-- Replace all occurrences of "Drama" in the Genre column with "Psychological Drama".
select replace(Genre, "Drama","Psychological Drama") as replace_genre from moviess;

-- Combine Series_Title and Director into a single column named Title_Directed_By.
select concat(Series_Title, ' , ', Director) as  Title_Directed_By from moviess;

select * from moviess;

--  Find the length of the Overview for each movie.
select Series_Title, length(Overview) as length_overview from moviess;

--  Convert the Series_Title of all movies to uppercase and lowercase.
select upper(Series_Title) as upper_tital, lower(Series_Title) as lower_tital from moviess;

-- Calculate the number of years since the movie The Godfather was released
select Series_Title, datediff(now(), concat(Released_Year, '-01-01')) / 365 as years_since_release
from moviess where Series_Title = 'The Godfather';

select * from moviess;

select Series_Title, round(IMDB_Rating,0) as round_value from moviess;

select Series_Title, ceil(IMDB_Rating) as cel_score from moviess;

select Series_Title, floor(IMDB_Rating) as floor_rating from moviess limit 10;

select Series_Title, abs(Gross) as absulute_gross from moviess;

-- What will be the value of the gross_values column if the Gross is 28341469
-- If the Gross is not 100000 or 28341469, what value will the gross_values column contain?
select Certificate,Director, Gross,
case Gross
when  100000 then 'low'
when 28341469 then 'medium'
else 'hiegh'
end as gross_values
from moviess;
 
SELECT NOW();
SELECT CURRENT_TIMESTAMP();
SELECT current_date();
SELECT current_time();

SELECT CURDATE();
 
-- the movie(s) released in 1994 that has the highest Meta_score for that year?
 select *  from moviess where  Released_Year = 1994
 and Meta_score =(select max(Meta_score) from moviess where Released_Year = 1994);
 
 select * from moviess where Meta_score = (select max(Meta_score) from moviess
 where No_of_Votes > (select avg(No_of_Votes) from moviess));
 
select * from moviess where (Genre, Meta_score) in (
select Genre, max(Meta_score) from moviess where No_of_Votes group by Genre);

--   Find Movies with Higher Gross than the Average Gross
select Series_Title, Gross from moviess where Gross >(select avg(Gross) from moviess);

--  Find the movie with the highest gros
select  Gross from moviess where Gross =(select max(Gross) from moviess);

-- Find movies released in the same years as those with a gross over $50M
select Series_Title,  Released_Year, Gross  from moviess
 where Released_Year in (select  Released_Year from moviess
                       where Gross > 50000000);

-- Match movies with the same director and genre as "The Godfather"
select Series_Title from moviess where (Director, Genre) =(select Director, Genre from moviess
where  Series_Title = "The Godfather");

-- Top-Rated Movies by Director
with cte_rating as(
select Director, max(IMDB_Rating) as highest_reting from moviess group by Director
)
select Director, highest_reting
from cte_rating
order by  highest_reting
limit 4;

create index ind_ganre on moviess(ganre);

-- Rank Movies Based on Gross Earnings
select Gross, Genre,
   rank() over (partition by  Gross order by Genre desc) as rank_gross from moviess;
   select * from moviess;   
   
--    Longest Movies with 'Drama' Genre cte
with cte_longest_movie as(
select Genre, max(Series_Title) as longest_movie from moviess where Genre =  'Drama'
)
select Genre, longest_movie
from cte_longest_movie
where Genre =  'Drama'
group by Genre
order by  longest_movie
limit 6;

-- IMDB Rating vs Meta Score Analysis cte
with cte_score as(
select  Series_Title, IMDB_Rating, Meta_score from moviess
)
select Series_Title, IMDB_Rating, Meta_score
from cte_score order by IMDB_Rating desc,  Meta_score desc;

select Series_Title, IMDB_Rating,
case
when IMDB_Rating between  7.2 and 7 then "low"
when IMDB_Rating between 8 and 8.9 then "medium"
else "high"
end as satisfication_level
from moviess;

select * from moviess;

-- Most Popular Star Combination
with  cte_star as(
select max(Star1) as most_star from moviess
)
select most_star
from cte_star
order by most_star desc limit 1;

-- Movies with Above-Average Votes cte
with cte_avgvote as(
select Series_Title, avg(No_of_Votes) as avg_votes from moviess  group by Series_Title
)
select Series_Title, avg_votes
from cte_avgvote
group by Series_Title
order by avg_votes
limit 5;
 
-- Top Grossing Movie by Released Yea cte
with cte_gross as(
select Series_Title, Released_Year, Gross, count(Gross) as top_groos from moviess group by Series_Title, Released_Year, Gross
)
select Series_Title, Released_Year, Gross,  top_groos
from cte_gross
group by Series_Title, Released_Year, Gross
order by  top_groos
limit 3;
