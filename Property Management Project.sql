DROP DATABASE IF EXISTS HAFH;
CREATE DATABASE HAFH;
USE HAFH;

-- Step 1: Create the Manager table without the foreign key to Building
CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,
    MFirstName VARCHAR(50) NOT NULL,
    MLastName VARCHAR(50) NOT NULL,
    MAge INT NOT NULL,
    MBonus DECIMAL(10, 2),
    MSalary DECIMAL(10, 2) NOT NULL,
    MBirthDate DATE NOT NULL
);
CREATE TABLE Manager_MPhone (
    MPhone VARCHAR(15),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID),
    PRIMARY KEY (MPhone, ManagerID)
);


-- Step 2: Create the Building table with a foreign key to Manager
CREATE TABLE Building (
    BuildingID INT PRIMARY KEY,
    BNoOfFloors INT NOT NULL,
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID) ON DELETE SET NULL
);

-- Step 3: Alter the Manager table to add the foreign key to Building
ALTER TABLE Manager
ADD COLUMN BuildingID INT,
ADD FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID) ON DELETE SET NULL;


-- Table: CorpClient
CREATE TABLE CorpClient (
    CCID INT PRIMARY KEY,
    CCName VARCHAR(50) NOT NULL UNIQUE,
    CCIndustry VARCHAR(50) NOT NULL,
    CCLocation VARCHAR(50) NOT NULL,
    Refers_CCID INT NULL,
    FOREIGN KEY (Refers_CCID) REFERENCES CorpClient(CCID)
);

-- Table: Apartment
CREATE TABLE Apartment (
    AptNo INT,
    BuildingID INT,
    ANoOfBedrooms INT NOT NULL,
    CCID INT  NULL,
    PRIMARY KEY (AptNo, BuildingID),
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID) ON DELETE CASCADE,
    FOREIGN KEY (CCID) REFERENCES CorpClient(CCID) ON DELETE SET NULL
);


-- Table: StaffMember
CREATE TABLE StaffMember (
    SMemberID INT PRIMARY KEY,
    SMemberName VARCHAR(50) NOT NULL
);


CREATE TABLE Cleans (
    AptNo INT,
    BuildingID INT,
    SMemberID INT,
    FOREIGN KEY (AptNo, BuildingID) REFERENCES Apartment(AptNo, BuildingID),
    FOREIGN KEY (SMemberID) REFERENCES StaffMember(SMemberID),
    PRIMARY KEY (AptNo, BuildingID, SMemberID)
);


-- Table: Inspector
CREATE TABLE Inspector (
    InsID INT PRIMARY KEY,
    InsName VARCHAR(50) NOT NULL
);


CREATE TABLE Inspects (
    BuildingID INT NOT NULL,
    InsID INT NOT NULL,
    DateNext DATE NULL,
    DateLast DATE NULL,
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID),
    FOREIGN KEY (InsID) REFERENCES Inspector(InsID),
    PRIMARY KEY (BuildingID, InsID)
);


-- Table: Lease
CREATE TABLE Lease (
    LeaseID INT PRIMARY KEY,
    BuildingID INT NOT NULL,
    AptNo INT NOT NULL,
    CCID INT NULL, -- Allows NULL for unoccupied apartments
    LeaseStartDate DATE NOT NULL,
    LeaseEndDate DATE NOT NULL,
    MonthlyRent DECIMAL(10, 2) NOT NULL,
    SecurityDeposit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID) ON DELETE CASCADE,
    FOREIGN KEY (AptNo, BuildingID) REFERENCES Apartment(AptNo, BuildingID) ON DELETE CASCADE,
    FOREIGN KEY (CCID) REFERENCES CorpClient(CCID) ON DELETE SET NULL
);


-- Table: MaintenanceRequest
CREATE TABLE MaintenanceRequest (
    RequestID INT PRIMARY KEY,                 -- Primary key
    AssignedStaff INT NOT NULL,                     -- Foreign key referencing StaffMember
    RequestDate DATE NOT NULL,                 -- Not null (Date of request)
    Status VARCHAR(50) NOT NULL,     -- Status of the request
    Description TEXT, 
    AptNo INT,                                 -- Foreign key referencing Apartment
    BuildingID INT,                            -- Foreign key referencing Building
    FOREIGN KEY (AssignedStaff) REFERENCES StaffMember(SMemberID) ON DELETE CASCADE, -- Assigned staff
    FOREIGN KEY (AptNo, BuildingID) REFERENCES Apartment(AptNo, BuildingID) ON DELETE CASCADE -- Apartment-Building relationship
    );






-- Add CompletedDate column to MaintenanceRequest table
-- This column tracks when maintenance requests are completed
-- NULL values indicate requests that are still pending/in-progress
-- This addition supports:
--   1. Resolution time analysis
--   2. Staff efficiency metrics
--   3. Service level tracking

ALTER TABLE MaintenanceRequest
ADD COLUMN CompletedDate DATE NULL;


-- Populating the Database: 

USE HAFH;

-- Populating Manager table
 INSERT INTO Manager (ManagerID, MFirstName, MLastName, MAge, MBonus, MSalary, MBirthDate)
VALUES
    (4201, 'Alice', 'Cooper', 44, 2000.00, 75000.00, '1980-05-14'),
    (4202, 'Ethan', 'Harris', 39, 1500.00, 70000.00, '1985-08-22'),
    (4203, 'Liam', 'Patterson', 49, NULL, 68000.00, '1975-02-12'),
    (4204, 'Sophia', 'Garcia', 46, 2500.00, 80000.00, '1978-11-05'),
    (4205, 'Chloe', 'Martinez', 41, 2000.00, 72000.00, '1983-07-30'),
    (4206, 'Benjamin', 'Walker', 45, 3000.00, 85000.00, '1979-09-21'),
    (4207, 'Emma', 'Rodriguez', 42, NULL, 69000.00, '1982-12-11'),
    (4208, 'Oliver', 'Nguyen', 38, 1200.00, 71000.00, '1986-03-17'),
    (4209, 'Amelia', 'Clark', 40, 1800.00, 73000.00, '1984-01-28'),
    (4210, 'Lucas', 'Baker', 47, 2200.00, 78000.00, '1977-06-19');




-- Inserting values into Manager_MPhone table with different random phone numbers
INSERT INTO Manager_MPhone (MPhone, ManagerID)
VALUES 
    ('987-654-3210', 4201),
    ('876-543-2109', 4202),
    ('765-432-1098', 4203),
    ('654-321-0987', 4204),
    ('543-210-9876', 4205),
    ('432-109-8765', 4206),
    ('321-098-7654', 4207),
    ('210-987-6543', 4208),
    ('109-876-5432', 4209),
    ('098-765-4321', 4210);


-- Populating Building table
   INSERT INTO Building (BuildingID, BNoOfFloors, ManagerID)
VALUES 
    (101, 10, 4201),
    (102, 8, 4202),
    (103, 12, 4203),
    (104, 15, 4204),
    (105, 7, 4205),
    (106, 9, 4206),
    (107, 5, 4207),
    (108, 6, 4208),
    (109, 10, 4209),
    (110, 8, 4210);

    -- Update Manager with BuildingID now that Building entries exist
UPDATE Manager SET BuildingID = 101 WHERE ManagerID = 4201;
UPDATE Manager SET BuildingID = 102 WHERE ManagerID = 4202;
UPDATE Manager SET BuildingID = 103 WHERE ManagerID = 4203;
UPDATE Manager SET BuildingID = 104 WHERE ManagerID = 4204;
UPDATE Manager SET BuildingID = 105 WHERE ManagerID = 4205;
UPDATE Manager SET BuildingID = 106 WHERE ManagerID = 4206;
UPDATE Manager SET BuildingID = 107 WHERE ManagerID = 4207;
UPDATE Manager SET BuildingID = 108 WHERE ManagerID = 4208;
UPDATE Manager SET BuildingID = 109 WHERE ManagerID = 4209;
UPDATE Manager SET BuildingID = 110 WHERE ManagerID = 4210;
-- Populating CorpClient table
INSERT INTO CorpClient (CCID, CCName, CCIndustry, CCLocation, Refers_CCID)
VALUES 
    (1001, 'TechCorp', 'Technology', 'New York', NULL),         -- No referrals
    (1002, 'HealthInc', 'Healthcare', 'Boston', 1001),          -- Referred by TechCorp
    (1003, 'EduWorld', 'Education', 'Chicago', 1002),           -- Referred by HealthInc
    (1004, 'AgriFoods', 'Agriculture', 'Dallas', 1002),         -- Referred by HealthInc
    (1005, 'MediLab', 'Biotechnology', 'San Francisco', 1003),  -- Referred by EduWorld
    (1006, 'EcoEnergy', 'Energy', 'Denver', 1004),              -- Referred by AgriFoods
    (1007, 'AutoMech', 'Automotive', 'Detroit', 1005),          -- Referred by MediLab
    (1008, 'FinPro', 'Finance', 'Miami', 1005),                 -- Referred by MediLab
    (1009, 'BuildIt', 'Construction', 'Houston', 1006),         -- Referred by EcoEnergy
    (1010, 'Foodies', 'Food & Beverages', 'Seattle', 1009);     -- Referred by BuildIt

-- Populating Apartment table
INSERT INTO Apartment (AptNo, BuildingID, ANoOfBedrooms, CCID)
VALUES 
    (201, 101, 2, 1001), -- TechCorp
    (202, 101, 3, NULL), -- HealthInc - Vacant
    (203, 102, 1, 1003), -- EduWorld
    (204, 102, 2, 1009), -- BuildIt
    (205, 103, 3, NULL), -- AgriFoods - Vacant
    (206, 103, 1, NULL), -- MediLab - Vacant
    (207, 104, 2, 1010), -- Foodies
    (208, 104, 3, 1006), -- EcoEnergy
    (209, 105, 1, 1007), -- AutoMech
    (210, 106, 2, 1008); -- FinPro



-- Populating StaffMember table
INSERT INTO StaffMember (SMemberID, SMemberName)
VALUES 
    (301, 'Alice White'),
    (302, 'Bob Green'),
    (303, 'Carol Black'),
    (304, 'David Brown'),
    (305, 'Emma Grey'),
    (306, 'Frank Pink'),
    (307, 'Grace Blue'),
    (308, 'Henry Orange'),
    (309, 'Ivy Violet'),
    (310, 'Jack Cyan');

-- Inserting values into Cleans table
INSERT INTO Cleans (AptNo, BuildingID, SMemberID)
VALUES 
    (201, 101, 301), -- Alice White cleans this apartment
    (202, 101, 302), -- Bob Green cleans this apartment
    (203, 102, 301), -- Alice White also cleans this apartment
    (204, 102, 303), -- Carol Black cleans this apartment
    (205, 103, 304), -- David Brown cleans this apartment
    (206, 103, 305), -- Emma Grey cleans this apartment
    (207, 104, 302), -- Bob Green also cleans this apartment
    (208, 104, 306), -- Frank Pink cleans this apartment
    (209, 105, 307), -- Grace Blue cleans this apartment
    (210, 106, 304); -- David Brown also cleans this apartment


-- Populating Inspector table
INSERT INTO Inspector (InsID, InsName)
VALUES 
    (401, 'Inspector Lee'),
    (402, 'Inspector Kim'),
    (403, 'Inspector Park'),
    (404, 'Inspector Choi'),
    (405, 'Inspector Jung'),
    (406, 'Inspector Shin'),
    (407, 'Inspector Cho'),
    (408, 'Inspector Yoon'),
    (409, 'Inspector Moon'),
    (410, 'Inspector Han');

INSERT INTO Inspects (BuildingID, InsID, DateNext, DateLast)
VALUES
    (101, 401, '2024-02-15', '2024-01-15'),
    (102, 402, '2024-03-10', '2024-02-10'),
    (103, 403, '2024-04-20', '2024-03-20'),
    (104, 404, '2024-05-25', '2024-04-25'),
    (105, 405, '2024-06-30', '2024-05-30'),
    (106, 406, '2024-07-15', '2024-06-15'),
    (107, 407, '2024-08-10', '2024-07-10'),
    (108, 408, '2024-09-05', '2024-08-05'),
    (109, 409, '2024-10-20', '2024-09-20'),
    (110, 410, '2024-11-15', '2024-10-15');

-- Populating Lease table
INSERT INTO Lease (LeaseID, BuildingID, AptNo, CCID, LeaseStartDate, LeaseEndDate, MonthlyRent, SecurityDeposit)
VALUES 
    (501, 101, 201, 1001, '2024-01-01', '2025-01-01', 1200.00, 2400.00),
    (503, 102, 203, 1003, '2023-12-01', '2024-12-01', 1000.00, 2000.00),
    (504, 102, 204, 1009, '2024-03-01', '2025-03-01', 800.00, 1600.00),
    (507, 104, 207, 1010, '2024-05-01', '2025-05-01', 900.00, 1800.00),
    (508, 104, 208, 1006, '2024-06-01', '2025-06-01', 1600.00, 3200.00),
    (509, 105, 209, 1007, '2024-07-01', '2025-07-01', 1100.00, 2200.00),
    (510, 106, 210, 1008, '2024-08-01', '2025-08-01', 1400.00, 2800.00);


-- Populating MaintenanceRequest table
INSERT INTO MaintenanceRequest (RequestID, AssignedStaff, RequestDate, Description, Status, AptNo, BuildingID)
VALUES 
    (601, 301, '2024-01-15', 'Fix plumbing issue', 'in-progress', 201, 101),
    (602, 302, '2024-02-20', 'Repair electrical wiring', 'completed', 202, 101),
    (603, 303, '2024-03-10', 'Replace door lock', 'pending', 203, 102), 
    (604, 304, '2024-04-05', 'Clean HVAC system', 'completed', 204, 102),
    (605, 305, '2024-05-15', 'Repair windows', 'in-progress', 205, 103), 
    (606, 306, '2024-06-25', 'Fix elevator', 'pending', 206, 103),
    (607, 307, '2024-07-01', 'Pest control', 'completed', 207, 104), 
    (608, 308, '2024-08-10', 'Paint walls', 'in-progress', 208, 104),
    (609, 309, '2024-09-20', 'Inspect fire alarm', 'completed', 209, 105), 
    (610, 310, '2024-10-01', 'Roof maintenance', 'pending', 210, 106);

-- Update completion dates for existing maintenance requests
-- Adding actual completion dates for tracking resolution times
UPDATE MaintenanceRequest
SET CompletedDate = '2024-02-25'
WHERE RequestID = 602;

UPDATE MaintenanceRequest
SET CompletedDate = '2024-04-10'
WHERE RequestID = 604;

UPDATE MaintenanceRequest
SET CompletedDate = '2024-07-05'
WHERE RequestID = 607;

UPDATE MaintenanceRequest
SET CompletedDate = '2024-09-25'
WHERE RequestID = 609;

-- Adding historical maintenance request data for trend analysis
-- Including data from multiple years (2022-2023) to support year-over-year comparisons
INSERT INTO MaintenanceRequest (RequestID, AssignedStaff, RequestDate, Description, Status, AptNo, BuildingID, CompletedDate)
VALUES 
    -- Historical data from 2022 for year-over-year analysis
    (701, 301, '2022-01-10', 'Fix plumbing issue', 'completed', 201, 101, '2022-01-15'),
    (702, 302, '2022-02-05', 'Repair electrical wiring', 'completed', 202, 101, '2022-02-10'),
    (703, 303, '2022-03-12', 'Replace door lock', 'completed', 203, 102, '2022-03-15'),
    (704, 304, '2022-04-18', 'Clean HVAC system', 'completed', 204, 102, '2022-04-25'),
    
    -- Historical data from 2023 for recent trend analysis
    (801, 305, '2023-05-01', 'Repair windows', 'completed', 205, 103, '2023-05-08'),
    (802, 306, '2023-06-15', 'Fix elevator', 'completed', 206, 103, '2023-06-20'),
    (803, 307, '2023-07-10', 'Pest control', 'completed', 207, 104, '2023-07-15'),
    (804, 308, '2023-08-20', 'Paint walls', 'completed', 208, 104, '2023-08-25');

-- Adding historical lease data to support rental trend analysis
-- Including data from 2022-2023 to track rental price changes and occupancy patterns
INSERT INTO Lease (LeaseID, BuildingID, AptNo, CCID, LeaseStartDate, LeaseEndDate, MonthlyRent, SecurityDeposit)
VALUES 
    -- Historical lease data from 2022
    -- Shows initial rental rates and lease terms
    (491, 101, 201, 1001, '2022-01-01', '2023-01-01', 900.00, 1500.00),
    (492, 102, 203, 1003, '2022-06-01', '2023-06-01', 750.00, 1400.00),
    (493, 104, 207, 1010, '2022-03-01', '2023-03-01', 700.00, 1800.00),
    
    -- Lease data from 2023
    -- Demonstrates rental price changes and continued occupancy patterns
    (494, 101, 201, 1001, '2023-01-01', '2024-01-01', 1000.00, 2600.00),
    (495, 104, 208, 1006, '2023-02-01', '2024-02-01', 1400.00, 3200.00),
    (496, 106, 210, 1008, '2023-03-01', '2024-03-01', 1250.00, 2800.00);

-- Simulating changes in client locations to demonstrate SCD functionality
-- These updates will trigger historical tracking in Dim_Client
-- Original locations: 
-- TechCorp: New York -> Los Angeles
-- HealthInc: Boston -> San Diego
-- EduWorld: Chicago -> Sacramento

UPDATE CorpClient
SET CCLocation = 'Los Angeles'
WHERE CCID = 1001;

UPDATE CorpClient
SET CCLocation = 'San Diego'
WHERE CCID = 1002;

UPDATE CorpClient
SET CCLocation = 'Sacramento'
WHERE CCID = 1003;








-- Creating Dimension and Fact Tables

CREATE TABLE Dim_Time (
    TimeKey INT PRIMARY KEY AUTO_INCREMENT,  -- Surrogate key
    FullDate DATE NOT NULL,                  -- Actual date
    Year INT NOT NULL,                       -- Year
    Quarter INT NOT NULL,                    -- Quarter
    Month INT NOT NULL,                      -- Month
    DayOfWeek VARCHAR(10) NOT NULL,          -- Day name (e.g., Monday)
    FiscalYear INT NOT NULL                  -- Fiscal year
);


CREATE TABLE Dim_Building (
    BuildingKey INT PRIMARY KEY,          -- Surrogate key
    BuildingID INT,                 -- Original BuildingID from source
    NumberOfFloors INT,                   -- Same as BNoOfFloors from source
    ManagerID INT,                        -- Reference to original ManagerID
    ManagerFullName VARCHAR(100),         -- Derived from MFirstName + MLastName
    ManagerPhone VARCHAR(15)             -- From Manager_MPhone
 );

CREATE TABLE Dim_Apartment (
    ApartmentKey INT PRIMARY KEY,         -- Surrogate key
    BuildingID INT,                 -- Original BuildingID
    AptNo INT,                      -- Original AptNo
    NumberOfBedrooms INT,                 -- Same as ANoOfBedrooms
    CurrentStatus VARCHAR(20)            -- Derived status
);

CREATE TABLE Dim_Client (
    ClientKey INT PRIMARY KEY,            -- Surrogate key
    CCID INT,                             -- Original CCID
    ClientName VARCHAR(50),               -- Same as CCName
    CCIndustry VARCHAR(50),               -- Same as CCIndustry
    CCLocation VARCHAR(50),               -- Same as CCLocation
    ReferredBy INT,                       -- Same as Refers_CCID
    StartDate DATE NOT NULL,              -- Start date for SCD tracking
    EndDate DATE NULL,                    -- End date for SCD tracking
    IsCurrent BOOLEAN NOT NULL            -- Indicator for the current record
);

CREATE TABLE Dim_Staff (               
    StaffKey INT PRIMARY KEY,           -- Surrogate key
    SMemberID INT,                      -- Original staff ID from operational table
    SMemberName VARCHAR(100)           -- Staff member's full name
);


-- Fact Tables with clear metrics and relationships

   CREATE TABLE Fact_Rental (
    RentalKey INT PRIMARY KEY,            -- Surrogate key
    TimeKey INT NOT NULL,                          -- FK to Dim_Time
    BuildingKey INT,                      -- FK to Dim_Building
    ApartmentKey INT,                     -- FK to Dim_Apartment
    ClientKey INT,                        -- FK to Dim_Client
    LeaseID INT,                    -- Original LeaseID
    MonthlyRent DECIMAL(10,2),      -- From Lease.MonthlyRent
    RevenueGenerated DECIMAL(10,2), -- Added for revenue analysis (Add this to schema)
    SecurityDeposit DECIMAL(10,2),   -- From Lease.SecurityDeposit
    LeaseDuration INT,                -- Calculated field
    LeaseStartDate DATE,      
    LeaseEndDate DATE,  
    OccupancyStatus BOOLEAN,          -- Derived field add this to schema
    FOREIGN KEY (TimeKey) REFERENCES Dim_Time(TimeKey),
    FOREIGN KEY (BuildingKey) REFERENCES Dim_Building(BuildingKey),
    FOREIGN KEY (ApartmentKey) REFERENCES Dim_Apartment(ApartmentKey),
    FOREIGN KEY (ClientKey) REFERENCES Dim_Client(ClientKey)
);

CREATE TABLE Fact_Maintenance (
    MaintenanceKey INT PRIMARY KEY,        -- Surrogate key
    TimeKey INT,                           -- FK to Dim_Time
    BuildingKey INT,                       -- FK to Dim_Building
    ApartmentKey INT,                      -- FK to Dim_Apartment
    StaffKey INT,                               -- FK to Dim_Staff
    RequestID INT,                   -- Original RequestID
    TotalRequests INT,                     -- Count metric
    CompletedRequests INT,                 -- Count metric
    AverageResolutionDays DECIMAL(5,2),    -- Calculated metric
    FOREIGN KEY (TimeKey) REFERENCES Dim_Time(TimeKey),
    FOREIGN KEY (BuildingKey) REFERENCES Dim_Building(BuildingKey),
    FOREIGN KEY (ApartmentKey) REFERENCES Dim_Apartment(ApartmentKey),
    FOREIGN KEY (StaffKey) REFERENCES Dim_Staff(StaffKey)
);


-- ETL Dim Time:
DELIMITER $$
CREATE PROCEDURE PopulateDimTime()
BEGIN
    DECLARE startDate DATE DEFAULT '2020-01-01'; -- Adjust start date as needed
    DECLARE endDate DATE DEFAULT '2030-12-31';   -- Adjust end date as needed
    DECLARE currentDate DATE;

    SET currentDate = startDate; -- Initialize the date

    WHILE currentDate <= endDate DO
        INSERT INTO Dim_Time (FullDate, Year, Quarter, Month, DayOfWeek, FiscalYear)
        VALUES (
            currentDate,                        -- FullDate
            YEAR(currentDate),                  -- Year
            QUARTER(currentDate),               -- Quarter
            MONTH(currentDate),                 -- Month
            DAYNAME(currentDate),               -- DayOfWeek
            CASE 
                WHEN MONTH(currentDate) >= 7 THEN YEAR(currentDate) + 1 -- Fiscal year starts in July
                ELSE YEAR(currentDate)
            END                                -- FiscalYear
        );
        SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY); -- Increment by 1 day
    END WHILE;
END$$

DELIMITER ;

CALL PopulateDimTime();










-- ETL Dim_Building:

INSERT INTO Dim_Building (BuildingKey, BuildingID, NumberOfFloors, ManagerID, ManagerFullName, ManagerPhone)    -- Loading Data into Dim_Building
SELECT 
    ROW_NUMBER() OVER (ORDER BY B.BuildingID) AS BuildingKey, -- Transformation: Generate surrogate key
    B.BuildingID, -- Extracted from Building table
    B.BNoOfFloors, -- Extracted from Building table
    M.ManagerID, -- Extracted from Manager table
    CONCAT(M.MFirstName, ' ', M.MLastName) AS ManagerFullName, -- Transformation: Derive manager's full name
    MP.MPhone -- Extracted from Manager_MPhone table
FROM Building B
LEFT JOIN Manager M ON B.ManagerID = M.ManagerID -- Extraction: Join Building with Manager
LEFT JOIN Manager_MPhone MP ON M.ManagerID = MP.ManagerID; -- Extraction: Join Manager with Manager_MPhone

-- ETL Dim_Apartment:

INSERT INTO Dim_Apartment (ApartmentKey, BuildingID, AptNo, NumberOfBedrooms, CurrentStatus)  -- Loading Data into Dim_Apartment
SELECT 
    ROW_NUMBER() OVER (ORDER BY A.BuildingID, A.AptNo) AS ApartmentKey, -- Transformation: Generate surrogate key
    A.BuildingID,                -- Extracted from Apartment table
    A.AptNo,                      -- Extracted from Apartment table
    A.ANoOfBedrooms,     -- Extracted from Apartment table
    CASE 
        WHEN A.CCID IS NULL THEN 'Vacant'   -- Transformation: Assign 'Vacant' if no corporate client is associated
        ELSE 'Occupied'       -- Transformation: Assign 'Occupied' if a corporate client is associated
    END AS CurrentStatus
FROM Apartment A;      -- Extraction: Source table for apartment details









-- ETL Dim_Client and Implementing SCD (Slowly changing Dimension):

-- Loading data into Dim_Client with SCD Type 2 logic
-- Extract data from CorpClient table for Client ID, Name, Industry, Location, and Referral information

INSERT INTO Dim_Client (ClientKey, CCID, ClientName, CCIndustry, CCLocation, ReferredBy, StartDate, EndDate, IsCurrent)
SELECT 
    ROW_NUMBER() OVER (ORDER BY CC.CCID) AS ClientKey,
    CC.CCID,
    CC.CCName AS ClientName,
    CC.CCIndustry,
    CC.CCLocation,
    CC.Refers_CCID AS ReferredBy,
    -- Transformation: Get earliest lease date for each client, if no lease found default to '2024-01-01'
    COALESCE(
        (SELECT MIN(LeaseStartDate) 
         FROM Lease L 
         WHERE L.CCID = CC.CCID),
        '2024-01-01'  -- Default date for clients with no lease history
    ) AS StartDate,
    NULL AS EndDate,
    TRUE AS IsCurrent
FROM CorpClient CC
WHERE NOT EXISTS (
    SELECT 1 
    FROM Dim_Client DC
    WHERE DC.CCID = CC.CCID
    AND DC.CCLocation = CC.CCLocation
    AND DC.IsCurrent = TRUE
);

-- Update existing records when locations change
UPDATE Dim_Client
SET EndDate = CURRENT_DATE - INTERVAL 1 DAY, -- Mark the record as historical
    IsCurrent = FALSE -- Mark as a previous record
WHERE ClientKey IN (
    SELECT ClientKey 
    FROM (
        SELECT DC.ClientKey
        FROM Dim_Client DC
        INNER JOIN CorpClient CC ON DC.CCID = CC.CCID
        WHERE DC.IsCurrent = TRUE -- Only consider current records
        AND DC.CCLocation <> CC.CCLocation -- Detect location change
    ) AS temp
);



-- ETL Dim_Staff:

-- Loading data into Dim_staff 

INSERT INTO Dim_Staff (
    StaffKey,        -- Surrogate Key
    SMemberID,       -- Original Staff Member ID
    SMemberName      -- Full Name of Staff Member
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY SM.SMemberID) AS StaffKey,  -- Transformation: Generate Surrogate Key
    SM.SMemberID,                                           -- Extract Staff Member ID
    SM.SMemberName                                          -- Extract Full Name
FROM StaffMember SM;                                        -- Extract from Operational Table



-- Fact Rental ETL:
-- Loading data into Fact_Rental with extracted data from operational and dimension tables and transformed metrics

INSERT INTO Fact_Rental (
    RentalKey, TimeKey, BuildingKey, ApartmentKey, ClientKey, LeaseID,
    MonthlyRent, RevenueGenerated, SecurityDeposit, LeaseDuration,
    LeaseStartDate, LeaseEndDate, OccupancyStatus
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY L.LeaseID) AS RentalKey,
    T.TimeKey, 
    DB.BuildingKey, 
    DA.ApartmentKey, 
    DC.ClientKey, 
    L.LeaseID,
    L.MonthlyRent,
    ROUND(L.MonthlyRent * DATEDIFF(L.LeaseEndDate, L.LeaseStartDate) / 30, 2) AS RevenueGenerated,    -- Transformation: Calculate revenue generated
    L.SecurityDeposit,
    DATEDIFF(L.LeaseEndDate, L.LeaseStartDate) AS LeaseDuration, -- Transformation: Calculate lease duration in days
    L.LeaseStartDate,
    L.LeaseEndDate,
    CASE 
        WHEN L.LeaseEndDate >= CURRENT_DATE THEN 1
        ELSE 0
    END AS OccupancyStatus    -- Transformation: Derive occupancy status
FROM Lease L
-- Extraction: Retrieve data from the operational Lease table and dimension tables Dim_Time, Dim_Building, Dim_Apartment, and Dim_Client
JOIN Dim_Time T ON DATE(L.LeaseStartDate) = T.FullDate
JOIN Dim_Building DB ON L.BuildingID = DB.BuildingID
JOIN Dim_Apartment DA ON L.AptNo = DA.AptNo AND L.BuildingID = DA.BuildingID
JOIN Dim_Client DC ON L.CCID = DC.CCID;


-- ETL Fact Maintenance:

-- Loading data into Fact_Maintenance with extracted data from operational and dimension tables and transformed metrics

INSERT INTO Fact_Maintenance (
    MaintenanceKey,
    TimeKey,
    BuildingKey,
    ApartmentKey,
    RequestID,
    TotalRequests,
    CompletedRequests,
    AverageResolutionDays
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY MR.RequestID) AS MaintenanceKey, -- Transformation: Generate surrogate key for the fact table
    DT.TimeKey,
    DB.BuildingKey,
    DA.ApartmentKey,
    MR.RequestID,
    1 AS TotalRequests,  -- Transformation: Each row represents 1 request
    CASE WHEN MR.Status = 'completed' THEN 1 ELSE 0 END AS CompletedRequests, -- Transformation: Derive count of completed requests
    CASE 
        WHEN MR.Status = 'completed' 
        THEN DATEDIFF(MR.CompletedDate, MR.RequestDate)
        ELSE NULL 
    END AS AverageResolutionDays  -- Transformation: Calculate average resolution time for completed requests
FROM MaintenanceRequest MR
-- Extraction: Retrieve data from operational MaintenanceRequest table and dimension tables Dim_Time, Dim_Building, and Dim_Apartment
JOIN Dim_Time DT ON DATE(MR.RequestDate) = DT.FullDate  -- Extraction: Link time dimension
JOIN Dim_Building DB ON MR.BuildingID = DB.BuildingID   -- Extraction: Link building dimension
JOIN Dim_Apartment DA ON MR.AptNo = DA.AptNo 
    AND MR.BuildingID = DA.BuildingID;     -- Extraction: Link apartment dimension
    

CREATE TABLE Summary_StaffEfficiency AS
SELECT 
    S.SMemberID,
    S.SMemberName AS StaffMemberName,
    YEAR(MR.RequestDate) AS Year,
    COUNT(MR.RequestID) AS TotalRequestsHandled,
    AVG(DATEDIFF(MR.CompletedDate, MR.RequestDate)) AS AvgResolutionDays
FROM Dim_Staff S
LEFT JOIN MaintenanceRequest MR 
    ON S.SMemberID = MR.AssignedStaff
WHERE MR.Status = 'completed'
GROUP BY 
    S.SMemberID, 
    S.SMemberName, 
    YEAR(MR.RequestDate);

CREATE TABLE Summary_OccupancyTrends AS
SELECT 
    DB.BuildingID,
    COUNT(DISTINCT CASE 
        WHEN FR.LeaseID IS NOT NULL THEN DA.ApartmentKey 
    END) AS TotalOccupiedApartments,
    COUNT(DISTINCT DA.ApartmentKey) AS TotalApartments,
    ROUND(
        COUNT(DISTINCT CASE WHEN FR.LeaseID IS NOT NULL THEN DA.ApartmentKey END) * 100.0 / 
        COUNT(DISTINCT DA.ApartmentKey),
        2
    ) AS AverageOccupancyRate
FROM Dim_Building DB
JOIN Dim_Apartment DA ON DB.BuildingID = DA.BuildingID
LEFT JOIN Fact_Rental FR ON DA.ApartmentKey = FR.ApartmentKey
GROUP BY DB.BuildingID;


CREATE TABLE Summary_YearlyRentalIncome AS
SELECT 
    B.BuildingID,
    YEAR(T.FullDate) AS RentalYear,
    ROUND(SUM(FR.MonthlyRent * FR.LeaseDuration / 30), 2) AS TotalRentalIncome
FROM Fact_Rental FR
JOIN Dim_Building B ON FR.BuildingKey = B.BuildingKey
JOIN Dim_Time T ON FR.TimeKey = T.TimeKey
WHERE YEAR(T.FullDate) IN (YEAR(CURRENT_DATE) - 2, YEAR(CURRENT_DATE) - 1)
GROUP BY B.BuildingID, YEAR(T.FullDate);


CREATE TABLE Summary_UnresolvedRequests AS
SELECT 
    DB.BuildingID AS BuildingID,
    COUNT(MR.RequestID) AS UnresolvedRequests
FROM MaintenanceRequest MR
JOIN Dim_Building DB ON MR.BuildingID = DB.BuildingID -- Map BuildingID to Dim_Building
WHERE MR.Status IS NULL OR MR.Status != 'completed' -- Include NULL and non-completed statuses
GROUP BY DB.BuildingID;

CREATE TABLE Summary_RequestResolutionDetails AS
SELECT 
    YEAR(DT.FullDate) AS RequestYear,         
    MONTH(DT.FullDate) AS RequestMonth,       
    MR.RequestID,                             
    MR.Description AS RequestDescription,     
    MR.Status AS RequestStatus,              
    DATEDIFF(MR.CompletedDate, MR.RequestDate) AS ResolutionDays 
FROM MaintenanceRequest MR
LEFT JOIN Dim_Time DT ON MR.RequestDate = DT.FullDate 
WHERE MR.Status = 'completed' -- Only include completed requests
ORDER BY ResolutionDays ASC; -- Order by the fastest resolution


CREATE TABLE Summary_RentalIncomeByBedrooms AS
SELECT 
    DA.NumberOfBedrooms AS Bedrooms,                      
    ROUND(SUM(FR.MonthlyRent * FR.LeaseDuration / 30), 2) AS TotalRentalIncome, 
    ROUND(AVG(FR.MonthlyRent), 2) AS AverageMonthlyRent, 
    COUNT(DISTINCT FR.ApartmentKey) AS TotalApartments   
FROM Fact_Rental FR
JOIN Dim_Apartment DA ON FR.ApartmentKey = DA.ApartmentKey 
GROUP BY DA.NumberOfBedrooms                            
ORDER BY TotalRentalIncome DESC;









