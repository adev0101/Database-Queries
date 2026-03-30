
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

