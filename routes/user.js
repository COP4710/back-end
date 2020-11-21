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
    var username = req.body.username;
    var password = req.body.password;
    // Password encryption. Excrypted password is then stored into database
    bcrypt.hash(password, 5).then(hash => {
        console.log(`Hash ${hash}`);
        let values = [
            username,
            hash
        ];
        exhibitDB.query(sql, values, function(err, data, fields){
            if(err) throw err;
            res.json({
                status: 200,
                message: `Added ${req.body.username} into the database`
            })
        })
    }).catch(err => console.error(err.message));
});

router.post('/login', function(req, res){
    var username = req.body.username;
    console.log(username);
    var password = req.body.password;
    console.log(password);
    let sql = 'SELECT * FROM user WHERE username = (?)';

    var user = exhibitDB.query(sql, username, function(err, data, fields){
        if(err) throw err;
        console.log(data);
        console.log(data[0].username);
    })
});

module.exports = router;