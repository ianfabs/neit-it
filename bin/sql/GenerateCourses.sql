-- populate the cohorts table - done within the tool

-- Generate the section numbers
exec dbo.generateSectionNumbers '201740'


DELETE FROM  Curriculum.CourseSections
WHERE QuarterID = '201740'

-- Generate courses along with sections for each of the cohorts
INSERT INTO Curriculum.CourseSections (QuarterID,  CourseDept, CourseId, SectionNumber, CohortID, StudentCount)
SELECT '201740', ccs.CourseDept,  ccs.CourseId, '.' + RIGHT('00'+CAST(SectionNumber AS VARCHAR(2)),2), CohortId, CohortStudentCount
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
INNER JOIN Curriculum.CurriculumCourses ccs ON  dbo.getQuarterDifference (CohortStartDate,'201740') = ccs.CurriculumQuarter+1 and coh.CurriculumId = ccs.CurriculumId

SELECT CourseDept + ' ' + CourseId   AS Course, CohortSession, SUM(StudentCount) AS TotalStudents,  COUNT(*) AS Sections,  
COUNT(*) - CEILING(SUM(StudentCount)/20.0) AS NumberToCancel
FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts c ON cs.CohortID = c.CohortId
GROUP BY CourseDept + ' ' + CourseId, CohortSession
HAVING COUNT(*) - CEILING(SUM(StudentCount)/20.0) > 0
ORDER BY CourseDept + ' ' + CourseId, CohortSession

DECLARE @sql NVARCHAR(200)
SET @sql =    'SELECT * FROM 
	Curriculum.CourseSections'; 
exec sp_executesql @sql;

-- Make duplicate sections unique
SELECT CourseDept + ' ' + CourseId + SectionNumber  AS Course, COUNT(*), SUM(StudentCount),  COUNT(*) - CEILING(SUM(StudentCount)/20.0) AS NumberToCancel
FROM Curriculum.CourseSections
GROUP BY  CourseDept + ' ' + CourseId + SectionNumber
HAVING COUNT(*) > 1

SELECT * FROM Curriculum.CourseSections
WHERE CourseDept = 'GDS' AND CourseId='243' and sectionNumber = '.04'


SELECT  CohortId, CohortSession, dbo.getQuarterDifference (CohortStartDate,'201740') AS Quarter, ccs.CurriculumQuarter, 
       c.CurriculumProgramName, CohortStudentCount, '.' + RIGHT('00'+CAST(SectionNumber AS VARCHAR(2)),2) AS SectionNumber, 
	   ccs.CourseDept + ' ' + ccs.CourseId AS Course
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
INNER JOIN Curriculum.CurriculumCourses ccs ON  dbo.getQuarterDifference (CohortStartDate,'201740') = ccs.CurriculumQuarter+1 and coh.CurriculumId = ccs.CurriculumId
--ORDER BY CohortSession, CurriculumLevel, dbo.getQuarterDifference (CohortStartDate, '201740') , CurriculumProgramName
ORDER BY ccs.CourseDept , ccs.CourseId

-- delete sections that have other courses in the same session.
SELECT  CohortSession,    ccs.CourseDept , ccs.CourseId AS Course, COUNT(*) AS NumberOfSections, SUM(CohortStudentCount) AS StudentCount, COUNT(*) - CEILING(SUM(CohortStudentCount)/20.0) AS NumberToCancel
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
INNER JOIN Curriculum.CurriculumCourses ccs ON  dbo.getQuarterDifference (CohortStartDate,'201740') = ccs.CurriculumQuarter+1 and coh.CurriculumId = ccs.CurriculumId
GROUP BY CohortSession,   ccs.CourseDept , ccs.CourseId
HAVING COUNT(*) > 1 and COUNT(*) > CEILING(SUM(CohortStudentCount)/20.0)
ORDER BY ccs.CourseDept , ccs.CourseId

-- add sections for those courses that have an anticipated number of students greater than the max for the course

CREATE TABLE Curriculum.MaxClassSize (
   CourseDept VARCHAR(5),
   CourseId VARCHAR(10),
   ClassSize INT
)

INSERT INTO Curriculum.MaxClassSize (CourseDept, CourseId, ClassSize) VALUES ('NE', '242', 15)
INSERT INTO Curriculum.MaxClassSize (CourseDept, CourseId, ClassSize) VALUES ('NE', '257', 15)
INSERT INTO Curriculum.MaxClassSize (CourseDept, CourseId, ClassSize) VALUES ('NE', '406', 15)
INSERT INTO Curriculum.MaxClassSize (CourseDept, CourseId, ClassSize) VALUES ('NE', '415', 15)
INSERT INTO Curriculum.MaxClassSize (CourseDept, CourseId, ClassSize) VALUES ('NE', '418', 15)

SELECT * FROM Curriculum.MaxClassSize
SELECT * FROM Curriculum.Courses WHERE CourseDept = 'NE'
