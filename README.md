# Hospital Appointments & Patient Care Analysis


## Project Overview

This project simulates a hospital appointment management system using a dimensional data model. The objective is to analyse patient care, appointment performance, hospital revenue and operational efficiency through SQL.



## Database Structure

```text
hospital-appointments-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_data.sql
│   └── 03_eda.sql
```

The database follows a star schema design:

**Fact Table:**
 - fact_appointments

**Dimension Tables:**
 - dim_patients
 - dim_doctors
 - dim_specialties
 - dim_hospitals
 - dim_dates

**Main Features:**
 - Relational database design
 - Primary and foreign keys
 - Constraints and data validation
 - Indexes for performance optimisation
 - Views for business reporting
 - Custom SQL function
 - Data quality checks
 - Data cleaning processes
 - Exploratory Data Analysis (EDA)
 - Business insights



## Entity Relationship Diagram

```mermaid
erDiagram

    dim_patients ||--o{ fact_appointments : has
    dim_doctors ||--o{ fact_appointments : attends
    dim_dates ||--o{ fact_appointments : scheduled_on
    dim_specialties ||--o{ dim_doctors : includes
    dim_hospitals ||--o{ dim_doctors : employs

    dim_patients {
        int patient_id PK
        varchar first_name
        varchar last_name
        varchar gender
        date birth_date
        varchar city
        varchar insurance_type
        date registration_date
    }

    dim_doctors {
        int doctor_id PK
        int specialty_id FK
        int hospital_id FK
        varchar first_name
        varchar last_name
        date hire_date
        boolean is_active
    }

    dim_specialties {
        int specialty_id PK
        varchar specialty_name
    }

    dim_hospitals {
        int hospital_id PK
        varchar hospital_name
        varchar city
        varchar region
        varchar hospital_type
    }

    dim_dates {
        int date_id PK
        date full_date
        int year
        int month
        varchar month_name
        int quarter
        varchar day_of_week
    }

    fact_appointments {
        int appointment_id PK
        int patient_id FK
        int doctor_id FK
        int date_id FK
        varchar appointment_status
        numeric consultation_fee
        int waiting_minutes
        int appointment_duration_minutes
        int satisfaction_score
        timestamp created_at
    }
```


## SQL Concepts Demonstrated
SELECT
INSERT
UPDATE
DELETE
JOINs
GROUP BY
HAVING
CASE
Subqueries
CTEs
Window Functions
CAST
Date Functions
Transactions
User-defined Functions
Business Insights

Some of the analyses performed include:
 - Revenue by hospital
 - Revenue by specialty
 - Revenue by doctor
 - Patient satisfaction by hospital
 - Patient satisfaction by doctor
 - Appointment status distribution
 - Waiting time analysis
 - Insurance revenue contribution
 - Monthly revenue trends
 - Doctor ranking by specialty


## Technologies
- PostgreSQL
- DBeaver
- SQL


## Project Walkthrough

This project includes a video presentation explaining:

- Database design
- Star schema architecture
- Data quality checks
- Data cleaning process
- Exploratory data analysis
- Business insights
- Advanced SQL features used

Video:
[Watch the Loom presentation](https://www.loom.com/share/b323417e32ed4b6d80650408cf23b7b0)
