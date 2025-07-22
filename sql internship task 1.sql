create database college;
use college;

CREATE TABLE students(
studentid INT PRIMARY KEY,
NAME VARCHAR (50),
deptid int);

INSERT INTO students(studentid, name, deptid) VALUES( 1, 'alice', 12);
INSERT INTO students(studentid, name, deptid) VALUES( 2, 'bobby', 15); 
INSERT INTO students(studentid, name, deptid) VALUES( 3, 'aakash', 18);
INSERT INTO students(studentid, name, deptid) VALUES( 4, 'riva', 20);

CREATE TABLE departments(
deptid INT PRIMARY KEY,
deptname VARCHAR(50)
);

INSERT INTO departments(deptid, deptname)values(10, 'computer sci');
INSERT INTO departments(deptid, deptname)values(20, 'information technology');
INSERT INTO departments(deptid, deptname)values(30, 'cyber security');

-- 1.INNER JOIN

SELECT students.studentid,students.name,departments.deptid
FROM  students
INNER JOIN departments ON students.deptid=departments.deptid;

-- 2.LEFT JOIN

select students.studentid,students.name,departments.deptname
FROM students
LEFT JOIN departments ON students.deptid=departments.deptid;

-- 3.RIGHT JOIN 

SELECT students.studentid,students.name,departments.deptname
FROM students
RIGHT JOIN departments ON students.deptid=departments.deptid;

-- 4.FULL OUTER JOIN

SELECT students.studentid,students.name,depatments.deptname
FROM students
FULL OUTER JOIN departments ON students.deptid=departments.deptid; 
