select * from hw6.flights limit 5
select * from hw6.carriers limit 5
select * from hw6.city_markets limit 5
select * from hw6.weekdays limit 5
select * from hw6.cancellation_codes limit 5
select * from hw6.airports limit 5

--P1
--A
select * from hw6.flights where arrive_delay is not null limit 5

select a.description, avg(f.arrive_delay)::numeric(6,2) as avg_arrival_delay
from hw6.flights f
join hw6.airports a on f.dest_airport_id=a.airport_id
where f.arrive_delay is not null
group by a.description
having count(*)>=100
order by avg_arrival_delay desc
limit 1

--B
select * from hw6.flights where cancelled is null and arrive_delay is not null

select 
  c.description as city, 
  count(*) as no_inbound_flights
from hw6.flights f
join hw6.city_markets c on f.dest_city_market_id=c.city_market_id
where cancelled=0
group by c.description
order by no_inbound_flights desc
limit 3

--C
create temp table T1 AS (
    SELECT
    a.description as airport,
    COUNT(*) AS No_outgoing_flights,
	count (distinct flight_date) as No_of_days
    FROM hw6.flights f
	left join hw6.airports a on f.dest_airport_id=a.airport_id
	WHERE CANCELLED=0
    GROUP BY a.description)

DROP TABLE T1
select airport, (No_outgoing_flights::float/No_of_days)::numeric(7,2) as No_flights_per_day
from T1
order by No_flights_per_day desc
limit 5
--
SELECT origin_airport_id, 
       AVG(daily_flights)::numeric(7,2) AS avg_flights_per_day
FROM 
    (SELECT origin_airport_id, 
           flight_date, 
           COUNT(*) AS daily_flights
    FROM hw6.flights
	where cancelled=0
    GROUP BY origin_airport_id, flight_date)
GROUP BY origin_airport_id
ORDER BY avg_flights_per_day DESC
LIMIT 5;
--
SELECT airport, 
       AVG(daily_flights)::numeric(7,2) AS avg_flights_per_day
FROM 
    (SELECT
	       description as airport,
	       airport_id,
           flight_date, 
           COUNT(*) AS daily_flights
    FROM hw6.flights f
	join hw6.airports a on f.dest_airport_id=a.airport_id
	where cancelled=0
    GROUP BY description,airport_id,flight_date)
GROUP BY airport
ORDER BY avg_flights_per_day DESC
LIMIT 5;

SELECT airport, 
       AVG(daily_flights)::numeric(5,0) AS avg_flights_per_day
FROM 
    (SELECT
	       description as airport,
           flight_date, 
           COUNT(*) AS daily_flights
    FROM hw6.flights f
	join hw6.airports a on f.dest_airport_id=a.airport_id
	where cancelled=0
    GROUP BY description,flight_date)
GROUP BY airport
ORDER BY avg_flights_per_day DESC
LIMIT 5;
--test table airport=> dump
select count (distinct description) from hw6.airports
select count (distinct airport_id) from hw6.airports
--D
create temp table LongestFlights AS
    (SELECT carrier_id, 
           MAX(flight_distance) AS max_distance
    FROM hw6.flights
    GROUP BY carrier_id)
select * from LongestFlights
	
SELECT distinct c.name AS carrier_name,
       f.origin_airport_id, 
       f.dest_airport_id, 
       f.flight_distance
FROM hw6.carriers AS c
JOIN LongestFlights AS lf ON c.carrier_id = lf.carrier_id
JOIN hw6.flights AS f ON c.carrier_id = f.carrier_id AND f.flight_distance = lf.max_distance
where cancelled=0;

SELECT DISTINCT ON (least(f.origin_airport_id, f.dest_airport_id), greatest(f.origin_airport_id, f.dest_airport_id))
       c.name AS carrier_name,
       f.origin_airport_id,
	   a1.description,
       f.dest_airport_id, 
	   a2.description,
       f.flight_distance
FROM hw6.carriers c
JOIN LongestFlights lf ON c.carrier_id = lf.carrier_id
JOIN hw6.flights f ON c.carrier_id = f.carrier_id AND f.flight_distance = lf.max_distance
JOIN hw6.airports a1 on f.origin_airport_id=a1.airport_id
JOIN hw6.airports a2 on f.dest_airport_id=a2.airport_id
ORDER BY least(f.origin_airport_id, f.dest_airport_id), 
         greatest(f.origin_airport_id, f.dest_airport_id),
         c.name;

SELECT DISTINCT ON 
(least(f.origin_airport_id, f.dest_airport_id), 
 greatest(f.origin_airport_id, f.dest_airport_id))
       c.name AS carrier_name,
	   a1.description as airport_1,
	   a2.description as airpart_2
FROM hw6.carriers c
JOIN LongestFlights lf ON c.carrier_id = lf.carrier_id
JOIN hw6.flights f ON c.carrier_id = f.carrier_id AND f.flight_distance = lf.max_distance
JOIN hw6.airports a1 on f.origin_airport_id=a1.airport_id
JOIN hw6.airports a2 on f.dest_airport_id=a2.airport_id
ORDER BY least(f.origin_airport_id, f.dest_airport_id), 
         greatest(f.origin_airport_id, f.dest_airport_id),
         c.name;
		 
copy
(SELECT DISTINCT ON 
(least(f.origin_airport_id, f.dest_airport_id), 
 greatest(f.origin_airport_id, f.dest_airport_id))
       c.name AS carrier_name,
	   a1.description as airport_1,
	   a2.description as airpart_2
FROM hw6.carriers c
JOIN LongestFlights lf ON c.carrier_id = lf.carrier_id
JOIN hw6.flights f ON c.carrier_id = f.carrier_id AND f.flight_distance = lf.max_distance
JOIN hw6.airports a1 on f.origin_airport_id=a1.airport_id
JOIN hw6.airports a2 on f.dest_airport_id=a2.airport_id
ORDER BY least(f.origin_airport_id, f.dest_airport_id), 
         greatest(f.origin_airport_id, f.dest_airport_id),
         c.name)
to 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring24\Data\Repository\homework-6-ChloeBui24-main\longest_flights.csv'
with (format csv, header)

SELECT *
FROM hw6.carriers c
JOIN LongestFlights lf ON c.carrier_id = lf.carrier_id
JOIN hw6.flights f ON c.carrier_id = f.carrier_id AND f.flight_distance = lf.max_distance
where cancelled=0;
--P2
--A
SELECT 
	wd.day_name,
    COUNT(f.flight_date) AS total_departing_flights
FROM  hw6.flights f
JOIN hw6.weekdays wd ON f.day_of_week = wd.code
where cancelled=0
GROUP BY wd.day_name,wd.code
ORDER BY wd.code

SELECT 
	wd.day_name,
    COUNT(*) AS total_departing_flights
FROM  hw6.flights f
JOIN hw6.weekdays wd ON f.day_of_week = wd.code
where cancelled=0
GROUP BY wd.day_name,wd.code
ORDER BY wd.code
--B
SELECT 
    wd.day_name,
    c.name AS carrier_name,
    AVG(f.depart_delay)::numeric(7,3) AS average_departure_delay
FROM hw6.flights f
JOIN hw6.weekdays wd ON f.day_of_week = wd.code
JOIN hw6.carriers c ON f.carrier_id = c.carrier_id
WHERE f.depart_delay IS NOT NULL
GROUP BY wd.day_name, c.name,wd.code
ORDER BY wd.code, average_departure_delay DESC;

SELECT 
    wd.day_name,
    AVG(f.depart_delay)::numeric(5,2) AS average_departure_delay
FROM hw6.flights f
JOIN hw6.weekdays wd ON f.day_of_week = wd.code
WHERE f.depart_delay IS NOT NULL
GROUP BY wd.day_name, wd.code
ORDER BY wd.code, average_departure_delay DESC;

--P3
CREATE TABLE StudentGrades (
    student_id INT PRIMARY KEY,
    name VARCHAR(255),
    submitted_date DATE,
    assignment VARCHAR(255),
    total_available_points INT,
    deductions NVARCHAR(MAX) -- Store deductions as JSON
);
Table: Assignments_Submissions_Deductions
+-------------------------+------------+
| Column                  | Type       |
+-------------------------+------------+
| student_id              | STRING     |
| name                    | STRING     |
| submitted_date          | DATE       |
| assignment              | STRING     |
| total_available_points  | INT        |
| deduction_id            | INT        |
| comment                 | STRING     |
| deduction               | FLOAT      |
+-------------------------+------------+
Primary Key: (student_id, assignment, submitted_date, deduction_id)

Table: Assignments_Submissions_Deductions
+-------------------------+------------+
| Column                  | Type       |
+-------------------------+------------+
| student_id              | STRING     |
| name                    | STRING     |
| submitted_date          | DATE       |
| assignment              | STRING     |
| total_available_points  | INT        |
| deduction_id            | INT        |
| comment                 | STRING     |
| deduction               | FLOAT      |
+-------------------------+------------+
Primary Key: (student_id, assignment, submitted_date, deduction_id)

