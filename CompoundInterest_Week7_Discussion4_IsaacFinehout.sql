/* Isaac Finehout
Sunday, July 29, 2024
CMSC 320 6982
Professor Anthony Baird
CompoundInterest_Week7_Discussion4_IsaacFinehout */

-- Drop table
DROP TABLE CDAccounts CASCADE CONSTRAINTS;
COMMIT;

-- Create table
CREATE TABLE CDAccounts (
    AccountID               VARCHAR2(8)     NOT NULL,
    PresentValue            NUMBER(15, 2)   NOT NULL,
    InterestRateCompounded  NUMBER(2, 2)    NOT NULL,
    TimeInYears             NUMBER(2)       NOT NULL,
    EndValue                NUMBER(15, 2)   NOT NULL,
    CONSTRAINT AccountID_PK PRIMARY KEY (AccountID),
    CONSTRAINT chk_time_in_years CHECK (TimeInYears IN (1, 5, 10)),
    CONSTRAINT chk_interest_rate_compounded CHECK (InterestRateCompounded IN (.05, .1, .15)),
    CONSTRAINT chk_present_value CHECK (PresentValue BETWEEN 5000 AND 999000),
    CONSTRAINT chk_end_value CHECK (EndValue BETWEEN 5256.35548187 AND 4477207.38128)
);
COMMIT;

-- Delete Table (unecessary unless populate table is its own file)
/*
DELETE FROM CDAccounts;
COMMIT;
*/

-- Drop sequence
DROP SEQUENCE seq_account;
COMMIT;

-- Populate table
CREATE SEQUENCE seq_account
MINVALUE 000000
MAXVALUE 999999
START WITH 100000
INCREMENT BY 1
CACHE 10
CYCLE;
COMMIT;

-- Declare variables to randomly populate CDTable using PL/SQL
-- SET SERVEROUTPUT ON;
DECLARE
    -- Declare basic variables
    table_size                      NUMBER(4);
    i                               NUMBER(4);
    random_present_value            NUMBER(15, 6);
    random_i                        NUMBER(1);
    end_value                       NUMBER(15, 2);
    -- Declare arrays
    TYPE CDAccountArrayClass IS VARRAY(3) OF NUMBER(5, 2);
    interest_array CDAccountArrayClass := CDAccountArrayClass(.05, .1, .15);
    year_array CDAccountArrayClass := CDAccountArrayClass(1, 5, 10);

BEGIN
    -- The number of rows in the CDAccount table
    table_size := ROUND(DBMS_RANDOM.VALUE(20,1000));
    
    FOR i IN 1..table_size LOOP
        random_present_value := TRUNC(DBMS_RANDOM.VALUE(5000, 999000),2);
        -- Using the ROUND function
        random_i := ROUND(DBMS_RANDOM.VALUE(1, 3));
        -- Using EXP Function
        end_value := random_present_value * EXP(interest_array(random_i) * year_array(random_i));
        -- Insert the random values into the table, uses TO_CHAR Function
        INSERT INTO CDAccounts(AccountID,PresentValue,InterestRateCompounded,TimeInYears,EndValue)
            VALUES('FM' || TO_CHAR(seq_account.NEXTVAL),random_present_value,interest_array(random_i),year_array(random_i),end_value);
        COMMIT;
    END LOOP;
    -- DBMS_OUTPUT.PUT_LINE('Table size: ' || table_size);
END;
/

-- Query Tables using CONCAT Function
SELECT
AccountID AS Account,
CONCAT('$',TO_CHAR(PresentValue, 'FM999,999,999.00')) AS Present,
CONCAT('%',TO_CHAR(InterestRateCompounded * 100, 'FM990.00')) AS Interest,
TimeInYears AS Time,
CONCAT('$',TO_CHAR(EndValue, 'FM999,999,999.00')) AS End
FROM CDAccounts;


-- Query table to find the minimum and maximum start and end values
SELECT MIN(PresentValue) FROM CDAccounts;
SELECT MAX(PresentValue) FROM CDAccounts;
SELECT MIN(EndValue) FROM CDAccounts;
SELECT MAX(EndValue) FROM CDAccounts;

-- Query the table to find the sum of all start and all end values, as well as their difference
SELECT SUM(PresentValue) FROM CDAccounts;
SELECT SUM(EndValue) FROM CDAccounts;
SELECT SUM(EndValue) - SUM(PresentValue) AS DifferenceOfTotalEndAndTotalSum FROM CDAccounts;

-- Query the table to find the average start and end values, as well as the average's difference
SELECT AVG(PresentValue) FROM CDAccounts;
SELECT AVG(EndValue) FROM CDAccounts;