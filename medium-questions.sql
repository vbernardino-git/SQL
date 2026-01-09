-- Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;

/*
Show unique first names from the patients table which only occurs once in the list.
For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. 
If only 1 person is named 'Leo' then include them in the output.
*/
select first_name from patients
group by first_name having count(first_name) = 1;

/*
Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
*/
select patient_id, first_name from patients
where first_name like 's%s' and len(first_name) > 5;

/*
Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
Primary diagnosis is stored in the admissions table.
*/
select patients.patient_id, first_name, last_name from patients
JOIN admissions ON patients.patient_id = admissions.patient_id
where diagnosis = 'Dementia';

/*
Display every patient's first_name.
Order the list by the length of each name and then by alphabetically.
*/
select first_name from patients
order by len(first_name), first_name;

--Show first name, last name, and gender of patients whose gender is 'M'
select first_name, last_name, gender from patients
where gender = 'M';

/*
Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
*/
SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients;

/*
Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
Show results ordered ascending by allergies then by first_name then by last_name.
*/
SELECT first_name, last_name, allergies FROM patients
where allergies = 'Penicillin' or allergies = 'Morphine' 
order by allergies, first_name, last_name;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id, diagnosis from admissions
group by patient_id, diagnosis
having count(*) > 1;

/*
Show the city and the total number of patients in the city.
Order from most to least patients and then by city name ascending.
*/
select city, count(*) as num_patients from patients
group by city
order by num_patients desc, city asc;

/*
Show first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor"
*/
SELECT first_name, last_name, 'Patient' as role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' as role FROM doctors;

/*
Show all allergies ordered by popularity. Remove NULL values from query.
*/
select allergies, count(*) as total_diagnosis from patients
where allergies is not NULL
group by allergies
order by total_diagnosis desc;

/*
Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
Sort the list starting from the earliest birth_date.
*/
SELECT first_name, last_name, birth_date FROM patients
where year(birth_date) between 1970 and 1979
order by birth_date asc;

/*
We want to display each patient's full name in a single column. 
Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
EX: SMITH,jane
*/
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format FROM patients
ORDER BY first_name DESC;

/*
Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
*/
select province_id, sum(height) as sum_height from patients
group by province_id
having sum_height >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight)-min(weight) from patients
where last_name = 'Maroni';

/*
Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
Sort by the day with most admissions to least admissions.
*/
select day(admission_date) as day_number, count(patient_id) as number_of_admissions from admissions
group by day_number 
order by number_of_admissions desc;

-- Show all columns for patient_id 542's most recent admission_date.
SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
-- LIMIT 1;

/*
Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
*/
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE (attending_doctor_id IN (1, 5, 19) AND patient_id % 2 != 0) 
OR
(attending_doctor_id LIKE '%2%' AND len(patient_id) = 3);

-- Show first name and last name of patients who does not have allergies. (null)
select first_name, last_name from patients
where allergies IS NULL;

-- Show first name of patients that start with the letter 'C'
select first_name from patients
where first_name like 'c%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name, last_name from patients
where weight >= 100 and weight <= 120;

/*
Show first_name, last_name, and the total number of admissions attended for each doctor.
Every admission has been attended by a doctor.
*/
select first_name, last_name, count(*) from doctors
join admissions ON admissions.attending_doctor_id = doctors.doctor_id
group by attending_doctor_id;

-- For each doctor, display their id, full name, and the first and last admission date they attended.
select doctor_id, first_name || " " || last_name as full_name, min(admission_date) as first_adm_date, max(admission_date) as last_adm_date from doctors
join admissions ON admissions.attending_doctor_id = doctors.doctor_id
group by attending_doctor_id;

-- Display the total amount of patients for each province. Order by descending.
select province_name, count(*) as amount from patients
join province_names ON province_names.province_id = patients.province_id
group by province_name 
order by amount desc;

/*
For every admission, display the patient's full name, their admission diagnosis, and their doctor's full 
name who diagnosed their problem.
*/
select p.first_name || " " || p.last_name as patient_name, diagnosis, doctors.first_name || " " || doctors.last_name from patients as p
join province_names ON province_names.province_id = p.province_id
join admissions on admissions.patient_id = p.patient_id
join doctors on admissions.attending_doctor_id = doctors.doctor_id;

/*
display the first name, last name and number of duplicate patients based on their first name and last name.
Ex: A patient with an identical name can be considered a duplicate.
*/
select first_name, last_name, count(*) as total from patients 
group by first_name, last_name
having count(*) > 1

/*
Display patient's full name,
height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date,
gender non abbreviated.

Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.
*/
UPDATE patients
SET gender = 'MALE'
WHERE gender = 'M';
update patients
set gender = 'FEMALE'
where gender = 'F';
select p.first_name || " " || p.last_name as patient_name, round(height/30.48, 1), round(weight*2.205), birth_date, gender from patients as p

/*
Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
(Their patient_id does not exist in any admissions.patient_id rows.)
*/
SELECT patient_id, first_name, last_name FROM patients
WHERE patient_id NOT IN (
    SELECT patient_id
    FROM admissions
);
