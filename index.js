const express = require('express'),
    app = express(),
    cors = require('cors'),
    bodyParser = require('body-parser'),
    usersRouter = require('./routes/user'),
    eventRouter = require('./routes/event');

var server = {
    port: 8081
};

app.use(cors());
// When grabbing json
app.use(bodyParser.json());
app.use('/user', usersRouter);
app.use('/event', eventRouter);

app.listen(server.port, function(){
    console.log(`Server started, listening port: ${server.port}`)
});