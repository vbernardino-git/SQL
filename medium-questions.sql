-- Show unique birth years FROM patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;

/*
Show unique first names FROM the patients table which only occurs once in the list.
For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. 
If only 1 person is named 'Leo' then include them in the output.
*/
SELECT first_name FROM patients
GROUP BY first_name HAVING COUNT(first_name) = 1;

/*
Show patient_id and first_name FROM patients where their first_name start and ends with 's' and is at least 6 characters long.
*/
SELECT patient_id, first_name FROM patients
WHERE first_name LIKE 's%s' AND LEN(first_name) > 5;

/*
Show patient_id, first_name, last_name FROM patients whos diagnosis is 'Dementia'.
Primary diagnosis is stored in the admissions table.
*/
SELECT patients.patient_id, first_name, last_name FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE diagnosis = 'Dementia';

/*
Display every patient's first_name.
Order the list by the length of each name and then by alphabetically.
*/
SELECT first_name FROM patients
ORDER BY LEN(first_name), first_name;

-- Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender FROM patients
WHERE gender = 'M';

/*
Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
*/
SELECT 
  SUM(Gender = 'M') AS male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients;

/*
Show first and last name, allergies FROM patients which have allergies to either 'Penicillin' or 'Morphine'. 
Show results ordered ascending by allergies then by first_name then by last_name.
*/
SELECT first_name, last_name, allergies FROM patients
WHERE allergies = 'Penicillin' OR allergies = 'Morphine' 
ORDER BY allergies, first_name, last_name;

-- Show patient_id, diagnosis FROM admissions. Find patients admitted multiple times for the same diagnosis.
SELECT patient_id, diagnosis FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

/*
Show the city and the total number of patients in the city.
Order FROM most to least patients and then by city name ascending.
*/
SELECT city, COUNT(*) AS num_patients FROM patients
GROUP BY city
ORDER BY num_patients DESC, city ASC;

/*
Show first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor"
*/
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

/*
Show all allergies ordered by popularity. Remove NULL values FROM query.
*/
SELECT allergies, COUNT(*) AS total_diagnosis FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

/*
Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
Sort the list starting FROM the earliest birth_date.
*/
SELECT first_name, last_name, birth_date FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

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
SELECT province_id, SUM(height) AS sum_height FROM patients
GROUP BY province_id
HAVING sum_height >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT MAX(weight)-MIN(weight) FROM patients
WHERE last_name = 'Maroni';

/*
Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
Sort by the day with most admissions to least admissions.
*/
SELECT DAY(admission_date) AS day_number, COUNT(patient_id) AS number_of_admissions FROM admissions
GROUP BY day_number 
ORDER BY number_of_admissions DESC;

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
(attending_doctor_id LIKE '%2%' AND LEN(patient_id) = 3);

-- Show first name and last name of patients who does not have allergies. (null)
SELECT first_name, last_name FROM patients
WHERE allergies IS NULL;

-- Show first name of patients that start with the letter 'C'
SELECT first_name FROM patients
WHERE first_name LIKE 'c%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name FROM patients
WHERE weight >= 100 AND weight <= 120;

/*
Show first_name, last_name, and the total number of admissions attended for each doctor.
Every admission has been attended by a doctor.
*/
SELECT first_name, last_name, COUNT(*) FROM doctors
JOIN admissions ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY attending_doctor_id;

-- For each doctor, display their id, full name, and the first and last admission date they attended.
SELECT doctor_id, first_name || " " || last_name AS full_name, MIN(admission_date) AS first_adm_date, MAX(admission_date) AS last_adm_date FROM doctors
JOIN admissions ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY attending_doctor_id;

-- Display the total amount of patients for each province. Order by descending.
SELECT province_name, COUNT(*) AS amount FROM patients
JOIN province_names ON province_names.province_id = patients.province_id
GROUP BY province_name 
ORDER BY amount DESC;

/*
For every admission, display the patient's full name, their admission diagnosis, and their doctor's full 
name who diagnosed their problem.
*/
SELECT p.first_name || " " || p.last_name AS patient_name, diagnosis, doctors.first_name || " " || doctors.last_name FROM patients AS p
JOIN province_names ON province_names.province_id = p.province_id
JOIN admissions ON admissions.patient_id = p.patient_id
JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id;

/*
display the first name, last name and number of duplicate patients based on their first name and last name.
Ex: A patient with an identical name can be considered a duplicate.
*/
SELECT first_name, last_name, COUNT(*) AS total FROM patients 
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

/*
Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded
to 0 decimals, birth_date, gender non abbreviated.
*/
UPDATE patients
SET gender = 'MALE'
WHERE gender = 'M';

UPDATE patients
SET gender = 'FEMALE'
WHERE gender = 'F';

SELECT p.first_name || " " || p.last_name AS patient_name, ROUND(height/30.48, 1), ROUND(weight*2.205), birth_date, gender FROM patients AS p;

/*
Show patient_id, first_name, last_name FROM patients whose does not have any records in the admissions table.
*/
SELECT patient_id, first_name, last_name FROM patients
WHERE patient_id NOT IN (
    SELECT patient_id
    FROM admissions
);

/*
Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number
of admissions per day is calculated. Average is rounded to 2 decimal places.
*/
SELECT 
    MAX(daily_visits) AS max_visits, 
    MIN(daily_visits) AS min_visits, 
    ROUND(AVG(daily_visits), 2) AS avg_visits
FROM (
    SELECT admission_date, COUNT(*) AS daily_visits
    FROM admissions
    GROUP BY admission_date
);

/*
Display every patient that has at least one admission and show their most recent admission along with the
patient and doctor's full name.
*/
SELECT p.first_name || ' ' || p.last_name AS patient_name,
MAX(admission_date) AS most_recent_adm,
d.first_name || ' ' || d.last_name AS doctor_full_name
FROM patients p
JOIN admissions adm ON adm.patient_id = p.patient_id
JOIN doctors d ON d.doctor_id = adm.attending_doctor_id
GROUP BY adm.patient_id
HAVING COUNT(*) >= 1;

/*
Atividade de análise de quanto cada cidade gastou em cada produto, somando os valores das vendas e exibindo os 
resultados do maior para o menor gasto, com ordenação adicional por cidade e produto.
*/
SELECT ci.city_name, p.product_name, ROUND(SUM(ii.line_total_price), 2) AS total_spent
FROM city ci
JOIN customer cu ON cu.city_id = ci.id
JOIN invoice i ON i.customer_id = cu.id
JOIN invoice_item ii ON ii.invoice_id = i.id
JOIN product p ON p.id = ii.product_id
GROUP BY ci.city_name, p.product_name
ORDER BY total_spent DESC, ci.city_name ASC, p.product_name ASC;
