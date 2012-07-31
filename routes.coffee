routes = (app) =>
	mongoose = require('mongoose')
	mongoose.connect 'mongodb://localhost/ligher'
	
	app.get '/', (req, res) ->
		res.render 'index', 
			title: 'Blog'
			postedOn : new Date().toDateString()
		
	app.get '/post', (req, res) ->
		res.render 'post', 
			title: 'Blog'
			postedOn : new Date().toDateString() 

module.exports = routes