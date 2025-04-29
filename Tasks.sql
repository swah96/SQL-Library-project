-- Project Task

-- Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'Half Of a Yellow Sun', 'Historican Fiction', 20.00, 'yes', 'Chimamanda Ngozi Adichie', '4th Estate'

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-8-53593-805-0', 'Half Of a Yellow Sun', 'Historical Fiction', 20.00, 'yes', 'Chimamanda Adichie', 
'4th Estate');
SELECT * FROM books;

ALTER TABLE books
MODIFY category VARCHAR(50);

-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '145 Golf St'
WHERE member_id = 'C104';
SELECT * FROM members;


-- Task 3: Delete a Record from the Books Table 
-- Objective: Delete the Book with ISBN = '978-1-60129-456-2' from the Books table.

SELECT * FROM books
WHERE isbn = '978-1-60129-456-2';

DELETE FROM books
WHERE isbn = '978-1-60129-456-2';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E104'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E104';

-- Task 5: List Members Who Have Been Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have been issued more than one book.

SELECT i.issued_member_id, m.member_name, COUNT(issued_id) AS books_issued
FROM issued_status AS i
JOIN
members AS m
ON m.member_id = i.issued_member_id
GROUP BY 1, 2
HAVING COUNT(i.issued_id) > 1
ORDER BY 3 desc;

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- of each book and total book_issued_cnt**

DROP TABLE IF EXISTS book_issued_cnt;
CREATE TABLE book_issued_cnt
AS    
SELECT b.isbn, b.book_title, COUNT(i.issued_id) AS no_issued
FROM books AS b
JOIN
issued_status AS i
ON i.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT * FROM book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:

SELECT b.category, SUM(b.rental_price) AS revenue
FROM books AS b
JOIN
issued_status as i
ON i.issued_book_isbn = b.isbn
GROUP BY 1;

-- List Members Who Registered in the Last 180 Days:

SELECT *
FROM members
WHERE reg_date >= DATE_SUB(CURRENT_DATE, INTERVAL 200 DAY);

-- task 10. List Employees with Their Branch Manager's Name and their branch details:

select * from branch;

SELECT 
    e.emp_id AS employee_id,
    e.emp_name AS employee_name,
    b.*,
    em.emp_name AS branch_manager
FROM 
    employees e
JOIN 
    branch b ON e.branch_id = b.branch_id
JOIN 
    employees em ON b.manager_id = em.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

DROP TABLE IF EXISTS books_price_greater_than_seven;
CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7;

SELECT * FROM 
books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT DISTINCT i.issued_book_name
FROM issued_status as i
LEFT JOIN
return_status as r
ON i.issued_id = r.issued_id
WHERE r.return_id IS NULL;

SELECT DISTINCT *
FROM issued_status as i
LEFT JOIN
return_status as r
ON i.issued_id = r.issued_id;