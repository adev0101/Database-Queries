
Restore Database VehicleMakesDB
From Disk = 'C:\VehicleMakesDB.bak';


Select * From VehicleDetails


Use VehicleMakesDB
Exec sp_changedbowner 'sa';

CREATE DATABASE CarData;

SELECT * FROM CarDetails;

SELECT * FROM CarDetails
WHERE Make = 'BMW';

-- Creating a lookup table for makes

CREATE TABLE Makes
(
MakeID int identity(1, 1) NOT NULL,
MakeName nvarchar(50) NOT NULL,

CONSTRAINT PK_MakeID PRIMARY KEY (MakeID),
CONSTRAINT UC_MakeName UNIQUE (MakeName)
)

INSERT INTO Makes
SELECT DISTINCT Make 
FROM CarDetails
ORDER BY Make ASC;

SELECT * FROM Makes;

-- adding makeID in car details table from designer

UPDATE CarDetails
SET MakeID = (SELECT MakeID FROM Makes WHERE Makes.MakeName = CarDetails.Make)

SELECT * FROM CarDetails;

ALTER TABLE CarDetails
DROP COLUMN Make;



ALTER TABLE CarDetails
ADD CONSTRAINT FK_MakeID FOREIGN KEY (MakeID) REFERENCES Makes(MakeID);

ALTER TABLE CarDetails
ALTER COLUMN MakeID int NOT NULL

-- Model and Submodel

SELECT * FROM CarDetails;

CREATE TABLE Submodels
(
SubmodelID int identity(1, 1) NOT NULL,
SubmodelName nvarchar(50) NOT NULL,

CONSTRAINT PK_SubmodelID PRIMARY KEY (SubmodelID),
CONSTRAINT UC_SubmodelName UNIQUE (SubmodelName)

)

INSERT INTO Submodels
SELECT DISTINCT Submodel 
FROM CarDetails; 


SELECT * FROM Submodels;


ALTER TABLE Submodels
ADD ModelID int NULL;

ALTER TABLE Submodels
ADD CONSTRAINT UC_SubmodelName_ModelID UNIQUE (SubmodelName, ModelID);

-- adding submodelID in car details table from designer

SELECT * FROM CarDetails;

UPDATE CarDetails
SET SubmodelID = (SELECT SubmodelID FROM Submodels WHERE Submodels.SubModelName = CarDetails.Submodel);

ALTER TABLE CarDetails
DROP COLUMN Submodel;

CREATE TABLE Models
(
ModelID int identity(1, 1) NOT NULL,
ModelName nvarchar(50),
MakeID int NOT NULL,

CONSTRAINT PK_ModelID PRIMARY KEY (ModelID)

);

ALTER TABLE Models
ADD CONSTRAINT UC_ModelName_MakeID UNIQUE (ModelName, MakeID)

ALTER TABLE Models
Drop Constraint UC_ModelName;

INSERT INTO Models (ModelName)
SELECT DISTINCT Model
FROM CarDetails
ORDER BY Model Asc;

SELECT * FROM Models;
SELECT * FROM CarDetails
WHERE MakeID = 101;

UPDATE M
SET M.MakeID = C.MakeID
FROM Models M
INNER JOIN CarDetails c
ON M.ModelName = c.Model

SELECT * FROM Models
WHERE MakeID = 101;

-- adding modelID to car details
SELECT * FROM SubModels
SELECT * FROM CarDetails
SELECT * FROM Models;

UPDATE CarDetails
SET ModelID = (SELECT ModelID FROM Models WHERE Models.ModelName = CarDetails.Model);

ALTER TABLE CarDetails
DROP COLUMN Model

-- adding modelID to submodel
UPDATE sm
SET sm.ModelID = c.ModelID
FROM Submodels sm
INNER JOIN CarDetails c
ON sm.SubmodelID = c.SubmodelID

SELECT * FROM Submodels;
SELECT * FROM CarDetails;

ALTER TABLE CarDetails
DROP CONSTRAINT FK_MakeID;

ALTER TABLE CarDetails
DROP COLUMN MakeID;

ALTER TABLE CarDetails
DROP COLUMN ModelID;


-- creating realtions between tables
ALTER TABLE CarDetails
ADD CONSTRAINT FK_SubmodelID FOREIGN KEY (SubmodelID) REFERENCES Submodels(SubmodelID);

ALTER TABLE Submodels
ADD CONSTRAINT FK_ModelID FOREIGN KEY (ModelID) REFERENCES Models(ModelID);

ALTER TABLE Models
ADD CONSTRAINT FK_MakeID FOREIGN KEY (MakeID) REFERENCES Makes(MakeID);


SELECT * FROM CarDetails;

-- Fuel Type
CREATE TABLE Fuels
(
FuelID int identity(1, 1) NOT NULL,
FuelName nvarchar(50) NOT NULL,

CONSTRAINT PK_FuelID PRIMARY KEY (FuelID),
CONSTRAINT UC_FuelName UNIQUE (FuelName)
)

INSERT INTO Fuels
SELECT DISTINCT Fuel_Type_Name
FROM CarDetails
ORDER BY Fuel_Type_Name;

SELECT * FROM Fuels;
SELECT * FROM CarDetails;

UPDATE c
SET c.FuelID = f.FuelID
FROM CarDetails c
INNER JOIN Fuels f
ON c.Fuel_Type_Name = f.FuelName

ALTER TABLE CarDetails
DROP COLUMN Fuel_Type_Name;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_FuelID FOREIGN KEY (FuelID) REFERENCES Fuels (FuelID);

ALTER TABLE CarDetails
ALTER COLUMN FuelID int NOT NULL;

CREATE INDEX Idx_CarDetails_FuelID ON CarDetails(FuelID);

SELECT * FROM CarDetails
WHERE FuelID IN (6, 14);

ALTER TABLE CarDetails
ALTER COLUMN ymm_id bigint NOT NULL;

ALTER TABLE CarDetails
ADD CONSTRAINT PK_CarDetailsID PRIMARY KEY (ymm_id);

ALTER TABLE CarDetails
DROP COLUMN Fuel_Type_Name;

-- Body
CREATE TABLE BodyTypes
(
BodyTypeID int identity (1, 1) NOT NULL,
BodyName nvarchar(50) NOT NULL,

CONSTRAINT PK_BodyTypeID PRIMARY KEY (BodyTypeID),
CONSTRAINT UC_BodyName UNIQUE (BodyTypeID)
)

ALTER TABLE BodyTypes
ADD CONSTRAINT UC_BodyName UNIQUE (BodyName)

ALTER TABLE BodyTypes
DROP CONSTRAINT UC_BodyName

ALTER TABLE CarDetails
DROP CONSTRAINT FK_BodyID



SELECT * FROM CarDetails;

INSERT INTO BodyTypes
SELECT DISTINCT Body
FROM CarDetails
ORDER BY Body;

SELECT * FROM BodyTypes
WHERE BodyTypeID IN (88, 90);

UPDATE c
SET c.BodyID = b.BodyTypeID
FROM CarDetails c
INNER JOIN BodyTypes b
ON c.Body = b.BodyName


ALTER TABLE CarDetails
DROP COLUMN Body;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_BodyID FOREIGN KEY (BodyID) REFERENCES BodyTypes (BodyTypeID);

ALTER TABLE CarDetails
ALTER COLUMN BodyID int NOT NULL;

ALTER TABLE CarDetails
DROP COLUMN Body;

-- Cylinder

SELECT * FROM CarDetails;

CREATE TABLE CylinderTypes
(
CylinderTypeID int identity(1, 1) NOT NULL,
CylinderName nvarchar(50) NOT NULL,

CONSTRAINT PK_CylinderTypeID PRIMARY KEY (CylinderTypeID),
CONSTRAINT UC_CylinderName UNIQUE (CylinderName)
)


SELECT * FROM CylinderTypes;

INSERT INTO CylinderTypes
SELECT DISTINCT Cylinder_Type_Name
FROM CarDetails
WHERE NOT Cylinder_Type_Name = 'N/A'
ORDER BY Cylinder_Type_Name; 

UPDATE c
SET c.CylinderTypeID = ct.CylinderTypeID
FROM CarDetails c
INNER JOIN CylinderTypes ct
ON c.Cylinder_Type_Name = ct.CylinderName

SELECT COUNT(Cylinder_Type_Name)
FROM CarDetails
WHERE NOT Cylinder_Type_Name = 'N/A';

ALTER TABLE CarDetails
DROP COLUMN Cylinder_Type_Name;

ALTER TABLE CarDetails
DROP CONSTRAINT FK_CylinderTypeID;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CylinderTypeID FOREIGN KEY (CylinderTypeID) REFERENCES CylinderTypes (CylinderTypeID);



-- Drive Type

SELECT * FROM CarDetails;

CREATE TABLE DriveTypes
(
DriveTypeID int identity(1, 1) NOT NULL,
DriveTypeName nvarchar(50) NOT NULL,

CONSTRAINT PK_DriveTypeID PRIMARY KEY (DriveTypeID),
CONSTRAINT UC_DriveTypeName UNIQUE (DriveTypeName)
)

SELECT * FROM DriveTypes;

INSERT INTO DriveTypes
SELECT DISTINCT Drive_Type
FROM CarDetails
WHERE NOT Drive_Type = 'N/A'
ORDER BY Drive_Type;


UPDATE c
SET c.DriveTypeID = d.DriveTypeID
FROM CarDetails c
INNER JOIN DriveTypes d
ON c.Drive_Type = d.DriveTypeName


ALTER TABLE CarDetails
DROP COLUMN Drive_Type;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_DriveTypeID FOREIGN KEY (DriveTypeID) REFERENCES DriveTypes (DriveTypeID);


-- Aspirations
SELECT * FROM CarDetails;

CREATE TABLE Aspirations
(
AspirationID int identity(1, 1) NOT NULL,
AspirationName nvarchar(50) NOT NULL,

CONSTRAINT PK_AspirationID PRIMARY KEY (AspirationID),
CONSTRAINT UC_AspirationName UNIQUE (AspirationName)
)

SELECT * FROM Aspirations;

INSERT INTO Aspirations
SELECT DISTINCT Aspiration
FROM CarDetails
WHERE NOT Aspiration IN ('N/A', '-');


ALTER TABLE CarDetails
ADD AspirationID int NULL;

UPDATE c
SET c.AspirationID = a.AspirationID
FROM CarDetails c
INNER JOIN Aspirations a
ON c.Aspiration = a.AspirationName;

ALTER TABLE CarDetails
DROP COLUMN Aspiration;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_AspirationID FOREIGN KEY (AspirationID) REFERENCES Aspirations (AspirationID);

-- Block type

CREATE TABLE EngineBlockTypes
(
EngineBlockTypeID int identity(1, 1) NOT NULL,
BlockTypeName nvarchar(20) NOT NULL,

CONSTRAINT PK_EngineBlockTypeID PRIMARY KEY (EngineBlockTypeID),
CONSTRAINT UC_BlockTypeName UNIQUE (BlockTypeName)
)


SELECT * FROM EngineBlockTypes;

SELECT * FROM CarDetails;

INSERT INTO EngineBlockTypes
SELECT DISTINCT Engine_Block_Type
FROM CarDetails
WHERE NOT Engine_Block_Type IN ('N/A', '-')
ORDER BY Engine_Block_Type;

ALTER TABLE CarDetails
ADD EngineBlockTypeID int NULL;


UPDATE c
SET c.EngineBlockTypeID = bt.EngineBlockTypeID
FROM CarDetails c
INNER JOIN EngineBlockTypes bt
ON c.Engine_Block_Type = bt.BlockTypeName;

ALTER TABLE CarDetails
DROP COLUMN Engine_Block_Type;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_EngineBlockTypeID FOREIGN KEY (EngineBlockTypeID) REFERENCES EngineBlockTypes(EngineBlockTypeID);


-- Engines
CREATE TABLE Engines
(
EngineID int identity(1, 1) NOT NULL,
Engine_CC int,
Engine_CID int,
Engine_Cylinders int,
EngineBlockTypeID int,
FuelID int NOT NULL,
AspirationID int,

CONSTRAINT PK_EngineID PRIMARY KEY (EngineID),
CONSTRAINT UC_Engine UNIQUE (Engine_CC, Engine_CID, Engine_Cylinders, EngineBlockTypeID, FuelID, AspirationID)
)

SELECT * FROM Engines;

SELECT * FROM CarDetails;

ALTER TABLE CarDetails
DROP COLUMN EngineID;

INSERT INTO Engines
SELECT DISTINCT Engine_CC, Engine_CID, Engine_Cylinders, EngineBlockTypeID, FuelID, AspirationID
FROM CarDetails
WHERE Engine_CC IS NOT NULL;


ALTER TABLE CarDetails
ADD EngineID int NULL;

UPDATE c
SET c.EngineID = e.EngineID
FROM CarDetails c
INNER JOIN Engines e
ON c.Engine_CC = e.Engine_CC AND c.Engine_Cylinders = e.Engine_Cylinders AND c.FuelID = e.FuelID;

ALTER TABLE CarDetails
ADD CONSTRAINT FK_EngineID FOREIGN KEY (EngineID) REFERENCES Engines (EngineID);

ALTER TABLE CarDetails
DROP CONSTRAINT FK_EngineBlockTypeID;

ALTER TABLE CarDetails
DROP CONSTRAINT FK_FuelID;

ALTER TABLE CarDetails
DROP CONSTRAINT FK_AspirationID;

ALTER TABLE CarDetails
DROP COLUMN EngineBlockTypeID;

ALTER TABLE CarDetails
DROP COLUMN FuelID;

ALTER TABLE CarDetails
DROP COLUMN AspirationID;

ALTER TABLE CarDetails
DROP COLUMN Engine_CC;

ALTER TABLE CarDetails
DROP COLUMN Engine_CID;

ALTER TABLE CarDetails
DROP COLUMN Engine_Cylinders;

ALTER TABLE CarDetails
DROP COLUMN Engine_Liter_Display;

ALTER TABLE Engines
ADD CONSTRAINT FK_EngineBlockTypeID FOREIGN KEY (EngineBlockTypeID) REFERENCES EngineBlockTypes (EngineBlockTypeID);

ALTER TABLE Engines
ADD CONSTRAINT FK_FuelID FOREIGN KEY (FuelID) REFERENCES Fuels(FuelID);

ALTER TABLE Engines
ADD CONSTRAINT FK_AspirationID FOREIGN KEY (AspirationID) REFERENCES Aspirations(AspirationID);


----------------------------------------------------------------------------------------------------

-- mentor database
Select * From VehicleDetails;

Select * From Makes;

Select * From MakeModels;

Select * From SubModels;

Select * From Bodies;

Select * From DriveTypes;

Select * From FuelTypes;

-- two approaches

-- 1) condition filtering is connected directly with vehicle details 
Select v.Vehicle_Display_Name, mks.Make, mm.ModelName
From VehicleDetails v
Inner Join MakeModels mm ON v.ModelID = mm.ModelID
Inner Join Makes mks ON v.MakeID = mks.MakeID;

-- 2) condition filterint is connected to make models which is connected to makes 
Select v.Vehicle_Display_Name, mks.Make, mm.ModelName
From VehicleDetails v
Inner Join MakeModels mm ON v.ModelID = mm.ModelID
Inner Join Makes mks ON mm.MakeID = mks.MakeID;


Select * From VehicleDetails 
Where Engine_Cylinders = 4;

-- Which table contains Engine_Cylinders? vehicle details
-- If this table had millions of rows, what would SQL do if there’s no index? it would make a full table scan which would slow the process, we'd have to create an index for engine cylinder.

----------------------------------------------------------------------------------------

--## Task Group 1: Basic Data Retrieval

--* **Task 1.1: Select All Columns**
--    * Retrieve all data from the `VehicleDetails` table.
--    * Retrieve all data from the `Makes` table.
--    * Retrieve all data from the `MakeModels` table.
--    * Retrieve all data from the `subModels` table.
--    * Retrieve all data from the `DriveTypes` table.
--    * Retrieve all data from the `FuelTypes` table.
--    * Retrieve all data from the `Bodies` table.
Select * From VehicleDetails;
Select * From Makes;
Select * From MakeModels;
Select * From SubModels;
Select * From DriveTypes;
Select * From FuelTypes;
Select * From Bodies;


--* **Task 1.2: Select Distinct Values**
--    * Retrieve all unique `ModelId` values from the `VehicleDetails` table.
Select Distinct ModelID 
From VehicleDetails
Order By ModelID;


--## Task Group 2: Filtering Data

--* **Task 2.1: WHERE Clause**
--    * Retrieve all details of vehicles where the `MakeID` is `2`.

Select * From VehicleDetails
Where MakeID = 2;


--* **Task 2.2: WHERE with AND**
--    * Retrieve all details of vehicles where the `MakeID` is `3` AND the `ModelId` is `29`.
Select * From VehicleDetails
Where MakeID = 3 And ModelID = 29;

--* **Task 2.3: WHERE with OR**
--    * Retrieve all details of vehicles where the `MakeID` is `3` OR the `MakeID` is `2`.
Select * From VehicleDetails
Where MakeID IN (2, 3);

--* **Task 2.4: WHERE with NOT**
--    * Retrieve all details of vehicles where the `MakeID` is NEITHER `3` NOR `2`.
Select * From VehicleDetails
Where Not MakeID IN (2, 3);


--* **Task 2.5: IN Operator**
--    * Retrieve all details of vehicles where the `BodyID` is either `16` or `15`.
Select * From VehicleDetails
Where BodyID IN (15, 16);

--* **Task 2.6: BETWEEN Operator**
--    * Retrieve all details of vehicles manufactured between the years `1990` and `2000` (inclusive).
Select * From VehicleDetails 
Where Year Between 1990 And 2000;

--## Task Group 3: Sorting and Limiting Results

--* **Task 3.1: ORDER BY (Ascending)**
--    * Retrieve all details from `VehicleDetails` and sort the results by `Id` in ascending order.
Select * From VehicleDetails
Order by ID Asc;

--* **Task 3.2: ORDER BY (Descending)**
--    * Retrieve all details from `VehicleDetails` and sort the results by `Id` in descending order.
Select * From VehicleDetails
Order by ID Desc;

--* **Task 3.3: SELECT TOP**
--    * Retrieve the top `10` rows from the `VehicleDetails` table.
Select top 10 * From VehicleDetails;

--## Task Group 4: Data Manipulation and Aggregation

--* **Task 4.1: SELECT AS (Aliasing)**
--    * Retrieve the `Id` column from `VehicleDetails` and alias it as 'VehicleDetailsId'.
--    * Retrieve the `year` column from `VehicleDetails` and alias it as 'Made At'.
Select ID As VehicleDetailsID, Year As [Made At]
From VehicleDetails;

--* **Task 4.2: COUNT Function**
--    * Count the total number of records in the `VehicleDetails` table.
Select Count(*) As TotalNumberOfRecords
From VehicleDetails;

--* **Task 4.3: MIN Function**
--    * Find the minimum `ID` value in the `VehicleDetails` table.
Select Min(ID) From VehicleDetails;

--* **Task 4.4: MAX Function**
--    * Find the maximum `ID` value in the `VehicleDetails` table.
Select Max(ID) From VehicleDetails;

--* **Task 4.5: GROUP BY**
--    * Count the number of vehicles for each `MakeID` and order the results by `MakeID`.
--    * Count the number of vehicles for each `ModelID` and order the results by `ModelID`.
Select MakeID, Count(*) As TotalVehiclesPerMake
From VehicleDetails
Group by MakeID
Order by MakeID;

Select ModelID, Count(ID) As TotalVehiclesPerModel
From VehicleDetails
Group by ModelID
Order by ModelID

--* **Task 4.6: HAVING Clause**
--    * Count the number of vehicles for each `MakeID`, but only include `MakeID`s where the count of vehicles is between `6` and `8` (inclusive). Order the results by the count in ascending order.
Select MakeID, Count(*) As TotalVehiclesPerMake
From VehicleDetails
Group by MakeID
Having Count(*) Between 6 And 8
Order by MakeID;

--## Task Group 5: Pattern Matching and Wildcards

--* **Task 5.1: LIKE Operator (Starts With)**
--    * Retrieve all details of vehicles where the `Vehicle_Display_Name` starts with 'AC'. Order the results by `ID`.
Select * From VehicleDetails
Where Vehicle_Display_Name Like 'AC%'


--* **Task 5.2: LIKE Operator (Wildcard Character)**
--    * Retrieve all details of vehicles where the `Vehicle_Display_Name` is like 'Acur_ %'. Order the results by `ID`.
Select * From VehicleDetails
Where Vehicle_Display_Name Like 'Acur_%'

--* **Task 5.3: Wildcards (Specific Characters)**
--    * Retrieve the `ID` and `Vehicle_display_name` for vehicles with a `Vehicle_display_name` matching 'Acura RSX 200[36] Base'.
Select ID, Vehicle_display_name
From VehicleDetails
Where Vehicle_display_name Like 'Acura RSX 200[36] Base'


--## Task Group 6: Joining Tables

--* **Task 6.1: JOIN (Make and Engine)**
--    * Retrieve `MakeID`, `Make` (from `Makes` table), and `Engine` (from `VehicleDetails` table) for vehicles where `MakeID` is `2`. Join `VehicleDetails` and `Makes` tables on `MakeID` and order the results by `MakeID`.
Select mk.MakeID, mk.Make, v.Engine
From Makes mk
Join VehicleDetails v
ON mk.MakeID = v.MakeID
Where mk.MakeID = 2
Order by mk.MakeID;


--* **Task 6.2: JOIN (Body and NumDoors)**
--    * Retrieve `BodyID`, `BodyName` (from `Bodies` table), and `NumDoors` (from `VehicleDetails` table) for vehicles where `BodyID` is `2` and `NumDoors` is not null. Join `VehicleDetails` and `Bodies` tables on `BodyID` and order the results by `BodyID`.
Select b.BodyID, b.BodyName, v.NumDoors
From Bodies b
Join VehicleDetails v
ON b.BodyID = v.BodyID
Where b.BodyID = 2 And v.NumDoors Is NOT NULL;


--## Task Group 7: Advanced Concepts

--* **Task 7.1: Views**
--    * Create a view named `VehicleSummaryView` that shows the `Id` and `Vehicle_Display_Name` from the `VehicleDetails` table for vehicles manufactured after the year 2000.
Create View VehicleSummaryView As
Select ID, Vehicle_Display_Name
From VehicleDetails
Where Year > 2000;

Select * From VehicleSummaryView;

--* **Task 7.2: EXISTS Operator**
--    * Retrieve the `ID` and `Engine` from `VehicleDetails` for vehicles that have a `FuelTypeID` of `1` in the `FuelTypes` table. Order the results by `Id`.
Select ID, Engine
From VehicleDetails v
Where Exists (
Select 1 
From FuelTypes f
Where f.FuelTypeID = 1 And f.FuelTypeID = v.FuelTypeID
)
Order by ID;
-- not clear requirement and not logical

--* **Task 7.3: UNION Operator**
--    * Combine the `Engine` values from `VehicleDetails` where `Id` is `1` with the `Engine` values from `VehicleDetails` where `Id` is `2` into a single result set.
Select Engine 
From VehicleDetails
Where ID = 1
Union All
Select Engine
From VehicleDetails
Where ID = 2;

--* **Task 7.4: CASE Statement**
--    * Retrieve `Id`, `MakeId`, and a column aliased as 'Number Of Doors' from `VehicleDetails`.
--    * If `NumDoors` is `NULL`, display `0` for 'Number Of Doors'; otherwise, display the actual `NumDoors` value.
--    * Filter the results to include only vehicles with `MakeId` `1` or `4`, and order the results by `MakeId` in descending order.
Select ID, MakeID, [Number of Doors] = 
Case
When NumDoors IS NULL Then 0 Else NumDoors
End
From VehicleDetails
Where MakeID IN (1, 4)
Order by MakeID Desc;


----------------------------------------------------------------------------------------

-- Course Problems

--   Problem 1: Create Master View
Create View VehicleMasterDetails As
(
Select v.ID, v.MakeID, mk.Make, v.ModelID, md.ModelName, v.SubModelID, sbm.SubModelName, v.BodyID, bd.BodyName, 
v.Vehicle_Display_Name, v.Year, v.DriveTypeID, dt.DriveTypeName, v.Engine, v.Engine_CC, v.Engine_Cylinders, 
v.Engine_Liter_Display, v.FuelTypeID, f.FuelTypeName, v.NumDoors
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join MakeModels md ON v.ModelID = md.ModelID
Inner Join SubModels sbm ON v.SubModelID = sbm.SubModelID
Inner Join Bodies bd ON v.BodyID = bd.BodyID
Inner Join DriveTypes dt ON v.DriveTypeID = dt.DriveTypeID
Inner Join FuelTypes f ON v.FuelTypeID = f.FuelTypeID
)



--   Problem 2: Get all vehicles made between 1950 and 2000
Select * From VehicleDetails
Where Year Between 1950 And 2000;


-- Problem 3 : Get number vehicles made between 1950 and 2000
Select Count(*) As NumberOfVehicles
From VehicleDetails
Where Year Between 1950 And 2000;


--   Problem 4 : Get number vehicles made between 1950 and 2000 per make and order them by Number Of Vehicles Descending
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make
Order by NumberOfVehicles Desc;


--     Problem 5 : Get All Makes that have manufactured more than 12000 Vehicles in years 1950 to 2000

-- with having
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make
Having Count(*) > 12000
Order by NumberOfVehicles Desc;


-- Without having
Select * From 
(
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make
) R1
Where NumberOfVehicles > 12000
Order by NumberOfVehicles Desc;


--   Problem 6: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside
Select mk.Make, Count(*) As NumberOfVehicles, (Select Count(*) From VehicleDetails) As TotalVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make
Order by NumberOfVehicles Desc;


-- Problem 7: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it, then calculate it's percentage
Select mk.Make, Count(*) As NumberOfVehicles, (Select Count(*) From VehicleDetails) As TotalVehicles, ((Cast (Count(*) As Float)) / (Select Count(*) From VehicleDetails)) As Perc
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make
Order by NumberOfVehicles Desc;


Select *, ( Cast (NumberOfVehicles As Float) / Cast (TotalVehicles As Float) ) As Perc
From
(
Select mk.Make, Count(*) As NumberOfVehicles, (Select Count(*) From VehicleDetails) As TotalVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Year Between 1950 And 2000
Group by mk.Make

) R1
Order by NumberOfVehicles Desc;


--  Problem 8: Get Make, FuelTypeName and Number of Vehicles per FuelType per Make

Select * From VehicleDetails;
Select * From FuelTypes
Select * From VehicleMasterDetails

Select mk.Make, f.FuelTypeName, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join FuelTypes f ON v.FuelTypeID = f.FuelTypeID
Where v.Year Between 1950 And 2000
Group by mk.Make, f.FuelTypeName
Order by mk.Make;

--   Problem 9: Get all vehicles that runs with GAS
Select v.*, f.FuelTypeName
From VehicleDetails v
Inner Join FuelTypes f ON v.FuelTypeID = f.FuelTypeID
Where f.FuelTypeName = 'GAS';

--   Problem 10: Get all Makes that runs with GAS
Select Distinct mk.Make, f.FuelTypeName
From VehicleDetails v
Inner Join FuelTypes f ON v.FuelTypeID = f.FuelTypeID
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where f.FuelTypeName = 'GAS';

--   Problem 11: Get Total Makes that runs with GAS
Select Count(*) As TotalMakesRunsOnGas From
(
Select Distinct mk.Make, f.FuelTypeName
From VehicleDetails v
Inner Join FuelTypes f ON v.FuelTypeID = f.FuelTypeID
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where f.FuelTypeName = 'GAS'

) R1

Select Count(Distinct MakeID)
From VehicleDetails
Where FuelTypeID = (Select FuelTypeID From FuelTypes Where FuelTypeName = 'GAS')


-- Problem 12: Count Vehicles by make and order them by NumberOfVehicles from high to low.
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Group by mk.Make
Order by Count(*) Desc;


--   Problem 13: Get all Makes/Count Of Vehicles that manufactures more than 20K Vehicle
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Group by mk.Make
Having Count(*) > 20000
Order by Count(*) Desc;

-- without having

Select * From
(
Select mk.Make, Count(*) As NumberOfVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Group by mk.Make
) R1
Where NumberOfVehicles > 20000
Order by NumberOfVehicles Desc;



--   Problem 14: Get all Makes with make starts with 'B'
Select Make From Makes
Where Make Like 'B%';


--   Problem 15: Get all Makes with make ends with 'W'
Select Make From Makes
Where Make Like '%W';


-- Problem 16: Get all Makes that manufactures DriveTypeName = FWD
Select Distinct mk.Make, dt.DriveTypeName
From VehicleDetails v
Inner join Makes mk ON v.MakeID = mk.MakeID
Inner join DriveTypes dt ON v.DriveTypeID = dt.DriveTypeID
Where dt.DriveTypeName = 'FWD'
Order by mk.Make;

-- can be solved with one inner join but sacrificing the drive type name (not necessary to have it though)
Select Distinct mk.Make
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.DriveTypeID IN (Select DriveTypeID From DriveTypes Where DriveTypeName = 'FWD');


--  Problem 17: Get total Makes that Mantufactures DriveTypeName=FWD (get makes that manufactures with drive type name fwd then count them)


-- select makes that have a drive type FWD

Select Count(*) As TotalMakes From
(
Select Distinct mk.Make, dt.DriveTypeName
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join DriveTypes dt ON v.DriveTypeID = dt.DriveTypeID
Where dt.DriveTypeName = 'FWD'
) R1;

--   Problem 18: Get total vehicles per DriveTypeName Per Make and order them per make asc then per total Desc
Select Distinct mk.Make, dt.DriveTypeName, Count(*) As TotalVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join DriveTypes dt ON v.DriveTypeID = dt.DriveTypeID
Group by mk.Make, dt.DriveTypeName
Order by mk.Make Asc, TotalVehicles Desc;


--   Problem 19: Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000
Select Distinct mk.Make, dt.DriveTypeName, Count(*) As TotalVehicles
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join DriveTypes dt ON v.DriveTypeID = dt.DriveTypeID
Group by mk.Make, dt.DriveTypeName
Having Count(*) > 10000
Order by mk.Make Asc, TotalVehicles Desc;

--   Problem 20: Get all Vehicles that number of doors is not specified
Select * From VehicleDetails
Where NumDoors IS NULL;


--   Problem 21: Get Total Vehicles that number of doors is not specified
Select Count(*) As TotalVehicles
From VehicleDetails
Where NumDoors Is Null;


--   Problem 22: Get percentage of vehicles that has no doors specified

Select (

 Cast((Select Count(*) From VehicleDetails Where NumDoors Is Null) As Float) / Cast((Select Count(*) From VehicleDetails) As Float)

) As TotalPerc;


--   Problem 23: Get MakeID , Make, SubModelName for all vehicles that have SubModelName 'Elite'
Select Distinct mk.MakeID, mk.Make, sbm.SubModelName
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Inner Join SubModels sbm ON v.SubModelID = sbm.SubModelID
Where sbm.SubModelName = 'Elite';

--   Problem 24: Get all vehicles that have Engines > 3 Liters and have only 2 doors
Select * From VehicleDetails
Where Engine_Liter_Display > 3 And NumDoors = 2;


--   Problem 25: Get make and vehicles that the engine contains 'OHV' and have Cylinders = 4
Select mk.Make, v.*
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Engine Like '%OHV%' And Engine_Cylinders = 4;


--   Problem 26: Get all vehicles that their body is 'Sport Utility' and Year > 2020
Select b.BodyName, v.*
From VehicleDetails v
Inner Join Bodies b ON v.BodyID = b.BodyID
Where b.BodyName = 'Sport Utility' And v.Year > 2020;


--   Problem 27: Get all vehicles that their Body is 'Coupe' or 'Hatchback' or 'Sedan'
Select b.BodyName, v.*
From VehicleDetails v
Inner Join Bodies b ON v.BodyID = b.BodyID
Where b.BodyName IN ('Coupe', 'Hatchback', 'Sedan');


--   Problem 28: Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' and manufactured in year 2008 or 2020 or 2021
Select b.BodyName, v.*
From VehicleDetails v
Inner Join Bodies b ON v.BodyID = b.BodyID
Where b.BodyName IN ('Coupe', 'Hatchback', 'Sedan') And v.Year IN (2008, 2020, 2021);


--   Problem 29: Return found=1 if there is any vehicle made in year 1950
Select Found = 1
Where Exists (Select top 1 * From VehicleDetails Where Year = 1950);

-- SELECT 1 doesn't fetch any actual column data, it just returns a constant. Combined with EXISTS,
-- the engine stops as soon as it finds one match anyway, so DISTINCT is redundant but harmless.
Select Found = 1
Where Exists (Select 1 From VehicleDetails Where Year = 1950);


--   Problem 30: Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words, and if door is null display 'Not Set'
Select Distinct NumDoors From VehicleDetails
Order By NumDoors Asc;

Select Vehicle_Display_Name, NumDoors,
Case 
When NumDoors IS NULL Then 'Not Set' 
When NumDoors = 0 Then 'Zero Doors' -- motorcycles
When NumDoors = 1 Then 'One Doors'
When NumDoors = 2 Then 'Two Doors'
When NumDoors = 3 Then 'Three Doors'
When NumDoors = 4 Then 'Four Doors'
When NumDoors = 5 Then 'Five Doors'
When NumDoors = 6 Then 'Six Doors'
When NumDoors = 8 Then 'Eight Doors'
Else 'Unkown'
End As DoorDescription
From VehicleDetails;


--   Problem 31: Get all Vehicle_Display_Name, year and add extra column to calculate the age of the car then sort the results by age desc.
Select Vehicle_Display_Name, Year, Year(GetDate()) - Year As Age
From VehicleDetails
Order By Age Desc;

Select datediff(year, VehicleDetails.Year, GetDate())
From VehicleDetails;


--   Problem 32: Get all Vehicle_Display_Name, year, Age for vehicles that their age between 15 and 25 years old

Select * From
(
Select Vehicle_Display_Name, Year, Year(GetDate()) - Year As Age
From VehicleDetails

) R1
Where Age Between 15 And 25
Order By Age Desc;


Select Vehicle_Display_Name, Year, Year(GetDate()) - Year As Age
From VehicleDetails
Where (Year(GetDate()) - Year) Between 15 And 25
Order By Age Desc;


--   Problem 33: Get Minimum Engine CC , Maximum Engine CC , and Average Engine CC of all Vehicles
Select Min(Engine_CC) As MinimumEngineCC, Max(Engine_CC) As MaxEngineCC, Avg(Engine_CC) As AvgEngineCC
From VehicleDetails;


--   Problem 34: Get all vehicles that have the minimum Engine_CC
Select * From VehicleDetails
Where Engine_CC = Min(Engine_CC); -- An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.


-- in a subquery 
Select * From VehicleDetails
Where Engine_CC = (Select Min(Engine_CC) From VehicleDetails); 

-- **Note: SQL evaluates WHERE row by row before grouping, so it doesn't know the MIN yet at that stage.
-- **Note: YEAR(GETDATE()) - Year are fine in WHERE because they evaluate per row with no aggregation involved. 

--   Problem 35: Get all vehicles that have the Maximum Engine_CC
Select * From VehicleDetails
Where Engine_CC = (Select Max(Engine_CC) From VehicleDetails);


--   Problem 36: Get all vehicles that have Engin_CC below average
Select * From VehicleDetails
Where Engine_CC < (Select Avg(Engine_CC) From VehicleDetails);


--   Problem 37: Get total vehicles that have Engin_CC above average
Select Count(*) As NumberOfVehiclesAboveAverageEngineCC 
From
(
Select ID, Vehicle_Display_Name
From VehicleDetails
Where Engine_CC > (Select Avg(Engine_CC) From VehicleDetails)
) R1; -- unnecessary

Select Count(*) As NumberOfVehiclesAboveAverageEngineCC
From VehicleDetails
Where Engine_CC > (Select Avg(Engine_CC) From VehicleDetails); -- simpler and more clean


--   Problem 38: Get all unique Engin_CC and sort them Desc
Select Distinct Engine_CC
From VehicleDetails
Order By Engine_CC Desc;

--   Problem 39: Get the maximum 3 Engine CC
Select Distinct top 3 Engine_CC
From VehicleDetails
Order By Engine_CC Desc


--   Problem 40: Get all vehicles that has one of the Max 3 Engine CC
Select ID, Vehicle_Display_Name
From VehicleDetails
Where Engine_CC IN
(
Select Distinct top 3 Engine_CC
From VehicleDetails
Order By Engine_CC Desc
)


--   Problem 41: Get all Makes that manufactures one of the Max 3 Engine CC

-- without joins
Select Distinct MakeID
From VehicleDetails
Where Engine_CC IN (
Select Distinct top 3 Engine_CC From VehicleDetails
Order By Engine_CC Desc
)
Order By MakeID;

-- with joins
Select Distinct mk.MakeID, mk.Make
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where v.Engine_CC IN
(
Select Distinct top 3 Engine_CC
From VehicleDetails
Order By Engine_CC Desc
)
Order By mk.MakeID;


--   Problem 42: Get a table of unique Engine_CC and calculate tax per Engine CC
	-- 0 to 1000    Tax = 100
	-- 1001 to 2000 Tax = 200
	-- 2001 to 4000 Tax = 300
	-- 4001 to 6000 Tax = 400
	-- 6001 to 8000 Tax = 500
	-- Above 8000   Tax = 600
	-- Otherwise    Tax = 0

Select Distinct Engine_CC, 
(
Case
When Engine_CC Between 0 And 1000 Then 100
When Engine_CC Between 1001 And 2000 Then 200
When Engine_CC Between 2001 And 4000 Then 300
When Engine_CC Between 4001 And 6000 Then 400
When Engine_CC Between 6001 And 8000 Then 500
When Engine_CC > 8000 Then 600
Else 0
End
) As Tax
From VehicleDetails
Group By Engine_CC
Order By Engine_CC;


select Engine_CC, 
(
Case
When Engine_CC Between 0 And 1000 Then 100
When Engine_CC Between 1001 And 2000 Then 200
When Engine_CC Between 2001 And 4000 Then 300
When Engine_CC Between 4001 And 6000 Then 400
When Engine_CC Between 6001 And 8000 Then 500
When Engine_CC > 8000 Then 600
Else 0
End
) As Tax
From (Select Distinct Engine_CC From VehicleDetails) R1
Order By Engine_CC;


--   Problem 43: Get Make and Total Number Of Doors Manufactured Per Make
Select mk.Make, Sum(v.NumDoors) As TotalNumberOfDoors
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Group By mk.Make
Order By TotalNumberOfDoors Desc;

Select mk.Make, Sum(v.NumDoors) As TotalNumberOfDoors
From Makes mk
Left Join VehicleDetails v ON mk.MakeID = v.MakeID
Group By mk.Make
Order By TotalNumberOfDoors Desc;


--   Problem 44: Get Total Number Of Doors Manufactured by 'Ford'
Select mk.Make, Sum(v.NumDoors) As TotalNumberOfDoors
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Where mk.Make = 'Ford'
Group By mk.Make;


Select mk.Make, Sum(v.NumDoors) As TotalNumberOfDoors
From VehicleDetails v
Inner Join Makes mk ON v.MakeID = mk.MakeID
Group By mk.Make
Having mk.Make = N'Ford';


--   Problem 45: Get Number of Models Per Make
Select mk.Make, Count(m.ModelID) As NumberOfModels
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Order By NumberOfModels Desc;


SELECT        Makes.Make, COUNT(*) AS NumberOfModels
FROM            Makes INNER JOIN
                         MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY Makes.Make
Order By NumberOfModels Desc


-- COUNT(m.ModelID) vs COUNT(*)
-- COUNT on a specific column only counts non-NULL values, while COUNT(*) counts all rows including potential NULLs.
-- For accuracy, counting the actual ModelID is the right approach.


--   Problem 46: Get the highest 3 manufacturers that make the highest number of models
Select top 3 mk.Make, Count(m.ModelID) As NumberOfModels
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Order By NumberOfModels Desc;


--   Problem 47: Get the highest number of models manufactured
-- First get Number of models per make
-- second get the maximum number resulting from the Number of models per make
Select Max(NumberOfModels) As HighestNumberOfModels
From
(
Select mk.Make, Count(m.ModelID) As NumberOfModels
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
) R1


--   Problem 48: Get the highest Manufacturers manufactured the highest number of models
Select top 1 with ties mk.Make
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Order By Count(m.ModelID) Desc

-- query 
Select mk.Make
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Having Count(m.ModelID) = 
(
-- subquery 1
Select Max(NumberOfModels) As HighestNumberOfModels
From
(
-- subquery 2
Select mk.Make, Count(m.ModelID) As NumberOfModels
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make

) NumberOfModelsTable

)


--   Problem 49: Get the Lowest Manufacturers manufactured the lowest number of models

Select mk.Make
From MakeModels m 
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Having Count(m.ModelID) = 
(
-- get minimum number of models
Select Min(TotalNumberOfModels) As LowestNumberOfModels
From
(
-- get the total number of models per make
Select mk.Make, Count(m.ModelID) As TotalNumberOfModels
From MakeModels m
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
) TotalNumberOfModelsPerMakeTable
)

Select top 1 with ties mk.Make
From MakeModels m 
Inner Join Makes mk ON m.MakeID = mk.MakeID
Group By mk.Make
Order By Count(m.ModelID) Asc;



--   Problem 50: Get all Fuel Types , each time the result should be showed in random order
Select * From FuelTypes
Order By NewID();


-- New Db (EmployeesDB)
Restore Database EmployeesDB
From Disk = 'C:\EmployeesDB.bak';


--   Problem 51: Get all employees that have manager along with Manager's name.
Select * From Employees;

Select Employees.Name, Employees.ManagerID, Employees.Salary, Managers.Name
From Employees 
Inner Join Employees As Managers ON Employees.ManagerID = Managers.EmployeeID

--   Problem 52: Get all employees that have manager or does not have manager along with Manager's name, incase no manager name show null
Select emp.Name, emp.Salary, emp.ManagerID, mng.Name
From Employees emp
Left Join Employees mng ON emp.ManagerID = mng.EmployeeID;


--   Problem 53: Get all employees that have manager or does not have manager along with Manager's name, incase no manager name the same employee name as manager to himself
Select emp.Name, emp.Salary, emp.ManagerID, 
(
Case 
When mng.Name IS NULL Then emp.Name
Else mng.Name
End
) As ManagerName
From Employees emp
Left Join Employees mng ON emp.ManagerID = mng.EmployeeID;


--   Problem 54: Get All Employees managed by 'Mohammed'
Select emp.Name, emp.Salary, emp.ManagerID, mng.Name As ManagerName
From Employees emp
Inner Join Employees mng ON emp.ManagerID = mng.EmployeeID
Where mng.Name = 'Mohammed';
