const express = require('express'),
    cors = require('cors'),
    bodyParser = require('body-parser'),
    app = express(),
    usersRouter = require('./routes/user');

var server = {
    port: 8081
};

app.use(cors());
app.use(bodyParser.json());
app.use('/user', usersRouter);

app.listen(server.port, () =>
    console.log(`Server started, listening port: ${server.port}`)
);

app.get('/', function(req, res){
    res.sendFile(__dirname + "/" + "TestPage.html");
});