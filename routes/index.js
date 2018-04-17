var express = require('express');
var router = express.Router();

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
  knex.select('CohortStartDate', 'CohortStudentCount').from('Curriculum.Cohorts').then( (row) => {
    res.render('index', { title: 'Schedule', cohorts: row });
  } );

  
});

router.get('/cohorts/:id', function(req, res, next) {
  knex.select('CohortID', 'CohortStartDate','CohortStudentCount').from('Curriculum.Cohorts').then( (row) => {
    res.render('index', { title: 'Schedule', cohorts: row });
  } );

  
});

router.get('/courses', function(req, res, next) {
 
  knex.select('CourseID ','CourseTitle','CourseDept').from('Curriculum.courses').then( (row) => {
    res.json(row);
  } );


  //res.render('index', { title: 'Schedule', cohorts: row });
});

module.exports = router;
