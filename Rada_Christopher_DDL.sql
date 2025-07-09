-- SETTINGS --
-- Turn on echo, serveroutput, linesize, and pagesize
SET ECHO ON;
SET SERVEROUTPUT ON;
SET LINESIZE 150;
SET PAGESIZE 30;
-- SETTINGS --


-- DROPS --
-- Drop all tables for testing purposes and clear project db
DROP TABLE bloodwork;
DROP TABLE lab;
DROP TABLE patient;
DROP TABLE doctor;
DROP TABLE specialty;

-- Uncomment & run if on DBST651 Remote Lab Computer
-- DROP TABLE course;
-- DROP TABLE enrollment;
-- DROP TABLE grade;
-- DROP TABLE grade_conversion;
-- DROP TABLE grade_type;
-- DROP TABLE grate_type_weight;
-- DROP TABLE instructor;
-- DROP TABLE section;
-- DROP TABLE student;
-- DROP TABLE zipcode;

-- Drop sequences for testing
DROP SEQUENCE lab_seq;
DROP SEQUENCE patient_seq;
DROP SEQUENCE specialty_seq;
DROP SEQUENCE doctor_seq;
DROP SEQUENCE bloodwork_seq;
DROP SEQUENCE med_license_seq;
-- DROPS --


-- SEQUENCES --
-- Sequence for all pk's - surrogate keys
CREATE SEQUENCE lab_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE patient_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE specialty_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE doctor_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE bloodwork_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

-- Sequence for natural key in doctor
CREATE SEQUENCE med_license_seq START WITH 1245 INCREMENT BY 5 NOCYCLE;
-- SEQUENCES --


-- TABLES --
CREATE TABLE lab (
  lab_id INT DEFAULT lab_seq.NEXTVAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  address VARCHAR(200) NOT NULL,
  phone_number INT NOT NULL,
  yearly_profit INT NOT NULL
);

CREATE TABLE patient (
  patient_id INT DEFAULT patient_seq.NEXTVAL PRIMARY KEY,
  dob DATE NOT NULL,
  gender VARCHAR(1) CONSTRAINT GenderDomain CHECK (GENDER IN ('M', 'F')) NOT NULL, -- M is male, F is female
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  email VARCHAR(200),
  phone_number VARCHAR(200) NOT NULL
);

CREATE TABLE specialty (
  specialty_id INT DEFAULT specialty_seq.NEXTVAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description VARCHAR(200),
  avg_tuition INT,
  avg_salary INT
);

CREATE TABLE doctor (
  doctor_id INT DEFAULT doctor_seq.NEXTVAL PRIMARY KEY,
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  dob DATE NOT NULL,
  yoe INT NOT NULL, -- years of experience
  med_license INT DEFAULT med_license_seq.NEXTVAL,
  specialty_fk INT,
  FOREIGN KEY (specialty_fk) REFERENCES specialty(specialty_id) ON DELETE SET NULL
);

CREATE TABLE bloodwork (
  bloodwork_id INT DEFAULT bloodwork_seq.NEXTVAL PRIMARY KEY,
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


-- INSERT TABLE DATA --
-- Lab data
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('BloodCorp', '4512 Maple Drive, Oakwood, CA 93514', 4544551454, 30000000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('DiagTest', '8901 Birch Avenue, Springfield, IL 62704', 3451112304, 450000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('TrackQuest', '2134 Pine Street, Rivertown, TX 75201', 4540438942, 750000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Labzone', '6789 Cedar Lane, Greenfield, WI 53220', 0238889090, 1500000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Stealth Health', '4321 Elm Road, Silver Creek, NV 89031', 3403300034, 300000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Blue Hero', '1567 Willow Boulevard, Lakeside, MI 49009', 7678873467, 2000000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('John & Jody', '3286 Cherry Circle, Sunnyside, FL 33603', 9045003445, 25000000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Freedom University', '8954 Aspen Court, Brookfield, OH 44017', 1232344545, 1000000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Clinical Care', '1023 Oakwood Parkway, Millbrook, NY 12545', 9898444569, 40000000);
INSERT INTO lab (name, address, phone_number, yearly_profit) VALUES ('Riskaverse', '7432 Maple Ridge, Highland Park, NJ 08901', 3440065600, 160000);
COMMIT;

-- Patient data
INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1987-01-25', 'M', 'Walker', 'Ethan', 'ethan.walker@example.com', '5551234567');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1995-03-17', 'F', 'Murphy', 'Lily', 'lily.murphy@example.com', '5552345678');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1983-06-29', 'M', 'Reed', 'Noah', 'noah.reed@example.com', '5553456789');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '2000-10-02', 'F', 'Bailey', 'Grace', 'grace.bailey@example.com', '5554567890');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1978-09-14', 'M', 'Jenkins', 'Owen', 'owen.jenkins@example.com', '5555678901');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1990-04-25', 'F', 'Nguyen', 'Ava', 'ava.nguyen@example.com', '5556789012');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1993-01-11', 'M', 'Hughes', 'Liam', 'liam.hughes@example.com', '5557890123');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1985-11-06', 'F', 'Stewart', 'Mia', 'mia.stewart@example.com', '5558901234');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1998-02-18', 'M', 'Wheeler', 'Lucas', 'lucas.wheeler@example.com', '5559012345');

INSERT INTO patient (dob, gender, last_name, first_name, email, phone_number) 
VALUES (DATE '1981-07-09', 'F', 'Gordon', 'Chloe', 'chloe.gordon@example.com', '5550123456');
COMMIT;


-- Specialty data
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Cardiology', 'Specializes in diagnosing and treating heart diseases.', 200000, 400000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Neurology', 'Focuses on disorders of the brain, spinal cord, and nervous system.', 200000, 250000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Orthopedic Surgery', 'Specializes in the treatment of musculoskeletal issues such as bones, joints, and ligaments.', 200000, 500000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Pediatrics', 'Medical care for infants, children, and adolescents.', 200000, 180000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Dermatology', 'Focuses on the diagnosis and treatment of skin, hair, and nail conditions.', 200000, 350000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Psychiatry', 'Specializes in mental health, including diagnosing and treating disorders such as depression, anxiety, and schizophrenia.', 200000, 220000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Obstetrics and Gynecology (OB/GYN)', 'Focuses on women’s health, including pregnancy, childbirth, and reproductive system disorders.', 200000, 280000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Gastroenterology', 'Specializes in the digestive system, including the stomach, intestines, and liver.', 200000, 400000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Endocrinology', 'Deals with disorders of the endocrine system, including diabetes, thyroid conditions, and hormonal imbalances.', 200000, 250000);
INSERT INTO specialty (title, description, avg_tuition, avg_salary) VALUES ('Oncology', 'Specializes in diagnosing and treating cancer, including chemotherapy and radiation.', 200000, 400000);
COMMIT;

-- Doctor data
DECLARE
  cardiology_id INT;
  neurology_id INT;
  orthopedic_id INT;
  pediatrics_id INT;
  dermatology_id INT;
  obgyn_id INT;
  gastroenterology_id INT;
  endocrinology_id INT;
  oncology_id INT;
BEGIN
  SELECT specialty_id INTO cardiology_id FROM specialty WHERE title='Cardiology';
  SELECT specialty_id INTO neurology_id FROM specialty WHERE title='Neurology';
  SELECT specialty_id INTO orthopedic_id FROM specialty WHERE title='Orthopedic Surgery';
  SELECT specialty_id INTO pediatrics_id FROM specialty WHERE title='Pediatrics';
  SELECT specialty_id INTO dermatology_id FROM specialty WHERE title='Dermatology';
  SELECT specialty_id INTO obgyn_id FROM specialty WHERE title='Obstetrics and Gynecology (OB/GYN)';
  SELECT specialty_id INTO gastroenterology_id FROM specialty WHERE title='Gastroenterology';
  SELECT specialty_id INTO endocrinology_id FROM specialty WHERE title='Endocrinology';
  SELECT specialty_id INTO oncology_id FROM specialty WHERE title='Oncology';

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('John', 'Smith', DATE '1982-05-12', 23, cardiology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Emily', 'Johnson', DATE '1978-03-17', 28, neurology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Michael', 'Brown', DATE '1983-06-29', 22, orthopedic_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Sarah', 'Davis', DATE '1975-10-02', 30, pediatrics_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('James', 'Miller', DATE '1980-09-14', 25, oncology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Olivia', 'Wilson', DATE '1985-04-25', 20, dermatology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('David', 'Moore', DATE '1976-01-11', 29, obgyn_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Jessica', 'Taylor', DATE '1984-11-06', 21, endocrinology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Daniel', 'Anderson', DATE '1980-02-18', 26, oncology_id);

  INSERT INTO doctor (first_name, last_name, dob, yoe, specialty_fk) 
  VALUES ('Laura', 'Thomas', DATE '1972-07-09', 33, oncology_id);
  COMMIT;

END;
/

-- Bloodwork data
-- Patient 1's bloodwork history
DECLARE
  first_row_patient_id INT;
  first_row_doctor INT;
  first_row_lab INT;
BEGIN
  SELECT patient_id INTO first_row_patient_id FROM patient WHERE ROWNUM=1;
  SELECT doctor_id INTO first_row_doctor FROM doctor WHERE ROWNUM=1;
  SELECT lab_id INTO first_row_lab FROM lab WHERE ROWNUM=1;

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (250, 190, 25, 180, 0.92, 15.7, DATE '2025-06-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (240, 185, 28, 169, 0.95, 15.3, DATE '2025-07-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (230, 180, 31, 158, 0.91, 15.9, DATE '2025-08-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (220, 175, 34, 147, 0.99, 14.8, DATE '2025-09-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (210, 170, 37, 136, 0.94, 15.2, DATE '2025-10-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (200, 165, 40, 125, 0.98, 14.6, DATE '2025-11-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (190, 160, 43, 114, 0.93, 15.4, DATE '2025-12-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (180, 155, 46, 103, 0.90, 15.1, DATE '2026-01-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (170, 150, 49, 92, 0.97, 14.9, DATE '2026-02-15', first_row_patient_id, first_row_doctor, first_row_lab);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (160, 145, 52, 81, 0.91, 14.7, DATE '2026-03-15', first_row_patient_id, first_row_doctor, first_row_lab);
  COMMIT;

END;
/
-- INSERT TABLE DATA --


-- Functions to randomly select ID's of patient (except first patient in row), doctor, and lab
CREATE OR REPLACE FUNCTION random_patient_id
RETURN INT
IS 
  patient_id INT;
  first_row_patient_id INT;
BEGIN
  SELECT patient_id INTO first_row_patient_id FROM patient WHERE ROWNUM=1;
  SELECT patient_id INTO patient_id
  FROM (
    SELECT patient_id 
    FROM patient 
    WHERE patient_id!=first_row_patient_id
    ORDER BY DBMS_RANDOM.RANDOM)
  WHERE ROWNUM = 1;
  RETURN patient_id;
  DBMS_OUTPUT.PUT_LINE(patient_id);
END;
/

CREATE OR REPLACE FUNCTION random_doctor_id
RETURN INT
IS doctor_id INT;
BEGIN
  SELECT doctor_id INTO doctor_id
  FROM (
    SELECT doctor_id 
    FROM doctor
    ORDER BY DBMS_RANDOM.RANDOM)
  WHERE ROWNUM = 1;
  RETURN doctor_id;
  DBMS_OUTPUT.PUT_LINE(doctor_id);
END;
/

CREATE OR REPLACE FUNCTION random_lab_id
RETURN INT
IS lab_id INT;
BEGIN
  SELECT lab_id INTO lab_id
  FROM (
    SELECT lab_id 
    FROM lab
    ORDER BY DBMS_RANDOM.RANDOM)
  WHERE ROWNUM = 1;
  RETURN lab_id;
  DBMS_OUTPUT.PUT_LINE(lab_id);
END;
/

-- Random bloodwork for the rest of the patients
BEGIN

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (227, 391, 64, 137, 1.12, 17.4, DATE '2024-12-03', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (163, 237, 53, 112, 0.94, 25.3, DATE '2024-03-07', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (291, 480, 76, 183, 1.07, 16.8, DATE '2025-07-19', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (115, 293, 39, 121, 1.01, 28.6, DATE '2025-10-22', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (250, 126, 87, 110, 0.95, 12.9, DATE '2025-11-16', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (139, 376, 59, 159, 1.14, 18.4, DATE '2026-01-05', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (284, 262, 41, 96, 0.82, 19.2, DATE '2026-06-02', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (205, 182, 28, 88, 0.91, 27.5, DATE '2026-08-13', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (175, 123, 49, 172, 1.04, 22.1, DATE '2026-02-18', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (261, 305, 57, 153, 1.08, 13.3, DATE '2026-04-25', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (212, 257, 62, 119, 1.02, 21.7, DATE '2026-08-03', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (236, 426, 22, 107, 0.88, 24.6, DATE '2026-05-15', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (265, 315, 54, 174, 1.13, 10.8, DATE '2026-09-30', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (214, 188, 36, 135, 1.05, 15.4, DATE '2026-11-08', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (276, 442, 64, 133, 0.91, 28.2, DATE '2027-01-19', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (133, 163, 78, 109, 0.97, 11.5, DATE '2027-02-27', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (192, 345, 40, 125, 1.12, 20.6, DATE '2027-07-12', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (281, 208, 67, 150, 0.89, 26.3, DATE '2027-09-09', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (154, 131, 90, 94, 0.96, 24.0, DATE '2027-12-04', random_patient_id, random_doctor_id, random_lab_id);

  INSERT INTO bloodwork (cholesterol, triglycerides, hdl, ldl, creatinine, bun, date_tested, patient_fk, doctor_fk, lab_fk) 
  VALUES (239, 399, 23, 182, 1.09, 14.7, DATE '2027-05-17', random_patient_id, random_doctor_id, random_lab_id);
  COMMIT;

END;
/


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
FLOOR(AVG(FLOOR(MONTHS_BETWEEN(SYSDATE, doctor.dob)/12))) AS "Avg Doctor Age",
FLOOR(AVG(doctor.yoe)) AS "Doctor's Avg Years of Experience",
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


-- DML STATEMENTS --
-- Query 1: Select all columns and all rows from one table 
SELECT * FROM patient;

-- Query 2: Select five columns and all rows from one table 
SELECT cholesterol, triglycerides, hdl, ldl, creatinine FROM bloodwork;

-- Query 3: Select all columns from all rows from one view 
SELECT * FROM doctor_specialty_view;

-- Query 4: Using a join on 2 tables, select all columns and all rows from the tables without the use of a Cartesian product 
SELECT * FROM doctor INNER JOIN specialty ON doctor.specialty_fk=specialty.specialty_id;

-- Query 5: Select and order data retrieved from one table 
SELECT * FROM lab ORDER BY yearly_profit DESC;

-- Query 6: Using a join on 3 tables, select 5 columns from the 3 tables. Use syntax that would limit the output to 10 rows
SELECT patient.first_name ||' '|| patient.last_name AS "Patient", doctor.first_name ||' '|| doctor.last_name AS "Doctor", 
bloodwork.cholesterol, bloodwork.hdl, bloodwork.ldl FROM bloodwork
JOIN patient ON bloodwork.patient_fk=patient.patient_id
JOIN doctor ON bloodwork.doctor_fk=doctor.doctor_id;

-- Query 7: Select distinct rows using joins on 3 tables 
-- Query 8: Use GROUP BY and HAVING in a select statement using one or more tables 
-- Query 9: Use IN clause to select data from one or more tables 
-- Query 10: Select length of one column from one table (use LENGTH function) 
-- Query 11: Delete one record from one table. Use select statements to demonstrate the table contents before and after the DELETE statement. Make sure you use ROLLBACK afterwards so that the data will not be physically removed
-- Query 12: Update one record from one table. Use select statements to demonstrate the table contents before and after the UPDATE statement. Make sure you use ROLLBACK afterwards so that the data will not be physically removed 
-- Perform 8 Additional Advanced Queries 




















-- #1 show all bloodwork with doctor and specialty
SELECT bloodwork.bloodwork_id, CONCAT('Dr.', doctor.last_name) AS "Doctor", specialty.title FROM bloodwork 
JOIN doctor ON bloodwork.doctor_fk=doctor.doctor_id
JOIN specialty ON doctor.specialty_fk=specialty.specialty_id;

-- #2 show bloodwork results with patient order by date tested
SELECT * FROM patient
JOIN bloodwork ON patient.patient_id=bloodwork.patient_fk
ORDER BY bloodwork.date_tested;

-- #3 show all male patients order by dob and who age
SELECT gender, first_name, last_name, dob, FLOOR(MONTHS_BETWEEN(SYSDATE, dob)/12) AS "Age"
FROM patient WHERE gender='M'
ORDER BY dob;

-- #4 show all doctors who have at least 25 years of experience
SELECT doctor.first_name, doctor.last_name, FLOOR(MONTHS_BETWEEN(SYSDATE, dob)/12) AS "Age", 
doctor.yoe, specialty.title, specialty.avg_salary
FROM doctor 
JOIN specialty ON doctor.specialty_fk=specialty.specialty_id
WHERE yoe >= 25 ORDER BY dob DESC;

-- #5 show all labs 

-- DML STATEMENTS --
