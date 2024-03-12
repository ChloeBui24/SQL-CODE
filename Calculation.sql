create table taxi_rides(
TripID int,
VendorID int,
tpep_pickup_datetime timestamp,
tpep_dropoff_datetime timestamp,
Passenger_count numeric(1,0),
Trip_distance numeric(8,2),
RateCodeID numeric(2),
Store_and_fwd_flag text,
PULocationID int,
DOLocationID int,
Payment_type int,
Fare_amount numeric(6,2),
Extra numeric(5,2),
MTA_tax numeric(4,2),
Tip_amount numeric(5,2),
Tolls_amount numeric(5,2),
Improvement_surcharge numeric(2,1),
Total_amount numeric(6,2),
Congestion_Surcharge numeric(2,1),
Airport_fee numeric(3,2))

drop table taxi_rides

copy taxi_rides
from 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-3-ChloeBui24-main\yellow_tripdata_2023-01.csv'
with (format csv, header)

select * from taxi_rides limit 5

--P2
--qA
select * from taxi_rides 
where (DATE(tpep_pickup_datetime) NOT BETWEEN '2023-01-01' AND '2023-01-31') AND
      (DATE(tpep_dropoff_datetime) NOT BETWEEN '2023-01-01' AND '2023-01-31')

select count(*) from taxi_rides 
where (DATE(tpep_pickup_datetime) NOT BETWEEN '2023-01-01' AND '2023-01-31') AND
      (DATE(tpep_dropoff_datetime) NOT BETWEEN '2023-01-01' AND '2023-01-31')
	  	  
--test if not use DATE before Timestamp  =>incorrect result
select * from taxi_rides 
where (tpep_pickup_datetime NOT BETWEEN '2023-01-01' AND '2023-01-31') AND
      (tpep_dropoff_datetime NOT BETWEEN '2023-01-01' AND '2023-01-31')	
--qB
select (count(*)*100::numeric(10,2)/(select count(*)::numeric(10,2) from taxi_rides))::numeric(4,2)
as percentage_disputed 
from taxi_rides
where payment_type=4

select count(*) from taxi_rides
where payment_type=4
--check the data type
select (count(*)*100/(select count(*)::FLOAT from taxi_rides))::numeric(4,2)
as percentage_disputed 
from taxi_rides
where payment_type=4
--qC
select percentile_cont(0.5) within group (order by (total_amount/passenger_count))
as median_amount_charged
from (select * from taxi_rides where passenger_count>0)
--qD
select mode() within group (order by PULocationID)
as mode_pickup_location
from taxi_rides

select mode() within group (order by DOLocationID)
as mode_dropoff_location
from taxi_rides
--the substitute command for MODE
select DOLocationID, 
       Count(*) as frequency
from taxi_rides group by DOLocationID
order by frequency desc
-- FIND MODE OF PAIR
select
    PULocationID,
    DOLocationID,
    count(*) as pair_count
from taxi_rides
group by PULocationID, DOLocationID
order by pair_count DESC
limit 1;
--qE
select count (*) from taxi_rides
where tpep_pickup_datetime > tpep_dropoff_datetime

select * from taxi_rides where tpep_pickup_datetime > tpep_dropoff_datetime

select AVG(EXTRACT(EPOCH FROM (tpep_pickup_datetime - tpep_dropoff_datetime)))::numeric(6,2) from taxi_rides
where tpep_pickup_datetime > tpep_dropoff_datetime
   
--P3
create temp table speed as(
select tripID, trip_distance,
(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/3600)::numeric(10,5) as duration
from taxi_rides
where trip_distance > 0 AND
EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) >= 30)

drop table speed
select * from speed limit 5

create temp table t4 as 
(select *, (trip_distance/duration)::numeric(13,4) as speed_mph from speed)

select * from t5 limit 5

create temp table t5 as
(select percentile_cont(0.25) within group (order by speed_mph) as Q1,
       percentile_cont(0.75) within group (order by speed_mph) as Q3
from t4)
copy (
select tripID, speed_mph from t4
WHERE speed_mph< (7.9199-1.5*(14.1918-7.9199)) OR
      speed_mph> (14.1919+1.5*(14.1918-7.9199))
ORDER BY speed_mph)
to 'C:\Users\DUNG BUI\Desktop\WU\Courses\Spring 24\Data\Repository\homework-3-ChloeBui24-main\bad_taxi_mphs.csv'
with (format csv, header)

