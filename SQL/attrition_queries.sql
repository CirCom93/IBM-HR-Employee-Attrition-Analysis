-- =====================================================
-- IBM HR EMPLOYEE ATTRITION ANALYSIS
-- SQL QUERIES ORGANIZED BY POWER BI PAGES
-- =====================================================


-- =====================================================
-- PAGE 1 - HR OVERVIEW / KPI DASHBOARD
-- =====================================================

-- KPI OVERVIEW
SELECT 
    COUNT(Employee_Number) AS Total_Employees,
    ROUND(
        SUM(CASE WHEN Attrition = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
    , 2) AS Attrition_Rate,    
    ROUND(AVG(Monthly_Income), 0) AS Avg_Monthly_Income, 
    ROUND(AVG(Age), 0) AS Avg_Age, 
    ROUND(AVG(Years_At_Company), 0) AS Avg_Years_at_Company 
FROM hr_employee_attrition.csv;


-- ATTRITION OVERVIEW
SELECT 
    Attrition,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Attrition;


-- ATTRITION BY DEPARTMENT
SELECT 
    Department,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
WHERE Attrition = TRUE
GROUP BY Department
ORDER BY Total_Employees DESC;


-- ATTRITION BY JOB ROLE
SELECT 
    Job_Role,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
WHERE Attrition = TRUE
GROUP BY Job_Role
ORDER BY Total_Employees DESC;



-- =====================================================
-- PAGE 2 - EMPLOYEE DEMOGRAPHICS
-- =====================================================

-- AGE DISTRIBUTION
SELECT 
    Age,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Age
ORDER BY Age;


-- GENDER DISTRIBUTION
SELECT 
    Gender,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Gender
ORDER BY Gender;


-- EDUCATION LEVEL DISTRIBUTION
SELECT 
    Education,
    CASE 
        WHEN Education = 1 THEN 'Below College'
        WHEN Education = 2 THEN 'College'
        WHEN Education = 3 THEN 'Bachelor'
        WHEN Education = 4 THEN 'Master'
        ELSE 'Doctor'
    END AS Education_Level,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Education
ORDER BY Education;


-- MARITAL STATUS DISTRIBUTION
SELECT 
    Marital_Status,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Marital_Status
ORDER BY Total_Employees DESC;



-- =====================================================
-- PAGE 3 - ATTRITION DRIVERS ANALYSIS
-- =====================================================

-- OVERTIME VS ATTRITION
SELECT
    Over_Time,
    Attrition,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Over_Time, Attrition
ORDER BY Over_Time, Attrition;


-- JOB SATISFACTION VS ATTRITION
SELECT 
    Job_Satisfaction,
    Attrition,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Job_Satisfaction, Attrition
ORDER BY Job_Satisfaction;


-- WORK LIFE BALANCE VS ATTRITION
SELECT 
    Work_Life_Balance,
    Attrition,
    COUNT(Employee_Number) AS Total_Employees
FROM hr_employee_attrition.csv
GROUP BY Work_Life_Balance, Attrition
ORDER BY Work_Life_Balance;


-- YEARS AT COMPANY VS ATTRITION
WITH years_bands AS (
    SELECT
        CASE 
            WHEN Years_At_Company BETWEEN 0 AND 5 THEN '0-5'
            WHEN Years_At_Company BETWEEN 6 AND 10 THEN '6-10'
            WHEN Years_At_Company BETWEEN 11 AND 15 THEN '11-15'
            WHEN Years_At_Company BETWEEN 16 AND 20 THEN '16-20'
            WHEN Years_At_Company BETWEEN 21 AND 25 THEN '21-25'
            WHEN Years_At_Company BETWEEN 26 AND 30 THEN '26-30'
            WHEN Years_At_Company BETWEEN 31 AND 35 THEN '31-35'
            ELSE '36-40'
        END AS Years_Band,
        CASE 
            WHEN Years_At_Company BETWEEN 0 AND 5 THEN 1
            WHEN Years_At_Company BETWEEN 6 AND 10 THEN 2
            WHEN Years_At_Company BETWEEN 11 AND 15 THEN 3
            WHEN Years_At_Company BETWEEN 16 AND 20 THEN 4
            WHEN Years_At_Company BETWEEN 21 AND 25 THEN 5
            WHEN Years_At_Company BETWEEN 26 AND 30 THEN 6
            WHEN Years_At_Company BETWEEN 31 AND 35 THEN 7
            ELSE 8
        END AS Band_Order,
        Attrition,
        Employee_Number
    FROM hr_employee_attrition.csv
)

SELECT
    Years_Band,
    Attrition,
    COUNT(Employee_Number) AS Total_Employees
FROM years_bands
GROUP BY Years_Band, Band_Order, Attrition
ORDER BY Band_Order;
