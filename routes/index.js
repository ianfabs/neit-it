var express = require('express');
var router = express.Router();

var quarter = require("../comp.js").getQuarter;
var current = require("../comp.js").getCurrent;

var sql = require('mssql');
var knex = require('knex')({
  dialect: 'mssql',
  connection: {
    user: 'iantf',
    port: '4500',
	  password: 'iantf',
	  host: 'sql.neit.edu', 
	  database: 'erik'
  }
});


/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', { title: 'Schedule'});
});

router.get('/cohorts', function(req, res, next) {
  knex.select(knex.raw("CohortId AS [id], CohortStartDate, CohortStudentCount, dbo.getQuarter(Curriculum.Cohorts.CohortStartDate, "+current()+", Curriculum.Curriculum.CurriculumLevel) AS [q]"))
  .from("Curriculum.Cohorts").join("Curriculum.Curriculum", "Curriculum.Curriculum.CurriculumID", "=", "Curriculum.Cohorts.CurriculumId").then( (row) => {
    res.json(row);
  } );
});

router.get('/cohorts/:id', function(req, res, next) {
  knex.select('CohortID', 'CohortStartDate','CohortStudentCount').from('Curriculum.Cohorts').then( (row) => {
    res.render('index', { title: 'Schedule', cohorts: row });
  } );
});

router.post('/cohorts/:id', function(req, res, next) {
  knex.select(knex.raw("CohortId AS [id], CohortStartDate, CohortStudentCount, dbo.getQuarter(Curriculum.Cohorts.CohortStartDate, "+current()+", Curriculum.Curriculum.CurriculumLevel) AS [q], Curriculum.Curriculum.CurriculumID AS [CurriculumID]"))
  .from("Curriculum.Cohorts").join("Curriculum.Curriculum", "Curriculum.Curriculum.CurriculumID", "=", "Curriculum.Cohorts.CurriculumId").where("CohortId", "=", req.params.id).then( (row) => {
    res.send(row[0]);
  } );
});

router.put('/cohorts/:id/courses', function(req, res, next){
  //Get Next Quarter Classes
  console.log(req.body);

  knex.select('CurriculumId','CourseDept', 'CourseId', 'CurriculumQuarter').from('Curriculum.CurriculumCourses').where("CurriculumId", "=", req.body.CurriculumID).andWhere("CurriculumQuarter", "=", req.body.q).then(
    (row) => {
      res.send( row );
    }
  );
});

router.get('/instructors', function(req, res, next) {
  knex.select('instructorDisplayName').from('Curriculum.Instructor').where("instructorDisplayName", '<>', 'NULL').orderBy('instructorDisplayName').then( (row)=>{
    
    res.json(row);
  } );
});

router.get('/courses', function(req, res, next) {
 
  knex.select('CourseID ','CourseTitle','CourseDept').from('Curriculum.courses').then( (row) => {
    res.json(row);
  } );


  //res.render('index', { title: 'Schedule', cohorts: row });
});

router.get('/test', function(req, res, next){
  //testing knex queries
  knex.select(
    knex.raw("CohortId AS [id], CohortStartDate, CohortStudentCount, dbo.getQuarter(Curriculum.Cohorts.CohortStartDate, "+current()+", Curriculum.Curriculum.CurriculumLevel) AS [q], Curriculum.Cohorts.SectionNumber as [section], CohortStudentCount as [students], Curriculum.Curriculum.CurriculumLevel, Curriculum.CourseSections.CourseDept")
  ).from("Curriculum.Cohorts").join("Curriculum.Curriculum", "Curriculum.Curriculum.CurriculumID", "=", "Curriculum.Cohorts.CurriculumId").join("Curriculum.CourseSections", function(){
    this.on("Curriculum.CourseSections.SectionNumber", "=", "Curriculum.Cohorts.SectionNumber")
    .andOn("Curriculum.CourseSections.CohortID", "=", "Curriculum.Cohorts.CohortId")
  });
  


});

module.exports = router;
