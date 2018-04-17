

var sql = require('mssql');
var config = {
	user: 'iantf',
	password: 'iantf',
	server: 'sql.neit.edu', 
	database: 'erik', 
	port:4500
}


function getInstructor (initials, callback) {
    console.log ("get");
    sql.connect(config, err => {
        var request = new sql.Request();
        request.input('initials', sql.VarChar(2), initials);
        request.execute('getInstructorInfo', (err, result) => {
            // ... error checks 
           if (err == undefined) {
                callback (result[0]);
            } else {
                console.dir (err);
                callback (err[0]);
                //console.dir ("getInstructorInfo problem");
            }
           
        });
         sql.close();
    });
}

function displayInstructor (instructorInfo) {
    console.dir (instructorInfo);
}

//getInstructor ("EV", displayInstructor);
exports.getInstructor = getInstructor;





