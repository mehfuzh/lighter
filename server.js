
var express = require('express')
  , http = require('http');

// Configuration
var app = express();

require('./config')(app)
require('newrelic')

var settings = require( __dirname + '/modules/settings')()

require(__dirname + '/modules/schema')(settings.mongoose);

//  create user 
if (process.env.NODE_ENV != 'production'){
	require (__dirname +'/modules/builder')(settings);
}

var user = require('./modules/user')(settings);

user.init(function(data){ 
  if (data._id){
		console.log('user %s is initialized!',  data.username);
	}
});

// Routes
require('./routes')(app, settings);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});