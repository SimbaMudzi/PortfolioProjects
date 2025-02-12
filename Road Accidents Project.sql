/* UK Road Accidents Data Exploration
Skills Used: Joins, Aggregate Functions, Window Functions, Converting Data Types, Case Statements, CTEs, GroupBY clause, OrderBy clause, Sub Queries
*/

-- Adding accident month field by unding Case Statement, converting and concatenating values

SELECT *, FORMAT(a.Accident_Date,'MMM-yyyy') AS MONTH 
FROM  [dbo].[Accidents] a;


-- Using Joins to pull Accident details


SELECT a.ID
		,a.Accident_Date 
		,FORMAT(a.Accident_Date
		,'MMM-yyyy') AS [MONTH]
		,d.Junction_Control
		,d.Junction_Detail
		,d.Accident_Severity
		,d.Light_Conditions
		,d.Carriageway_Hazards
		,d.Number_of_Casualties
		,d.Number_of_Vehicles
		,d.Police_Force
		,d.Road_Surface_Conditions
		,d.Road_Type
		,d.Speed_limit
		,d.Weather_Conditions
		,d.Vehicle_Type
		,d.Time

FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID;


---Using Aggregate Functions to calculate total number of Casualties BY Year and Local Authority
WITH CTE_ACC AS (

SELECT a.ID
		,a.Accident_Date 
		,FORMAT(a.Accident_Date,'MMM-yyyy') AS [MONTH]
		,YEAR(a.Accident_Date) AS [YEAR] 
		,d.Number_of_Casualties
		,loc.Local_Authority_District
				
FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID
LEFT JOIN [dbo].[Location] loc ON a.ID=loc.ID)

SELECT A.YEAR,A.Local_Authority_District,SUM(a.Number_of_Casualties) Total_Casualties

FROM CTE_ACC a
GROUP BY a.YEAR,a.Local_Authority_District
ORDER BY a.YEAR,Total_Casualties DESC;


---Numbe of Accidents by Month and Junction Type

WITH CTE_ACC AS (

SELECT a.ID
		,a.Accident_Date 
		,FORMAT(a.Accident_Date,'MMM-yyyy') AS [MONTH]
		,d.Junction_Detail
				
FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID)

SELECT a.MONTH,a.Junction_Detail Junction_Type, COUNT(a.ID) Total_Accidents

FROM CTE_ACC a
GROUP BY a.MONTH,a.Junction_Detail
ORDER BY a.MONTH;

--Number of Accidents by Light Conditions

WITH CTE_ACC AS (

SELECT a.ID
		,a.Accident_Date 
		,FORMAT(a.Accident_Date,'MMM-yyyy') AS [MONTH]
		,d.Light_Conditions
				
FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID)

SELECT a.MONTH,a.Light_Conditions, COUNT(a.ID) Total_Accidents

FROM CTE_ACC a
GROUP BY a.MONTH,a.Light_Conditions
ORDER BY a.MONTH

---Number of Cases by Month and Accident Severity

SELECT CORE.MONTH
	,SUM(CORE.N_SERIOUS) N_SERIOUS
	,SUM(CORE.N_SLIGHT) N_SLIGHT
	,SUM(CORE.N_FATAL) N_FATAL
	,SUM(CORE.Total_Cases) TOTAL
	
	FROM(

SELECT a.Accident_Date
		,FORMAT(a.Accident_Date,'MMM-yyyy') AS [MONTH]
		,SUM(CASE WHEN d.Accident_Severity = 'Serious' THEN 1 ELSE 0 END) N_Serious
		,SUM(CASE WHEN d.Accident_Severity = 'Slight' THEN 1 ELSE 0 END) N_Slight
		,SUM(CASE WHEN d.Accident_Severity = 'Fatal' THEN 1 ELSE 0 END) N_Fatal
		,COUNT(a.ID) Total_Cases
		
FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID

GROUP BY d.Accident_Severity,a.Accident_Date) CORE

GROUP BY CORE.MONTH

---- Percentage of Cases by Month and Severity

SELECT CORE.MONTH
	,SUM(CORE.N_SERIOUS) N_SERIOUS
	,SUM(CORE.N_SLIGHT) N_SLIGHT
	,SUM(CORE.N_FATAL) N_FATAL
	,SUM(CORE.Total_Cases) TOTAL
	,SUM(CORE.N_SERIOUS)*100.0/SUM(CORE.Total_Cases) PC_SERIOUS
	,SUM(CORE.N_SLIGHT)*100.0/SUM(CORE.Total_Cases) PC_SLIGHT
	,SUM(CORE.N_FATAL)*100.0/SUM(CORE.Total_Cases) PC_FATAL
		
	FROM(

SELECT a.Accident_Date
		,FORMAT(a.Accident_Date,'MMM-yyyy') AS [MONTH]
		,SUM(CASE WHEN d.Accident_Severity = 'Serious' THEN 1 ELSE 0 END) N_Serious
		,SUM(CASE WHEN d.Accident_Severity = 'Slight' THEN 1 ELSE 0 END) N_Slight
		,SUM(CASE WHEN d.Accident_Severity = 'Fatal' THEN 1 ELSE 0 END) N_Fatal
		,COUNT(a.ID) Total_Cases
		
FROM  [dbo].[Accidents] a
LEFT JOIN [dbo].[Accident Details] d ON a.ID= d.ID

GROUP BY d.Accident_Severity,a.Accident_Date) CORE

GROUP BY CORE.MONTH

--Number of Cases by LA




