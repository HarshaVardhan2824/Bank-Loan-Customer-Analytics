create database finance_project;
use finance_project;

show tables;

DESCRIBE finance_1;
DESCRIBE finance_2;

SELECT * FROM finance_1 LIMIT 5;
SELECT * FROM finance_2 LIMIT 5;

SELECT COUNT(*) FROM finance_1;
SELECT COUNT(*) FROM finance_2;


ALTER TABLE finance_2
ADD PRIMARY KEY (id);


ALTER TABLE finance_1
ADD PRIMARY KEY (id);

SELECT issue_d FROM finance_1 LIMIT 5;

ALTER TABLE finance_1
ADD COLUMN issue_date DATE;

UPDATE finance_1
SET issue_date = STR_TO_DATE(issue_d, '%m/%d/%Y');

SELECT issue_d, issue_date
FROM finance_1
LIMIT 5;

SELECT *
FROM finance_1 f1
INNER JOIN finance_2 f2
ON f1.id = f2.id
LIMIT 5;

SELECT COUNT(*)
FROM finance_1 f1
INNER JOIN finance_2 f2
ON f1.id = f2.id;

-- Creating final cleaned and merged dataset for analysis
CREATE TABLE finance_final AS
SELECT 
    f1.*,
    f2.Delinquencies_Last_2_Years,
    f2.Earliest_Credit_Line_Date,
    f2.Inquiries_Last_6_Months,
    f2.Moths_Since_Last_Dealing,
    f2.mths_since_last_record,
    f2.Open_Accounts,
    f2.Public_Records_Count,
    f2.Revolving_Balance,
    f2.Revolving_Utilization_Ratio,
    f2.Total_Accounts,
    f2.initial_list_status,
    f2.Outstanding_Principal,
    f2.Outstanding_Principal_Investor,
    f2.Total_Payment,
    f2.Total_Payment_Investor,
    f2.Total_Received_Principal,
    f2.Total_Received_Interest,
    f2.Total_Received_Late_Fee,
    f2.recoveries,
    f2.collection_recovery_fee,
    f2.Last_payment_date,
    f2.Last_Payment_Amount,
    f2.Last_Credit_Pull_Date
FROM finance_1 f1
INNER JOIN finance_2 f2
ON f1.id = f2.id;

SELECT COUNT(*) FROM finance_final;
SELECT * FROM finance_final LIMIT 5;

-- Data quality checks: NULL value analysis
SELECT COUNT(*) AS null_annual_inc
FROM finance_final
WHERE annual_inc IS NULL;

SELECT COUNT(*) AS null_dti
FROM finance_final
WHERE Debt_To_Income_Ratio IS NULL;

SELECT COUNT(*) AS null_installment
FROM finance_final
WHERE installment IS NULL;

SELECT COUNT(*) AS null_revolving_util
FROM finance_final
WHERE Revolving_Utilization_Ratio IS NULL;

SELECT COUNT(*) AS null_issue_date
FROM finance_final
WHERE issue_date IS NULL;

SELECT COUNT(*) AS null_last_payment
FROM finance_final
WHERE Last_payment_date IS NULL;

SELECT COUNT(*) AS null_emp_length
FROM finance_final
WHERE emp_length IS NULL;

SELECT COUNT(*) AS null_emp_title
FROM finance_final
WHERE emp_title IS NULL;

-- 1. Year-wise loan amount statistics
-- This query calculates the total loan amount issued each year
-- It helps to analyze loan growth trends over time
SELECT
    YEAR(issue_date) AS year,
    ROUND(SUM(loan_amnt), 2) AS total_loan_amount
FROM finance_final
GROUP BY year
ORDER BY year;

-- 2. Grade and sub-grade wise revolving balance analysis
-- This query calculates the average revolving balance for each grade and sub-grade
-- It helps to understand credit utilization patterns across risk categories
SELECT
    grade,
    sub_grade,
    ROUND(AVG(Revolving_Balance), 2) AS avg_revol_balance
FROM finance_final
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;



-- 3. Total payment comparison based on verification status
-- This query compares total payments made by verified and non-verified customers
-- It helps to analyze repayment behavior based on verification status
SELECT
    verification_status,
    ROUND(SUM(Total_Payment), 2) AS total_payment
FROM finance_final
GROUP BY verification_status;


-- 4. State-wise and last credit pull date wise loan status analysis
-- This query shows loan status distribution across states and credit pull dates
-- It helps to identify regional and time-based loan performance patterns
SELECT
    addr_state,
    Last_Credit_Pull_Date,
    loan_status,
    COUNT(*) AS total_loans
FROM finance_final
GROUP BY addr_state, Last_Credit_Pull_Date, loan_status
ORDER BY addr_state;



-- 5. Home ownership vs last payment date analysis
-- This query analyzes last payment behavior based on home ownership type
-- It helps understand repayment trends among different home ownership categories

SELECT
    home_ownership,
    MAX(Last_payment_date) AS last_payment_date,
    COUNT(*) AS total_loans
FROM finance_final
GROUP BY home_ownership;







