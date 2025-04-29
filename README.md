# 📚 Library Management SQL Project

## Overview

This SQL project demonstrates the use of **advanced SQL queries** and **stored procedures** for managing a library system. It covers key tasks including tracking overdue books, managing book returns, generating performance reports, and automating book issue processes.

---

## 📌 Tasks & Descriptions

### ✅ Task 1: Identify Members with Overdue Books
- Identifies members who have not returned books within 30 days.
- Returns: `member_id`, `member_name`, `book_title`, `issued_date`, and `days_overdue`.

### ✅ Task 2: Update Book Status on Return
- A stored procedure `add_return_records`:
  - Inserts return records.
  - Retrieves book details.
  - (Optional enhancement) Updates book status to 'yes'.

### ✅ Task 3: Branch Performance Report
- Creates a report using `CTAS`:
  - Total books issued
  - Total books returned
  - Total revenue per branch
  - Return rate percentage

### ✅ Task 4: Create Active Members Table
- Creates `active_members` table using `CTAS`.
- Includes members who borrowed books in the last 2 months.

### ✅ Task 5: Top 3 Employees by Issued Books
- Finds top 3 employees who issued the most books.
- Returns: `employee_name`, `total_issued`, and `branch_id`.

### ✅ Task 6: Issue Book Procedure
- Stored procedure `issue_book`:
  - Checks if book is available.
  - Issues the book and updates status to 'no'.
  - Returns a confirmation or error message.

---

## 💾 Database Tables Used

- `books`: Book details, rental price, availability status.
- `members`: Library members.
- `employees`: Library staff.
- `issued_status`: Records of book issuance.
- `return_status`: Records of book returns.
- `branch`: Branch-level data.

---

## 🚀 Technologies

- SQL (MySQL / MariaDB syntax)
- Stored Procedures
- CTAS (Create Table As Select)
- Conditional Logic
- Aggregations and Joins

---

## 🔧 Future Improvements

- Add **triggers** to auto-update book status on return.
- Create a **dashboard view** for library analytics.
- Add exception handling and logging to procedures.
- Track **damaged vs good** return statistics.
