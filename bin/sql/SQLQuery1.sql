
ALTER PROC dbo.generateSectionNumbers
@CurrentQuarter VARCHAR(10)
 AS
	DECLARE @MyCohorts table(
	RowID INT IDENTITY(1,1),  
    CohortId int NOT NULL,  
    Qtr int,  
    Session VARCHAR(10),  
    CurriculumId INT, Level VARCHAR(10));
	DECLARE @NumberRecords INT, @RowCount INT, @level VARCHAR(10);
	DECLARE @cohortId INT, @qtr INT, @qtr1 int, @session VARCHAR(10), @curriculumId INT;
	DECLARE @oldQtr INT, @oldCurriculumId INT, @oldSectionNumber INT, @sectionNumber INT, @eve bit, @oldEve bit

INSERT INTO @MyCohorts (CohortId, Qtr, Session, CurriculumID, Level)
SELECT CohortId, dbo.getQuarterDifference (CohortStartDate, @CurrentQuarter) AS Quarter, CohortSession, coh.CurriculumId , CurriculumLevel 
FROM Curriculum.Cohorts coh LEFT OUTER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
ORDER BY  coh.CurriculumId, dbo.getQuarterDifference (CohortStartDate, @CurrentQuarter),CohortSession

SET @NumberRecords = @@ROWCOUNT
SET @RowCount = 1

set @oldQtr = -1
set @oldCurriculumId = -1

WHILE @RowCount <= @NumberRecords
BEGIN
 SELECT @CohortId = CohortId, @qtr=Qtr, @session = Session, @curriculumId=CurriculumId, @level=level
 FROM @MyCohorts
 WHERE RowID = @RowCount


 if @Session = 'Eve'
	set @eve = 1
else
	set @eve = 0
 if @oldCurriculumID = @curriculumId  and @oldQtr = @qtr and @oldEve = @eve
   SET @sectionNumber = @oldSectionNumber + 10
ELSE
	BEGIN
		set @qtr1 = @qtr
		if @level = 'BS'
			set @qtr1 = @qtr + 6
		
		
		SELECT @sectionNumber = SectionNumber FROM Curriculum.SectionNumbers WHERE Qtr = @qtr1 and Eve = @eve 
	END
	
UPDATE Curriculum.Cohorts
SET SectionNumber = @sectionNumber
WHERE CohortId = @cohortId

SET  @oldCurriculumID = @curriculumId
SET  @oldQtr = @qtr
SET  @oldSectionNumber = @sectionNumber
SET @oldEve = @eve
 SET @RowCount = @RowCount + 1
END

GO

exec dbo.generateSectionNumbers '201740'
go

SELECT coh.CurriculumId, dbo.getQuarterDifference (CohortStartDate, '201740') AS Quarter,  CohortSession, '.' + RIGHT('00'+CAST(SectionNumber AS VARCHAR(2)),2) AS SectionNo, SectionNumber, CurriculumLevel 
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
ORDER BY  coh.CurriculumId , dbo.getQuarterDifference (CohortStartDate, '201740'), SectionNumber

SELECT  CohortSession,    ccs.CourseDept , ccs.CourseId AS Course, COUNT(*) AS NumberOfSections, SUM(CohortStudentCount) AS StudentCount, COUNT(*) - CEILING(SUM(CohortStudentCount)/20.0) AS NumberToCancel
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
INNER JOIN Curriculum.CurriculumCourses ccs ON  dbo.getQuarterDifference (CohortStartDate,'201740') = ccs.CurriculumQuarter+1 and coh.CurriculumId = ccs.CurriculumId
GROUP BY CohortSession,   ccs.CourseDept , ccs.CourseId

HAVING COUNT(*) > 1 and COUNT(*) > CEILING(SUM(CohortStudentCount)/20.0)
ORDER BY ccs.CourseDept , ccs.CourseId