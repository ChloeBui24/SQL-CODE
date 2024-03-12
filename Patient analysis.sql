drop table public.patients;
drop table public.encounters;
drop table public.conditions;
drop table public.immunizations

--1. create table patients:
CREATE TABLE patients
(Id text primary key
,BIRTHDATE date not null
,DEATHDATE date 
,SSN text 
,DRIVERS text 
,PASSPORT text
,PREFIX text
,FIRST text
,LAST text
,SUFFIX text
,MAIDEN text
,MARITAL text
,RACE text
,ETHNICITY text
,GENDER text
,BIRTHPLACE text
,ADDRESS text
,CITY text
,STATE text
,COUNTY text
,FIPS INT 
,ZIP INT
,LAT float
,LON float
,HEALTHCARE_EXPENSES float
,HEALTHCARE_COVERAGE float
,INCOME int
,Mrn int
);

copy public.patients
from 'C:\Users\DUNG BUI\Desktop\Project\SQL\Immunization\patients.csv'
with (format csv, header)

--2. create table encounters
CREATE TABLE encounters(
 Id text primary key,
START TIMESTAMP NOT NULL,
STOP TIMESTAMP NOT NULL,
PATIENT text NOT NULL, 
ORGANIZATION text NOT NULL,
PROVIDER text NOT NULL,
PAYER text,
ENCOUNTERCLASS text,
CODE text,
DESCRIPTION text,
BASE_ENCOUNTER_COST FLOAT,
TOTAL_CLAIM_COST FLOAT,
PAYER_COVERAGE FLOAT,
REASONCODE text,
foreign key (PATIENT) references patients(ID))

copy public.encounters
from 'C:\Users\DUNG BUI\Desktop\Project\SQL\Immunization\encounters.csv'
with (format csv, header)

--3. create table condistions
CREATE TABLE conditions(
START DATE NOT NULL,
STOP DATE,
PATIENT TEXT NOT NULL,
ENCOUNTER TEXT NOT NULL,
CODE TEXT NOT NULL,
DESCRIPTION TEXT NOT NULL,
FOREIGN KEY (PATIENT) REFERENCES PATIENTS(ID));

copy public.CONDITIONS
from 'C:\Users\DUNG BUI\Desktop\Project\SQL\Immunization\conditions.csv'
with (format csv, header)

--4. create table immunizations
CREATE TABLE immunizations
(DATE TIMESTAMP NOT NULL,
PATIENT TEXT NOT NULL,
ENCOUNTER TEXT NOT NULL,
CODE INT NOT NULL,
DESCRIPTION TEXT NOT NULL,
FOREIGN KEY (PATIENT)REFERENCES PATIENTS(ID))

copy public.IMMUNIZATIONS
from 'C:\Users\DUNG BUI\Desktop\Project\SQL\Immunization\immunizations.csv'
with (format csv, header)

SELECT * FROM PATIENTS LIMIT 3
SELECT * FROM ENCOUNTERS LIMIT 3
SELECT * FROM CONDITIONS LIMIT 3
SELECT * FROM IMMUNIZATIONS LIMIT 3
--Question:
--Q1. Top 10 counties in MA with the most frequent encounters of elderly patients?
SELECT
    p.COUNTY,
    COUNT(e.Id) AS No_of_Encounter
FROM patients p
JOIN encounters e ON p.Id = e.PATIENT
WHERE(EXTRACT(YEAR FROM AGE(p.BIRTHDATE)) >= 65)
GROUP BY p.COUNTY
ORDER BY No_of_Encounter DESC
LIMIT 10;

--Q2. What are TOP 5 most common conditions among elderly patients?
SELECT
    c.DESCRIPTION,
    COUNT(*) AS No_of_Condition
FROM conditions c
JOIN patients p ON c.PATIENT = p.Id
WHERE(EXTRACT(YEAR FROM AGE(p.BIRTHDATE)) >= 65)
GROUP BY c.DESCRIPTION
ORDER BY No_of_Condition DESC
LIMIT 5;

--Q3. Top 10 conditions with the highest total healthcare expense?
SELECT
    c.DESCRIPTION AS Condition,
    SUM(e.TOTAL_CLAIM_COST)::numeric(15,2) AS Total_Cost
FROM encounters e
JOIN conditions c ON e.Id = c.ENCOUNTER
JOIN patients p ON e.PATIENT = p.Id
WHERE (EXTRACT(YEAR FROM AGE(p.BIRTHDATE)) >= 65)
GROUP BY Condition
ORDER BY Total_Cost DESC
LIMIT 10;

--Q4. Compare the average expense of patients who used COVID vaccine vs all patients
select AVG(P.HEALTHCARE_EXPENSES)::NUMERIC(9,2)
FROM patients p
LEFT JOIN immunizations i ON p.Id = i.PATIENT
WHERE EXTRACT(YEAR FROM AGE(p.BIRTHDATE)) >= 65

select AVG(P.HEALTHCARE_EXPENSES)::NUMERIC(9,2)
FROM patients p
LEFT JOIN immunizations i ON p.Id = i.PATIENT
WHERE(EXTRACT(YEAR FROM AGE(p.BIRTHDATE)) >= 65) AND i.description ILIKE'%COVID%'




