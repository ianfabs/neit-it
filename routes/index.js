var express = require('express');
var router = express.Router();

var sql = require('mssql');
var knex = require('knex')({
  client: 'mssql',
  user: 'iantf',
	password: 'iantf',
	host: 'sql.neit.edu', 
	database: 'erik'
});

/* GET home page. */
router.get('/', function(req, res, next) {
  knex.select('CohortStartDate').from('Curriculum.Cohorts').then( (row) => {
    res.render('index', { title: 'Schedule', cohorts: row });
  } );

  
});

module.exports = router;
