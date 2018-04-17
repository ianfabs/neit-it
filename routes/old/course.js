/* 
    Given a course id and : dept and course id, return:
        - a list of active instructors who have taught the class in the past two years
        - a list of labs that this class can run in
        - specific course information:
            - contact hours
            - course title

*/

var sql = require('mssql');
var config = {
	user: 'iantf',
	password: 'iantf',
	server: 'sql.neit.edu', 
	database: 'erik', 
	port:4500
}


function listCourses (termId, dept, courseId, callback) {
    var oldTermId = (parseInt(termId.slice(0,4)) - 2).toString().concat(termId.slice(4,6));

    sql.connect(config, err => {
        var request = new sql.Request();
        request.input('termId', sql.VarChar(10), oldTermId);
        request.input('dept', sql.VarChar(5), dept);
        request.input('courseId', sql.VarChar(5), courseId);
        request.execute('getCourseInfo', (err, result) => {
            // ... error checks 
            if (err == undefined) {
            callback (result);
            } else {
            console.dir ("getCourseInfo problem");
            }
            sql.close();
        });
    });
}

function displayCourses (courseInfo) {
    console.dir (courseInfo);
}

exports.listCourses = listCourses;



