
-- (*) Data Defenition Language (DDL)

-- 1) Create

-- Db Level
CREATE DATABASE dbTest1;

IF NOT Exists(SELECT * FROM sys.databases WHERE Name = 'dbTest2')
BEGIN
CREATE DATABASE dbTest2;
END;


-- Table Level
USE dbTest1

CREATE TABLE testTable(
testID int PRIMARY KEY,
testName nvarchar(100) NOT NULL,
);



-- 2) Drop

-- DB Level
DROP DATABASE dbTest2;

IF EXISTS(Select * From sys.databases Where Name = 'KOKO')
Begin
DROP DATABASE KOKO
End;

-- Table Level
Use dbTest1
Drop Table testTable;



-- 3) Alter

-- A) Add Column
Alter Table testTable
Add Status nvarchar(50) NOT NULL;

-- B) Rename
----Alter Table testTable
----Rename Column Status to testStatus;

-- Column Level
exec sp_rename 'testTable.Status', 'testStatus', 'Column';

-- Table Level

--Alter Table testTable
--Rename TestTable to testTable;
exec sp_rename 'TestTable', 'testTable';

-- C) Modify Column
Alter Table testTable 
Alter Column testStatus nvarchar(100) NULL;

-- D) Delete Column
Alter Table testTable 
Drop Column testStatus;

-- Note: we only use the keyword 'Column' in the modify and delete commands



-- 4) Identity Field (Auto Number)

use dbtest1
Create Table Departments
(
DepartmentID int Identity(1,1) PRIMARY KEY, -- this is how you identify an identity field
DepartmentName nvarchar(200) NOT NULL
);

Select * From Departments;

Alter Table Departments
Add Constraint UQ_DepartmentName
Unique(DepartmentName);

Insert Into Departments
values
('Engineering');

Insert Into Departments
values
('IT');


Insert Into Departments
values
('HR');

Delete From Departments;

Truncate Table Departments;

Print @@identity; -- stores the last assigned ID

-- 5) Constraints

-- A) PK Constraint
CREATE TABLE Persons (
   ID int NOT NULL PRIMARY KEY,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255),
   Age int
);

-- to allow PK naming: 
CREATE TABLE Persons (
   ID int NOT NULL,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255),
   Age int,
    CONSTRAINT PK_Person PRIMARY KEY (ID,LastName) -- PK is multiple columns instead of just one
);

ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

ALTER TABLE Persons
DROP CONSTRAINT PK_Person;

-- B) FK Constraint
CREATE TABLE Customers
(
CustomerID int Identity(1, 1) PRIMARY KEY,
Name nvarchar(100) NOT NULL
);

CREATE TABLE Orders
(
OrderID int Identity(1, 1) PRIMARY KEY,
orderNumber nvarchar(50),
CustomerID int
FOREIGN KEY (CustomerID) References Customers(CustomerID)
);

-- to allow naming a FK: 
CREATE TABLE Orders (
   OrderID int NOT NULL,
   OrderNumber int NOT NULL,
   PersonID int,
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons(PersonID)
);

ALTER TABLE Orders
ADD FOREIGN KEY (customer_id) REFERENCES Customers(id);

-- to allow naming a FK on alter table:
ALTER TABLE Orders
ADD CONSTRAINT FK_PersonOrder
FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);


ALTER TABLE Orders
DROP CONSTRAINT FK_PersonOrder;


-- C) NOT NULL Constraint
CREATE TABLE Persons (
   ID int NOT NULL,
    LastName varchar(255) NOT NULL,
   FirstName varchar(255) NOT NULL,
   Age int
);

ALTER TABLE Persons
ALTER COLUMN Age int NOT NULL;

-- D) Default Constraint
CREATE TABLE Persons (
   ID int NOT NULL,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255),
   Age int,
   City varchar(255) DEFAULT 'Amman'
);

ALTER TABLE Persons
ADD CONSTRAINT df_City
DEFAULT 'Amman' FOR City;

ALTER TABLE Persons
DROP Constraint  df_City;

-- E) Check Constraint
CREATE TABLE Persons (
   ID int NOT NULL,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255),
   Age int CHECK (Age>=18)
);

CREATE TABLE Persons (
   ID int NOT NULL,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255),
   Age int,
   City varchar(255),
    CONSTRAINT CHK_Person CHECK (Age>=18 AND City='Amman')
);

ALTER TABLE Persons
DROP CONSTRAINT CHK_Person;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- (*) Backup & Restore 

-- A) Full Backup
Backup Database dbTest1
To Disk = 'C:\dbTest1.bak';

-- B) Differential Backup
Backup Database dbTest1
To Disk = 'C:\dbTest1.bak'
With Differential;

-- C) Restore Database
Restore Database dbtest1
From Disk = 'C:\dbTest1.bak';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- (*) Data Manipulation Language (DML)

Select * From testTable;

-- 1) Insert

-- Insert one record at a time
Insert Into testTable
values (1, 'test1', 'Checked');

--Insert one record at a time with some null values
Insert Into testTable
values (2, 'test2', NULL);

--insert multiple records at a time.
Insert Into testTable 
values
(3, 'test3', 'unchecked'),
(4, 'test3', 'unchecked'),
(5, 'test3', 'unchecked'),
(10, 'test3', 'unchecked')

--insert only selected fields
Insert Into testTable (testID, testName)
values
(6, 'test6');

--if you forget to insert not null field an error will occur.
Insert Into testTable(testID) -- Cannot insert the value NULL into column 'testName', table 'dbtest1.dbo.testTable'; column does not allow nulls. INSERT fails.
values (7);

Insert Into testTable(testID, testName) -- right approach is to fill all not nullable fields
values (7, 'test7');

Insert Into testTable 
values
(8, 'test7', 'checked');


Insert Into testTable 
values
(9, 'test7', 'checked');


-- Insert fields from other table
Insert Into testTableCopy1
Select * From testTable;

Select * From testTableCopy1;




-- 2) Update
Select * From testTable;

Update testTable
Set testName = 'test8'
Where testID = 8;

Update testTable
Set testName = 'test9'
Where testID = 9;


Update testTable
Set testName = 'test10'
Where testID = 10;

Update testTable
Set testStatus = 'checked'
Where testStatus Is Null;

Update testTable
Set salaryTest = 500
Where testID <= 5;


Update testTable
Set salaryTest = 200
Where testID > 5 and testID <=7;

Update testTable
set salaryTest = 150
Where testID = 8 or testID = 9;


Update testTable
set salaryTest = 500
Where testID = 10;

Update testTable
set salaryTest = salaryTest * 1.10
Where salaryTest <= 200;



-- 3) Delete

Select * From testTable;

Delete From testTable
Where salaryTest < 200;



-- 4) Select Into statement
Select * From testTableCopy3;

Select * 
Into testTableCopy1
From testTable;

Select testID, testName 
Into testTableCopy2
From testTable;

Select *
Into testTableCopy3
From testTable
Where 5 = 7;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- (*) Data Query Language (DML)

-- 1) Select Statement

Select * From Employees; -- * means all columns

Select Employees.* From Employees; -- * means everything from every table, Employees.* means Employees table only

Select ID, FirstName, LastName, DepartmentID From Employees; -- Selecting columns from employees table

Select * From Departments;

Select * From Countries;


-- 2) Select Distinct
SELECT DepartmentID FROM Employees;
Select Distinct DepartmentID From Employees;
Select Distinct FirstName, DepartmentID From Employees; -- Note: DISTINCT works on the entire selected row, not on individual columns.



-- 3) Where Statement + AND , OR, NOT

Select * From Employees;
Select * From Departments;
Select * From Countries;

Select * From Employees
Where CountryID = 1;

Select * From Employees
Where CountryID <> 1;

Select * From Employees
Where CountryID <> 1 And Gendor = 'm';

Select * From Employees
Where MonthlySalary > 500;

Select * From Employees
Where Not MonthlySalary >= 500;

Select * From Employees -- Working Employees
Where ExitDate Is Null;

Select * From Employees -- Resigned Employees
Where ExitDate Is Not Null;

Select * From Employees
Where DepartmentID = 1 And Gendor = 'f';

Select * From Employees
Where DepartmentID = 1 And DepartmentID = 2;



-- 4) In Operator (a shorthand for multiple OR conditions)

Select * From Employees
Where DepartmentID = 1 Or DepartmentID = 2;

Select * From Employees
Where DepartmentID = 1 Or DepartmentID = 5 Or DepartmentID = 7;


Select * From Employees
Where DepartmentID = 1 Or DepartmentID = 5 Or DepartmentID = 7;


Select * From Employees
Where DepartmentID = 1 Or DepartmentID = 2 Or DepartmentID = 5 Or DepartmentID = 7;

-- that's where in operator comes in, when there are multiple or conditions

Select * From Employees
Where DepartmentID IN (1, 2);

Select * From Employees
Where DepartmentID IN (1, 5, 7);

Select * From Employees
Where DepartmentID IN (1, 2, 5, 7);

-- get me all the departments that gives employees a salary less than 500

Select Departments.Name From Departments
Where ID IN (Select DepartmentID From Employees Where MonthlySalary < 500);

Select * From Employees;
Select * From Departments;
Select * From Countries;

Select FirstName, LastName, MonthlySalary From Employees
Where DepartmentID IN (2, 4, 6);

Select FirstName, LastName From Employees
Where CountryID IN (Select ID From Countries Where Name IN ('USA', 'UK'));

Select * From Employees
Where DepartmentID IN (Select ID From Departments Where Name like'%ing%')

Select FirstName, LastName, HireDate From Employees
Where Gendor = 'm' AND DepartmentID IN (Select ID From Departments Where Name NOT IN ('Sales', 'Finance'));

Select FirstName, LastName From Employees
Where DepartmentID IN (Select DepartmentID From Employees Where ExitDate IS NOT NULL);

Select FirstName, LastName From Employees
Where DepartmentID IN (Select DepartmentID From Employees Where ExitDate IS NOT NULL) AND ExitDate IS NULL;

Select Name From Countries
Where ID IN (
Select CountryID From Employees 
Where BonusPerc > 0.1 And DepartmentID IN(Select ID From Departments Where Name like '%ing%')) 


-- 5) Order By

Select * From Employees;
Select * From Departments;

Select FirstName, LastName, DepartmentID From Employees
Where DepartmentID = 1;


Select FirstName, LastName, DepartmentID From Employees
Where DepartmentID = 1
ORDER BY FirstName;


Select FirstName, LastName, DepartmentID From Employees
Where DepartmentID = 1
ORDER BY FirstName Desc;


Select FirstName, LastName, DepartmentID From Employees
Where DepartmentID = 1
ORDER BY FirstName Desc, LastName;


Select FirstName, LastName, DepartmentID From Employees
Where DepartmentID = 1
ORDER BY FirstName Desc, LastName Desc;


Select FirstName, MonthlySalary From Employees
Where MonthlySalary > 500
ORDER BY FirstName;


Select FirstName, MonthlySalary From Employees
Where MonthlySalary > 500
ORDER BY FirstName DESC;


Select FirstName, MonthlySalary From Employees
Where MonthlySalary > 500
ORDER BY MonthlySalary;


Select FirstName, MonthlySalary From Employees
Where MonthlySalary > 500 And DepartmentID IN (1, 2)
ORDER BY MonthlySalary Desc;


Select FirstName, LastName, MonthlySalary, DepartmentID From Employees
Order By MonthlySalary Desc;

Select FirstName, LastName, DateOfBirth From Employees
Order By LastName, FirstName;

Select * From Employees
Where DepartmentID IN (Select ID From Departments Where Name IN ('IT', 'Engineering'))
Order By HireDate Desc;

-- 6) Top Clause

Select top 5 * From Employees;

Select top 5 * From Employees
Where MonthlySalary > 2800;

-- get the names of employees who have the highest 3 salaries

Select distinct top 3 FirstName, LastName, MonthlySalary From Employees
Order by MonthlySalary desc;

Select FirstName, LastName, MonthlySalary From Employees
Where MonthlySalary IN ( Select distinct top 3 MonthlySalary From Employees Order by MonthlySalary desc)
Order by MonthlySalary Desc;

Select FirstName, LastName, MonthlySalary From Employees
Where MonthlySalary IN (Select distinct top 3 MonthlySalary From Employees Order by MonthlySalary asc)
Order by MonthlySalary asc;

-- exercises

Select top 10 FirstName, LastName, MonthlySalary From Employees
Order by MonthlySalary Asc;

Select top 3 * From Employees
Order by DateOfBirth Asc;

Select top 5 * From Employees
Where CountryID IN (Select ID From Countries Where Name = 'UK')
Order by MonthlySalary Desc;

Select top 1 * From Employees
Where DepartmentID IN (Select ID From Departments Where Name = 'HR')
Order by HireDate desc;

Select top 3 * From Employees
Where DepartmentID IN (Select ID From Departments Where Name Like '%ing%')
Order by BonusPerc Desc;

Select top 1 * From Employees
Where DepartmentID IN (Select ID From Departments Where Name = 'Engineering') And CountryID IN (Select ID From Countries Where Name = 'USA')
Order by MonthlySalary Desc;


-- "Give me the absolute #1 person with the lowest bonus. Oh, and if anyone else has that exact same 'last place' bonus, bring them along too."
Select top 1 with ties * From Employees
Order by BonusPerc, HireDate asc;

Select top 1 with ties * From Employees
Order by MonthlySalary Desc, BonusPerc Desc; -- bonus perc is a tie breaker


-- 7) Select As (alias)

Select FirstName, MonthlySalary/2 As HalfMonthSalary
From Employees;

Select ID, FirstName + ' ' + LastName As FullName, MonthlySalary
From Employees;

Select ID, FirstName + ' ' + LastName As FullName, MonthlySalary * 12 As YearlySalary
From Employees;

Select ID, FirstName + ' ' + LastName As FullName, MonthlySalary * 12 As YearlySalary, BonusPerc * MonthlySalary As BonusAmountPerMonth
From Employees;

Select Today = getDate();

Select ID, FirstName + ' ' + LastName As FullName, DATEDIFF(year, DateOfBirth, getDate()) As Age, MonthlySalary * 12 As YearlySalary, 
BonusPerc * MonthlySalary As BonusAmountPerMonth
From Employees;

-- exercises

Select FirstName As GivenName, LastName As FamilyName, MonthlySalary As Paycheck
From Employees;

Select FirstName, MonthlySalary * 1.1 As [Salary with a raise]
From Employees
Order By [Salary with a raise] Desc;


Select top 1 e.* From Employees As e
Where e.DepartmentID IN (Select d.ID From Departments As d Where d.Name = 'Engineering') And e.CountryID IN (Select c.ID From Countries As c Where c.Name = 'USA')
Order By e.MonthlySalary Desc;

Select e.FirstName, e.LastName, e.MonthlySalary + (e.MonthlySalary * e.BonusPerc) As TotalPay
From Employees As e
Order By TotalPay Desc;

-- 8) Between Operator

Select e.* From Employees As e
Where e.MonthlySalary Between 2500 And 4000;

Select e.ID, e.FirstName, e.HireDate 
From Employees As e
Where e.HireDate Between '2020-01-01' And '2023-12-31'
Order by e.HireDate Desc; -- added from me not included in the exercise

Select top 5 e.* 
From Employees As e
Where e.BonusPerc Between 0.05 And 0.15
Order by e.MonthlySalary Desc;

Select e.*
From Employees As e
Where e.MonthlySalary Not Between 700 And 1000
Order by e.MonthlySalary Desc; -- added from me not included in the exercise for check purposes

-- 9) Aggregates

Select * From Employees; -- for check purposes

Select Count(ID) As TotalEmployees 
From Employees;

Select Sum(MonthlySalary) As [Total Salary]
From Employees;

Select Avg(BonusPerc) As [Bonus Average]
From Employees;

Select Min(MonthlySalary) As [Lowest Pay], Max(MonthlySalary) As [Highest Pay]
From Employees;

Select Avg(MonthlySalary) As [Average Salary Per Country]
From Employees
Where CountryID = 1;

Select Min(HireDate) As [Oldest Hire], Max(HireDate) As [Recent Hire]
From Employees;

Select Min(LastName) As [First Alphabit Name], Max(LastName) As [Last Alphabit Name]
From Employees;

Select Sum(MonthlySalary) As [Total Salary], Avg(MonthlySalary) As [Average Salary]
From Employees;

Select Sum(MonthlySalary) As [Total Salary], Avg(MonthlySalary) As [Average Salary]
From Employees
Where FirstName Like 'A%';

Select Count(*) As [Total Employees]
From Employees;

Select Count(BonusPerc) As [Employees having Bonus]
From Employees;

Select Count(*) As [Rich Employees]
From Employees
Where MonthlySalary > 2000; -- don't have 5000 in the table

Select Count(ExitDate) As [Resigned Employees]
From Employees;

Select Count(*) As [Total Employees]
From Employees;

Select Count(*) - Count(ExitDate) As [Working Employees]
From Employees;

Select Count(*) As [Total Employees], Count(ExitDate) As [Resigned Employees], Sum(Case When ExitDate IS NULL Then 1 Else 0 End) As [Working Employees]
From Employees;


-- 10) Group by

-- error because FirstName is not included in the group by clause which will cause a confusion for the engine as it won't know which FirstName to add to the row
SELECT DepartmentID, FirstName, SUM(MonthlySalary) 
FROM Employees 
GROUP BY DepartmentID; 

-- here we encounter 2 errors 
-- first is where clause is executed before Select which would cause a confusion of the sum aggregate 
-- second is that the where clause filter rows before any aggregations so we can't filter based on an aggregation, but we filter the actual rows of the table first using where
SELECT DepartmentID, SUM(MonthlySalary)
FROM Employees
WHERE SUM(MonthlySalary) > 10000 
GROUP BY DepartmentID;

-- works perfectly
SELECT DepartmentID, MIN(HireDate) as HireDatePerDepartment 
FROM Employees 
WHERE CountryID = 1 
GROUP BY DepartmentID;


Select CountryID, DepartmentID, Sum(MonthlySalary) As TotalMonthlySalary
From Employees
Group by CountryID, DepartmentID
Order by CountryID, DepartmentID;

Select DepartmentID, Count(*) - Count(ExitDate) As WorkingEmployees, Min(HireDate) As EarliestHireDate, Max(ExitDate) As LatestExitDate
From Employees
Group by DepartmentID
Order by DepartmentID;

-- gpt
-- general exercises
-- numbers will express the execution order

-- noticed that group by behaves exactly like distinct if there is no aggregates
Select DepartmentID -- 3
From Employees -- 1
Group By DepartmentID; -- 2

Select DepartmentID, CountryID
From Employees
Group By DepartmentID, CountryID;

Select FirstName, LastName, DepartmentID, CountryID
From Employees
Where DepartmentID IN (1, 4, 6) And CountryID IN (1);

Select DepartmentID -- 4
From Employees -- 1
Where MonthlySalary > 2000 -- 2
Group By DepartmentID; -- 3

Select DepartmentID, Avg(MonthlySalary) As [Average Salary Per Department]
From Employees
Where HireDate > '2020-01-01' -- date filter goes in where because where deals with main table rows
Group By DepartmentID;

Select DepartmentID, String_agg(LastName, ', ') As [List of all LastNames], Sum(BonusPerc) As [Total Commision]
From Employees
Group By DepartmentID
Order By DepartmentID;

-- can't use the count on where since where deals with table rows filtering not aggregates (so we'll use having but since we haven't taken them I am not adding the condition
Select CountryID, Count(DepartmentID) As [Total Departments per country]
From Employees
Group By CountryID
Order By CountryID;

-- 11) Having


select DepartmentID, TotalCount=Count(MonthlySalary), TotalSum=Sum(MonthlySalary), Average=Avg(MonthlySalary), MinSalary=Min(MonthlySalary), MaxSalary=Max(MonthlySalary) -- 4
from Employees -- 1
Group By DepartmentID -- 2
Having Count(MonthlySalary) > 130 -- 3
order by DepartmentID; -- 5

-- using the table without having

Select * -- 3
From -- 1
(
select DepartmentID, TotalCount=Count(MonthlySalary), TotalSum=Sum(MonthlySalary), Average=Avg(MonthlySalary), MinSalary=Min(MonthlySalary), MaxSalary=Max(MonthlySalary) 
from Employees 
Group By DepartmentID 
) R1

Where R1.TotalCount > 130 -- 2
Order By R1.DepartmentID; -- 4


Select CountryID, Count(*) As TotalEmployees 
From Employees
Group By CountryID
Having Count(*) > 2
Order By CountryID;


Select DepartmentID, Avg(MonthlySalary) As 'Boss average salary' -- 5
From Employees -- 1
Where MonthlySalary > 5000 -- 2
Group By DepartmentID -- 3
Having Avg(MonthlySalary) > 8000 -- 4
Order By DepartmentID; -- 6

Select CountryID, Sum(BonusPerc) As 'Total Bonus'
From Employees
Group By CountryID
Having Sum(BonusPerc) < 50
Order By 'Total Bonus' Desc; -- good to know that you have to add either '' or [] for the alias, and it's logical since order by is after select so it can recognize the total bonus

-- 12) Like

--Finds any values that start with "a"
select ID, FirstName from Employees
where FirstName like 'a%';


--Finds any values that end with "a"
select ID, FirstName from Employees
where FirstName like '%a';


--Finds any values that have "tell" in any position
select ID, FirstName from Employees
where FirstName like '%tell%';

--	Finds any values that start with "a" and ends with "a"
select ID, FirstName from Employees
where FirstName like 'a%a';

--Finds any values that have "a" in the second position
select ID, FirstName from Employees
where FirstName like '_a%';

--Finds any values that have "a" in the third position
select ID, FirstName from Employees
where FirstName like '__a%';


--Finds any values that start with "a" and are at least 3 characters in length
select ID, FirstName from Employees
where FirstName like 'a__%';

--Finds any values that start with "a" and are at least 4 characters in length
select ID, FirstName from Employees
where FirstName like 'a___%';



--Finds any values that start with "a"
select ID, FirstName from Employees
where FirstName like 'a%' or FirstName like 'b%' ;


-- 13) Wildcards


select ID, FirstName, LastName from Employees
Where firstName = 'Mohammed' or FirstName ='Mohammad'; 


-- will search form Mohammed or Mohammad
select ID, FirstName, LastName from Employees
Where firstName like 'Mohamm[ae]d';

--You can use Not 
select ID, FirstName, LastName from Employees
Where firstName Not like 'Mohamm[ae]d';


select ID, FirstName, LastName from Employees
Where firstName like 'a%' or firstName like 'b%' or firstName like 'c%';


-- search for all employees that their first name start with a or b or c
select ID, FirstName, LastName from Employees
Where firstName like '[abc]%';


-- search for all employees that their first name start with any letter from a to l
select ID, FirstName, LastName from Employees
Where firstName like '[a-l]%';


-- general exercises on single table queries
Select * From Employees;

Select Sum(e.MonthlySalary) As TotalSalary, Avg(e.MonthlySalary) As AverageSalary
From Employees As e
Where e.BonusPerc IS NOT NULL;

Select DepartmentID, Count(*) As totalEmployees
From Employees
Where DepartmentID NOT IN (5, 1) 
Group By DepartmentID
Order By DepartmentID;

-- second highest salary
Select Top 1 ID, MonthlySalary 
From Employees
Where MonthlySalary IN (Select distinct top 2  MonthlySalary From Employees Order By MonthlySalary Desc)
Order By MonthlySalary Asc;

Select Max(MonthlySalary) As SecondHighestSalary
From Employees
Where MonthlySalary < (Select Max(MonthlySalary) From Employees);

Select FirstName, MonthlySalary
From Employees
Where MonthlySalary > (Select Avg(MonthlySalary) From Employees);

Select DepartmentID, Count(*) As EmployeeCount
From Employees
Group By DepartmentID
Having Count(*) > 3;

Select Count(MonthlySalary) As KnownEmployees
From Employees;

Select Count(*) - Count(MonthlySalary) As UnkownEmployees
From Employees;


-- Exercise 1 — NULL Logic
Select Count(*) As totalEmployees, Count(MonthlySalary) As EmployeesWithSalary, Count(*) - Count(MonthlySalary) As EmployeesWithoutSalary
From Employees;

-- Exercise 2 — Aggregate Edge Case
Select Min(MonthlySalary) As lowestSalary 
From Employees
Having Min(MonthlySalary) IS NOT NULL;

-- Exercise 3 — Salary Distribution
Select MonthlySalary, Count(*) As employeesCount
From Employees
Group By MonthlySalary;


-- Exercise 4 — Detect Duplicate Salaries
Select MonthlySalary, Count(*) As employeesCount
From Employees
Group By MonthlySalary
Having Count(*) > 1;


-- Exercise 5 — Departments With Mixed Salary Data
Select DepartmentID 
From Employees
Group By DepartmentID
Having Count(MonthlySalary) > 0 And Count(MonthlySalary) < Count(*);


-- 14) Joins

-- A) Inner Join

Select * From Customers;

Select * From Orders;

Select e.CustomerID, e.Name, o.Amount
From Customers e
Inner Join Orders o ON e.CustomerID =  o.CustomerID;

Use HR_Database

-- Exercise 1
Select e.FirstName, e.LastName, d.Name
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID;


-- Exercise 2
Select e.FirstName, e.LastName, c.Name As CountryName
From Employees e
Inner Join Countries c
ON e.CountryID = c.ID;


-- Exercise 3
Select e.FirstName, e.LastName, d.Name As DepartmentName, c.Name As CountryName
From Employees e
Inner Join Departments d ON e.DepartmentID = d.ID
Inner Join Countries c ON e.CountryID = c.ID;

-- Exercise 4
Select e.FirstName, e.LastName, d.Name
From Employees e
Inner Join Departments d ON e.DepartmentID = d.ID
Where e.DepartmentID IN (2, 3);

-- Exercise 5
Select e.FirstName, e.LastName, c.Name
From Employees e
Inner Join Countries c ON e.CountryID = c.ID
Where e.CountryID = 1;

-- Exercise 6
Select d.Name, Count(e.ID) As TotalEmployees
From Employees e
Inner Join Departments d ON e.DepartmentID = d.ID
Group By d.Name;

-- Exercise 7
Select c.Name As CountryName, Avg(e.MonthlySalary) As AverageSalaryPerCountry
From Employees e
Inner Join Countries c ON e.CountryID = c.ID
Group By c.Name;

-- Exercise 8
-- What happens if you remove the ON condition here?
SELECT *
FROM Employees e
INNER JOIN Departments d;

-- is it valid? no it's not valid, becuase there is no condition to join those two table they're just glued together, we can't have inner join without ON for filtering 
-- what result shape do you get? As Follows:-
-- those are table columns:        ID  FirstName  LastName  Gender  DateOfBirth  CountryID  DepartmentID  HireDate  ExitDate  MonthlySalary  BonusPerc   ID       Name
--  Cartesian Product applied  ->  1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00      1    Engineering
--                                 1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00      2        IT
--                                 2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00      1    Engineering
--                                 2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00      2        IT

-- this the table shape missing the on condition which causes an error since the table becomes not logical but only a table of possibilites

-- Exercise 9
-- it may or may not give an error given the column name, if 'Name' is present in both tables this would cause an error since sql don't know which name to show,...
-- but if employees have firstName and departments have name sql understands that it would show departments.

-- Bonus (Deep Understanding)
SELECT e.FirstName, d.Name
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID;

-- 1. From Employees e ->                        ID  FirstName  LastName  Gender  DateOfBirth  CountryID  DepartmentID  HireDate  ExitDate  MonthlySalary  BonusPerc
--                                               1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00
--									             2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00
									           
-- 2. INNER JOIN Departments d                   ID  FirstName  LastName  Gender  DateOfBirth  CountryID  DepartmentID  HireDate  ExitDate  MonthlySalary  BonusPerc   ID       Name 
--  Cartesian Product applied  ->                1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00      1    Engineering
--                                               1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00      2        IT
--                                               2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00      1    Engineering
--                                               2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00      2        IT	

-- 3. ON e.DepartmentID = d.DepartmentID	     ID  FirstName  LastName  Gender  DateOfBirth  CountryID  DepartmentID  HireDate  ExitDate  MonthlySalary  BonusPerc   ID       Name 
--  Condition filtering applied  ->              1    Ahmed       Amr       M        NULL         1            1          NULL      NULL        8000         0.00      1    Engineering
--                                               2   Mohammed     Ali       M        NULL         2            2          NULL      NULL        8000         0.00      2        IT	


-- 4. SELECT e.FirstName, d.Name	               FirstName       Name 
--									                 Ahmed      Engineering
--                                                 Mohammed        IT	

-- quick revision

Select e.FirstName, e.LastName, d.Name
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID
Where MonthlySalary > 1000;


Select e.FirstName, d.Name As DepartmentName, c.Name As CountryName
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID
Inner Join Countries c
ON e.CountryID = c.ID;


Select d.Name As DepartmentName, Avg(e.MonthlySalary) As AverageSalary
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID
Group By d.Name;


Select * From Employees
Order By HireDate Desc;

Select e.FirstName, e.MonthlySalary, d.Name As DepartmentName
From Employees e 
Inner Join Departments d 
ON e.DepartmentID = d.ID
Where d.Name = 'IT' And e.HireDate > '2022-01-01'
Order By e.MonthlySalary Desc;


Select d.Name As DepartmentName, c.Name As CountryName, Sum(e.MonthlySalary) As TotalSalary
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID
Inner Join Countries c
ON e.CountryID = c.ID
Group By d.Name, c.Name;


-- B) Left Join

-- Exercise 1

-- first we use hr database which ensures referential integrity through non-nullable foreign keys (this means that left join is like inner join when there's referential integrity and FK not null)
-- we can later add freelancers which changes the constraint of FK non-nullablity (better for real life apps in my opinion)
Select e.FirstName, d.Name As DepartmentName
From Employees e
Left Join Departments d
ON e.DepartmentID = d.ID;

-- second we use shop database which doesn't have referential integrity cause there's no FK connection, each table between customers and orders is independant
Select * From Customers
Select * From Orders

-- NULLs appear because there are CustomerIDs in order not present in the customers table 
Select c.Name, o.Amount
From Customers c
Left Join Orders o
ON c.CustomerID = o.CustomerID;


-- Exercise 2 (VERY IMPORTANT)

Select e.FirstName, d.Name As DepartmentName
From Employees e 
Left Join Departments d 
ON e.DepartmentID = d.ID
Where d.Name IS NULL; -- no employees returned, becuase of the FK constraint with a non null constraint

Select c.Name, o.Amount
From Customers c
Left Join Orders o
ON c.CustomerID = o.CustomerID
Where o.Amount IS NULL;


-- Exercise 3 
SELECT e.FirstName, d.Name
FROM Employees e
LEFT JOIN Departments d
ON e.DepartmentID = d.ID
WHERE d.Name = 'IT';

-- this is not a left join result, it behaves exactly like Inner Join in that case, cause the core idea of left join is to show the data that's nullable and data that's not...
-- so filtering the data and getting only the ones in IT will give the same result as inner join with a where statement, so it was better to use inner join in that case.


-- Exercise 4: the fix
SELECT e.FirstName, d.Name
FROM Employees e
LEFT JOIN Departments d
ON e.DepartmentID = d.ID And d.Name = 'IT';


-- Exercise 5
Select d.Name As DepartmentName, e.FirstName
From Departments d
Left Join Employees e
ON d.ID = e.DepartmentID;


-- Exercise 6
-- I can just select all employees since any employee selected is one of 2, either belongs to a department or doesn't belong to one
-- so
Select * From Employees;
Select * From Departments;


-- Exercise 1 — COUNT Trap
Select d.Name As DepartmentName, Count(e.ID) As EmployeesPerDepartment
From Departments d
Left Join Employees e
ON d.ID = e.DepartmentID
Group By d.Name;


-- we now use count(e.ID), becuase if HR for example has one row that equals to NULL it's counted which is not correct, so we count only the not null values by ....
-- .. counting data in a certain column (e.ID)

-- Exercise 2 — Wrong COUNT (classic bug)
SELECT d.Name, COUNT(*)
FROM Departments d
LEFT JOIN Employees e
ON d.ID = e.DepartmentID
GROUP BY d.Name;

-- same as the answer of exercise 1

-- Exercise 3 — WHERE destroys LEFT JOIN (again, deeper)
Select d.Name As DepartmentName, Count(e.ID) As TotalEmployees
From Departments d
Left Join Employees e
ON d.ID = e.DepartmentID
Where e.MonthlySalary > 2000
Group By d.Name;
-- where destroyed the idea of left join since it removed any NULL values during the filtering of employees, and yes it can be removed from the salary since if employee is null...
-- then its monthly salary is automatically null

Select d.Name As DepartmentName, Count(e.ID) As TotalEmployees
From Departments d
Left Join Employees e
ON d.ID = e.DepartmentID And e.MonthlySalary > 2000
Group By d.Name;
-- result should be inside the ON condition, yes it will match the salaries for the ones who earn more than 2000 but for the ones who earn less they're added but with a null values 
-- unmatching -> NULL, filter -> complete removal
-- IMPORTANT NOTE: I am talking about general difference, but in case of counting both will give the same result since count(e.ID) only counts non nullable rows

-- Exercise 4 — Duplicate Explosion
SELECT d.Name, e.FirstName
FROM Departments d
LEFT JOIN Employees e
ON d.ID = e.DepartmentID;

-- yes they will repeat.
-- one department may have many employees so based on the condtion departmentID equals to deptID in employees rows which is why they'll appear repeatedly unless a department has no employees (NULL)
-- it teaches joins responsibility and limits, joins are just for joining two or more tables and about finding a match between those tables even if repeition occurs it's that simple.

--  Exercise 5 — Multi JOIN trap
Select e.FirstName As EmployeeName, d.Name As DepartmentName, c.Name As CountryName
From Employees e 
Left Join Departments d
ON e.DepartmentID = d.ID
Inner Join Countries c
ON e.CountryID = c.ID;

-- employees table should be left.
-- because it's required to show all employees even if they don't have a department or country, so the employee table is the main table.
-- if one of them is inner join it will remove any NULL values regarding shows up in the relation between employees and the table inner joining with it whether a country or a department


-- Exercise 6 — Real-world scenario
Select c.Name As CustomerName, o.Amount 
From Customers c
Left Join Orders o
ON c.CustomerID = o.CustomerID
Where o.Amount IS NULL;

-- Left join sometimes behaves like inner join when null rows are execluded and only the matching pairs show up,....
-- ... that often happens when using a where clause execluding null values or choosing a certain condition which automatically execlude any NULL values


-- I noticed something, after making any join we deal with the joined tables as one independant table and we query it based on that am I right?



-- 💀 FINAL LEFT JOIN CHALLENGE (Real-world + tricky)

Select d.Name As DepartmentName, Count(e.ID) As TotalEmployees
From Departments d
Left Join Employees e
ON d.ID = e.DepartmentID And e.MonthlySalary > 2000
Group By d.Name;


-- C) Full Outer Join

-- Exercise 1
Select e.FirstName As EmployeeName, d.Name As DepartmentName
From Employees e 
Full Outer Join Departments d
ON e.DepartmentID = d.ID;

Select c.Name as CustomerName, o.Amount As OrderAmount
From Customers c
Full Outer Join Orders o
ON c.CustomerID = o.CustomerID;

-- Exercise 2
Select e.FirstName As EmployeeName, d.Name As DepartmentName
From Employees e 
Full Outer Join Departments d
ON e.DepartmentID = d.ID
Where d.ID IS NULL Or e.ID IS NULL;


Select c.Name as CustomerName, o.Amount As OrderAmount
From Customers c
Full Outer Join Orders o
ON c.CustomerID = o.CustomerID
Where o.OrderID IS NULL Or c.CustomerID IS NULL;
-- Full Join would be better than left join if you want to see multiple results instead of one from tables 


-- 15) Views

Create View ActiveEmployees As
Select * From Employees 
Where ExitDate IS NULL;

Select * From ActiveEmployees;

Create View ResignedEmployees As
Select * From Employees
Where ExitDate IS NOT NULL;

Select * From ResignedEmployees;

Select DepartmentID, Count(r.ID) As TotalResignedEmployees
From ResignedEmployees r
Group By DepartmentID;

Create View SecuredEmployees As
Select ID, FirstName, Gendor
From Employees;

Select * From SecuredEmployees;

-- Exercise 1 — Basic View
Create View EmployeesWithDepartments As
Select e.FirstName + ' ' + e.LastName As FullName, d.Name As DepartmentName
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID;

Select * From EmployeesWithDepartments;

Select * From EmployeesWithDepartments
Where DepartmentName = 'Engineering';


-- Exercise 2 — Security View
Create View EmployeesWithoutSalary As
Select ID, FirstName, LastName, Gendor, DateOfBirth, CountryID, DepartmentID, HireDate, ExitDate
From Employees

Select * From EmployeesWithoutSalary

-- Exercise 3 — Filtered View
Create View IT_Employees As
Select e.* 
From Employees e 
Inner Join Departments d
ON e.DepartmentID = d.ID
Where d.Name = 'IT'; -- unncessary join

-- better solution
Create View IT_Employees As
Select * From Employees
Where DepartmentID IN (Select ID From Departments Where Name = 'IT');

Select * From IT_Employees;

-- using base view
Create View IT_EmployeesDerived As
Select * From EmployeesWithDepartments
Where DepartmentName = 'IT';

Select * From IT_EmployeesDerived;

-- Exercise 4 — Complex View
Create View DepartmentEmployeesCount As
Select d.Name As DepartmentName, Count(e.ID) As TotalEmployeesPerDepartment
From Employees e 
Inner Join Departments d
ON e.DepartmentID = d.ID
Group By d.Name;

Select * From DepartmentEmployeesCount
Where DepartmentName = 'Engineering';


Select * From DepartmentEmployeesCount
Where TotalEmployeesPerDepartment > 140;

-- When should I use a View instead of writing the query directly?
-- When that query is reusable in many cases of the program, also if I want to increase security or expose certain data and hide another



Select e.*
From Employees e 
Inner Join Departments d
ON e.DepartmentID = d.ID
Where e.DepartmentID IN 
(
Select DepartmentID 
From Employees e 
Group By DepartmentID
Having Count(*) > 5
)


Select * From Employees
Where DepartmentID IN 
( 
Select DepartmentID
From Employees e
Group By DepartmentID
Having Count(e.ID) > 5
)

Select Distinct DepartmentID 
From Employees
Where Exists
(
Select distinct 1 From Employees 
Where DepartmentID IS NOT NULL
)
Order by DepartmentID;

-- exists because we need to check if there is at least one employee so we just need to make sure that one exists.


Select *
From Employees
Where DepartmentID IN
(
Select DepartmentID
From Employees
Group By DepartmentID
Having avg(MonthlySalary) > 5000
)

-- subquery because we're doing filtering within the same table, no need for joins here 

Select e.FirstName + ' ' + e.LastName As FullName, d.Name As DepartmentName
From Employees e 
Inner Join Departments d 
ON e.DepartmentID = d.ID;

-- join because we need to first combine data and then display it


-- 16) Exists

-- Exercise 1 — Warm-up
Select * From Customers c
Where Exists
(
Select 1 
From Orders d
Where c.CustomerID = d.CustomerID
)


-- Exercise 2 — Reverse thinking
Select * From Customers c 
Where NOT EXISTS
(
Select 1
From Orders d 
Where c.CustomerID = d.CustomerID
)


-- Exercise 3 — Add condition
Select * From Customers c
Where Exists
(
Select 1
From Orders o
Where c.CustomerID = o.CustomerID And o.Amount > 1000
)


-- Exercise 4 — Trick (important)
Select * From Customers c
Where Not Exists
(
Select 1
From Orders o
Where c.CustomerID = o.CustomerID And o.Amount < 500
)
-- Note: so this is better because if any order less than 500 -> exclude it

-- Exercise 5 — Double logic

Select * From Customers c
Where Exists
(
Select 1 
From Orders o
Where c.CustomerID = o.CustomerID And Amount > 2000
)



-- 17) Union
Select * From ActiveEmployees
Union
Select * From ResignedEmployees;


Select * From Employees
Union
Select * From Departments;


Select * From Departments
Union 
Select * From Departments

Select * From Departments
Union All -- add duplicates 
Select * From Departments


-- 18) Case
Select ID, FirstName, LastName, GenderTitle = 
Case
	When Gendor = 'M' Then 'Male'
	When Gendor = 'F' Then 'Female'
	End
From Employees;


Select ID, FirstName, LastName, GenderTitle = 
Case
	When Gendor = 'M' Then 'Male'
	When Gendor = 'F' Then 'Female'
	Else 'Unkown'
End,

Status = 
Case
	When ExitDate IS NULL Then 'Active'
	When ExitDate IS NOT NULL Then 'Resigned'
	Else 'Unkown'
End
From Employees;

Select * From
(
Select ID, FirstName, LastName, GenderTitle = 
Case
	When Gendor = 'M' Then 'Male'
	When Gendor = 'F' Then 'Female'
	Else 'Unkown'
End,

Status = 
Case
	When ExitDate IS NULL Then 'Active'
	When ExitDate IS NOT NULL Then 'Resigned'
	Else 'Unkown'
End
From Employees
) t
Where t.Status = 'Resigned';


select ID, FirstName, LastName,  GendorTitle =
CASE
    WHEN Gendor='M' THEN 'Male'
    WHEN Gendor='F' THEN 'Female'
    ELSE 'Unknown'
END,

Status =
CASE
    WHEN ExitDate is null THEN 'Active'
    WHEN Gendor is Not null THEN 'Resigned'
END
from Employees


-- Exercise 1 — Basics
Select FirstName + ' ' + LastName As FullName, 
Case
	When MonthlySalary > 5000 Then 'High'
	When MonthlySalary Between 3000 And 5000 Then 'Medium'
	Else 'Low'
End As SalaryLevel
From Employees;


-- Exercise 2 — NULL handling
-- working on employees
Select *, 
Case
	When ExitDate IS NULL Then 'Active'
	Else 'Resigned'
End As EmployeeStatus
From Employees;

-- Exercise 3 — With JOIN
Select e.FirstName + ' ' + e.LastName As FullName, d.Name As DepartmentName,
Case 
	When d.Name IN('IT', 'Engineering') Then 'Tech'
	Else 'Other'
End As DeptType
From Employees e
Inner Join Departments d
ON e.DepartmentID = d.ID;


-- Exercise 4 — Inside ORDER BY
Select * From Employees
Order By 
Case 
When ExitDate IS NULL Then 1
Else 2
End;


-- Exercise 5 — Aggregation + CASE (important)
Select DepartmentID, Count(ID) As TotalEmployees, 
Count(Case When MonthlySalary > 5000 Then 1 End) As RichEmployees
From Employees
Group By DepartmentID
