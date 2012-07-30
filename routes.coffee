routes = (app) =>
	app.get '/', (req, res) ->
		res.render 'index', 
			title: 'Blog'
			postedOn : new Date().toDateString()
		
	app.get '/post', (req, res) ->
		res.render 'post', 
			title: 'Blog'
			postedOn : new Date().toDateString() 

module.exports = rotes