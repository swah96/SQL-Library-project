-- Create Database

CREATE DATABASE library_sql_project;
USE library_sql_project;

-- Create Tables

-- Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
	(
		branch_id VARCHAR(4) NOT NULL PRIMARY KEY
		,manager_id VARCHAR(4) NOT NULL
		,branch_address VARCHAR(50) NOT NULL
		,contact_no VARCHAR(12)  NOT NULL
	);
    
-- Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
	(
		emp_id    VARCHAR(10) NOT NULL PRIMARY KEY
		,emp_name  VARCHAR(26) NOT NULL
		,position  VARCHAR(19) NOT NULL
		,salary    INT NOT NULL
		,branch_id VARCHAR(24) NOT NULL
    );

-- Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books
	(
	   isbn         VARCHAR(20) NOT NULL PRIMARY KEY
	  ,book_title   VARCHAR(73) NOT NULL
	  ,category     VARCHAR(16) NOT NULL
	  ,rental_price FLOAT NOT NULL
	  ,status       VARCHAR(13) NOT NULL
	  ,author       VARCHAR(22) NOT NULL
	  ,publisher    VARCHAR(45) NOT NULL
    );
    
-- Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members
	(
		member_id      VARCHAR(14) NOT NULL PRIMARY KEY
		,member_name    VARCHAR(24) NOT NULL
		,member_address VARCHAR(33) NOT NULL
		,reg_date       DATE  NOT NULL
    );
    
-- Issued_Status Table 
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
	(
		issued_id VARCHAR(15) NOT NULL PRIMARY KEY
		,issued_member_id VARCHAR(14) NOT NULL
		,issued_book_name VARCHAR(83) NOT NULL
		,issued_date      DATE  NOT NULL
		,issued_book_isbn VARCHAR(27) NOT NULL
		,issued_emp_id    VARCHAR(14) NOT NULL
    );

-- Return_status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
    (
		return_id        VARCHAR(15) NOT NULL PRIMARY KEY
		,issued_id        VARCHAR(15) NOT NULL
		,return_book_name VARCHAR(54)
		,return_date      DATE  NOT NULL
		,return_book_isbn VARCHAR(24)
    );
    
-- Adding Foreign Key to Establish Relationship
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);