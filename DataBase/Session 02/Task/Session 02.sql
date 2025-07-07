CREATE TABLE Department (
    DNum INT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(100)
)



CREATE TABLE Employee (
    SSN INT PRIMARY KEY,
    FName VARCHAR(50) NOT NULL,
    LName VARCHAR(50) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Birthdate DATE,
    SuperSSN int,
    DNum INT,
    HireDate DATE,
    FOREIGN KEY (SuperSSN) REFERENCES Employee(SSN),
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
)

CREATE TABLE Project (
    PNum INT PRIMARY KEY,
    PName VARCHAR(100),
    City VARCHAR(100),
    DNum INT,
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
)

CREATE TABLE Works_On (
    SSN int,
    PNum INT,
    WorkingHours INT,
    PRIMARY KEY (SSN, PNum),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNum) REFERENCES Project(PNum)
)

CREATE TABLE Dependent (
    SSN int,
    Name VARCHAR(50),
    Gender CHAR(1),
    Birthdate DATE,
    PRIMARY KEY (SSN, Name),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
)

INSERT INTO Department VALUES (1, 'HR', 'Cairo')
INSERT INTO Department VALUES (2, 'IT', 'Alexandria')
INSERT INTO Department VALUES (3, 'Finance', 'Giza')


INSERT INTO Employee VALUES ('100000001', 'Ali', 'Ahmed', 'M', '1990-01-01', NULL, 1, '2020-06-01')
INSERT INTO Employee VALUES ('100000002', 'Sara', 'Mohamed', 'F', '1992-03-14', '100000001', 2, '2021-01-15')
INSERT INTO Employee VALUES ('100000003', 'Omar', 'Hassan', 'M', '1988-09-20', '100000001', 3, '2018-11-10')
INSERT INTO Employee VALUES ('100000004', 'Laila', 'Samir', 'F', '1995-07-30', '100000002', 2, '2022-04-25')
INSERT INTO Employee VALUES ('100000005', 'Mona', 'Fathy', 'F', '1993-12-12', NULL, 1, '2019-09-05')


UPDATE Employee
SET DNum = 3
WHERE SSN = '100000005'

DELETE FROM Dependent
WHERE SSN = '100000002' AND Name = 'Youssef'

SELECT * FROM Employee
WHERE DNum = 2

SELECT E.FName, E.LName, P.PName
FROM Employee E , Project P , Works_On W
where E.SSN = W.SSN and W.PNum = P.PNum


