const express = require('express'),
    router = express.Router(),
    bcrypt = require('bcrypt');

var exhibitDB = require('../config/dbconfig');

// Getting all the usernames of registered users
router.get('/all-users', function(req, res){
    let sql = 'SELECT username FROM user';
    exhibitDB.query(sql, function(err, data, fields){
        if(err) throw err;
        res.json({
            status: 200,
            data,
            message: "User list retrieved successfully"
        })
    })
});

// For creating a new user
router.post('/add-user', function(req, res){
    let sql = 'INSERT INTO `exhibitdb`.`user` (`username`, `password`) VALUES (?,?)';
    // Password encryption. Excrypted password is then stored into database
    // Currently unused since I'm still trying to figure out how bcrypt works.
    let hash = bcrypt.hashSync(req.body.password, 5);
    let values = [
        req.body.username,
        req.body.password
    ];
    exhibitDB.query(sql, values, function(err, data, fields){
        if(err) throw err;
        res.json({
            status: 200,
            message: `Added ${req.body.username} into the database`
        })
    })
});

router.post('/login', function(req, res){
    var username = req.body.username;
    var password = req.body.password;
});

module.exports = router;