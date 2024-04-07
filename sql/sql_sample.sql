-- CREATE DATABASE 
create database db_learning;

-- SET CURRENT DATABASE
use db_learning;

-- CREATE TABLE IN CURRENT DATABASE
--  mysql storage engine is definded as InnoDB

CREATE TABLE history (
id integer ,
author VARCHAR(128),
title VARCHAR(128),
type VARCHAR(16),
year CHAR(4)) ENGINE InnoDB;

DESC history;

INSERT INTO history (id, author, title,type,year)
VALUES (1, "Kumar", "Spring101","Java",2010);

insert into history values(2, "Kumar", "JPA","Java",2011);
insert into history values(3, "Kumar", "KUBERNETIES","Java",2012);
insert into history values(4, "Niranjan", "MONGO","db",2011);
insert into history values(5, "Niranjan", "AngularJs","JavaScript",2015);

select * from history;

alter table history add column sample_column varchar(128);

DESC history;

ALTER table history add index(sample_column);

SHOW INDEX FROM history;

CREATE INDEX sample_column2
ON history (author, title);

SHOW INDEX FROM history;
DROP INDEX sample_column2 ON history;

desc history;

alter table history add column(new_column varchar(128));
desc history;
ALTER TABLE history DROP COLUMN new_column;
desc history;

select * from history;

use db_learning;

DELETE FROM history
WHERE title = 'KUBERNETIES';

-- C:\WINDOWS\system32>cd C:\Program Files\MySQL\MySQL Server 8.0\bin

-- C:\Program Files\MySQL\MySQL Server 8.0\bin>mysqldump -u root -p db_learning history > D:\table_name.sql
-- Enter password: ****

-- table dump
mysqldump -u root -p db_learning history > table_name.sql
 
 -- db dump
 mysqldump -u root -p db_learning history > table_name.sql

mysql -u username -p db_learning < d:\table_name.sql

use db_learning2

show tables

select * from history

Directly from var/www/html

-- without loging into mysql
mysql -u username -p database_name < /path/to/file.sql
-- From within mysql:
mysql> use db_name;
mysql> source backup-file.sql


LOCK TABLES `history` WRITE;
INSERT INTO `history` VALUES (6,'Kumar','Spring10111','Java','2010',NULL,NULL);
UNLOCK TABLES;

select * from history

show databases;

SELECT CURRENT_ROLE();

show grants




-- 'GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION'

-- 'GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION'

-- 'GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION'

CREATE USER 'dev1'@'localhost' IDENTIFIED BY 'dev1pass';
GRANT INSERT ON db_learning.* TO 'dev1'@'localhost';

-- Granting privilages to role
-- CREATE ROLE 'admin'
-- CREATE ROLE 'admin@localhost'
-- DROP ROLE 'admin'
-- DROP ROLE 'admin@localhost'

CREATE ROLE 'admin@localhost';
GRANT SELECT ON db_learning.* TO 'admin@localhost';
GRANT 'admin@localhost' TO 'dev1'@'localhost';


show grants for 'dev1'@'localhost';
show grants for 'admin@localhost';

CREATE ROLE 'admin2@localhost';
SELECT user FROM mysql.user;
   
   
CREATE ROLE 'r1', 'r2';
GRANT SELECT ON db_learning.* TO 'r1';
GRANT INSERT, UPDATE, DELETE ON db_learning.* TO 'r2';
CREATE USER 'u1'@'localhost' IDENTIFIED BY 'u1pass';
GRANT 'r1' TO 'u1'@'localhost';   


REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';
REVOKE 'role1', 'role2' FROM 'user1'@'localhost', 'user2'@'localhost';
REVOKE SELECT ON world.* FROM 'role3';


select title,sum(year) as sum1 from history

-- we can give any delimeter example # , //
DELIMITER #

CREATE PROCEDURE GetAllProducts4()
BEGIN
	SELECT *  FROM history;
END 
#

DELIMITER ;


-- calling a procidure

CALL GetAllProducts4();

 delimiter // 
CREATE TRIGGER agecheck BEFORE INSERT ON history FOR EACH ROW IF NEW.year < 2020 
THEN SET NEW.year = 2020; END IF;// 


SHOW TRIGGERS;

INSERT INTO history (id, author, title,type,year)
VALUES (1, "Kumar", "C#","C#",2010);

select * from history

--Yes, Views automatically update in MySQL; including, but not limited to:

--1)Changing table structures
--Insert/Update/Delete procedures on Tables
--Changing View structures using CREATE OR REPLACE VIEW
--NOTE: Changing a table's structure requires re-creating the View.


drop table t;
mysql> CREATE TABLE t (qty INT, price INT);
mysql> INSERT INTO t VALUES(3, 50), (5, 60);
mysql> CREATE VIEW v AS SELECT qty, price, qty*price AS value FROM t;
mysql> SELECT * FROM v;
INSERT INTO t VALUES(6, 50), (7, 60);

SELECT * FROM v WHERE qty = 5;

-- view is updatable if algorithm is Merge
-- updating view ,updates the original table
CREATE TABLE t1 (c1 INT, c2 INT,c3 INT);
INSERT INTO t1 VALUES(3, 50,100), (5, 60,101),(5, 60,102),(5, 60,103);
select * from t1;
CREATE ALGORITHM = MERGE VIEW v_merge (vc1, vc2) AS
SELECT c1, c2 FROM t1 WHERE c3 > 100;
select * from v_merge;
INSERT INTO t1 VALUES(3, 50,105);
select * from v_merge;
UPDATE v_merge SET vc1 = 11 where vc2 = 60 ;   
select * from v_merge;
select * from t1;                      

-- view is not updatable if algorithm is TEMPTABLE
CREATE ALGORITHM = TEMPTABLE VIEW v_temptable (vc1, vc2) AS
SELECT c1, c2 FROM t1 WHERE c3 > 100;
select * from v_temptable;
INSERT INTO t1 VALUES(4, 70,105),(5, 70,106);
select * from v_temptable;
UPDATE v_temptable SET vc1 = 11 where vc2 = 60 ; 

-- for algo UNDEFINED the view type MERGE is seleceted by default
CREATE ALGORITHM = UNDEFINED VIEW v_undefined (vc1, vc2) AS
SELECT c1, c2 FROM t1 WHERE c3 > 100;
select * from v_undefined;
select * from t1;     
delete from v_undefined where vc2 = 70;

ALTER TABLE table_name RENAME TO new_table_name;
-- mysql transaction
ALTER TABLE salary RENAME TO salary_tbl
CREATE TABLE salary_tbl (empid INT,salary INT,trans_year INT);
INSERT INTO salary_tbl VALUES(1, 5000,2001), (2, 6000,2002),(3, 6050,2003),(4, 7000,2003);
select * from salary_tbl

CREATE TABLE summery (trans_year INT,salary_sum INT);

SET autocommit = 1;  -- 0/1  to disable or enable auto commit
 Insert into summery (trans_year,salary_sum) values (1 ,2003); 
 ROLLBACK;
 select * from summery;
  -- START TRANSACTION  sets autocommit to disable for series on tranaction for current session
truncate summery;  -- drops table and recreates

START TRANSACTION;      
SELECT @A:=SUM(salary) FROM salary_tbl WHERE trans_year=2003;
Insert into summery (trans_year,salary_sum) values ( 2003,@A); 
COMMIT;
ROLLBACK;
select * from summery;


--  find second highest salary in below table dept wise     

DROP TABLE employee
CREATE TABLE employee (empId INT, emp Varchar(255), deptno INT,salary INT);
INSERT INTO employee VALUES(101,"A" ,10,1000), (102,"B" ,10 ,2000),(103,"C" ,10 ,3000),(104,"D",20,7000),
(105,"E" ,20 ,9000),(106,"F" ,20 ,8000),(107,"G" ,30 ,17000),(108,"H" ,30 ,15000),(109,"I" ,30 ,30000),
(110,"J" ,null,null);
select * from employee;



DROP TABLE dept;
CREATE TABLE dept (deptId INT, dempName Varchar(255));
INSERT INTO dept VALUES(10,"Sales"),(20,"Finance"),(30,"Engineering"),(40,"IT");

select * from employee e inner join dept d on e.deptno = d.deptId;
select * from employee e join dept d on e.deptno = d.deptId;
select * from employee e left outer join dept d on e.deptno = d.deptId;
select * from employee e right outer join dept d on e.deptno = d.deptId;

select * from employee e cross join dept d ; 
select * from employee e cross join dept d on e.deptno = d.deptId;

--  full outer join not supported by mysql achived through UNION
SELECT * FROM employee e 
LEFT JOIN  dept d ON  e.deptno = d.deptId
UNION
SELECT * FROM employee e 
RIGHT JOIN  dept d ON  e.deptno = d.deptId

-- below query will return dept no and second highest salary using 
-- corelated subquery
select e1.deptno, max(e1.salary) as maxs
from  employee e1
where e1.salary < (select max(salary)
                  from  employee e2
                  where e2.deptno = e1.deptno
                 )
group by e1.deptno;

-- get employees with second highest salary dipartment wise (if two or more emp has same second highest)
select e3.* from employee e3 join
(select e1.deptno, max(e1.salary) as maxs
from  employee e1
where e1.salary < (select max(salary)
                  from  employee e2
                  where e2.deptno = e1.deptno
                 )
group by e1.deptno
) result  on result.deptno = e3.deptno and result.maxs = e3.salary;


DROP TABLE employee;
DROP TABLE dept;

create table EMPLOYEES(
	 EmpID    char(4) unique Not null,
     Ename    varchar(10),
     Job      varchar(9),
     MGR      char(4),
     Hiredate date,
     Salary   decimal(7,2),
     Comm     decimal(7,2),
     DeptNo   char(2)  not null,
         Primary key(EmpID),
    FOREIGN KEY(MGR)
   REFERENCES EMPLOYEES (EmpID));
   
   
insert into EMPLOYEES values (7839,'King','President',null,'17-11-11',5000,null,10);
insert into EMPLOYEES values (7698,'Blake','Manager',7839,'01-05-11',2850,null,30);
insert into EMPLOYEES values (7782,'Clark','Manager',7839,'02-06-11',2450,null,10);
insert into EMPLOYEES values (7566,'Jones','Manager',7839,'02-04-11',2975,null,20);
insert into EMPLOYEES values (7654,'Martin','Salesman',7698,'28-02-12',1250,1400,30);
insert into EMPLOYEES values (7499,'Allen','Salesman',7698,'20-02-11',1600,300,30);
insert into EMPLOYEES values (7844,'Turner','Salesman',7698,'08-07-11',1500,0,30);
insert into EMPLOYEES values (7900,'James','Clerk',7698,'22-02-12',950,null,30);
insert into EMPLOYEES values (7521,'Ward','Salesman',7698,'22-02-12',1250,500,30);
insert into EMPLOYEES values (7902,'Ford','Analyst',7566,'03-12-11',3000,null,20);
insert into EMPLOYEES values (7369,'Smith','Clerk',7902,'17-12-10',800,null,20);
insert into EMPLOYEES values (7788,'Scott','Analyst',7566,'09-12-12',3000,null,20);
insert into EMPLOYEES values (7876,'Adams','Clerk',7788,'12-01-10',1100,null,20);
insert into EMPLOYEES values (7934,'Miller','Clerk',7782,'23-01-12',1300,null,10);

select count(*) from EMPLOYEES
-- list employee whose manager id given
select e.* from EMPLOYEES e ,EMPLOYEES ee  where e.MGR = ee.EmpID and ee.EmpID ='7839'
select e.* from EMPLOYEES e inner join EMPLOYEES ee on e.MGR =ee.EmpID  where  ee.EmpID ='7839'
select e.* from EMPLOYEES e inner join EMPLOYEES ee on e.MGR =ee.EmpID  and  ee.EmpID ='7839'

-- RANK (), DENSE_RANK (), ROW_NUMBER () these are called window function.
-- These window function are used with Over () clause   
-- Inside over clause we have to use order by   at least with one column.
-- Partition by clause is optional inside Over () clause  
-- RANK() gives you the ranking within your ordered partition. Ties are assigned the same rank, with the next ranking(s) skipped. So, if you have 3 items at rank 2, the next rank listed would be ranked 5.
--DENSE_RANK() again gives you the ranking within your ordered partition, but the ranks are consecutive. No ranks are skipped if there are ranks with multiple items.

SELECT EmpID,Ename,Job,Salary, 
    RANK() OVER(ORDER BY Salary desc) AS rnk,
	DENSE_RANK() OVER(ORDER BY Salary desc) AS dense_rnk,
    ROW_NUMBER() OVER(ORDER BY Salary desc) AS row_num
     FROM  EMPLOYEES
 
 SELECT EmpID,Ename,Job,Salary,rnk FROM (
       SELECT EmpID,Ename,Job,Salary, 
          RANK() OVER(ORDER BY Salary desc) AS rnk,
	      DENSE_RANK() OVER(ORDER BY Salary desc) AS dense_rnk,
          ROW_NUMBER() OVER(ORDER BY Salary desc) AS row_num
		  FROM  EMPLOYEES  
	) ee where ee.rnk=2
     

SELECT EmpID,Ename,Job,Salary, 
    RANK() OVER(partition by Job ORDER BY Salary desc) AS rnk,
	DENSE_RANK() OVER(partition by Job ORDER BY Salary desc) AS dense_rnk,
    ROW_NUMBER() OVER(partition by Job ORDER BY Salary desc) AS row_num
     FROM  EMPLOYEES

-- cann't put where clause in below query  
-- SELECT e.EmpID,e.Ename,e.Salary, 
--     RANK() OVER(ORDER BY Salary desc) AS rnk 
--     FROM  EMPLOYEES e where e.rnk = 1

-- Get Department wise 2nd highest salary (or nth highest salary)
-- ---------------------------------------------------------------------
select EmpID,Ename,Job,Salary,rnk from (
             SELECT EmpID,Ename,Job,Salary,RANK() OVER(partition by Job ORDER BY Salary desc) as rnk 
             FROM EMPLOYEES 
             ) 
    ee where ee.rnk=2
    
    
-- A subquery, or nested query, is a query placed within another SQL query. 
-- When requesting information from a database, you may find it necessary to
--  include a subquery into the SELECT, FROM , JOIN, or WHERE clause.
--  However, you can also use subqueries when updating the database (i.e. in 
--  INSERT, UPDATE, and DELETE statements).   

-- There are several types of SQL subqueries:

-- Scalar subqueries : return a single value, or exactly one row and exactly one column.
-- Multirow subqueries return either:
--      One column with multiple rows (i.e. a list of values), or
--      Multiple columns with multiple rows (i.e. tables).
-- Correlated subqueries, where the inner query relies on information obtained from the outer query. 
 
DROP TABLE employee
CREATE TABLE employee (empId INT, emp Varchar(255), deptno INT,salary INT);
INSERT INTO employee VALUES(101,"A" ,10,1000), (102,"B" ,10 ,2000),(103,"C" ,10 ,3000),(104,"D",20,7000),
(105,"E" ,20 ,9000),(106,"F" ,20 ,8000),(107,"G" ,30 ,17000),(108,"H" ,30 ,15000),(109,"I" ,30 ,30000),
(110,"J" ,null,null);
select * from employee;

DROP TABLE dept;
CREATE TABLE dept (deptId INT, dempName Varchar(255));
INSERT INTO dept VALUES(10,"Sales"),(20,"Finance"),(30,"Engineering"),(40,"IT");


-- employees with below average salary (single value sub query)
SELECT e.*
FROM employee e
WHERE e.salary < (
    SELECT AVG(e2.salary)
    FROM employee e2
);

-- employees who belongs to some department (single coulmn multi value value sub query)
SELECT e.*
FROM employee e
WHERE e.deptno in (
    SELECT d.deptId
    FROM dept d
);

-- employees whose salary is less than dept average (multi coulmn multi value value sub query)
select e.*,deptAvg.avgSal from employee e join (    
 SELECT e2.deptno,AVG(e2.salary) as avgSal
    FROM employee e2 group by e2.deptno ) as deptAvg 
    on deptAvg.deptno = e.deptno and deptAvg.avgSal > e.salary
    
   
   
-- corelated subquery in SELECT 
    
    select d.*,
    (select count(*) as cnt from employee e 
     where e.deptno = d.deptId) 
    from dept d 

-- corelated subquery in WHERE 
SELECT d.*
FROM   dept d
WHERE  EXISTS (SELECT e.*
               FROM   employee e
               WHERE  e.deptno = d.deptid)

SELECT d.*
FROM   dept d
WHERE  NOT EXISTS (SELECT e.*
                   FROM   employee e
                   WHERE  e.deptno = d.deptid) 
     
-- employees whose salary is less than dept average 

SELECT *
FROM   employee e
WHERE  e.salary < (SELECT Avg(e2.salary) AS avgSal
                   FROM   employee e2
                   WHERE  e.deptno = e2.deptno) 
                   
-- dept wise second highest salary                   
    
SELECT e1.deptno,
       Max(e1.salary) AS maxs
FROM   employee e1
WHERE  e1.salary < (SELECT Max(salary)
                    FROM   employee e2
                    WHERE  e2.deptno = e1.deptno)
GROUP  BY e1.deptno; 

-- CORRELATED SELECT :
SELECT column1, column2, ....
FROM table1 outer
WHERE column1 operator
                    (SELECT column1, column2
                     FROM table2
                     WHERE expr1 = 
                               outer.expr2);

-- CORRELATED UPDATE :
UPDATE table1 alias1
 SET column = (SELECT expression 
               FROM table2 alias2
               WHERE alias1.column =
                     alias2.column);
Use a correlated subquery to update rows in one table based on rows from another table.

-- CORRELATED DELETE :
DELETE FROM table1 alias1
 WHERE column1 operator
               (SELECT expression
                FROM table2 alias2
                WHERE alias1.column = alias2.column);
                
 
 
--  SQL | ALL and ANY  Operator

-- ALL operator is used to select all tuples of SELECT STATEMENT. It is also used to compare
--  a value to every value in another value set or result from a subquery.

-- The ALL operator returns TRUE iff all of the subqueries values meet the condition. 
-- The ALL must be preceded by comparison operators and evaluates true if all of the
--  subqueries values meet the condition.
-- ALL is used with SELECT, WHERE, HAVING statement.
                
  SELECT e.* 
     FROM employee e
     WHERE (e.salary) <= ALL (SELECT Max(e2.salary)
                                    FROM employee e2);    
   SELECT e.* 
     FROM employee e
     WHERE (e.salary) <= ALL (SELECT e2.salary
                                    FROM employee e2);                                      
                                    

SELECT ALL e.*
     FROM employee e where true

-- ANY  Operator
-- ANY compares a value to each value in a list or results from a query and evaluates to true if the result of an inner query contains at least one row.
-- ANY return true if any of the subqueries values meet the condition.
-- ANY must be preceded by comparison operators.

  SELECT e.* 
     FROM employee e
     WHERE (e.salary) <= ANY (SELECT MIN(e2.salary)
                                    FROM employee e2);  
    SELECT e.* 
     FROM employee e
     WHERE (e.salary) <= ANY (SELECT e2.salary
                                    FROM employee e2);       
                                    
                                    
--  Second Maximum Salary in MySQL using LIMIT                                   
 SELECT Salary FROM (SELECT e.Salary FROM Employee e ORDER BY e.salary DESC LIMIT 2) AS Emp 
 ORDER BY salary ASC LIMIT 1  
 
--  Second Highest Salary using SQL Server Top Keyword
 SELECT TOP 1 Salary FROM ( SELECT TOP 2 Salary FROM Employee ORDER BY Salary DESC) AS MyTable
 ORDER BY Salary ASC;
 
 
 select e.deptno,AVG(e.salary) as av from employee e group by e.deptno having av > 1000
 
 
-- PARTITION BY Example:
--PARTITION BY allows us to divide the result set into separate partitions based on a specific column, enabling us to perform operations within --each partition. Below is an example that groups employees by the Department column and calculates the number of employees and the total salary within --each partition:

SELECT EmployeeID, EmployeeName, Department, Salary,
       COUNT(*) OVER (PARTITION BY Department) AS EmployeeCount,
       SUM(Salary) OVER (PARTITION BY Department) AS DepartmentSalary
FROM Employees;
                                    

