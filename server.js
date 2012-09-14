
/**
 * Module dependencies.
 */

require('coffee-script')

var express = require('express')
  , http = require('http')
	, mongoose = require('mongoose');

// init mongo
mongoose.connect('mongodb://localhost/lighter');

// Configuration
var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(__dirname + '/public'));
});


app.configure('production', function(){
  app.use(express.errorHandler()); 
});


if (process.env.NODE_ENV != 'production'){
	require ('./modules/builder')(mongoose);
}

// Routes
require('./routes')(app, mongoose);


http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});