USE [erik]
GO
/****** Object:  User [ICT\admin-mpreziosi]    Script Date: 6/28/2017 10:05:01 AM ******/
CREATE USER [ICT\admin-mpreziosi] FOR LOGIN [ICT\admin-mpreziosi] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [Curriculum]    Script Date: 6/28/2017 10:05:01 AM ******/
CREATE SCHEMA [Curriculum]
GO
/****** Object:  UserDefinedFunction [dbo].[getQuarter]    Script Date: 6/28/2017 10:05:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getQuarterDifference]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getSectionNumber]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [Curriculum].[Cohorts]    Script Date: 6/28/2017 10:05:02 AM ******/
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
	[SectionNumber] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CohortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Curriculum].[courses]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [Curriculum].[Curriculum]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [Curriculum].[CurriculumCourses]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[Assignments]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[CanvasCourses]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[CourseOfferings]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[cssCourses]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[cssObjectives]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  Table [dbo].[test]    Script Date: 6/28/2017 10:05:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[col1] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Test2]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[deleteCohort]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[deleteCourseOfferings]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[getCohort]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[getCohorts]    Script Date: 6/28/2017 10:05:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[getCohorts]
(@CurrentQuarter VARCHAR(10))
 AS
SELECT CohortId, coh.CurriculumId, CurriculumLevel, CohortSession, CohortStartDate, CurriculumStartDate, CurriculumProgramName, CohortStudentCount, dbo.getQuarterDifference (CohortStartDate, @CurrentQuarter) AS Quarter
FROM Curriculum.Cohorts coh INNER JOIN Curriculum.Curriculum c ON c.CurriculumID = coh.CurriculumId
ORDER BY CohortSession, CurriculumLevel, CohortStartDate DESC

GO
/****** Object:  StoredProcedure [dbo].[insertAssignment]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[insertCanvasCourseOffering]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[insertCohort]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[InsertCourse]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[insertCourseOffering]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[insertCSSCourse]    Script Date: 6/28/2017 10:05:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCSSCourse] 
@courseNumber VARCHAR(10), @courseTitle VARCHAR(100)
AS
INSERT INTO cssCourses (courseNumber, courseTitle) VALUES (@courseNumber,@courseTitle)

GO
/****** Object:  StoredProcedure [dbo].[insertCSSObjective]    Script Date: 6/28/2017 10:05:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertCSSObjective] 
@courseNumber VARCHAR(10), @chairPerson VARCHAR(50),@chairEmail VARCHAR(50)
AS
INSERT INTO cssObjectives (courseNumber, chairPerson, chairEmail) VALUES (@courseNumber, @chairPerson, @chairEmail)

GO
/****** Object:  StoredProcedure [dbo].[insertCurriculum]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[switchSequences]    Script Date: 6/28/2017 10:05:02 AM ******/
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
/****** Object:  StoredProcedure [dbo].[updateCohort]    Script Date: 6/28/2017 10:05:02 AM ******/
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
