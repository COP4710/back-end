const express = require('express'),
    cors = require('cors'),
    bodyParser = require('body-parser'),
    app = express(),
    usersRouter = require('./routes/user');

var server = {
    port: 8081
};

app.use(cors());
// When grabbing json
app.use(bodyParser.json());
app.use('/user', usersRouter);

app.listen(server.port, function(){
    console.log(`Server started, listening port: ${server.port}`)
});