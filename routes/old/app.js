var http = require("http");
var path = require("path");
var express = require("express");
var logger = require("morgan");
var bodyParser = require("body-parser");
var async = require("async");
var app = express();
var sql = require('mssql');
var cur = require("./curriculum");
var course = require("./course");
var instructor = require("./instructor");
var labs = require("./labs");



var config = {
	user: 'iantf',
	password: 'iantf',
	server: 'sql.neit.edu', 
	database: 'erik', 
	port:4500
}
app.set('view engine', 'html');
app.use(logger("dev"));


app.use(express.static('css'));
app.use(express.static('js'));

app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: false })); 

app.get("/curriculum/", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);

  sql.connect(config, err => {
    new sql.Request().query('SELECT CurriculumId,  CurriculumStartDate, CurriculumProgramName, CurriculumLevel  FROM Curriculum.Curriculum', (err, result) => {
        
        res.send(result);
        sql.close();
    });
});
  

});

app.get("/cohorts/:currentQuarter", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);
  sql.connect(config, err => {
    var request = new sql.Request();
    request.input('CurrentQuarter', sql.VarChar(10), req.params.currentQuarter);
    request.execute('getCohorts', (err, result) => {
        // ... error checks 
         sql.close();
        if (err == undefined) {
           res.send (result);
        } else {
           res.send ("Insert problem");
        }
       
    });
  });
  

});

app.get("/labs", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);
  labs.getLabs ("201740", 20, "0745", "1115", "M", function (data) {
    res.send (data);
   
  });
});

app.get("/cohort/:cohortId", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);
  sql.connect(config, err => {
    var request = new sql.Request();
    request.input('CohortId', sql.VarChar(10), req.params.cohortId);
    request.execute('getCohort', (err, result) => {
        // ... error checks 
         sql.close();
        if (err == undefined) {
           res.send (result);
        } else {
           res.send ("Could not retrieve");
        }
       
    });
  });
  

});

app.get("/instructor/:initials", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);

  instructor.getInstructor (req.params.initials, function (data) {
   res.send (data);
   
  });
});

app.get("/course/:term/:dept/:courseId", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);

  course.listCourses (req.params.term, req.params.dept, req.params.courseId, function (data) {
   res.send (data);
  });
    
  

});

app.get("/curriculum/:obj", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions) 
  res.setHeader('Access-Control-Allow-Credentials', true);

    
  res.send('Obj: ' + req.params.obj + '!');

});

app.post("/curriculum/", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');


  cur.insertCurriculum (req.body);
  res.send ("okay");
});

app.post("/cohort/", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
 console.dir (req.body.startDate);
 sql.connect(config, err => {
    var request = new sql.Request();
    request.input('CohortStartDate', sql.VarChar(10), req.body.startDate);
    request.input('CohortSession', sql.VarChar(5), req.body.session);
    request.input('CurriculumId', sql.Int, req.body.curriculumId);
    request.input('CohortStudentCount', sql.VarChar(10), req.body.students);
    request.execute('insertCohort', (err, result) => {
        // ... error checks 
        if (err == undefined) {
           res.send (result);
        } else {
           res.send ("Insert problem");
        }
        sql.close();
    });
 });
  
});

app.post("/schedule/generate", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  
  //console.log ("Cohort ID", req.body.CohortId);
 console.log ("Generate Schedule", req.body.term);
 sql.connect(config, err => {
   
    var request = new sql.Request();
    request.input('quarterId', sql.Int, req.body.term);
    request.execute('generateCourseSections', (err, result) => {
        // ... error checks 
         sql.close();
        if (err == undefined) {
           res.send ("DONE");
        } else {
           res.send ("Problem generating course sections.");
        }
       
    });
 });
});

app.post("/cohort/delete", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  
  console.log ("Cohort ID", req.body.CohortId);
 
 sql.connect(config, err => {
    var request = new sql.Request();
    request.input('CohortId', sql.Int, req.body.CohortId);
    request.execute('deleteCohort', (err, result) => {
        // ... error checks 
         sql.close();
        if (err == undefined) {
           res.send ("DONE");
        } else {
           res.send ("Delete problem");
        }
       
    });
 });
});

app.post("/cohort/update", function(req, res) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', null);

  // Request methods you wish to allow
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

  // Request headers you wish to allow
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  
 
 sql.connect(config, err => {
    var request = new sql.Request();
    request.input('CohortStartDate', sql.VarChar(10), req.body.CohortStartDate);
    request.input('CohortSession', sql.VarChar(5), req.body.CohortSession);
    request.input('CurriculumId', sql.Int, req.body.CurriculumId);
    request.input('CohortStudentCount', sql.VarChar(10), req.body.CohortStudentCount);
    request.input('CohortId', sql.Int, req.body.CohortId);
    request.execute('updateCohort', (err, result) => {
        // ... error checks 
         sql.close();
        if (err == undefined) {
           res.send ("DONE");
        } else {
           res.send ("Update problem");
        }
       
    });
 });
});

app.use(function(req, res) { 
  res.status(404).render("404");
});

http.createServer(app).listen(3000, function() {
  console.log("Schedule app started.");
});
