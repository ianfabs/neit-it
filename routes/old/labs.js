

var sql = require('mssql');
var config = {
	user: 'iantf',
	password: 'iantf',
	server: 'sql.neit.edu', 
	database: 'erik', 
	port:4500
}

function getLabs (termId, numberOfStudents, day, startTime, endTime, callback) {
    sql.connect(config, err => {
        var request = new sql.Request();
        request.input('termID', sql.VarChar(10), termId);
        request.input('numberOfStudents', sql.Int, numberOfStudents);
        request.input('startTime', sql.VarChar(10), startTime);
        request.input('endTime', sql.VarChar(10), endTime);
        request.input('day', sql.VarChar(10), day);
        
        request.execute('getLabs', (err, result) => {
            // ... error checks 
           if (err == undefined) {
                callback (result[0]);
            } else {
               
                callback (err[0]);
               
            }
           
        });
         sql.close();
    });
}

function displayLabs (labs) {
    console.dir (labs);
}

//getLabs ("201740", 20, "0745", "1115", "M", displayLabs);
exports.getLabs = getLabs;





