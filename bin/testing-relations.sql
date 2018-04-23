SELECT
Curriculum.Cohorts.CohortId as [Cohort ID],
Curriculum.Cohorts.SectionNumber as [Section],
CohortStartDate as [Start Date],
dbo.getQuarter(CohortStartDate, '201810', Curriculum.Curriculum.CurriculumLevel) AS [Current Quarter],
CohortStudentCount as [# Students],
Curriculum.Curriculum.CurriculumLevel,
Curriculum.CourseSections.CourseDept,
Curriculum.CourseSections.CohortID AS [Course Section Cohort]
FROM Curriculum.Cohorts JOIN Curriculum.Curriculum
	ON Curriculum.Cohorts.CurriculumId = Curriculum.Curriculum.CurriculumId
	JOIN Curriculum.CourseSections 
	ON (Curriculum.CourseSections.SectionNumber = Curriculum.Cohorts.SectionNumber)
	AND (Curriculum.CourseSections.CohortID = Curriculum.Cohorts.CohortId)
ORDER BY Curriculum.CourseSections.CohortID ASC