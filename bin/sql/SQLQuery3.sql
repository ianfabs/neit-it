DELETE FROM Curriculum.CourseSections
GO
exec generateCourseSections '201810'
GO
exec generateSectionNumbers '201810'
GO
exec generateUniqueSectionNumbers

SELECT * FROM Curriculum.CourseSections ORDER BY CourseDept, CourseId
SELECT * FROM Curriculum.Courses WHERE CourseDept = 'IT' and CourseId='259'
SELECT * FROM Curriculum.CurriculumCourses WHERE CourseDept = 'IT' and CourseId='259'

UPDATE Curriculum.Courses 
SET CourseDept = 'NE'
WHERE CourseDept = 'IT' and CourseId='259'

UPDATE Curriculum.CurriculumCourses 
SET CourseDept = 'NE'
WHERE CourseDept = 'IT' and CourseId='259'

SELECT * FROM Curriculum.CourseDeletions

CREATE PROC getInstructorHis

SELECT CohortId, Quarter, CurriculumLevel, CurriculumProgramName, CohortSession, CourseDept, t.CourseId, SectionNumber, StudentCount,
instructorDisplayName, instructorInitials, TimesTaught FROM
(
SELECT coh.CohortId, dbo.getQuarter (CohortStartDate, QuarterId, CurriculumLevel) AS Quarter, CurriculumLevel, 
       c.CurriculumProgramName, CohortSession, cs.CourseDept, cs.CourseID, cs.SectionNumber, cs.StudentCount, 'RUNNING' AS status
FROM Curriculum.CourseSections cs 
INNER JOIN Curriculum.Cohorts coh ON cs.CohortID = coh.CohortId
INNER JOIN Curriculum.Curriculum c ON coh.CurriculumId = c.CurriculumID

UNION
SELECT coh.CohortId, dbo.getQuarter (CohortStartDate,'201740', CurriculumLevel) AS Quarter,CurriculumLevel, 
       c.CurriculumProgramName, CohortSession, cd.CourseDept, cd.CourseID, coh.SectionNumber, coh.CohortStudentCount, 'DELETED' AS Status
FROM Curriculum.CourseDeletions cd
INNER JOIN Curriculum.Cohorts coh ON cd.CohortID = coh.CohortId
INNER JOIN Curriculum.Curriculum c ON coh.CurriculumId = c.CurriculumID

 ) t
 LEFT OUTER JOIN

 (

 SELECT instructorDisplayName, instructorInitials, dept, courseid, COUNT(*) As TimesTaught
 FROM Curriculum.CourseHistory ch INNER JOIN Curriculum.instructor i on ch.instructorid = i.instructorid
 WHERE instructorActive = 1 
 GROUP BY instructorDisplayName, instructorInitials, dept, courseid

) t2 ON t.CourseDept= t2.dept and t.CourseId = t2.courseid

ORDER BY CohortSession, CurriculumLevel, quarter, CurriculumProgramName, CohortId, CourseDept, t.CourseId, TimesTaught DESC

-- calculate columns

SELECT  Dept, CourseId, COUNT(*) 
FROM (
SELECT instructorDisplayName, dept, courseid, COUNT(*) As TimesTaught
 FROM Curriculum.CourseHistory ch INNER JOIN Curriculum.instructor i on ch.instructorid = i.instructorid
 WHERE instructorActive = 1 
 GROUP BY instructorDisplayName, dept, courseid
) t 
GROUP BY Dept, CourseId
ORDER BY COUNT(*) DESC



