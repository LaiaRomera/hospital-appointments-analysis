-- ============================================================
-- Project: Hospital Appointments & Patient Care Analysis
-- Script: 02_data.sql
-- Purpose: Load sample data into dimension and fact tables.
-- ============================================================



-- ============================================================
-- Load patients
-- ============================================================

INSERT INTO dim_patients (first_name, last_name, gender, birth_date, city, insurance_type, registration_date) VALUES
	('Jonathan', 'Marquez', 'Male', '1985-04-12', 'Madrid', 'Public', '2023-01-10'),
	('Maria', 'Perez', 'Female', '1992-08-25', 'Barcelona', 'Private', '2023-01-15'),
	('Roberto', 'Picasso', 'Male', '1978-11-03', 'Valencia', 'Public', '2023-02-02'),
	('Patricia', 'Cunillera', 'Female', '1965-06-18', 'Seville', 'Private', '2023-02-20'),
	('Miquel', 'Turu', 'Male', '2001-09-30', NULL, 'None', '2023-03-05'),
	('Linda', 'Garcia', 'Female', '1995-12-14', 'Barcelona', 'Public', '2023-03-12'),
	('William', 'Miller', 'Male', '1988-07-07', 'Valencia', 'Private', '2023-04-01'),
	('Elisa', 'Martin', 'Female', '1972-03-22', 'Seville', 'Public', '2023-04-18'),
	('David', 'Rodriguez', 'Male', '1999-10-09', 'Madrid', 'None', '2023-05-03'),
	('Susana', 'Martinez', 'Female', '1981-01-27', 'Barcelona', 'Private', '2023-05-21'),
	('José', 'Hernandez', 'Male', '1969-05-16', 'Valencia', 'Public', '2023-06-10'),
	('Karen', 'Perez', 'Female', '1990-02-11', 'Seville', 'Private', '2023-06-25'),
	('Carlos', 'Gonzalez', 'Male', '1976-09-04', NULL, 'Public', '2023-07-08'),
	('Carla', 'Cuesta', 'Female', '1984-12-29', 'Barcelona', 'None', '2023-07-19'),
	('Mauricio', 'Colmenero', 'Male', '1958-04-02', 'Valencia', 'Public', '2023-08-01'),
	('Inmaculada', 'García', 'Female', '2000-06-13', 'Seville', 'Private', '2023-08-15'),
	('Daniel', 'Lopez', 'Male', '1993-11-21', 'Madrid', 'Public', '2023-09-06'),
	('Berta', 'Puell', 'Female', '1987-05-09', 'Barcelona', 'Private', '2023-09-20'),
	('Mateo', 'Martinez', 'Male', '1979-08-17', 'Valencia', 'None', '2023-10-04'),
	('Sandra', 'Sanchez', 'Female', '1996-03-06', 'Seville', 'Public', '2023-10-22'),
	('Antonio', 'La Vega', 'Male', '1982-07-31', 'Madrid', 'Private', '2023-11-02'),
	('Davinia', 'Perez', 'Female', '1971-01-19', 'Barcelona', 'Public', '2023-11-18'),
	('Manolo', 'Gomez', 'Male', '1998-09-12', 'Valencia', 'None', '2023-12-01'),
	('Carolina', 'Duarte', 'Female', '1989-10-28', 'Seville', 'Private', '2023-12-15'),
	('Agustin', 'Gil', 'Male', '1962-02-07', 'Madrid', 'Public', '2023-12-29');

-- Intentional duplicate inserted for data quality testing.
INSERT INTO dim_patients (first_name, last_name, gender, birth_date, city, insurance_type, registration_date) VALUES
('Sandra', 'Sanchez', 'Female', '1996-03-06', 'Seville', 'Public', '2023-10-22');


-- ============================================================
-- Load specialties
-- ============================================================

INSERT INTO dim_specialties (specialty_name) VALUES
('Cardiology'),
('Neurology'),
('Pediatrics'),
('Dermatology'),
('Orthopedics'),
('General Medicine'),
('Gynecology'),
('Chiropody');



-- ============================================================
-- Load hospitals
-- ============================================================

INSERT INTO dim_hospitals (hospital_name, city, region, hospital_type) VALUES
	('Hospital Central', ' Barcelona', 'Cataluña', 'Public'), -- Intentional leading space to demonstrate data cleaning with TRIM().
	('Hospital Universitario de Valencia', 'Valencia', 'Comunidad Valenciana', 'University'),
	('Quirón','Barcelona', 'Cataluña','Private'),
	('Hospital Regional Santa Catalina','Sevilla','Andalucia','Public'),
	('Hospital del Mar', 'Barcelona', 'Cataluña', 'Private'),
	('Hospital Universitario Central de Asturias','Oviedo', 'Asturias', 'University'),
	('Hospital Regional de Madrid', 'Madrid', 'Madrid', 'Public');



-- ============================================================
-- Load doctors
-- Each doctor is linked to one specialty and one hospital.
-- ============================================================

INSERT INTO dim_doctors (specialty_id, hospital_id, first_name, last_name, hire_date, is_active) VALUES
	(1,1,'Maria','Hernandez', '2018-06-12', TRUE),
	(1,2,'Marta','Fernandez', '2005-12-19', FALSE),
	(2,1,'Pau','Moya', '2023-03-02', TRUE),
	(3,1,'Carlos','Prieto', '2022-06-22', TRUE),
	(7,5,'Paula','Fanegas', '2023-06-01', TRUE),
	(5,7,'Claudia','Perez', '2012-09-25', TRUE),
	(6,3,'Cristian','Galvez', '2009-06-30', TRUE),
	(7,4,'Maria Helena','Gutierrez', '2021-09-05', TRUE),
	(8,6,'José Maria','Fenollosa', '2013-10-15', TRUE),
	(4,1,'Emma','García', '2019-04-18', TRUE),
	(6,2,'Pablo','Antequera', '2008-07-22', TRUE),
	(5,3,'Olivia','Vergara', '2023-10-17', TRUE),
	(4,3,'Daniel','Martínez', '2024-02-20', TRUE);



-- ============================================================
-- Load dates
-- Calendar dimension used for time-based analysis.
-- Each row represents one calendar date.
-- ============================================================

INSERT INTO dim_dates (full_date, year, month, month_name, quarter, day_of_week) VALUES
('2024-01-05', 2024, 1, 'January', 1, 'Friday'),
('2024-01-12', 2024, 1, 'January', 1, 'Friday'),
('2024-01-19', 2024, 1, 'January', 1, 'Friday'),
('2024-02-02', 2024, 2, 'February', 1, 'Friday'),
('2024-02-09', 2024, 2, 'February', 1, 'Friday'),
('2024-02-16', 2024, 2, 'February', 1, 'Friday'),
('2024-03-01', 2024, 3, 'March', 1, 'Friday'),
('2024-03-08', 2024, 3, 'March', 1, 'Friday'),
('2024-03-15', 2024, 3, 'March', 1, 'Friday'),
('2024-04-05', 2024, 4, 'April', 2, 'Friday'),
('2024-04-12', 2024, 4, 'April', 2, 'Friday'),
('2024-04-19', 2024, 4, 'April', 2, 'Friday'),
('2024-05-03', 2024, 5, 'May', 2, 'Friday'),
('2024-05-10', 2024, 5, 'May', 2, 'Friday'),
('2024-05-17', 2024, 5, 'May', 2, 'Friday'),
('2024-06-07', 2024, 6, 'June', 2, 'Friday'),
('2024-06-14', 2024, 6, 'June', 2, 'Friday'),
('2024-06-21', 2024, 6, 'June', 2, 'Friday'),
('2024-07-05', 2024, 7, 'July', 3, 'Friday'),
('2024-07-12', 2024, 7, 'July', 3, 'Friday'),
('2024-07-19', 2024, 7, 'July', 3, 'Friday'),
('2024-08-02', 2024, 8, 'August', 3, 'Friday'),
('2024-08-09', 2024, 8, 'August', 3, 'Friday'),
('2024-08-16', 2024, 8, 'August', 3, 'Friday'),
('2024-09-06', 2024, 9, 'September', 3, 'Friday'),
('2024-09-13', 2024, 9, 'September', 3, 'Friday'),
('2024-09-20', 2024, 9, 'September', 3, 'Friday'),
('2024-10-04', 2024, 10, 'October', 4, 'Friday'),
('2024-10-11', 2024, 10, 'October', 4, 'Friday'),
('2024-10-18', 2024, 10, 'October', 4, 'Friday');




-- ============================================================
-- Load fact_appointments
-- Each row represents a medical appointment.
-- ============================================================

INSERT INTO fact_appointments (patient_id,doctor_id,date_id,appointment_status,consultation_fee,waiting_minutes,appointment_duration_minutes,satisfaction_score) VALUES
	(1, 1, 1, 'Completed', 120.00, 15, 30, 5),
	(2, 2, 1, 'Completed', 150.00, 25, 40, 4),
	(3, 3, 2, 'Completed', 100.00, 10, 25, 5),
	(4, 4, 2, 'Cancelled', NULL, NULL, NULL, NULL),
	(5, 5, 3, 'No-show', NULL, NULL, NULL, NULL),
	(6, 6, 3, 'Completed', 90.00, 20, 30, 4),
	(7, 7, 4, 'Completed', 130.00, 35, 45, 3),
	(8, 8, 4, 'Scheduled', NULL, NULL, NULL, NULL),
	(9, 9, 5, 'Completed', 160.00, 12, 35, 5),
	(10, 10, 5, 'Completed', 110.00, 18, 25, 4),
	(11, 11, 6, 'Completed', 80.00, 8, 20, 5),
	(12, 12, 6, 'Cancelled', NULL, NULL, NULL, NULL),
	(13, 1, 7, 'Completed', 125.00, 22, 30, 4),
	(14, 2, 7, 'Completed', 155.00, 30, 40, 3),
	(15, 3, 8, 'Completed', 105.00, 15, 25, 5),
	(16, 4, 8, 'No-show', NULL, NULL, NULL, NULL),
	(17, 5, 9, 'Completed', 95.00, 40, 30, 3),
	(18, 6, 9, 'Completed', 100.00, 17, 35, 4),
	(19, 7, 10, 'Cancelled', NULL, NULL, NULL, NULL),
	(20, 8, 10, 'Completed', 135.00, 28, 45, 4),
	(21, 9, 11, 'Completed', 170.00, 20, 50, 5),
	(22, 10, 11, 'Completed', 115.00, 14, 30, 4),
	(23, 11, 12, 'Completed', 85.00, 10, 20, 5),
	(24, 12, 12, 'Scheduled', NULL, NULL, NULL, NULL),
	(25, 1, 13, 'Completed', 120.00, 16, 30, 4),
	(1, 2, 13, 'Completed', 150.00, 25, 40, 5),
	(2, 3, 14, 'Completed', 100.00, 12, 25, 4),
	(3, 4, 14, 'Cancelled', NULL, NULL, NULL, NULL),
	(4, 5, 15, 'Completed', 95.00, 38, 30, 3),
	(5, 6, 15, 'Completed', 90.00, 19, 30, 4),
	(6, 7, 16, 'Completed', 130.00, 33, 45, 4),
	(7, 8, 16, 'No-show', NULL, NULL, NULL, NULL),
	(8, 9, 17, 'Completed', 165.00, 21, 50, 5),
	(9, 10, 17, 'Completed', 110.00, 15, 25, 4),
	(10, 11, 18, 'Completed', 80.00, 9, 20, 5),
	(11, 12, 18, 'Cancelled', NULL, NULL, NULL, NULL),
	(12, 1, 19, 'Completed', 125.00, 18, 30, 4),
	(13, 2, 19, 'Completed', 150.00, 26, 40, 4),
	(14, 3, 20, 'Completed', 100.00, 13, 25, 5),
	(15, 4, 20, 'Scheduled', NULL, NULL, NULL, NULL);





