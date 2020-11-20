const mysql = require('mysql');

var exhibitDB = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'DB PASSWORD HERE',
    database: 'ExhibitDB'
});

exhibitDB.connect(function(err){
    if(err) throw err;
    console.log("Connected!");
});

module.exports = exhibitDB;