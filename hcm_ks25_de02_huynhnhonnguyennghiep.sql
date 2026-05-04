CREATE DATABASE CenterManagement;
USE CenterManagement;

CREATE TABLE Student (
    IDstudent VARCHAR(10) PRIMARY KEY,
    Fullname  VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Numberphone VARCHAR(15),
    Birthday  DATE
);

CREATE TABLE Course (
    IDclient  VARCHAR(10) PRIMARY KEY,
    Nameclient  VARCHAR(255) NOT NULL,
    Teacher VARCHAR(255),
    Tuition DECIMAL(18, 0) NOT NULL CHECK (Tuition >= 0),
    Duration INT
);

CREATE TABLE Enrollment (
    IDticket VARCHAR(10) PRIMARY KEY,
    IDstudent VARCHAR(10) NOT NULL,
    Dateofreceipt DATE NOT NULL,
    Paymentmethods VARCHAR(20) CHECK (Paymentmethods IN ('Cash', 'Transfer')),
    FOREIGN KEY (IDstudent) REFERENCES Student(IDstudent)
);

CREATE TABLE Enrollment_Detail (
    IDticket VARCHAR(10),
    IDclient VARCHAR(10),
    Learningstate VARCHAR(20) CHECK (Learningstate IN ('Studying', 'Reserve')),
    Finalgrade DECIMAL(4, 2),
    PRIMARY KEY (IDticket, IDclient),
    FOREIGN KEY (IDticket) REFERENCES Enrollment(IDticket),
    FOREIGN KEY (IDclient) REFERENCES Course(IDclient)
);
ALTER TABLE Enrollment
ADD COLUMN Note TEXT;

ALTER TABLE Course
CHANGE COLUMN Teacher Instructor VARCHAR(255);

INSERT INTO Student (IDstudent, Fullname, Email, Numberphone, Birthday) VALUES
('HV001', 'Nguyen Van A', 'nguyenvana@email.com', '0901111111', '2000-01-15'),
('HV002', 'Tran Thi B', 'tranthib@email.com', '0902222222', '1999-05-20'),
('HV003', 'Le Van C', NULL, '0903333333', '2001-11-01'),
('HV004', 'Pham Thu D', 'phamthud@email.com', '0904444444', '2002-03-25'),
('HV005', 'Huynh Van E', 'huynhvane@email.com', '0905555555', '2000-08-10');

INSERT INTO Course (IDclient, Nameclient, Instructor, Tuition, Duration) VALUES
('C001', 'IELTS 6.5', 'Trần Anh', 3500000, 60),
('C002', 'Basic Office IT', 'Nguyễn Thị Hoa', 900000, 30),
('C003', 'Python Programming', 'Trần Anh', 2000000, 45),
('C004', 'Conversational English', 'Phạm Duy', 1500000, 40),
('C005', 'Presentation Skills', 'Nguyễn Thị Hoa', 3200000, 20);

INSERT INTO Enrollment (IDticket, IDstudent, Dateofreceipt, Paymentmethods, Note) VALUES
('PDK001', 'HV001', '2026-06-10', 'Cash', 'Fully paid'),
('PDK002', 'HV002', '2026-07-05', 'Transfer', NULL),
('PDK003', 'HV003', '2026-08-01', 'Cash', 'Awaiting confirmation'),
('PDK004', 'HV004', '2026-07-20', 'Transfer', 'Double for 2 courses'),
('PDK005', 'HV005', '2026-05-15', 'Cash', NULL);

INSERT INTO Enrollment_Detail (IDticket, IDclient, Learningstate, Finalgrade) VALUES
('PDK001', 'C001', 'Studying', NULL),
('PDK001', 'C004', 'Reserve', NULL),
('PDK002', 'C003', 'Studying', NULL),
('PDK003', 'C005', 'Reserve', NULL),
('PDK004', 'C001', 'Studying', 8.5),
('PDK004', 'C002', 'Studying', 9.0),
('PDK005', 'C004', 'Studying', NULL);

UPDATE Course
SET Tuition = Tuition * 0.9
WHERE Instructor = 'Trần Anh';

DELETE FROM Student
WHERE Email IS NULL;

SELECT *
FROM Course
WHERE Tuition BETWEEN 1000000 AND 3000000;

SELECT S.Fullname, E.IDticket
FROM Student S
JOIN Enrollment E ON S.IDstudent = E.IDstudent
WHERE YEAR(E.Dateofreceipt) = 2026 AND MONTH(E.Dateofreceipt) = 7;

SELECT C.Nameclient
FROM Course C
JOIN Enrollment_Detail ED ON C.IDclient = ED.IDclient
WHERE ED.IDticket = 'PDK001';

SELECT DISTINCT S.Fullname, S.Numberphone, S.Email
FROM Student S
JOIN Enrollment E ON S.IDstudent = E.IDstudent
JOIN Enrollment_Detail ED ON E.IDticket = ED.IDticket
JOIN Course C ON ED.IDclient = C.IDclient
WHERE C.Nameclient = 'IELTS 6.5';

SELECT
    ED.IDticket,
    C.Nameclient,
    C.Instructor,
    ED.Finalgrade
FROM Enrollment_Detail ED
JOIN Course C ON ED.IDclient = C.IDclient
WHERE ED.Learningstate = 'Studying';