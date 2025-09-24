--Due to messy data, import data as text.
--create table
CREATE TABLE messy_employee_data(
	    id TEXT,
	    full_name TEXT,
	    email TEXT,
	    phone TEXT,
	    department TEXT,
	    join_date TEXT,
	    salary TEXT,
	    city TEXT);

-- This is run in PSQL TOOL WORKSPACE
-- Employee_data_EDA=# \copy messy_employee_data FROM 'C:\Users\my pc\OneDrive\Desktop\SQL\Data Cleaning and EDA\messy_employee_data.csv' DELIMITER
-- ',' CSV HEADER;
-- COPY 100
-- Employee_data_EDA=#

--View table first 10 rows
SELECT *
FROM messy_employee_data
LIMIT 10;

--find all null values in table
SELECT *
FROM messy_employee_data
WHERE id IS NULL
	OR full_name IS NULL
	OR email IS NULL
	OR phone IS NULL
	OR department IS NULL
	OR join_date IS NULL
	OR salary IS NULL
	OR city IS NULL;



--COUNT THAT NULL VALUE ROWS
SELECT COUNT(*) AS TOTAL_NULL_VALUE_ROWS
FROM messy_employee_data
WHERE id IS NULL
	OR full_name IS NULL
	OR email IS NULL
	OR phone IS NULL
	OR department IS NULL
	OR join_date IS NULL
	OR salary IS NULL
	OR city IS NULL;

--TO FIND NULL VALUES PER COLUMNS SO GET WHICH CLUMN IS DIRTIEST
SELECT
    COUNT(*) FILTER (WHERE id IS NULL) AS null_id,
    COUNT(*) FILTER (WHERE full_name IS NULL) AS null_full_name,
    COUNT(*) FILTER (WHERE email IS NULL) AS null_email,
    COUNT(*) FILTER (WHERE phone IS NULL) AS null_phone,
    COUNT(*) FILTER (WHERE department IS NULL) AS null_department,
    COUNT(*) FILTER (WHERE join_date IS NULL) AS null_join_date,
    COUNT(*) FILTER (WHERE salary IS NULL) AS null_salary,
    COUNT(*) FILTER (WHERE city IS NULL) AS null_city
FROM messy_employee_data;

--email and phone is null then no way to indentify person so delete it
DELETE
FROM messy_employee_data
WHERE email IS NULL
	OR phone IS NULL;

--replace null salary with impute values like mean median mode
--here we use mean or average

UPDATE messy_employee_data
SET salary =(SELECT ROUND(AVG(CAST(salary AS INT)))
				FROM messy_employee_data
				WHERE salary ~ '^[0-9]+$')
WHERE salary IS NULL;

-- TO CHECK IF salary column has only numeric values
SELECT id, salary
FROM messy_employee_data
WHERE salary !~ '^[0-9]+$';

--change data type of column into int
ALTER TABLE messy_employee_data
ALTER COLUMN salary TYPE INT
USING salary::INT;

--Basic trim
SELECT 
	TRIM(full_name) AS clean_name
FROM messy_employee_data
LIMIT 10;

--CHANGE IN TABLE
UPDATE messy_employee_data
SET full_name = TRIM(full_name),
	email = TRIM(email),
	department = TRIM(department),
	city = TRIM(city);

SELECT *
FROM messy_employee_data;

--capitalize the first letter of each word (Proper Case) using INITCAP
UPDATE messy_employee_data
SET 
    full_name = INITCAP(full_name),
    department = INITCAP(department),
    city = INITCAP(city);

--EMAIL CLEAN. ALREAY REMOVE EXTRA SPACES BY TRIM
--CONVERT INTO LOWER CASE
UPDATE messy_employee_data
SET email = LOWER(email);

--UPDATE NULL VALUES
UPDATE messy_employee_data
SET email = 'missing@gamil.com'
	WHERE email IS NULL;

UPDATE messy_employee_data
SET email = 'missing@gamil.com'
	WHERE email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

SELECT *
FROM messy_employee_data;

-- Remove non-digit characters
-- [0-9] → digits
-- [^0-9] → any non-digit character
-- 'g' → global replacement
UPDATE messy_employee_data
SET phone = REGEXP_REPLACE(phone, '[^0-9]', '', 'g');

-- Optional: set placeholder for missing phones
UPDATE messy_employee_data
SET phone = '0000000000'
WHERE phone IS NULL OR LENGTH(phone) <> 10;

-- DATE CLEAN UP
-- Replace slashes with dashes
UPDATE messy_employee_data
SET join_date = REPLACE(join_date, '/', '-');

-- Optional: set placeholder date for NULLs
UPDATE messy_employee_data
SET join_date = '2000-01-01'
WHERE join_date IS NULL;

-- Change column type to DATE
ALTER TABLE messy_employee_data
ALTER COLUMN join_date TYPE DATE
USING join_date::DATE;

-- Convert join_date from DD-MM-YYYY to DATE

UPDATE messy_employee_data
SET join_date = CASE
    WHEN join_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(join_date, 'YYYY-MM-DD')
    WHEN join_date ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(join_date, 'DD-MM-YYYY')
    ELSE NULL
END;

SELECT *
FROM messy_employee_data;

--CHANGE DATA TYPE TO DATE
ALTER TABLE messy_employee_data
ALTER COLUMN join_date TYPE DATE
USING join_date::DATE;

