-- EDA (Exploratory Data Analysis) in SQL
-- Total Overview

-- Total rows
SELECT COUNT(*)
FROM messy_employee_data;

-- Count distinct values per column
SELECT 
    COUNT(DISTINCT full_name) AS unique_names,
    COUNT(DISTINCT email) AS unique_emails,
    COUNT(DISTINCT department) AS unique_departments,
    COUNT(DISTINCT city) AS unique_cities
FROM messy_employee_data;


-- Sample data
SELECT * 
FROM messy_employee_data 
LIMIT 10;

-- Descriptive statistics for numeric columns (only salary)
SELECT 
    MAX(salary) AS max_salary,
	MIN(salary) AS min_salary,
	ROUND(AVG(salary),2) AS average_salary,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)) AS median_salary
FROM messy_employee_data;

-- Total AND AVG salary expenses per dept
SELECT 
    department,
	SUM(salary) AS Total_salary,
	ROUND(AVG(salary),2) AS avg_salary,
	MAX(salary) AS max_salary,
	MIN(salary) AS min_salary
FROM messy_employee_data
GROUP BY department;

-- MAX AND MIN SALARY PER DEPT
SELECT 
    department,
	MAX(salary) AS max_salary,
	MIN(salary) AS min_salary
FROM messy_employee_data
GROUP BY department;
-- Total employee per dept
SELECT 
    department,
	COUNT(*) AS Total_employee
FROM messy_employee_data
GROUP BY department
ORDER BY total_employee DESC;

-- Total employee per city
SELECT 
    city,
	COUNT(*) AS Total_employee
FROM messy_employee_data
GROUP BY city
ORDER BY total_employee DESC;

-- employee joined by year
SELECT 
    EXTRACT(YEAR FROM join_date) AS year,
	COUNT(*) AS Total_employee
FROM messy_employee_data
GROUP BY year
ORDER BY year;

-- latest and earliest joined dates
SELECT 
    MAX(join_date) AS latest_joined_date,
	MIN(join_date) AS earliest_joined_date
FROM messy_employee_data;

-- latest and earliest joined employee details
SELECT *
FROM messy_employee_data
WHERE join_date = '2022-10-25'
	OR join_date = '2000-01-01'
ORDER BY join_date;


-- Duplicate names with same email
SELECT 
	full_name, 
	email, 
	COUNT(*) AS count
FROM messy_employee_data
GROUP BY full_name, email
HAVING COUNT(*) > 1;

-- Unusual salaries (very high or low)
SELECT * 
FROM messy_employee_data
WHERE salary < 30000 
	OR salary > 70000;
