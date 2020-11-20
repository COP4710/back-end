const express = require('express'),
    router = express.Router();

var exhibitDB = require('../config/dbconfig');

router.get('/all-users', function(req, res){
    let sql = 'SELECT * FROM user';
    exhibitDB.query(sql, function(err, data, fields){
        if(err) throw err;
        res.json({
            status: 200,
            data,
            message: "User list retrieved successfully"
        })
    })
});

// router.post('/add-user', function(req, res){

// })
module.exports = router;