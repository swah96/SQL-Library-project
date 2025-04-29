-- ADVANCED QUERIES
/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

SELECT 
	i.issued_member_id,
	m.member_name,
	b.book_title,
	i.issued_date,
	r.return_date,
	CURRENT_DATE - i.issued_date AS days_overdue 
FROM 
	issued_status AS i
JOIN 
	members AS m
	ON m.member_id = i.issued_member_id
JOIN 
	books AS b
	ON b.isbn = i.issued_book_isbn
LEFT JOIN 
	return_status AS r
	ON r.issued_id = i.issued_id
WHERE 
	r.return_date IS NULL
AND 
	(CURRENT_DATE - i.issued_date) > 30
ORDER BY 1;

/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when books are returned 
(based on entries in the return_status table).
*/

-- Using Stored Procedures
DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(15),
    IN p_issued_id VARCHAR(15),
    IN p_book_quality VARCHAR(15)
)
BEGIN
-- Declare variables
    DECLARE v_isbn VARCHAR(27);
    DECLARE v_book_name VARCHAR(83);

    -- Insert into return_status
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Fetch ISBN, Book name
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id
    LIMIT 1;

    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END $$

DELIMITER ;

-- Calling Function 
CALL add_return_records('RS119', 'IS135', 'Good');

CALL add_return_records('RS120', 'IS121', 'Damaged');


/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, and the total 
revenue generated from book rentals.
*/

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(DISTINCT i.issued_id) AS total_books_issued,
    COUNT(DISTINCT r.return_id) AS total_books_returned,
    IFNULL(SUM(bk.rental_price), 0) AS total_revenue,
    ROUND((COUNT(DISTINCT r.return_id) / COUNT(DISTINCT i.issued_id)) * 100, 2) AS return_rate_percentage

FROM 
	issued_status AS i
JOIN 
	employees AS e 
    ON e.emp_id = i.issued_emp_id
JOIN 
	branch AS b 
    ON e.branch_id = b.branch_id
LEFT JOIN 
	return_status AS r 
    ON r.issued_id = i.issued_id
JOIN 
	books AS bk 
    ON i.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id
ORDER BY b.branch_id;

SELECT * FROM branch_reports;


/* Task 16: Find Employees with the Most Book Issue
Write a query to find the top 3 employees who have issued the most books. 
Display the employee name, number of books issued, and their branch.
*/

SELECT 
	e.emp_name, 
    COUNT(DISTINCT i.issued_id) AS total_issued, 
    b.branch_id 
FROM 
	employees AS e
JOIN 
	issued_status AS i
	ON i.issued_emp_id = e.emp_id
JOIN 
	branch AS b
	ON b.branch_id = e.branch_id
GROUP BY 1,3


/*
Task 17: Stored Procedure Objective: 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

DELIMITER $$

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_name VARCHAR(100),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    -- Check if the book is available
    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn
    LIMIT 1;

    IF v_status = 'yes' 
    THEN

        -- Insert into issued_status
        INSERT INTO 
			issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
        VALUES 
			(p_issued_id, p_issued_member_id, p_issued_book_name, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        -- Update book status
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Success message
        SELECT 
			CONCAT('Book record added successfully for book ISBN: ', p_issued_book_isbn) AS message;

    ELSE
        -- Error message
        SELECT 
			CONCAT('Sorry, the book you requested is unavailable. Book ISBN: ', p_issued_book_isbn) AS message;
    END IF;

END $$

DELIMITER ;

/* Task 18: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have been issued at least one book in the last 2 months.
*/
DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members
AS
	SELECT 
		DISTINCT m.*
	FROM 
		members m
	JOIN 
		issued_status i 
		ON m.member_id = i.issued_member_id
	WHERE 
		i.issued_date >= DATE_SUB(CURRENT_DATE, INTERVAL 2 MONTH);
        
        
/*Task 19: Identify Members with Poor Books Handling
Write a query to identify members who have returned books more than once with the status "damaged" 
in the books table. Display the member name and the number of times they've returned damaged books.
*/

SELECT 
    m.member_name,
    COUNT(*) AS num_damaged
FROM 
    issued_status i
JOIN 
    members m ON m.member_id = i.issued_member_id
JOIN 
    return_status r ON r.issued_id = i.issued_id
WHERE 
    r.book_quality = 'damaged'
GROUP BY
    m.member_name
HAVING 
    COUNT(*) > 1;
    

/*
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have beenn issued 
but not returned within 30 days. The table should include: The number of overdue books. 
The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. 
The resulting table should show: Member ID Number of overdue books Total fines
*/

CREATE TABLE overdue_fines_summary AS
SELECT 
    m.member_id,
    m.member_name,
    
    -- Total books issued to this member
    COUNT(i.issued_id) AS total_books_issued,
    
    -- Number of overdue books (returned late or not returned yet)
    SUM(
        CASE 
            WHEN r.return_date IS NULL AND CURRENT_DATE - i.issued_date > 30 THEN 1
            ELSE 0
        END
    ) AS num_overdue_books,
    
    -- Total fine for overdue books only
    SUM(
        CASE 
            WHEN r.return_date IS NULL AND CURRENT_DATE - i.issued_date > 30 
            THEN (CURRENT_DATE - i.issued_date - 30) * 0.5
            ELSE 0
        END
    ) AS total_fine
FROM 
    issued_status i
JOIN 
    members m ON m.member_id = i.issued_member_id
LEFT JOIN 
    return_status r ON r.issued_id = i.issued_id
GROUP BY 
    m.member_id, m.member_name;
