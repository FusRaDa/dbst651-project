-- Turn on echo
SET ECHO ON;

-- Drop all tables for testing purposes and clear project db
DROP TABLE bloodwork;
DROP TABLE lab;
DROP TABLE patient;
DROP TABLE doctor;
DROP TABLE specialty;

DROP TABLE course;
DROP TABLE enrollment;
DROP TABLE grade;
DROP TABLE grade_conversion;
DROP TABLE grade_type;
DROP TABLE grate_type_weight;
DROP TABLE instructor;
DROP TABLE section;
DROP TABLE student;
DROP TABLE zipcode;

-- SEQUENCES --
-- Sequence for all pk's - surrogate keys
CREATE SEQUENCE pk_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
-- Sequence for natural key in doctor
CREATE SEQUENCE med_license_seq START WITH 1245 INCREMENT BY 5 NOCYCLE;
-- SEQUENCES --

-- TABLES --
CREATE TABLE lab (
  lab_id INT DEFAULT pk_seq.NEXTVAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  address VARCHAR(200) NOT NULL,
  phone_number INT NOT NULL
);

CREATE TABLE patient (
  patient_id INT DEFAULT pk_seq.NEXTVAL PRIMARY KEY,
  dob DATE NOT NULL,
  gender VARCHAR(1) CONSTRAINT GenderDomain CHECK (GENDER IN ('M', 'F')) NOT NULL, -- M is male, F is female
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  email VARCHAR(200),
  phone_number VARCHAR(200) NOT NULL
);

CREATE TABLE specialty (
  specialty_id INT DEFAULT pk_seq.NEXTVAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description VARCHAR(200),
  avg_tuition INT,
  avg_salary INT
);

CREATE TABLE doctor (
  doctor_id INT DEFAULT pk_seq.NEXTVAL PRIMARY KEY,
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  dob DATE NOT NULL,
  yoe INT NOT NULL, -- years of experience
  med_license INT DEFAULT med_license_seq.NEXTVAL,
  specialty_fk INT,
  FOREIGN KEY (specialty_fk) REFERENCES specialty(specialty_id)
  ON DELETE SET NULL
);

CREATE TABLE bloodwork (
  bloodwork_id INT DEFAULT pk_seq.NEXTVAL PRIMARY KEY,
  cholesterol FLOAT, --100 to 300
  triglycerides FLOAT, --
  hdl FLOAT, --25 to 150
  ldl FLOAT, --25 to 150
  creatinine FLOAT,
  bun FLOAT,
  date_tested DATE,
  date_submitted DATE DEFAULT CURRENT_DATE,
  patient_fk INT,
  doctor_fk INT,
  lab_fk INT,
  FOREIGN KEY (patient_fk) REFERENCES patient(patient_id) ON DELETE SET NULL,
  FOREIGN KEY (doctor_fk) REFERENCES doctor(doctor_id) ON DELETE SET NULL,
  FOREIGN KEY (lab_fk) REFERENCES lab(lab_id) ON DELETE SET NULL
);
-- TABLES --


-- INDEXES --
CREATE INDEX in_doctor_specialty ON doctor (specialty_fk);
CREATE INDEX in_bloodwork_patient ON bloodwork (patient_fk);
CREATE INDEX in_bloodwork_doctor ON bloodwork (doctor_fk);
CREATE INDEX in_bloodwork_lab ON bloodwork (lab_fk);
-- INDEXES --


-- VIEWS --
-- This view shows all the bloodwork of the first patient in the first row
CREATE OR REPLACE VIEW first_patient_bloodwork_view AS SELECT 
bloodwork.cholesterol AS "Cholestorol (mg/dL)", bloodwork.triglycerides AS "Triglycerides (mg/dL)", 
bloodwork.hdl AS "High Density Lipo-proteins (mg/dL)", bloodwork.ldl AS "Low Density Lipo-proteins (mg/dL)",
bloodwork.creatinine AS "Creatinine (mg/dL)", bloodwork.bun AS "Blood Urea Nitrogen (mg/dL)", 
bloodwork.date_tested AS "Date Tested", CONCAT('Dr. ', doctor.last_name) AS "Doctor", 
lab.name AS "Laboratory" FROM bloodwork 
INNER JOIN patient ON bloodwork.patient_fk=patient.patient_id
INNER JOIN doctor ON bloodwork.doctor_fk=doctor.doctor_id
INNER JOIN lab ON bloodwork.lab_fk=lab.lab_id
WHERE bloodwork.patient_fk=(SELECT patient_id FROM patient WHERE ROWNUM=1);


-- This view shows all specialties that have the avg doctor age, avg years of experience, and the number of bloodwork orders
CREATE OR REPLACE VIEW doctor_specialty_view AS SELECT
specialty.title, 
AVG(FLOOR(MONTHS_BETWEEN(SYSDATE, doctor.dob)/12)) AS "Avg Doctor Age",
AVG(doctor.yoe) AS "Doctor's Avg Years of Experience",
COUNT(bloodwork.date_submitted) AS "Total Bloodwork Orders"
FROM specialty 
INNER JOIN doctor ON specialty.specialty_id=doctor.specialty_fk
INNER JOIN bloodwork ON doctor.doctor_id=bloodwork.doctor_fk
GROUP BY specialty.title;
-- VIEWS --


-- TRIGGERS --
-- This trigger prevents the date tested to be updated in the bloodwork unless all blood results have been filled in
CREATE OR REPLACE TRIGGER confirm_bloodwork_update AFTER UPDATE ON bloodwork FOR EACH ROW
WHEN (NEW.date_tested IS NOT NULL 
AND (NEW.cholesterol IS NULL
OR NEW.cholesterol IS NULL
OR NEW.cholesterol IS NULL
OR NEW.cholesterol IS NULL
OR NEW.cholesterol IS NULL
OR NEW.cholesterol IS NULL))
BEGIN
  DBMS_OUTPUT.PUT_LINE('Bloodwork results must all be filled in before updating test date.');
  ROLLBACK;
END;
/
-- / -> End of first trigger block

--This trigger prevents bloodwork from being updated if the date tested is not null
CREATE OR REPLACE TRIGGER prevent_bloodwork_update AFTER UPDATE ON bloodwork FOR EACH ROW
WHEN (NEW.date_tested IS NOT NULL)
BEGIN
  DBMS_OUTPUT.PUT_LINE('Bloodwork can no longer be updated if date tested has been entered.');
  ROLLBACK;
END;
-- TRIGGERS --
