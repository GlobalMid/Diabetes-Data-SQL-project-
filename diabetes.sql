
-- patients and age only 
SELECT   Patient_id,age
FROM PortfolioProject..Dataset$


-- all female patients who are older than 40. 
SELECT   *
FROM PortfolioProject..Dataset$
WHERE gender = 'Female' AND Age > 40;



-- Average BMI 
SELECT   AVG(bmi) AS Average_BMI
FROM PortfolioProject..Dataset$

-- patients in descending order of blood glucose levels
SELECT   *
FROM PortfolioProject..Dataset$
ORDER BY blood_glucose_level DESC;

-- patient with Hypertension and diabetes 
SELECT *  
FROM PortfolioProject..Dataset$
WHERE hypertension = 1 AND diabetes = 1;

-- Number of Patients with heart diease its showing 0 because we removed them eariler 
SELECT COUNT(*) AS patients_heart_disease_count  
FROM PortfolioProject..Dataset$
WHERE heart_disease = 1 

-- 	Group patients by smoking history and count how many smokers and nonsmokers there are. 
SELECT smoking_history,COUNT(*) AS Count_patients 
FROM PortfolioProject..Dataset$
GROUP BY smoking_history;

-- Patient_ids of patients who have a BMI greater than the average BMI. 
SELECT Patient_id
FROM PortfolioProject..Dataset$
WHERE BMI > (SELECT AVG(bmi) FROM PortfolioProject..Dataset$);



-- Patient with the highest HbA1c level
SELECT TOP 1 *
FROM PortfolioProject..Dataset$
ORDER BY HbA1c_level DESC;


-- Patient with the lowest HbA1c level

SELECT TOP 1 *
FROM PortfolioProject..Dataset$
ORDER BY HbA1c_level ASC;


-- age of patients in years (assuming the current date as of now). getting birthyear of people 

 
SELECT  Patient_id,
    EmployeeName,
	age,
    YEAR(GETDATE()) - age AS EstimatedBirthYear
FROM PortfolioProject..Dataset$

-- Rank patients by blood glucose level within each gender group.
SELECT  Patient_id,
    EmployeeName,
	gender,
	blood_glucose_level,
	RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level DESC) AS GlucoseLevelRank
FROM PortfolioProject..Dataset$

-- Update the smoking history of patients who are older than 50 to "Ex-smoker."
UPDATE PortfolioProject..Dataset$
SET smoking_history = 'Ex-smoker'
WHERE Age > 50;

-- Insert a new patient into the database with sample data
INSERT INTO PortfolioProject..Dataset$ (EmployeeName, gender, age, blood_glucose_level, smoking_history)
VALUES ('John Doe', 'Male', 35, 110, 'Non-smoker');



-- Delete all patients with heart disease from the database
DELETE FROM PortfolioProject..Dataset$
WHERE heart_disease = '1';




-- patients who have hypertension but not diabetes using the EXCEPT operator
SELECT  Patient_id
FROM PortfolioProject..Dataset$
where hypertension = '1';

EXCEPT

SELECT  Patient_id
FROM PortfolioProject..Dataset$
where diabetes = '1';

-- without EXCEPT as it doesnt seem to work on Micrsoft SQL server 
SELECT Patient_id
FROM PortfolioProject..Dataset$
WHERE Hypertension = '1'
AND NOT EXISTS (
    SELECT 1
    FROM PortfolioProject..Dataset$
    WHERE Diabetes = '1'
    AND Patient_id = Dataset$.Patient_id
);

-- another method fpr EXPECT one 
SELECT Patient_id
FROM PortfolioProject..Dataset$
WHERE Hypertension = '1'
AND Patient_id NOT IN (
    SELECT Patient_id
    FROM PortfolioProject..Dataset$
    WHERE Diabetes = '1'
);

-- Define a unique constraint on the "patient_id" column to ensure its values are unique.

ALTER TABLE PortfolioProject..Dataset$
ADD CONSTRAINT UQ_PatientID UNIQUE (patient_id);


--  a view that displays the Patient_ids, ages, and BMI of patients.
CREATE VIEW PatientView AS
SELECT Patient_id, age, bmi
FROM PortfolioProject..Dataset$;

SELECT * FROM PatientView;