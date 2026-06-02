create schema Hospital_Management_Data_Analysis;
use Hospital_Management_Data_Analysis;

#Business Questions & SQL Analysis
# Total Patients

SELECT COUNT(*) AS total_patients
FROM patients;

#Total Doctors

SELECT COUNT(*) AS total_doctors
FROM doctors;

#Total Appointments

SELECT COUNT(*) AS total_appointments
FROM appointments;

#Total Revenue Generated

SELECT SUM(amount) AS total_revenue
FROM billing
WHERE payment_status='Paid';

#Revenue By Payment Method

SELECT
payment_method,
SUM(amount) AS revenue
FROM billing
WHERE payment_status='Paid'
GROUP BY payment_method
ORDER BY revenue DESC;

#Number of Patients by Gender

SELECT
gender,
COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

#Doctor-wise Appointment Count

SELECT
d.doctor_id,
CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
COUNT(a.appointment_id) AS total_appointments
FROM doctors d
LEFT JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_id,doctor_name
ORDER BY total_appointments DESC;

#Most Busy Doctor

SELECT
d.doctor_id,
CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
COUNT(a.appointment_id) AS appointments
FROM doctors d
JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_id,doctor_name
ORDER BY appointments DESC
LIMIT 1;

#Specialization Wise Doctors

SELECT
specialization,
COUNT(*) AS doctors_count
FROM doctors
GROUP BY specialization;

#Appointment Status Analysis

SELECT
status,
COUNT(*) AS total
FROM appointments
GROUP BY status;

#Most Common Treatment

SELECT
treatment_type,
COUNT(*) AS frequency
FROM treatments
GROUP BY treatment_type
ORDER BY frequency DESC;

#Treatment Revenue Analysis

SELECT
t.treatment_type,
SUM(b.amount) AS revenue
FROM treatments t
JOIN billing b
ON t.treatment_id=b.treatment_id
WHERE b.payment_status='Paid'
GROUP BY t.treatment_type
ORDER BY revenue DESC;

#Top 10 Highest Bills

SELECT
bill_id,
patient_id,
amount
FROM billing
ORDER BY amount DESC
LIMIT 10;

#Average Treatment Cost

SELECT
AVG(cost) AS avg_cost
FROM treatments;

#Highest Cost Treatment Type

SELECT
treatment_type,
AVG(cost) AS avg_cost
FROM treatments
GROUP BY treatment_type
ORDER BY avg_cost DESC;

#Top 5 Revenue Generating Patients

SELECT
p.patient_id,
CONCAT(p.first_name,' ',p.last_name) AS patient_name,
SUM(b.amount) AS total_bill
FROM patients p
JOIN billing b
ON p.patient_id=b.patient_id
GROUP BY p.patient_id,patient_name
ORDER BY total_bill DESC
LIMIT 5;

#Hospital Branch Performance

SELECT
d.hospital_branch,
COUNT(a.appointment_id) AS appointments
FROM doctors d
JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.hospital_branch
ORDER BY appointments DESC;

#Insurance Provider Analysis

SELECT
insurance_provider,
COUNT(*) AS patients
FROM patients
GROUP BY insurance_provider
ORDER BY patients DESC;

#Pending Payments

SELECT
COUNT(*) AS pending_bills,
SUM(amount) AS pending_amount
FROM billing
WHERE payment_status='Pending';

#Failed Payments

SELECT
COUNT(*) AS failed_bills,
SUM(amount) AS failed_amount
FROM billing
WHERE payment_status='Failed';

#Rank Doctors by Appointments

SELECT
doctor_id,
appointments,
RANK() OVER(ORDER BY appointments DESC) AS doctor_rank
FROM
(
SELECT
doctor_id,
COUNT(*) AS appointments
FROM appointments
GROUP BY doctor_id
) x;

#Revenue Ranking of Patients

SELECT
patient_id,
revenue,
DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
FROM
(
SELECT
patient_id,
SUM(amount) AS revenue
FROM billing
GROUP BY patient_id
) x;

#Row Number on Bills

SELECT
bill_id,
patient_id,
amount,
ROW_NUMBER() OVER(ORDER BY amount DESC) AS row_num
FROM billing;

#CTE Analysis
#Doctors Above Average Experience

WITH avg_exp AS
(
SELECT AVG(years_experience) avg_experience
FROM doctors
)

SELECT *
FROM doctors,avg_exp
WHERE years_experience > avg_experience;

#Patients Spending Above Average

WITH patient_spending AS
(
SELECT
patient_id,
SUM(amount) AS total_spent
FROM billing
GROUP BY patient_id
)

SELECT *
FROM patient_spending
WHERE total_spent >
(
SELECT AVG(total_spent)
FROM patient_spending
);

#Views
# Create Revenue View

CREATE VIEW revenue_summary AS
SELECT
payment_method,
SUM(amount) revenue
FROM billing
WHERE payment_status='Paid'
GROUP BY payment_method;

#use
SELECT * FROM revenue_summary;

#Patient Billing View

CREATE VIEW patient_billing AS
SELECT
p.patient_id,
CONCAT(p.first_name,' ',p.last_name) patient_name,
SUM(b.amount) total_bill
FROM patients p
JOIN billing b
ON p.patient_id=b.patient_id
GROUP BY p.patient_id,patient_name;

#use
SELECT * FROM patient_billing;

#Final KPI Dashboard Queries

-- Total Revenue
SELECT SUM(amount) FROM billing WHERE payment_status='Paid';

-- Total Patients
SELECT COUNT(*) FROM patients;

-- Total Doctors
SELECT COUNT(*) FROM doctors;

-- Total Appointments
SELECT COUNT(*) FROM appointments;

-- Pending Amount
SELECT SUM(amount) FROM billing WHERE payment_status='Pending';

-- Failed Amount
SELECT SUM(amount) FROM billing WHERE payment_status='Failed';

