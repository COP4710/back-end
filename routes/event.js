const express = require('express'),
    router = express.Router();

var exhibitDB = require('../config/dbconfig');

router.post('/add-event', function(req, res){
    var title = req.body.title;
    var description = req.body.description;
    var url = req.body.url;
    var start_date = req.body.start_date;
    var end_date = req.body.end_date;
    var address = req.body.address;
    var city = req.body.city;
    var host_id = req.body.host_id;

    //SQL query to insert all the data for adding an event to the database
    let sql = 'INSERT INTO `exhibitdb`.`event` (`title`, `description`, `event_homepage`, `start_date`, `end_date`, `address`, `city`, `host_id`) VALUES (?,?,?,?,?,?,?,?)';
    let values = [
        title,
        description,
        url,
        start_date,
        end_date,
        address,
        city,
        host_id
    ];

    //SQL query to see if there are any conflicts with another event in the database
    let sqlCheck = 'SELECT * FROM `exhibitdb`.`event` WHERE `city` = (?) AND `address` = (?) AND ((?) <= `end_date` AND (?) >= `start_date`)';
    let values2 = [
        city,
        address,
        start_date,
        end_date
    ];

    //Checks if there is any conflicts and returns a dissaproval message if there is
    exhibitDB.query(sqlCheck, values2, function(err, data, fields){
        if (err) throw err;
        if (data.length > 0)
        {
            res.json({
                "status": 400,
                "approved": false
            })
        }
        //If no conflicts are found then the event is inserted into database and approved
        else
        {
            exhibitDB.query(sql, values, function(err, data, fields){
                if(err) throw err;
                res.json({
                    "status": 200,
                    "approved": "true"
                })
            })
        }
    })
});

module.exports = router;
