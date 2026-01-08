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

