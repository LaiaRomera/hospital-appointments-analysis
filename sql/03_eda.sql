-- ============================================================
-- Project: Hospital Appointments & Patient Care Analysis
-- Script: 03_eda.sql
--
-- Purpose: Data quality checks, exploratory data analysis (EDA) and business insights.
-- ============================================================

-- ============================================================
-- 1. DATA QUALITY CHECKS
-- ============================================================

-- Check number of ROWS in each main table.
-- To verify that the data load was successful.

SELECT 
	'dim_patients' AS table_name, 
	COUNT(*) AS total_rows
FROM dim_patients
UNION ALL
SELECT 
	'dim_doctors' AS table_name, 
	COUNT(*) AS total_rows
FROM dim_doctors
UNION ALL
SELECT 
	'dim_hospitals' AS table_name, 
	COUNT(*) AS total_rows
FROM dim_hospitals
UNION ALL
SELECT 
	'dim_specialties' AS table_name, 
	COUNT(*) AS total_rows
FROM dim_specialties
UNION ALL
SELECT 
	'dim_dates' AS table_name, 
	COUNT(*) AS total_rows
FROM dim_dates
UNION ALL
SELECT 
	'fact_appointments' AS table_name, 
	COUNT(*) AS total_rows
FROM fact_appointments;


-- Check diferent tables with missing information.
-- We want to check if this fields has nulls because it will be useful to make an analysis.

SELECT *
FROM dim_patients
WHERE city IS NULL OR insurance_type IS NULL OR registration_date IS NULL;

SELECT *
FROM dim_doctors
WHERE hire_date IS NULL OR is_active IS NULL;

SELECT *
FROM dim_hospitals
WHERE hospital_type IS NULL;



-- Check possible duplicated patients based on first name, last name and birth date.

SELECT
    first_name,
    last_name,
    birth_date,
    COUNT(*) AS total_patients
FROM dim_patients
GROUP BY
    first_name,
    last_name,
    birth_date
HAVING COUNT(*) > 1; -- This returns how many rows there are in each grouping.


-- Check possible duplicated doctors based on first name, last name and hire_date.
SELECT
    first_name,
    last_name,
    hire_date,
    COUNT(*) AS total_patients
FROM dim_doctors
GROUP BY
    first_name,
    last_name,
    hire_date
HAVING COUNT(*) > 1;



-- Check appointments with invalid numeric values.

SELECT *
FROM fact_appointments
WHERE consultation_fee < 0
   OR waiting_minutes < 0
   OR appointment_duration_minutes <= 0
   OR satisfaction_score NOT BETWEEN 1 AND 5;






-- This demonstrates how to safely test a deletion.

BEGIN;
DELETE FROM fact_appointments
WHERE appointment_status = 'Scheduled';
-- Check how many scheduled appointments remain after deletion.
SELECT COUNT(*) AS scheduled_appointments_after_delete
FROM fact_appointments
WHERE appointment_status = 'Scheduled';
ROLLBACK;


-- ============================================================
-- 2. DATA CLEANING
-- ============================================================

-- This safely updates missing insurance values if they exist.
BEGIN;
UPDATE dim_patients
SET insurance_type = 'None'
WHERE insurance_type IS NULL;
COMMIT;

-- Remove leading spaces from hospital city names.
BEGIN;
UPDATE dim_hospitals
SET city = TRIM(city)
WHERE city <> TRIM(city);
COMMIT;


-- Update NULLS in city from dim_patients. 

UPDATE dim_patients
SET city = 'Unknown'
WHERE city IS NULL;

-- Drop duplicated patients.

-- We check which patient is duplicated.
SELECT patient_id
FROM dim_patients
WHERE first_name = 'Sandra' AND last_name = 'Sanchez';

-- Check wich patient_id has appointments
SELECT *
FROM fact_appointments
WHERE patient_id = 20 OR patient_id = 26;

-- Now we can delete only de duplicated without appointments:
DELETE FROM dim_patients 
WHERE patient_id = 26;



-- Text standarization
UPDATE dim_hospitals
SET city = INITCAP(TRIM(city));


-- ============================================================
-- 3. EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================================

-- How many appointments are registered?
SELECT
    COUNT(*) AS total_appointments
FROM fact_appointments;

--And how many of them are completed, canceled, not shown, or scheduled?
SELECT
    appointment_status,
    COUNT(*) AS total_appointments
FROM fact_appointments
GROUP BY appointment_status;


-- What is the average cost of a completed consultation?
SELECT 
	ROUND(AVG(consultation_fee),2) AS avg_fee
FROM fact_appointments 
WHERE appointment_status = 'Completed';


-- What is the total profit?
SELECT
	SUM(consultation_fee) AS total_revenue
FROM fact_appointments
WHERE appointment_status = 'Completed';


-- What is the patients average satisfaction?
SELECT 
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM fact_appointments 
WHERE appointment_status = 'Completed';



-- ============================================================
-- 4. BUSINESS INSIGHTS
-- ============================================================

-- Insight 1:
-- Average patient satisfaction by hospital.
-- This query helps identify hospitals with the highest patient satisfaction scores.
-- ============================================================
SELECT 
	h.hospital_id,
	h.hospital_name,
	ROUND(AVG(fa.satisfaction_score),2) AS avg_satisfaction
FROM fact_appointments fa
LEFT JOIN dim_doctors d ON fa.doctor_id = d.doctor_id 
LEFT JOIN dim_hospitals h ON d.hospital_id = h.hospital_id
WHERE fa.appointment_status = 'Completed'
GROUP BY h.hospital_id
ORDER BY avg_satisfaction DESC;


-- Insight 2:
-- Average patient satisfaction by doctor.
-- This query helps identify doctors with the highest patient satisfaction scores.
-- ============================================================
SELECT 
	d.doctor_id,
	d.first_name || ' ' || d.last_name AS doctor_name,
	ROUND(AVG(fa.satisfaction_score),2) AS avg_satisfaction
FROM fact_appointments fa
INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id 
WHERE fa.appointment_status = 'Completed'
GROUP BY d.doctor_id
ORDER BY avg_satisfaction DESC;


-- Insight 3:
-- Revenue generated by each hospital.
-- Helps identify the most profitable hospitals and includes the ranking of hospitals according to their revenues
-- The CTE makes the query more readable by separating the revenue calculation from the final ordering.
-- ============================================================
WITH hospital_revenue AS (
    SELECT
        h.hospital_name,
        ROUND(SUM(fa.consultation_fee), 2) AS total_revenue
    FROM fact_appointments fa
    INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id
    INNER JOIN dim_hospitals h ON d.hospital_id = h.hospital_id
    WHERE fa.appointment_status = 'Completed'
    GROUP BY h.hospital_name
)
SELECT
	RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,    
	hospital_name,
    total_revenue
FROM hospital_revenue;



-- Insight 4:
-- Revenue generated by specialty.
-- Helps identify the most profitable specialties.
-- ============================================================
SELECT 
	sp.*,
	SUM(fa.consultation_fee) AS revenue_by_specialty
FROM fact_appointments fa
INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id 
LEFT JOIN dim_hospitals h ON d.hospital_id = h.hospital_id
LEFT JOIN dim_specialties sp ON d.specialty_id = sp.specialty_id
WHERE fa.appointment_status = 'Completed'
GROUP BY sp.specialty_id
ORDER BY revenue_by_specialty DESC;


-- Insight 5:
-- Revenue generated by doctors.
-- Helps identify the most profitable doctors.
-- ============================================================
SELECT
    d.first_name || ' ' || d.last_name AS doctor_name,
    ROUND(SUM(fa.consultation_fee), 2) AS total_revenue
FROM fact_appointments fa
INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id
WHERE fa.appointment_status = 'Completed'
GROUP BY d.first_name, d.last_name
ORDER BY total_revenue DESC;


-- Insight 6:
-- Average waiting time by specialty.
-- ============================================================
SELECT
    sp.specialty_name,
    ROUND(AVG(fa.waiting_minutes), 2) AS avg_waiting_time
FROM fact_appointments fa
INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id
INNER JOIN dim_specialties sp ON d.specialty_id = sp.specialty_id
WHERE fa.appointment_status = 'Completed'
GROUP BY sp.specialty_name
ORDER BY avg_waiting_time DESC;



-- Insight 7:
-- What percentage of appointments are cancelled?
-- ============================================================
SELECT
    appointment_status,
    COUNT(*) AS total_appointments, -- We count the rows for each status appointment
    ROUND(COUNT(*) * 100.0 /(SELECT COUNT(*) FROM fact_appointments),2) AS percentage --And divided it for the total of rows to obtain the percentage.
FROM fact_appointments fa 
WHERE appointment_status = 'Cancelled'
GROUP BY appointment_status
ORDER BY percentage DESC;



-- Insight 8:
-- Which insurance type generates the most revenue?
-- ============================================================
SELECT 
	p.insurance_type,
	SUM(fa.consultation_fee) AS revenue
FROM fact_appointments fa
INNER JOIN dim_patients p ON fa.patient_id = p.patient_id
WHERE fa.appointment_status = 'Completed'
GROUP BY p.insurance_type
ORDER BY revenue DESC
LIMIT 1;


-- Insight 9:
-- How many appointments have low, medium, or high waiting times?
-- ============================================================
SELECT
	CASE
		WHEN fa.waiting_minutes >= 20 THEN 'High Wait'
		WHEN fa.waiting_minutes BETWEEN 10 AND 19  THEN 'Medium Wait'
		ELSE 'Low Wait'
	END AS waiting_category,
	COUNT(*) AS total_appointments
FROM fact_appointments fa
WHERE appointment_status = 'Completed'
GROUP BY waiting_category;	


-- Insight 10:
-- Identifies the best-performing doctors within each medical specialty.
-- This query uses chained CTEs:
-- 	1. doctor_revenue calculates revenue by doctor.
-- 	2. ranked_doctors ranks doctors inside each specialty.
-- ============================================================
WITH doctor_revenue AS (
    SELECT
        sp.specialty_name,
        d.doctor_id,
        d.first_name || ' ' || d.last_name AS doctor_name,
        ROUND(SUM(fa.consultation_fee), 2) AS total_revenue -- Calculate the completed appointment's total revenue.
    FROM fact_appointments fa
    INNER JOIN dim_doctors d ON fa.doctor_id = d.doctor_id
    INNER JOIN dim_specialties sp ON d.specialty_id = sp.specialty_id
    WHERE fa.appointment_status = 'Completed'
    GROUP BY sp.specialty_name, d.doctor_id
),
ranked_doctors AS (
    SELECT
        specialty_name,
        doctor_id,
        doctor_name,
        total_revenue,
        RANK() OVER (
        	PARTITION BY specialty_name
            ORDER BY total_revenue DESC) AS revenue_rank -- Makes a total revenue ranking by specialties.
    FROM doctor_revenue
)
SELECT
    specialty_name,
    doctor_name,
    total_revenue,
    revenue_rank
FROM ranked_doctors
ORDER BY specialty_name, revenue_rank;


-- Insight 11:
-- In which months has the highest average appointment fee been recorded?
-- ============================================================
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', da.full_date) AS month_start, --This makes it the first day of every month.
        COUNT(fa.appointment_id) AS completed_appointments, -- Count completed appointments.
        SUM(fa.consultation_fee) AS total_revenue -- Calculate monthly revenue.
    FROM fact_appointments fa
    INNER JOIN dim_dates da ON fa.date_id = da.date_id
    WHERE fa.appointment_status = 'Completed'
    GROUP BY month_start
)
SELECT
    CAST(month_start AS DATE) AS month, -- We converted this from timestamp to date.
    completed_appointments,
    total_revenue,
    ROUND(total_revenue / completed_appointments, 2) AS avg_revenue_per_appointment -- Calculate the monthly total revenue average.
FROM monthly_revenue
ORDER BY avg_revenue_per_appointment DESC;


-- Insight 12:
-- Revenues of each doctor searched by their ID
-- ============================================================
SELECT get_doctor_revenue(2) AS doctor_revenue;