Use loan;
 -- Select all columns for all records
SELECT * FROM loan_data;
-- Select specific columns: loan amount and loan type
SELECT LoanID, LoanType, LoanAmount FROM loan_data;
-- Sort loans by issue date
SELECT * FROM loan_data ORDER BY IssueDate;
-- Filter loans by loan type (e.g., Personal)
SELECT * FROM loan_data WHERE LoanType = 'Personal';
-- Total number of loans
SELECT COUNT(*) AS Total_Loans FROM loan_data;
-- Average loan amount
SELECT AVG(LoanAmount) AS Average_Loan_Amount FROM loan_data;
-- Maximum and minimum loan amounts
SELECT MAX(LoanAmount) AS Max_Loan_Amount, MIN(LoanAmount) AS Min_Loan_Amount FROM loan_data;

-- Create a view for all active loans (Approved status)
CREATE VIEW Active_Loans AS
SELECT * FROM loan_data WHERE LoanStatus = 'Approved';
-- Average loan amount for each loan type
SELECT LoanType, AVG(LoanAmount) AS Average_Loan_Amount
FROM loan_data
GROUP BY LoanType;
-- Customers with loans in more than one category
SELECT CustomerID, COUNT(DISTINCT LoanType) AS Loan_Categories
FROM loan_data
GROUP BY CustomerID
HAVING Loan_Categories > 1;

-- Group loans by region and calculate average loan amount
SELECT Region, AVG(LoanAmount) AS Avg_Loan_Amount
FROM loan_data
GROUP BY Region;
-- Filter regions with average loan amounts above a certain threshold
SELECT Region, AVG(LoanAmount) AS Avg_Loan_Amount
FROM loan_data
GROUP BY Region
HAVING AVG(LoanAmount) > 50000;
-- Create a temporary table to calculate payment schedules
CREATE TEMPORARY TABLE Payment_Schedule AS
SELECT LoanID, LoanAmount, MonthlyPayment, LoanAmount / MonthlyPayment AS Months_To_Repay
FROM loan_data
WHERE MonthlyPayment != 0;

-- Running total of loan amounts issued
SELECT LoanID, LoanAmount, 
SUM(LoanAmount) OVER (ORDER BY IssueDate) AS Running_Total_Loan_Amount
FROM loan_data;
-- Rank loans within each type by size
SELECT LoanID, LoanType, LoanAmount, 
RANK() OVER (PARTITION BY LoanType ORDER BY LoanAmount DESC) AS Loan_Rank
FROM loan_data;

### Automation of Data Processes Stored procedure for loan status updates:
DELIMITER $$

CREATE PROCEDURE Update_Loan_Status()
BEGIN
   UPDATE loan_data 
   SET LoanStatus = 'Delinquent' 
   WHERE PaymentStatus = 'Unpaid';
END $$

DELIMITER ;