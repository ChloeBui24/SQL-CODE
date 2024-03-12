create table pokemon(
ID text,
Name text,
Type_1 text,
Type_2 text,
Total int,
HP INT,
Attack int,
Defense int,
Sp_Atk int,
Sp_Def int,
Speed int,
Generation int,
Legendary text);

drop table pokemon

COPY pokemon from 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\pokemon.csv'
with (format csv, header);

select * from pokemon;
select distinct * from pokemon;
#q1
select count(*) from pokemon 
where (legendary='TRUE') and (defense>attack)
select distinct * from pokemon 
where (legendary='TRUE') and (defense>attack)
#q2
select * from pokemon
where (type_1='Water' and type_2='Poison') OR (type_2='Water' and type_1='Poison')
#q3
select type_1, type_2 from pokemon
where type_1<>type_2 order by type_1, type_2

copy 
(select type_1, type_2 from pokemon
where type_1<>type_2 order by type_1, type_2)
to 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\type_combos.csv'
with (format csv)

#P3
create table movies(
No serial,
id text,
title text,
release_date date,
overview text,
popularity decimal(8,3),
vote_average decimal(2,1),
vote_count int,
video text)

drop table movies

select * from movies;

copy movies 
from 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\movies.csv'
with (format csv, header)
#q1
select * from movies 
where extract (year from release_date) between 1980 and 1989 
order by popularity desc, title;

select * from movies 
where (release_date >= '1980-1-1') and (release_date <='1989-12-31')
order by popularity desc, title;

select * from movies 
where release_date between '1980-1-1' and '1989-12-31'
order by popularity desc, title;

#q2
select * from movies
where release_date>='2010-1-1' and vote_count>=10000
order by vote_average desc
limit 5;

#q3
copy
( select release_date, title, popularity from movies
where (title ilike '%spider%'or overview ilike '%spider%') and (title not ilike '%spider-man%')
 order by release_date)
to 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\spider_not_man.csv'
with (format csv, header)

#P4
create table resolutions(
other_topic text,
resolution_topics text,
gender text,
name text,
Resolution_Category text,
retweet_count int,
text text,
tweet_coord text,
tweet_created timestamp,
tweet_date date,
tweet_id text,
tweet_location text,
tweet_state text,
user_timezone text,
tweet_region text)

drop table resolutions

select * from resolutions

copy resolutions
from 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\resolutions.csv'
with (format csv, header)

#q1
select name,resolution_topics, tweet_created from resolutions
where (resolution_topics ilike '% Time Management%')and (tweet_date<'2015-1-1')
order by tweet_created desc
limit 1

#q2
select name, retweet_count from resolutions
where (gender='female')and (tweet_region='Midwest') and (retweet_count is not null)
order by retweet_count desc
limit 1

#q3
select name from resolutions
where text ilike '%#NewYearsResolution%#%' and tweet_state='OR'
ORDER BY name

copy(
select name from resolutions
where text ilike '%#NewYearsResolution%#%' and tweet_state='OR'
ORDER BY name)
to 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-2-ChloeBui24-main\data\hashtag_happy.csv'
with (format csv, header)