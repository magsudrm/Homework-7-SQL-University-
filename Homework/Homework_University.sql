CREATE DATABASE HomeworkUniversity
GO
USE HomeworkUniversity
GO
CREATE TABLE Students (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(20),
  Surname NVARCHAR(20),
  GroupId INT
);
ALTER TABLE Students
DROP COLUMN GroupId
ALTER TABLE Students
ADD GroupId INT FOREIGN KEY REFERENCES Groups(Id)


CREATE TABLE Groups (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(30)
);

CREATE TABLE Subjects (
  Id INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(30)
);
CREATE TABLE Exams (
  Id INT PRIMARY KEY IDENTITY,
  SubjectId INT,
  GroupId INT,
  ExamDate DATE,
  FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
  FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);
ALTER TABLE Exams
ADD Name NVARCHAR (25)


CREATE TABLE StudentExamGrades (
  Id INT PRIMARY KEY IDENTITY,
  ExamId INT,
  StudentId INT,
  Point INT,
  FOREIGN KEY (ExamId) REFERENCES Exams(Id),
  FOREIGN KEY (StudentId) REFERENCES Students(Id)
);

INSERT INTO Students (Name,Surname,GroupId)
VALUES
('Maqsud','Muslumov',1),
('Amin','Israfilzade',2),
('Tural','Isbatov',4),
('Resad','Abbasov',6),
('Elvin','Eliyev',5),
('Resad','Hesenov',2),
('Orxan','Ekberov',3)

INSERT INTO Groups
VALUES
('P232'),
('D256'),
('S122'),
('S202'),
('P214'),
('D112')

INSERT INTO Subjects
VALUES
('SQL'),
('JS'),
('Photoshop'),
('Adobe XD'),
('Ansible'),
('ConnectBot')

INSERT INTO Exams(Name,SubjectId,GroupId,ExamDate)
VALUES
('Weekly exam',1,3,'2023-05-01'),
('Daily exam',4,3,'2023-03-17'),
('Monthly exam',5,2,'2023-05-03'),
('Semester exam',6,5,'2023-05-04'),
('Final test',2,6,'2023-05-05')

INSERT INTO StudentExamGrades(ExamId, StudentId, Point) 
VALUES
  (1, 2, 85),
  (3, 4, 56),
  (5, 5, 70),
  (2, 8, 45),
  (4, 7, 100),
  (5, 3, 60),
  (3, 2, 88),
  (1, 4, 31);

SELECT Students.*, Groups.name as GroupName
FROM Students
JOIN Groups ON Students.GroupId = Groups.Id;

SELECT Students.*, 
(SELECT COUNT(StudentExamGrades.Id) FROM StudentExamGrades 
WHERE StudentExamGrades.StudentId = Students.Id) AS ExamCount
FROM Students;

SELECT Subjects.*
FROM Subjects
LEFT JOIN Exams ON Subjects.Id = Exams.SubjectId
WHERE Exams.Id IS NULL;

INSERT INTO Exams(Name,SubjectId,GroupId,ExamDate)
VALUES
('Weekly exam',2,5,'2023-09-04')

SELECT Exams.Id, Exams.ExamDate, Subjects.Name AS SubjectName,
(SELECT COUNT(*) FROM StudentExamGrades WHERE Exams.Id = StudentExamGrades.ExamId) AS StudentCount
FROM Exams
JOIN Subjects ON Exams.SubjectId = Subjects.Id
WHERE Exams.ExamDate = DATEADD(day, -1, GETDATE());

SELECT StudentExamGrades.*, CONCAT(Students.Name, ' ', Students.Surname) AS FullName, Students.GroupId
FROM StudentExamGrades
JOIN Students ON StudentExamGrades.StudentId = Students.Id;

SELECT 
Students.*,(SELECT AVG(Point) FROM StudentExamGrades WHERE StudentExamGrades.StudentId = Students.Id) AS AverageResult
FROM  Students 