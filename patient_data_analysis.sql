CREATE DATABASE IF NOT EXISTS healthcare;
USE healthcare;

DROP TABLE IF EXISTS patients_data;

CREATE TABLE patients_data (
    Age INT,
    Gender VARCHAR(20),
    `Medical Condition` VARCHAR(100),
    Glucose FLOAT,
    `Blood Pressure` FLOAT,
    BMI FLOAT,
    `Oxygen Saturation` FLOAT,
    LengthOfStay INT,
    Cholesterol FLOAT,
    Triglycerides FLOAT,
    HbA1c FLOAT,
    Smoking TINYINT,
    Alcohol TINYINT,
    `Physical Activity` FLOAT,
    `Diet Score` FLOAT,
    `Family History` TINYINT,
    `Stress Level` FLOAT,
    `Sleep Hours` FLOAT,
    random_notes TEXT,
    noise_col FLOAT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patients_data.csv'
INTO TABLE patients_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @Age,
    @Gender,
    @MedicalCondition,
    @Glucose,
    @BloodPressure,
    @BMI,
    @OxygenSaturation,
    @LengthOfStay,
    @Cholesterol,
    @Triglycerides,
    @HbA1c,
    @Smoking,
    @Alcohol,
    @PhysicalActivity,
    @DietScore,
    @FamilyHistory,
    @StressLevel,
    @SleepHours,
    @random_notes,
    @noise_col
)
SET
    Age = NULLIF(@Age, ''),
    Gender = NULLIF(@Gender, ''),
    `Medical Condition` = NULLIF(@MedicalCondition, ''),
    Glucose = NULLIF(@Glucose, ''),
    `Blood Pressure` = NULLIF(@BloodPressure, ''),
    BMI = NULLIF(@BMI, ''),
    `Oxygen Saturation` = NULLIF(@OxygenSaturation, ''),
    LengthOfStay = NULLIF(@LengthOfStay, ''),
    Cholesterol = NULLIF(@Cholesterol, ''),
    Triglycerides = NULLIF(@Triglycerides, ''),
    HbA1c = NULLIF(@HbA1c, ''),
    Smoking = NULLIF(@Smoking, ''),
    Alcohol = NULLIF(@Alcohol, ''),
    `Physical Activity` = NULLIF(@PhysicalActivity, ''),
    `Diet Score` = NULLIF(@DietScore, ''),
    `Family History` = NULLIF(@FamilyHistory, ''),
    `Stress Level` = NULLIF(@StressLevel, ''),
    `Sleep Hours` = NULLIF(@SleepHours, ''),
    random_notes = NULLIF(@random_notes, ''),
    noise_col = NULLIF(@noise_col, '');

SELECT *
FROM healthcare.patients_data
LIMIT 20;

DROP TABLE IF EXISTS cleaned_patient_data;

CREATE TABLE cleaned_patient_data AS
SELECT *
FROM patients_data;

ALTER TABLE healthcare.cleaned_patient_data
DROP COLUMN random_notes,
DROP COLUMN noise_col;

SET SQL_SAFE_UPDATES = 0;

UPDATE healthcare.cleaned_patient_data
SET `Physical Activity` = 0
WHERE `Physical Activity` < 0;

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS age_pct_null,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS gender_pct_null,
    SUM(CASE WHEN `Medical Condition` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS condition_pct_null,
    SUM(CASE WHEN Glucose IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS glucose_pct_null,
    SUM(CASE WHEN `Blood Pressure` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS bp_pct_null,
    SUM(CASE WHEN BMI IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS bmi_pct_null,
    SUM(CASE WHEN `Oxygen Saturation` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS oxygen_pct_null,
    SUM(CASE WHEN LengthOfStay IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS lengthofstay_pct_null,
    SUM(CASE WHEN Cholesterol IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS cholesterol_pct_null,
    SUM(CASE WHEN Triglycerides IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS triglycerides_pct_null,
    SUM(CASE WHEN HbA1c IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS hba1c_pct_null,
    SUM(CASE WHEN Smoking IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS smoking_pct_null,
    SUM(CASE WHEN Alcohol IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS alcohol_pct_null,
    SUM(CASE WHEN `Physical Activity` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS physical_activity_pct_null,
    SUM(CASE WHEN `Diet Score` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS diet_pct_null,
    SUM(CASE WHEN `Family History` IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100.0 AS family_history_pct_null
FROM healthcare.cleaned_patient_data;

SELECT COUNT(*) AS rows_missing_all_five
FROM healthcare.cleaned_patient_data
WHERE Age IS NULL
  AND Gender IS NULL
  AND `Medical Condition` IS NULL
  AND Glucose IS NULL
  AND `Blood Pressure` IS NULL;

UPDATE healthcare.cleaned_patient_data
SET Age = (
    SELECT avg_val
    FROM (
        SELECT ROUND(AVG(Age), 0) AS avg_val
        FROM healthcare.cleaned_patient_data
        WHERE Age IS NOT NULL
    ) t
)
WHERE Age IS NULL;

UPDATE healthcare.cleaned_patient_data
SET Gender = 'Unknown'
WHERE Gender IS NULL;

UPDATE healthcare.cleaned_patient_data
SET `Medical Condition` = 'Unknown'
WHERE `Medical Condition` IS NULL;

UPDATE healthcare.cleaned_patient_data
SET Glucose = (
    SELECT avg_val
    FROM (
        SELECT ROUND(AVG(Glucose), 0) AS avg_val
        FROM healthcare.cleaned_patient_data
        WHERE Glucose IS NOT NULL
    ) t
)
WHERE Glucose IS NULL;

UPDATE healthcare.cleaned_patient_data
SET `Blood Pressure` = (
    SELECT avg_val
    FROM (
        SELECT ROUND(AVG(`Blood Pressure`), 0) AS avg_val
        FROM healthcare.cleaned_patient_data
        WHERE `Blood Pressure` IS NOT NULL
    ) t
)
WHERE `Blood Pressure` IS NULL;

SELECT 
    Age,
    Gender,
    `Medical Condition`,
    Glucose,
    `Blood Pressure`,
    BMI,
    `Oxygen Saturation`,
    LengthOfStay,
    Cholesterol,
    Triglycerides,
    HbA1c,
    Smoking,
    Alcohol,
    `Physical Activity`,
    `Diet Score`,
    `Family History`,
    `Stress Level`,
    `Sleep Hours`,
    COUNT(*) AS duplicate_count
FROM healthcare.cleaned_patient_data
GROUP BY 
    Age,
    Gender,
    `Medical Condition`,
    Glucose,
    `Blood Pressure`,
    BMI,
    `Oxygen Saturation`,
    LengthOfStay,
    Cholesterol,
    Triglycerides,
    HbA1c,
    Smoking,
    Alcohol,
    `Physical Activity`,
    `Diet Score`,
    `Family History`,
    `Stress Level`,
    `Sleep Hours`
HAVING COUNT(*) > 1;

SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    AVG(Age) AS avg_age,
    MIN(Glucose) AS min_glucose,
    MAX(Glucose) AS max_glucose,
    AVG(Glucose) AS avg_glucose,
    MIN(`Blood Pressure`) AS min_bp,
    MAX(`Blood Pressure`) AS max_bp,
    AVG(`Blood Pressure`) AS avg_bp,
    MIN(BMI) AS min_bmi,
    MAX(BMI) AS max_bmi,
    AVG(BMI) AS avg_bmi,
    MIN(`Oxygen Saturation`) AS min_o2,
    MAX(`Oxygen Saturation`) AS max_o2,
    AVG(`Oxygen Saturation`) AS avg_o2
FROM healthcare.cleaned_patient_data;

UPDATE healthcare.cleaned_patient_data
SET Glucose = 40
WHERE Glucose < 40;

UPDATE healthcare.cleaned_patient_data
SET Glucose = 300
WHERE Glucose > 300;

UPDATE healthcare.cleaned_patient_data
SET `Blood Pressure` = 200
WHERE `Blood Pressure` > 200;

UPDATE healthcare.cleaned_patient_data
SET BMI = 10
WHERE BMI < 10;

UPDATE healthcare.cleaned_patient_data
SET `Oxygen Saturation` = 70
WHERE `Oxygen Saturation` < 70;

UPDATE healthcare.cleaned_patient_data
SET `Oxygen Saturation` = 100
WHERE `Oxygen Saturation` > 100;

SELECT 
    `Sleep Hours`,
    ROUND(AVG(`Stress Level`), 2) AS avg_stress
FROM healthcare.cleaned_patient_data
GROUP BY `Sleep Hours`
ORDER BY `Sleep Hours`;

SELECT 
    Smoking,
    ROUND(AVG(`Stress Level`), 2) AS avg_stress
FROM healthcare.cleaned_patient_data
GROUP BY Smoking;

SELECT 
    Alcohol,
    ROUND(AVG(`Stress Level`), 2) AS avg_stress
FROM healthcare.cleaned_patient_data
GROUP BY Alcohol;

SELECT 
    CASE 
        WHEN `Stress Level` < 4 THEN 'Low Stress'
        WHEN `Stress Level` BETWEEN 4 AND 7 THEN 'Moderate Stress'
        ELSE 'High Stress'
    END AS stress_group,
    ROUND(AVG(Glucose), 2) AS avg_glucose,
    ROUND(AVG(`Blood Pressure`), 2) AS avg_bp,
    ROUND(AVG(BMI), 2) AS avg_bmi
FROM healthcare.cleaned_patient_data
GROUP BY stress_group;

SELECT 
    CASE 
        WHEN `Physical Activity` < 3 THEN 'Low Activity'
        WHEN `Physical Activity` BETWEEN 3 AND 6 THEN 'Moderate Activity'
        ELSE 'High Activity'
    END AS activity_group,
    ROUND(AVG(Cholesterol), 2) AS avg_cholesterol,
    ROUND(AVG(Triglycerides), 2) AS avg_triglycerides
FROM healthcare.cleaned_patient_data
GROUP BY activity_group;

SELECT 
    CASE 
        WHEN `Diet Score` < 3 THEN 'Poor Diet'
        WHEN `Diet Score` BETWEEN 3 AND 6 THEN 'Moderate Diet'
        ELSE 'Healthy Diet'
    END AS diet_group,
    ROUND(AVG(Cholesterol), 2) AS avg_cholesterol,
    ROUND(AVG(Triglycerides), 2) AS avg_triglycerides
FROM healthcare.cleaned_patient_data
GROUP BY diet_group;

SELECT 
    Smoking,
    ROUND(AVG(Cholesterol), 2) AS avg_cholesterol,
    ROUND(AVG(Triglycerides), 2) AS avg_triglycerides
FROM healthcare.cleaned_patient_data
GROUP BY Smoking;

SELECT 
    Alcohol,
    ROUND(AVG(Cholesterol), 2) AS avg_cholesterol,
    ROUND(AVG(Triglycerides), 2) AS avg_triglycerides
FROM healthcare.cleaned_patient_data
GROUP BY Alcohol;

SELECT 
    CASE
        WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_group,
    ROUND(AVG(HbA1c), 2) AS avg_hba1c
FROM healthcare.cleaned_patient_data
GROUP BY bmi_group;

SELECT 
    CASE 
        WHEN `Diet Score` < 3 THEN 'Poor Diet'
        WHEN `Diet Score` BETWEEN 3 AND 6 THEN 'Moderate Diet'
        ELSE 'Healthy Diet'
    END AS diet_group,
    ROUND(AVG(HbA1c), 2) AS avg_hba1c
FROM healthcare.cleaned_patient_data
GROUP BY diet_group;

SELECT 
    CASE 
        WHEN `Physical Activity` < 3 THEN 'Low Activity'
        WHEN `Physical Activity` BETWEEN 3 AND 6 THEN 'Moderate Activity'
        ELSE 'High Activity'
    END AS activity_group,
    ROUND(AVG(HbA1c), 2) AS avg_hba1c
FROM healthcare.cleaned_patient_data
GROUP BY activity_group;

SELECT 
    `Family History`,
    ROUND(AVG(HbA1c), 2) AS avg_hba1c
FROM healthcare.cleaned_patient_data
GROUP BY `Family History`;