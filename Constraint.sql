CREATE SCHEMA IF NOT EXISTS hw5;

DROP TABLE IF EXISTS hw5.ratings;
DROP TABLE IF EXISTS hw5.movies;
DROP TABLE IF EXISTS hw5.reviewers;

CREATE TABLE hw5.movies (
id int primary key,
title text,
year smallint check (year>1900),
director text,
constraint uniq_pair unique(title, year)
);

CREATE TABLE hw5.reviewers (
id int primary key,
name text not null
);

CREATE TABLE hw5.ratings (
reviewer_id INT REFERENCES hw5.reviewers(id),
movie_id INT REFERENCES hw5.movies(id),
stars INT NOT NULL CHECK (stars >= 1 AND stars <= 5),
rating_date DATE NOT NULL CHECK (rating_date > '2000-01-01'),
PRIMARY KEY(reviewer_id, movie_id)
);
select * from hw5.movies
select * from hw5.reviewers
select * from hw5.ratings

INSERT INTO hw5.movies (id,title,year,director) 
VALUES
  (2,'The Graduate',1967,'Mike Nichols');
  
INSERT INTO hw5.movies (id,title,year,director) 
VALUES
  (51,'The Graduate',1865,'Mike Nichols');

INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (4,36,5,'2010-01-01');
  
DROP TABLE hw5.reviewers;

INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (1,3,NULL,'2015-04-02');

INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (1,3,3,'1999-04-18');
select * from hw5.ratings where hw5.ratings.reviewer_id=1 and hw5.ratings.movie_id=3
--P4
INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (1,3,6,'1999-04-18');
  
INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (1,2,0,'2012-02-18');
  
DROP TABLE hw5.movies;

INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (4,3,-2,'2014-01-03');
  
select * from hw5.reviewers where hw5.reviewers.id=1
select * from hw5.movies where hw5.movies.title='The Graduate' and hw5.movies.year=1867
INSERT INTO hw5.reviewers (id,name) 
VALUES
  (20,NULL);

INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (2,3,4.3,'1989-10-30');
  
INSERT INTO hw5.ratings (reviewer_id,movie_id,stars,rating_date) 
VALUES
  (1,3,3,NULL);

INSERT INTO hw5.movies (id,title,year,director) 
VALUES
  (51,'The Graduate',1867,'Mike Nichols'),
  (52,'The Graduate',1867,'Krzysztof Kieslowski');