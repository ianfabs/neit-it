# neit-it

## SQL Table Analysis

-- this is a query that is a visual representation of something i can't understand
the QuarterID for the courses in the table `Curriculum.CourseSections` is always the value `201740`, 
Which doesn't make sense, right? because in the table `Curriculum.CurriculumCourses` the column `CurriculumQuarter` doesn't relfect the 
translated value represented by QuarterID. If you could shed more light on this, that would be fantastic. Thank you.

 ```SQL
select QuarterID
	  ,dbo.getQuarter('201710', QuarterID, Curriculum.Curriculum.CurriculumLevel) as [Course Quarter]
      ,Curriculum.CurriculumCourses.CurriculumQuarter as [Expected Course Quarter]
	  ,Curriculum.CourseSections.CourseDept
      ,Curriculum.CourseSections.CourseId
      ,Curriculum.CourseSections.SectionNumber
      ,Curriculum.CourseSections.CohortID
	  ,Curriculum.Cohorts.CohortStartDate
	  
	  ,Curriculum.Curriculum.CurriculumLevel
from Curriculum.CourseSections
join Curriculum.Cohorts
	ON Curriculum.Cohorts.CohortId = Curriculum.CourseSections.CohortID
join Curriculum.CurriculumCourses 
	ON Curriculum.CurriculumCourses.CourseDept = Curriculum.CourseSections.CourseDept
join Curriculum.Curriculum
	ON Curriculum.Curriculum.CurriculumID = Curriculum.CurriculumCourses.CurriculumId
 ```
