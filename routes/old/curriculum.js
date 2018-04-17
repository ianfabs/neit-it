var request = require("request");
var jsdom = require("jsdom");
var sql = require('mssql');
var async = require ('async');
		
var config = {
	user: 'iantf',
	password: 'iantf',
	server: 'sql.neit.edu', 
	database: 'erik', 
	port:4500
}

function insertCourse (course, callback) {
	var request = new sql.Request();
    request.input('curriculumId', sql.INT, course.curriculumId);
    request.input('quarter', sql.INT, course.quarter);
    request.input('courseDept', sql.VarChar(5), course.dept);
    request.input('CourseID', sql.VarChar(10), course.courseNumber);
    request.input('courseTitle', sql.VarChar(200), course.courseTitle);
    request.input('courseLecture', sql.Int, course.class);
    request.input('courseLab', sql.Int, course.lab);
    request.input('courseCredits', sql.Int, course.credits);
    request.execute('InsertCourse', (err, result) => {
        // ... error checks 
        console.log ("inserted " + course.dept + " " +  course.courseNumber);
        callback();
    }); 
}


function insertCurriculum (curriculum, callback) {

    sql.connect(config, function(err) {
        if (err) {
            console.log ("Error connecting to db");
            console.dir(err);
        } else {
            console.log ("Connected ...");
            
            var request = new sql.Request();
            request.input('startDate', sql.VarChar(10), curriculum.startDate);
            request.input('programName', sql.VarChar(50), curriculum.curriculumName);
            request.input('level', sql.VarChar(20), curriculum.programLevel);

            request.execute('insertCurriculum', (err, result) => {  
                // ... error checks  
                insertAllCourses (result[0][0].CurriculumId, curriculum);
            }); 
        }
    });
    
}

function insertAllCourses(curriculumId, cur) {
   var coursesInCurriculum = [];

   
    for (i=0; i<cur.title.length; i++) {
        coursesInCurriculum.push ({quarter: cur.qtr[i], dept: cur.dept[i], courseNumber: cur.number[i], courseTitle: cur.title[i],
                                    class: cur.lecture[i], lab: cur.lab[i], credits: cur.credits[i], curriculumId: curriculumId });
    }

   async.each (coursesInCurriculum, 
   
        function (course, callback) {
            insertCourse (course, function () {
                callback();
            });
        }, function (err) {
             console.log ("all done");
             sql.close();
            
            }
    );
  
}

exports.insertCurriculum = insertCurriculum;