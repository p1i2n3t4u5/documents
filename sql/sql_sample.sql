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

