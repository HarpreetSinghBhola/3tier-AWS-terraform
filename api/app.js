var express = require('express');
var app = express();
var uuid = require('node-uuid');

var pg = require('pg');
var myArgs = process.argv.slice(2);

var conString = {
    user: myArgs[0],
    database: myArgs[3],
    password: myArgs[1],
    host: myArgs[2],
    port: myArgs[4]                
};

// Routes
app.get('/api/status', function(req, res) {
//'SELECT now() as time', [], function(err, result
  
  const Pool = require('pg').Pool
  const pool = new Pool(conString)
  // connection using created pool
  pool.connect((err, client, release) => {
    if (err) {
      return console.error('Error acquiring client', err.stack)
    }
    client.query('SELECT now() as time', (err, result) => {
      release()
    if (err) {
      console.log(err);
      return console.error('Error executing query', err.stack)
    }
    res.status(200).send(result.rows);
  });
});

  // pool shutdown
  pool.end()
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});


module.exports = app;
