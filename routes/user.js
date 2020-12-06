const express = require('express'),
    router = express.Router(),
    bcrypt = require('bcrypt');

const { constants } = require('buffer');
var exhibitDB = require('../config/dbconfig');
const saltRounds = 10;

// For creating a new user
router.post('/add-user', async function (req, res) {
    let sql = "INSERT INTO user (username, password) VALUES (?, ?)";
    try{
        var username = req.body.username;
        // Password encryption. Excrypted password is then stored into database
        const hashedPwd = await bcrypt.hash(req.body.password, saltRounds);
        let values = [
            username,
            hashedPwd
        ]

        exhibitDB.query(sql, values, function(err, data, fields) {
            if(!err){
                res.json({
                    status: 200,
                    message: "Added"
                })
            }
            else{
                res.json({
                    status: 400,
                    message: err.sqlMessage
                })
            }
        })
    }
    catch(error){
        res.json({
            status: 500
        })
    }
});

// Validating login credentials
router.post('/login', async function(req, res){
    var username = req.body.username;
    var password = req.body.password;
    let sql = "SELECT password, role FROM user WHERE username = (?)";

    try {
        exhibitDB.query(sql, username, async function(err, data, fields){
            if(err){
                res.json({
                    status: 500
                })
            }
            // If something was returned from the query, explicitly at least one thing, then we can validate the password
            else if(typeof data[0] !== 'undefined'){
                var userpassword = data[0].password;

                if(userpassword !== null){
                    var cmp  = await bcrypt.compare(password, userpassword);
                    if(cmp){
                        res.json({
                            status: 200,
                            role: data[0].role,
                            message: "Login Successful"
                        })
                    }
                    else{
                        res.json({
                            status: 400,
                            message: "Your username or password is incorrect"
                        })
                    }
                }
            }
            // If nothing was returned from the database, this means the username is not in the db, aka not registered
            else{
                res.json({
                    status: 400,
                    message: "Your username or password is incorrect"
                })
            }
        });
    }
    catch(error) {
        res.json({
            status: 500
        })
    }
});

module.exports = router;