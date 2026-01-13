/*
Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
*/

SELECT
  count(*),
  (weight / 10) * 10 as weight_groups
FROM patients
GROUP BY weight_groups
ORDER BY weight DESC

/*
Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30.

weight is in units kg.
height is in units cm.
*/
SELECT
  patient_id,
  weight,
  height,
  case
    WHEN (weight / POWER((height / 100.0), 2)) >= 30 THEN 1
    ELSE 0
  END as IsObese
FROM patients

/*
Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information.
*/
SELECT
  p.patient_id,
  p.first_name,
  p.last_name,
  d.specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors d ON d.doctor_id = a.attending_doctor_id
where
  diagnosis = 'Epilepsy'
  and d.first_name = 'Lisa'

/*
All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date
*/
SELECT DISTINCT
  p.patient_id,
  CONCAT(
    p.patient_id,
    LENGTH(last_name),
    YEAR(birth_date)
  ) as temp_password
FROM patients p

JOIN admissions a ON a.patient_id = p.patient_id