# 🧹 Employee Data Cleaning & EDA Project

## 📌 Project Overview
This project demonstrates **data cleaning and exploratory data analysis (EDA)** in PostgreSQL using a messy employee dataset.  
The dataset contains **100 rows of inconsistent employee information**, including names, emails, phone numbers, departments, join dates, salaries, and cities.  

The goal is to **clean the data** and perform **analysis** to gain insights about employee distribution, salary trends, and joining patterns.

---

## 📁 Dataset
- File: `messy_employee_data.csv`  
- Columns:
  - `id` – Employee ID  
  - `full_name` – Employee full name  
  - `email` – Employee email  
  - `phone` – Employee phone number  
  - `department` – Department name  
  - `join_date` – Date of joining  
  - `salary` – Salary (numeric)  
  - `city` – City of employee  

> All data initially imported as `TEXT` to handle inconsistencies.

---

## 🛠️ Data Cleaning Steps

### 1️⃣ Trim spaces from text columns
```sql
UPDATE messy_employee_data
SET 
    full_name = TRIM(full_name),
    email = TRIM(email),
    department = TRIM(department),
    city = TRIM(city);
````

### 2️⃣ Capitalize names, departments, and cities

```sql
UPDATE messy_employee_data
SET 
    full_name = INITCAP(full_name),
    department = INITCAP(department),
    city = INITCAP(city),
    email = LOWER(email);
```

### 3️⃣ Clean emails

```sql
UPDATE messy_employee_data
SET email = LOWER(TRIM(email));

UPDATE messy_employee_data
SET email = 'missing@email.com'
WHERE email IS NULL OR email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
```

### 4️⃣ Clean phone numbers

```sql
UPDATE messy_employee_data
SET phone = REGEXP_REPLACE(phone, '[^0-9]', '', 'g');

UPDATE messy_employee_data
SET phone = '0000000000'
WHERE phone IS NULL OR LENGTH(phone) <> 10;
```

### 5️⃣ Clean join\_date

```sql
UPDATE messy_employee_data
SET join_date = CASE
    WHEN join_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(join_date, 'YYYY-MM-DD')
    WHEN join_date ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(join_date, 'DD-MM-YYYY')
    ELSE NULL
END;
```

### 6️⃣ Convert salary to INT

```sql
UPDATE messy_employee_data
SET salary = ROUND(AVG(CAST(salary AS INT)))
WHERE salary !~ '^[0-9]+$' OR salary IS NULL;

ALTER TABLE messy_employee_data
ALTER COLUMN salary TYPE INT
USING salary::INT;
```

### 7️⃣ Remove duplicate rows (keep one)

```sql
DELETE FROM messy_employee_data a
USING messy_employee_data b
WHERE a.full_name = b.full_name
  AND a.email = b.email
  AND a.ctid < b.ctid;
```

---

## 🔎 Exploratory Data Analysis (EDA)

### Basic Overview

```sql
SELECT COUNT(*) AS total_rows FROM messy_employee_data;

SELECT 
    COUNT(DISTINCT full_name) AS unique_names,
    COUNT(DISTINCT email) AS unique_emails,
    COUNT(DISTINCT department) AS unique_departments,
    COUNT(DISTINCT city) AS unique_cities
FROM messy_employee_data;

SELECT * FROM messy_employee_data LIMIT 10;
```

### Salary Analysis

```sql
SELECT 
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(AVG(salary)::NUMERIC, 2) AS avg_salary,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary), 2) AS median_salary,
    ROUND(STDDEV(salary), 2) AS salary_stddev
FROM messy_employee_data;

SELECT department, ROUND(AVG(salary),2) AS avg_salary
FROM messy_employee_data
GROUP BY department
ORDER BY avg_salary DESC;
```

### Employee Distribution

```sql
SELECT department, COUNT(*) AS count
FROM messy_employee_data
GROUP BY department
ORDER BY count DESC;

SELECT city, COUNT(*) AS count
FROM messy_employee_data
GROUP BY city
ORDER BY count DESC;

SELECT EXTRACT(YEAR FROM join_date) AS year_joined, COUNT(*) AS count
FROM messy_employee_data
GROUP BY year_joined
ORDER BY year_joined;
```

### Checking Duplicates & Anomalies

```sql
SELECT full_name, email, COUNT(*) AS count
FROM messy_employee_data
GROUP BY full_name, email
HAVING COUNT(*) > 1;

SELECT * FROM messy_employee_data
WHERE salary < 30000 OR salary > 70000;
```

---

## 📌 Key Notes

* All **text columns** were cleaned using `TRIM()` and `INITCAP()` or `LOWER()`.
* **Phone numbers** and **emails** were standardized.
* **Join dates** were converted to DATE type using `TO_DATE()`.
* **Salary** was converted to numeric for proper calculations.
* **Duplicates** were removed.

After cleaning, the dataset is ready for **analysis, reporting, or visualization**.

---

## 📂 Repository Contents

* `messy_employee_data.csv` → Original dataset
* `data_cleaning.sql` → SQL script for cleaning
* `EDA_queries.sql` → SQL script for all exploratory analysis
* `README.md` → Project documentation

---

## 🛠️ Technologies

* **PostgreSQL** – Database & SQL queries
* **psql** – Command-line interface for executing queries

---

