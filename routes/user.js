const express = require('express'),
    router = express.Router(),
    bcrypt = require('bcrypt');

var exhibitDB = require('../config/dbconfig');

// Getting all the usernames of registered users
// More for debugging. Don't think this has baring on the project. 
router.get('/all-users', function(req, res){
    let sql = 'SELECT username FROM user';
    exhibitDB.query(sql, function(err, users, fields){
        if(err) throw err;
        res.json({
            status: 200,
            // users is a json array of the results of the query
            users
        })
    })
});

// For creating a new user
router.post('/add-user', function(req, res){
    let sql = 'INSERT INTO `exhibitdb`.`user` (`username`, `password`) VALUES (?,?)';
    var username = req.body.username;
    var password = req.body.password;
    // Password encryption. Excrypted password is then stored into database
    bcrypt.hash(password, 5).then(hash => {
        let values = [
            username,
            hash
        ];
        exhibitDB.query(sql, values, function(err, data, fields){
            if(err) throw err;
            res.json({
                status: 200
                // Added for debugging purposes
                // message: `Added ${req.body.username} into the database`
            })
        })
    }).catch(err => console.error(err.message));
});

// Validating login credentials
router.post('/login', function(req, res){
    var username = req.body.username;
    var password = req.body.password;
    let sql = 'SELECT * FROM user WHERE username = (?)';

    exhibitDB.query(sql, username, function(err, data, fields){
        if(err) throw err;
        bcrypt.compare(password, data[0].password).then(
            res.json({
                "status": 200,
                "user_role": data[0].role
            })
        ).catch(err => console.error(err.message));
    })
});

module.exports = router;