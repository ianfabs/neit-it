USE [erik]
GO
/****** Object:  User [ICT\admin-mpreziosi]    Script Date: 7/7/2017 9:53:03 PM ******/
CREATE USER [ICT\admin-mpreziosi] FOR LOGIN [ICT\admin-mpreziosi] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [Curriculum]    Script Date: 7/7/2017 9:53:03 PM ******/
CREATE SCHEMA [Curriculum]
GO
/****** Object:  UserDefinedFunction [dbo].[getQuarter]    Script Date: 7/7/2017 9:53:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[getQuarter] (@q1 VARCHAR(10), @q2 VARCHAR(10), @level VARCHAR(10))
RETURNS INT
AS
BEGIN
  DECLARE @difference INT, @q1ValueYear AS INT, @q1ValueTerm as INT;
  SET @difference = 0;

  set @q1ValueYear = @q1/100;
  set @q1ValueTerm = @q1 % 100;
  
  WHILE @q1 <= @q2 and @difference < 10
  BEGIN
   SET @q1ValueTerm = @q1ValueTerm + 10
   IF @q1ValueTerm = 50 
		SET @q1ValueTerm = 10
	IF @q1ValueTerm =10
	    SET @q1ValueYear = @q1ValueYear + 1
	SET @difference = @difference + 1
	set @q1 = cast(@q1ValueYear as varchar(10)) + cast(@q1ValueTerm as varchar(10))
                          
  END
  if (@level = 'BS')
	SET @difference = @difference + 6

	RETURN @difference;
	END;


GO
/****** Object:  UserDefinedFunction [dbo].[getQuarterDifference]    Script Date: 7/7/2017 9:53:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getQuarterDifference] (@q1 VARCHAR(10), @q2 VARCHAR(10))
RETURNS INT
AS
BEGIN
  DECLARE @difference INT, @q1ValueYear AS INT, @q1ValueTerm as INT;
  SET @difference = 0;

  set @q1ValueYear = @q1/100;
  set @q1ValueTerm = @q1 % 100;
  
  WHILE @q1 <= @q2 and @difference < 10
  BEGIN
   SET @q1ValueTerm = @q1ValueTerm + 10
   IF @q1ValueTerm = 50 
		SET @q1ValueTerm = 10
	IF @q1ValueTerm =10
	    SET @q1ValueYear = @q1ValueYear + 1
	SET @difference = @difference + 1
	set @q1 = cast(@q1ValueYear as varchar(10)) + cast(@q1ValueTerm as varchar(10))
                          
  END

	RETURN @difference;
	END;

GO
/****** Object:  UserDefinedFunction [dbo].[getSectionNumber]    Script Date: 7/7/2017 9:53:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getSectionNumber] (@currentQuarter VARCHAR(20), @startdate VARCHAR(20), @cid INT)
RETURNS INT
AS
BEGIN
 DECLARE @result INT, @qtr INT
 DECLARE @MaxSectionNumber INT

 SET @qtr = dbo.getQuarterDifference (@currentQuarter, @startdate) 
 SELECT @MaxSectionNumber  = ISNULL(Max(SectionNumber), 0) 
 FROM Curriculum.Cohorts
  WHERE CurriculumId = @cid and CohortStartDate = @startdate  

 if @MaxSectionNumber <> 0
	SET @result = @MaxSectionNumber + 10
 else IF (@qtr <= 10)
	set @result = @qtr;
   else if (@qtr = 11)
    set @result = 30
  else if (@qtr = 12)
    set @result = 40
  return(@result)
END;

GO
/****** Object:  Table [Curriculum].[Cohorts]    Script Date: 7/7/2017 9:53:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[Cohorts](
	[CohortId] [bigint] IDENTITY(1,1) NOT NULL,
	[CohortStartDate] [varchar](10) NULL,
	[CohortSession] [varchar](5) NULL,
	[CurriculumId] [bigint] NULL,
	[CohortStudentCount] [int] NULL,
	[SectionNumber] [varchar](5) NULL,
 CONSTRAINT [PK__Cohorts__4A228F1FB07572A8] PRIMARY KEY CLUSTERED 
(
	[CohortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[CourseDeletions]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[CourseDeletions](
	[CourseDeletionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CourseDept] [varchar](10) NULL,
	[CourseId] [varchar](10) NULL,
	[Session] [varchar](10) NULL,
	[CohortID] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseDeletionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[courses]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[courses](
	[CourseDept] [varchar](5) NOT NULL,
	[CourseID] [varchar](10) NOT NULL,
	[CourseTitle] [varchar](200) NULL,
	[CourseLecture] [int] NULL,
	[CourseLab] [int] NULL,
	[CourseCredits] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseDept] ASC,
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[CourseSections]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[CourseSections](
	[CourseSectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuarterID] [varchar](10) NULL,
	[CourseDept] [varchar](5) NULL,
	[CourseId] [varchar](10) NULL,
	[SectionNumber] [varchar](5) NULL,
	[CohortID] [int] NULL,
	[StudentCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseSectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[Curriculum]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[Curriculum](
	[CurriculumID] [bigint] IDENTITY(1,1) NOT NULL,
	[CurriculumStartDate] [varchar](10) NULL,
	[CurriculumProgramName] [varchar](100) NULL,
	[CurriculumLevel] [varchar](20) NULL,
 CONSTRAINT [PK__Curricul__06C9FA7C9BA73981] PRIMARY KEY CLUSTERED 
(
	[CurriculumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[CurriculumCourses]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[CurriculumCourses](
	[CurriculumId] [bigint] NOT NULL,
	[CourseDept] [varchar](5) NOT NULL,
	[CourseId] [varchar](10) NOT NULL,
	[CurriculumQuarter] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CurriculumId] ASC,
	[CourseDept] ASC,
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[MaxClassSize]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[MaxClassSize](
	[CourseDept] [varchar](5) NULL,
	[CourseId] [varchar](10) NULL,
	[ClassSize] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[SectionNumbers]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Curriculum].[SectionNumbers](
	[Qtr] [int] NOT NULL,
	[Eve] [bit] NOT NULL,
	[SectionNumber] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Qtr] ASC,
	[Eve] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Assignments]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assignments](
	[AssignmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[CanvasCourseID] [varchar](10) NULL,
	[AssignmentName] [varchar](100) NULL,
	[AssignmentDueDate] [datetime] NULL,
	[UngradedAssignments] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CanvasCourses]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CanvasCourses](
	[CanvasCourseIdentityID] [bigint] IDENTITY(1,1) NOT NULL,
	[CanvasCourseID] [varchar](10) NULL,
	[CourseID] [varchar](10) NULL,
	[SectionNumber] [varchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CourseOfferings]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseOfferings](
	[CourseOfferingsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TermId] [varchar](10) NULL,
	[ScheduleLocation] [varchar](10) NULL,
	[CourseID] [varchar](10) NULL,
	[CourseName] [varchar](50) NULL,
	[SectionNumber] [varchar](10) NULL,
	[StartTimeHours] [smallint] NULL,
	[StartTimeMinutes] [smallint] NULL,
	[EndTimeHours] [smallint] NULL,
	[EndTimeMinutes] [smallint] NULL,
	[CourseDay] [varchar](20) NULL,
	[RoomNumber] [varchar](20) NULL,
	[InstructorName] [varchar](50) NULL,
	[RecordTimeStamp] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cssCourses]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cssCourses](
	[courseId] [bigint] IDENTITY(1,1) NOT NULL,
	[courseNumber] [varchar](10) NULL,
	[courseTitle] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[courseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cssObjectives]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cssObjectives](
	[objectiveID] [bigint] IDENTITY(1,1) NOT NULL,
	[courseNumber] [varchar](10) NULL,
	[chairPerson] [varchar](50) NULL,
	[chairEmail] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[objectiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[test]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[col1] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Test2]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test2](
	[col1] [int] NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CourseOfferings] ADD  DEFAULT (getdate()) FOR [RecordTimeStamp]
GO
/****** Object:  StoredProcedure [dbo].[deleteCohort]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[deleteCohort]
@CohortId INT
AS
DELETE FROM Curriculum.Cohorts
WHERE CohortId = @CohortId



GO
/****** Object:  StoredProcedure [dbo].[deleteCourseOfferings]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteCourseOfferings] 
@TermId VARCHAR(10),
@ScheduleLocation VARCHAR(10)
AS
DELETE FROM CourseOfferings
WHERE TermId = @TermId and ScheduleLocation = @ScheduleLocation


GO
/****** Object:  StoredProcedure [dbo].[generateCourseSections]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[generateCourseSections]
@quarterId VARCHAR(10)
AS
SET NOCOUNT ON
	DECLARE @sections table(
		RowID INT IDENTITY(1,1),  
		CourseDept VARCHAR(10),  
		CourseId VARCHAR(10),  
		Session VARCHAR(10),  
		NumberToCancel INT);

	DECLARE @NumberRecords INT, @RowCount INT, @dept VARCHAR(50), @courseId VARCHAR(10), @Session VARCHAR(5), @N INT, @sql NVARCHAR(400)

	exec dbo.generateSectionNumbers @quarterId 

	DELETE FROM  Curriculum.CourseSections
	WHERE QuarterID = @quarterId
	DELETE FROM Curriculum.CourseDeletions

	-- Generate courses along with sections for each of the cohorts
	INSERT INTO Curriculum.CourseSections (QuarterID,  CourseDept, CourseId, SectionNumber, CohortID, StudentCount)
	SELECT @quarterId, ccs.CourseDept,  ccs.CourseId, '.' + RIGHT('00'+CAST(SectionNumber AS VARCHAR(2)),2), CohortId, CohortStudentCount
	FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
	INNER JOIN Curriculum.CurriculumCourses ccs ON  dbo.getQuarterDifference (CohortStartDate, @quarterId) = ccs.CurriculumQuarter+1 and coh.CurriculumId = ccs.CurriculumId

	INSERT INTO @sections (CourseDept, CourseId, Session,  NumberToCancel)
	SELECT CourseDept, CourseId, CohortSession, COUNT(*) - CEILING(SUM(StudentCount)/20.0) 
	FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts c ON cs.CohortID = c.CohortId
	GROUP BY CourseDept, CourseId, CohortSession
	HAVING COUNT(*) - CEILING(SUM(StudentCount)/20.0) > 0
	ORDER BY CourseDept + ' ' + CourseId, CohortSession

	SET @NumberRecords = @@ROWCOUNT
	SET @RowCount = 1

	WHILE @RowCount <= @NumberRecords
	BEGIN
		 SELECT @dept=CourseDept, @courseId=CourseId, @Session=Session, @N=NumberToCancel
		 FROM @sections
		 WHERE RowID = @RowCount
		
		

		SET @sql = 'INSERT INTO Curriculum.CourseDeletions (CourseDept, CourseId, Session ,CohortID)'
		set @sql = @sql + ' SELECT TOP ' + CAST(@N AS VARCHAR(2)) +  '''' + @dept +''',''' + @courseId +''',''' + @Session + ''', cs.CohortID'
		set @sql = @sql + ' FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts c ON cs.CohortID = c.CohortId'
		set @sql = @sql + ' WHERE CourseId = ''' + @courseId + ''' and CourseDept = ''' + @dept + ''' and CohortSession = ''' + @Session + ''''
		exec sp_executesql @sql

		set @sql = 'DELETE FROM Curriculum.CourseSections '
		set @sql = @sql + 'WHERE CourseId = ''' + @courseId + ''' and CourseDept = ''' + @dept + ''' and  CohortId IN (   '
		set @sql = @sql + 'SELECT TOP ' + CAST(@N AS VARCHAR(2)) + ' cs.CohortID   '
		set @sql = @sql + 'FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts c ON cs.CohortID = c.CohortId   '
		set @sql = @sql + 'WHERE CourseId = ''' + @courseId + ''' and CourseDept = ''' + @dept + ''' and CohortSession = ''' + @Session + ''' )   '
		exec sp_executesql @sql


	 SET @RowCount = @RowCount + 1
	END

	-- update counts of recently deleted courses
	UPDATE cs
	SET cs.studentCount = cs.studentCount + cd.StudentCount/cd.NumberOfSections
	FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts coh ON cs.CohortID = coh.CohortId
	INNER JOIN 
			(
				SELECT t1.CourseDept, t1.CourseId, t1.Session, t1.StudentCount, t2.NumberOfSections FROM (
				SELECT CourseDept, CourseId, Session, SUM(CohortStudentCount) AS StudentCount  
				FROM Curriculum.CourseDeletions d INNER JOIN Curriculum.Cohorts c ON d.CohortID = c.CohortId
				GROUP BY CourseDept, CourseId, Session ) t1
				
				INNER JOIN (
				SELECT CourseDept, CourseId, cohortSession, Count(*) AS NumberOfSections
				FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts coh ON cs.cohortid = coh.cohortid
				GROUP BY CourseDept, CourseId, cohortSession
				) t2 ON t1.CourseDept=t2.CourseDept and t1.CourseId=t2.courseid and Session=t2.CohortSession
				
			) cd ON cs.CourseDept = cd.CourseDept and coh.CohortSession = cd.Session and cs.CourseId = cd.CourseId


GO
/****** Object:  StoredProcedure [dbo].[generateSectionNumbers]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[generateSectionNumbers]
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
/****** Object:  StoredProcedure [dbo].[generateUniqueSectionNumbers]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[generateUniqueSectionNumbers] AS
	SET NOCOUNT ON

	DECLARE @duplicates table(
		RowID INT IDENTITY(1,1),  
		CourseDept VARCHAR(10),  
		CourseId VARCHAR(10),  
		SectionNumber VARCHAR(10),  
		NumberToChange INT);

		DECLARE @NumberRecords INT, @RowCount INT, @dept VARCHAR(50), @courseId VARCHAR(10), @sectionNumber VARCHAR(5), @no INT, @N INT

		INSERT INTO @duplicates (CourseDept, CourseId, SectionNumber, NumberToChange)
		SELECT  c1.CourseDept, c1.courseid, c1.sectionnumber, COUNT(*) -1 
		FROM Curriculum.CourseSections c1 
			INNER JOIN Curriculum.CourseSections c2 
			ON c1.coursedept = c2.coursedept and c1.courseid=c2.courseid and c1.sectionnumber = c2.sectionnumber and c1.CourseSectionID <> c2.CourseSectionID
		GROUP BY c1.CourseDept, c1.courseid, c1.sectionnumber

	SET @NumberRecords = @@ROWCOUNT
	SET @RowCount = 1

	DECLARE @s VARCHAR(5), @s1 AS VARCHAR(1), @isUniqueSectionNumber BIT, @sectionCount INT


	WHILE @RowCount <= @NumberRecords
	BEGIN
		 SELECT @dept=CourseDept, @courseId=CourseId, @sectionNumber=sectionNumber, @N=NumberToChange
		 FROM @duplicates
		 WHERE RowID = @RowCount

		 set @isUniqueSectionNumber = 0
		 set @s = @sectionNumber
		 while @isUniqueSectionNumber = 0
		 begin
			 -- get a new section number
			 
			 set @s1 = RIGHT(@s, 1)
			 if @s1 >= '0' and @s1 <= '9'
				set @s = @s + 'A'
			 else
				set @s = LEFT(@s, LEN(@s) -1) + CHAR(ASCII(RIGHT(@s,1)) + 1)
			
			SELECT @sectionCount = COUNT(*) 
			FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts coh ON cs.CohortID = coh.cohortid
			WHERE  cs.CourseDept = @dept AND cs.CourseId = @courseId AND coh.SectionNumber = @s
			if @sectionCount = 0
				set @isUniqueSectionNumber = 1
		 end

		 UPDATE Curriculum.CourseSections 
		SET SectionNumber = @s
		WHERE CourseDept = @dept and CourseId = @courseId and CohortId = (
		SELECT MAX(CohortID) FROM Curriculum.CourseSections 
		WHERE CourseDept = @dept and CourseId =@courseId and 
		SectionNumber = @sectionNumber)

		 SET @RowCount = @RowCount + 1
	END


GO
/****** Object:  StoredProcedure [dbo].[getCohort]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getCohort]
(@CohortId BIGINT)
AS 
SELECT CohortStartDate, CohortSession, CohortStudentCount, ch.CurriculumId, cc.CurriculumLevel
FROM Curriculum.Cohorts ch INNER JOIN Curriculum.Curriculum cc ON ch.CurriculumId = cc.CurriculumID
WHERE CohortId = @CohortId

GO
/****** Object:  StoredProcedure [dbo].[getCohorts]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[getCohorts]
(@CurrentQuarter VARCHAR(10))
 AS
SELECT CohortId, coh.CurriculumId, CurriculumLevel, CohortSession, CohortStartDate, CurriculumStartDate, CurriculumProgramName, CohortStudentCount, dbo.getQuarterDifference (CohortStartDate, @CurrentQuarter) AS Quarter
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
ORDER BY CohortSession, CurriculumLevel,  CohortStartDate DESC, CurriculumProgramName 


GO
/****** Object:  StoredProcedure [dbo].[insertAssignment]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[insertAssignment]
	@CanvasCourseID VARCHAR(10),
	@AssignmentName VARCHAR(100),
	@AssignmentDueDate DATETIME,
	@UngradedAssignments INT
AS 
	INSERT INTO Assignments (CanvasCourseID, AssignmentName, AssignmentDueDate, UngradedAssignments)
	VALUES (@CanvasCourseID, @AssignmentName, @AssignmentDueDate, @UngradedAssignments)

GO
/****** Object:  StoredProcedure [dbo].[insertCanvasCourseOffering]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCanvasCourseOffering]
	@CanvasCourseID VARCHAR(10),
	@CourseID VARCHAR(10),
	@SectionNumber VARCHAR(10)

AS
INSERT INTO CanvasCourses (CanvasCourseID, CourseID, SectionNumber)
VALUES (@CanvasCourseID, @CourseID, @SectionNumber)

GO
/****** Object:  StoredProcedure [dbo].[insertCohort]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[insertCohort]
@CohortStartDate VARCHAR(10),
@CohortSession VARCHAR(5),
@CurriculumId BIGINT,
@CohortStudentCount INT

AS
INSERT INTO Curriculum.Cohorts (CohortStartDate, CohortSession, CurriculumId, CohortStudentCount) 
VALUES (@CohortStartDate, @CohortSession, @CurriculumId, @CohortStudentCount)


GO
/****** Object:  StoredProcedure [dbo].[InsertCourse]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[InsertCourse] 
@CurriculumId BIGINT,
@Quarter INT,
@CourseDept VARCHAR(5),
@CourseID VARCHAR(10),
@CourseTitle VARCHAR(200),
@CourseLecture INT,
@CourseLab INT,
@CourseCredits INT
AS
DELETE FROM  curriculum.courses WHERE CourseDept = @CourseDept and CourseID = @CourseId
INSERT INTO curriculum.courses (CourseDept ,CourseID ,CourseTitle,CourseLecture, CourseLab, CourseCredits)
VALUES (@CourseDept ,@CourseID ,@CourseTitle,@CourseLecture,@CourseLab,@CourseCredits)

INSERT INTO Curriculum.CurriculumCourses (CurriculumId, CourseDept, CourseId, CurriculumQuarter)
VALUES (@CurriculumId, @CourseDept, @CourseID, @Quarter)

GO
/****** Object:  StoredProcedure [dbo].[insertCourseOffering]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCourseOffering] 
@TermId VARCHAR(10),
@ScheduleLocation VARCHAR(10),
	@CourseID VARCHAR(10),
	@CourseName VARCHAR(50),
	@SectionNumber VARCHAR(10),
	@Day VARCHAR(20),
	@StartTimeHours SMALLINT,
	@StartTimeMinutes SMALLINT,
	@EndTimeHours SMALLINT,
	@EndTimeMinutes SMALLINT,
	@RoomNumber VARCHAR(20),
	@InstructorName VARCHAR(50)
AS
INSERT INTO CourseOfferings (TermId,ScheduleLocation, CourseID, CourseName, SectionNumber , CourseDay, StartTimeHours, StartTimeMinutes, EndTimeHours, EndTimeMinutes, RoomNumber,InstructorName) 
VALUES (@TermId, @ScheduleLocation, @CourseID, @CourseName, @SectionNumber , @Day,  @StartTimeHours,  @StartTimeMinutes , @EndTimeHours, @EndTimeMinutes, @RoomNumber,@InstructorName)


GO
/****** Object:  StoredProcedure [dbo].[insertCSSCourse]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCSSCourse] 
@courseNumber VARCHAR(10), @courseTitle VARCHAR(100)
AS
INSERT INTO cssCourses (courseNumber, courseTitle) VALUES (@courseNumber,@courseTitle)

GO
/****** Object:  StoredProcedure [dbo].[insertCSSObjective]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCSSObjective] 
@courseNumber VARCHAR(10), @chairPerson VARCHAR(50),@chairEmail VARCHAR(50)
AS
INSERT INTO cssObjectives (courseNumber, chairPerson, chairEmail) VALUES (@courseNumber, @chairPerson, @chairEmail)

GO
/****** Object:  StoredProcedure [dbo].[insertCurriculum]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[insertCurriculum]
@startDate VARCHAR(10),
@programName VARCHAR(50),
@level VARCHAR(20)
AS
	INSERT INTO Curriculum.Curriculum(CurriculumStartDate, CurriculumProgramName, CurriculumLevel)
	VALUES (@startDate, @programName, @level)

	SELECT @@IDENTITY AS CurriculumId

GO
/****** Object:  StoredProcedure [dbo].[removeSections]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[removeSections]
@quarterId VARCHAR(10)
AS
SELECT CourseDept + ' ' + CourseId   AS Course, CohortSession, SUM(StudentCount) AS TotalStudents,  COUNT(*) AS Sections,  
COUNT(*) - CEILING(SUM(StudentCount)/20.0) AS NumberToCancel
FROM Curriculum.CourseSections cs INNER JOIN Curriculum.Cohorts c ON cs.CohortID = c.CohortId
GROUP BY CourseDept + ' ' + CourseId, CohortSession
HAVING COUNT(*) - CEILING(SUM(StudentCount)/20.0) > 0
ORDER BY CourseDept + ' ' + CourseId, CohortSession

GO
/****** Object:  StoredProcedure [dbo].[switchSequences]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[switchSequences]
@CurriculumID BIGINT
AS
UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 10
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 0

UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 11
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 1

UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 0
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 2

UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 1
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 3

UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 2
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 10

UPDATE Curriculum.CurriculumCourses
SET CurriculumQuarter = 3
WHERE CurriculumID = @CurriculumID and CurriculumQuarter = 11
GO
/****** Object:  StoredProcedure [dbo].[updateCohort]    Script Date: 7/7/2017 9:53:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[updateCohort]
@CohortStartDate VARCHAR(10),
@CohortSession VARCHAR(5),
@CurriculumId BIGINT,
@CohortStudentCount INT,
@CohortId INT
AS
UPDATE Curriculum.Cohorts
SET cohortStartDate=@CohortStartDate, CohortSession=@CohortSession, CurriculumId=@CurriculumId, CohortStudentCount=@CohortStudentCount
WHERE CohortId = @CohortId
SELECT * FROM Curriculum.cohorts where cohortid = @CohortId

GO
