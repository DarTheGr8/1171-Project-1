--Darwyne Azueta Project 1 sql
--introduction to database

--drop database if exists
DROP DATABASE IF EXISTS courses;
--create database courses
CREATE DATABASE courses;
--create role coursese
CREATE ROLE courses;
--choose database courses in postgress
\c courses;

--creating tables
CREATE TABLE faculties(
  faculty_id VARCHAR(4) PRIMARY KEY,
  faculty_name VARCHAR(100) NOT NULL,
  faculty_description TEXT NOT NULL
);

CREATE TABLE programs (
  program_id CHAR(4) PRIMARY KEY,
  faculty_id VARCHAR(4),
  program_name VARCHAR(50) NOT NULL,
  program_location VARCHAR(50),
  program_description TEXT NOT NULL,
  FOREIGN KEY (faculty_id)
  REFERENCES faculties (faculty_id)
);

CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  email VARCHAR (50) ,
  instructor_name VARCHAR (50),
  office_location VARCHAR (50),
  telephone CHAR (20),
  degree VARCHAR(5)
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  code CHAR ( 8 ) NOT NULL,
  year INT NOT NULL,
  semester INT NOT NULL,
  section VARCHAR (10) NOT NULL,
  title VARCHAR ( 100 ) NOT NULL,
  credits INT NOT NULL,
  modality VARCHAR ( 50 ) NOT NULL,
  modality_type VARCHAR(20) NOT NULL,
  instructor_id INT NOT NULL,
  class_venue    VARCHAR(100),
  communicatioin_tool    VARCHAR(25),
  course_platform    VARCHAR(25),
  field_trips    VARCHAR(3) check(field_trips in ('Yes','No')),
  resources_required TEXT NOT NULL,
  resources_recommended TEXT NOT NULL,
  resources_other TEXT NOT NULL,
  description TEXT NOT NULL,
  outline_url TEXT NOT NULL,
  UNIQUE (code, year, semester, section),
  FOREIGN KEY (instructor_id)
    REFERENCES instructors (instructor_id)
);

CREATE TABLE pre_requisties(
  course_id INT NOT NULL,
  prereq_id VARCHAR(8) NOT NULL,
  PRIMARY Key(prereq_id,course_id),
  FOREIGN Key(course_id)
   REFERENCES courses (course_id)
);
  

CREATE TABLE courses_programs (
  course_id INT NOT NULL,
  program_id CHAR(4) NOT NULL,
  FOREIGN KEY (program_id)
    REFERENCES programs (program_id),
  FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
);

--importing tables to postgres sql using copy commands
COPY faculties
FROM '/home/darwyne/Downloads/Project1/faculties.csv'
DELIMITER ','
CSV HEADER;

COPY programs
FROM '/home/darwyne/ubuntu/Documents/project1/programs.csv'
DELIMITER ','
CSV HEADER;

COPY instructors
FROM '/home/darwyne/ubuntu/Documents/project1/instructors.csv'
DELIMITER ','
CSV HEADER;

COPY courses
FROM '/home/darwyne/ubuntu/Documents/project1/courses.csv'
DELIMITER ','
CSV HEADER;

COPY pre_requisties
FROM '/home/darwyne/ubuntu/Documents/project1/pre_reqs.csv'
DELIMITER ','
CSV HEADER;

COPY courses_programs
FROM '/home/darwyne/ubuntu/Documents/project1/courses_programs.csv'
DELIMITER ','
CSV HEADER;

--Queries
--3. What are the faculties at ub end in S

SELECT faculty_id, faculty_name
FROM Faculties
WHERE faculty_id
LIKE '%S';

--4. What prog are offeren in belize

SELECT program_id, program_name, program_location
FROM Programs
WHERE program_location = 'Belize City';

--5. What progs does ms vernelle offer

SELECT C.course_id, C.code, C.year, C.semester, C.section, C.title AS course_name, I.instructor_id, I.instructor_name
FROM Courses AS C
JOIN Instructors AS I
ON C.instructor_id = I.instructor_id
WHERE I.instructor_name = 'Vernelle Sylvester'
GROUP BY C.course_id, I.instructor_id;

--6. Which instructors have a masters degree

SELECT instructor_id, instructor_name, degree
FROM Instructors
WHERE degree = 'M.Sc.';

--7. What are prerequisites for programming2

SELECT C.course_id, C.code, C.title, P.prerequisite_id
FROM Courses AS C
JOIN pre_requisites AS P
ON C.course_id = P.course_id
WHERE C.title = 'Priciples of Programming 2';

--8. List the code, year, semester, section and title for all courses.

SELECT code, year, semester, section, title
FROM courses;


--9. list the program_name and code, year, semester section and title for all courses in the AINT program.

SELECT P.program_id, P.program_name, C.code, C.year, C.semester, C.section, C.title AS course_name
FROM programs AS P
JOIN courses_programs AS CP
ON P.program_id = CP.program_id
JOIN courses AS C
ON CP.course_id = C.course_id 
WHERE P.program_id = 'AINT';

--10. List the faculty_name and code, year, semester section and title for all courses offered by FST. *hint join 4 tables

SELECT F.faculty_id, F.faculty_name, C.year, C.semester, C.section, C.title AS course_name
FROM faculties AS F
JOIN programs AS P
ON F.faculty_id = P.faculty_id
JOIN courses_programs AS CP
ON P.program_id = CP.program_id
JOIN courses AS C
ON CP.course_id = C.course_id
WHERE F.faculty_id = 'FST';
