#Create Database

CREATE DATABASE hr_analytics;
USE hr_analytics;

#Total Employees

SELECT COUNT(*) AS total_employees
FROM employee_data;

#Active vs Exited Employees

SELECT EmployeeStatus,
       COUNT(*) AS total_employees
FROM employee_data
GROUP BY EmployeeStatus;

#Department Wise Employees

SELECT DepartmentType,
       COUNT(*) AS total_employees
FROM employee_data
GROUP BY DepartmentType
ORDER BY total_employees DESC;

#Average Employee Rating

SELECT AVG(`Current Employee Rating`) AS avg_rating
FROM employee_data;

#Gender Distribution

SELECT GenderCode,
       COUNT(*) AS total
FROM employee_data
GROUP BY GenderCode;

#State Wise Employees

SELECT State,
       COUNT(*) AS total_employees
FROM employee_data
GROUP BY State
ORDER BY total_employees DESC;

#Employee Engagement Analysis (JOIN)

SELECT e.EmpID,
       e.FirstName,
       e.LastName,
       s.`Engagement Score`
FROM employee_data e
LEFT JOIN employee_engagement_survey_data s
ON e.EmpID = s.`Employee ID`;

#Top 10 Most Engaged Employees

SELECT e.EmpID,
       CONCAT(e.FirstName,' ',e.LastName) AS employee_name,
       s.`Engagement Score`
FROM employee_data e
JOIN employee_engagement_survey_data s
ON e.EmpID=s.`Employee ID`
ORDER BY s.`Engagement Score` DESC
LIMIT 10;

#Average Engagement Score by Department

SELECT e.DepartmentType,
       AVG(s.`Engagement Score`) AS avg_engagement
FROM employee_data e
JOIN employee_engagement_survey_data s
ON e.EmpID=s.`Employee ID`
GROUP BY e.DepartmentType
ORDER BY avg_engagement DESC;

#Training Cost by Program

SELECT `Training Program Name`,
       SUM(`Training Cost`) AS total_cost
FROM training_and_development_data
GROUP BY `Training Program Name`
ORDER BY total_cost DESC;

#Average Training Duration

SELECT AVG(`Training Duration(Days)`) AS avg_days
FROM training_and_development_data;

#Training Outcome Analysis

SELECT `Training Outcome`,
       COUNT(*) AS total
FROM training_and_development_data
GROUP BY `Training Outcome`;

#Highest Training Cost Employees

SELECT `Employee ID`,
       SUM(`Training Cost`) AS total_cost
FROM training_and_development_data
GROUP BY `Employee ID`
ORDER BY total_cost DESC
LIMIT 10;

#CTE Example

WITH avg_score AS
(
    SELECT AVG(`Engagement Score`) AS avg_eng
    FROM employee_engagement_survey_data
)

SELECT e.EmpID,
       e.FirstName,
       s.`Engagement Score`
FROM employee_data e
JOIN employee_engagement_survey_data s
ON e.EmpID=s.`Employee ID`
CROSS JOIN avg_score
WHERE s.`Engagement Score` > avg_score.avg_eng;

#Window Function (RANK)

SELECT `Employee ID`,
       `Engagement Score`,
       RANK() OVER
       (
           ORDER BY `Engagement Score` DESC
       ) AS engagement_rank
FROM employee_engagement_survey_data;

#ROW_NUMBER()

SELECT `Employee ID`,
       `Training Cost`,
       ROW_NUMBER() OVER
       (
           ORDER BY `Training Cost` DESC
       ) AS row_num
FROM training_and_development_data;

#HAVING Clause

SELECT DepartmentType,
       COUNT(*) AS total_employees
FROM employee_data
GROUP BY DepartmentType
HAVING COUNT(*) > 100;

#View Creation

CREATE VIEW employee_performance_view AS

SELECT EmpID,
       FirstName,
       LastName,
       DepartmentType,
       `Current Employee Rating`
FROM employee_data;

#use it

SELECT * FROM employee_performance_view;

#Business Insight Report (Final Project Query)

SELECT e.DepartmentType,
       COUNT(e.EmpID) AS total_employees,
       ROUND(AVG(s.`Engagement Score`),2) AS avg_engagement,
       ROUND(AVG(e.`Current Employee Rating`),2) AS avg_rating,
       ROUND(SUM(t.`Training Cost`),2) AS total_training_cost
FROM employee_data e
LEFT JOIN employee_engagement_survey_data s
ON e.EmpID=s.`Employee ID`
LEFT JOIN training_and_development_data t
ON e.EmpID=t.`Employee ID`
GROUP BY e.DepartmentType
ORDER BY avg_engagement DESC;

