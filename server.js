
var express = require('express')
  , http = require('http')
	, settings = require( __dirname + '/modules/settings')();

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
  app.locals.pretty = true;
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

require(__dirname + '/modules/schema')(settings.mongoose);

if (process.env.NODE_ENV != 'production'){
	require ('./modules/builder')(settings);
}

// Routes
require('./routes')(app, settings);


http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});