
-- How many olympic games have been held? 
select count(distinct Games) as number_of_games
from athlete_events
;

-- List down all the Olympic games held so far
select distinct(Games) 
from athlete_events
order by Games;

-- List down the total number of countries who participated in each olympic game
with all_countries as
        (select games, nr.region
        from athlete_events ae
        join noc_regions nr ON nr.NOC = ae.NOC
        group by games, nr.region)
    select games, count(1) as total_countries
    from all_countries
    group by games
    order by games;
    
    -- which year saw the highest & lowest number of countries participating in Olympics
    
    -- which nation has participated in all of the olympic games
    with total_countries as
    (select Games, nr.region
    from athlete_events ae
    join noc_regions nr
    on ae.NOC = nr.NOC
    group by nr.region,Games
    order by Games)
    select region as country,count(region) as total_matches
    from total_countries
    group by region
    order by count(region) desc;
    
  -- Identify the sport which was played in all summer olympics
  with summer_games as
  (select count(distinct games) as total_summer_games
  from athlete_events
  where Season = 'Summer'),
  all_sports as
  (select distinct(Sport) , Games
  from athlete_events
  where Season = 'Summer'
  order by Games),
  no_of_games as
  (select Sport, count(Games) as times_played
  from all_sports
  group by Sport)
  select *
  from no_of_games ng
  join summer_games sg
  on sg.total_summer_games= ng.times_played;
  
  -- which sport was played only once in the Olympics
  -- 51 total olympics has been played
  
  with temp_table1 as
  (select distinct(Games),Sport
  from athlete_events
  order by Games,Sport),
  temp_table2 as
  (select Games, Sport, count(Sport) as times_played
  from temp_table1
  group by Sport)
  select tt2.*
  from temp_table1 tt1
  join temp_table2 tt2
  on tt1.sport = tt2.sport
  where tt2.times_played = 1
  order by Sport;
  
  -- Fetch the total number of sports played in each olympic game
  with temp_table as 
  (select distinct(Games), Sport
  from athlete_events
 order by Games,Sport)
  select Games, count(Sport) as no_of_sports
  from temp_table
  group by Games
  order by no_of_sports desc;
  
  -- Find the percentage of male and female athletes who participated in all olympic games
 select Sex, count(*) as athlete_count, round(count(*)/ (select count(*)from athlete_events) * 100,2) as pct_of_athletes_gender
 from athlete_events
 group by Sex;

-- Fetch the top 5 athletes who have won the most gold medals
with temp_table as
(select Name, Medal, count(*) as gold_medals
from athlete_events
where Medal = 'Gold'
group by Name),
temp_table2 as
(select *, dense_rank()over(order by gold_medals desc) as rnk
from temp_table)
select Name, gold_medals
from temp_table2
where rnk <=5;

-- Fetch the top 5 athletes who have won the most medals (Gold/Silver/Bronze)
with temp_table as
(select Name, Count(Medal) as medals_won
from athlete_events
where Medal in ('Gold','Silver','Bronze')
group by Name
order by medals_won desc),
temp_table1 as
(select Name, medals_won, dense_rank()over(order by medals_won desc) as rnk
from temp_table)
select Name, medals_won
from temp_table1
where rnk <=5 ;

-- List down total gold, silver , bronze medals won by each country

-- Identify which country won the most gold, most silver and most bronze medals in each olympic game

-- Which countries have never won gold medal but have won silver/bronze medals?

-- n which Sport, India has won highest medals.
with temp_table as
(select ae.Sport, count(Medal) as medals_won
from athlete_events ae
join noc_regions nr
on ae.NOC = nr.NOC
where nr.region = 'India' and ae.Medal <> 'NA'
group by Sport),
temp_table2 as
(select Sport, medals_won, rank()over(order by medals_won desc) as rnk
from temp_table)
select Sport, medals_won
from temp_table2
where rnk = 1;

-- Break down all olympic games where india won medal for Hockey and how many medals in each olympic games
select ae.Games,ae.Sport,nr.region, count(*) as total_medals
from athlete_events ae
join noc_regions nr
on ae.NOC = nr.NOC
where nr.region = 'India' and ae.Medal <> 'NA' and sport = 'Hockey'
group by Games,Sport,Region
order by count(*) desc;
