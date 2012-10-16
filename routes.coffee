routes = (app, settings) =>
	blog = (require __dirname+'/modules/blog')(settings.mongoose)
	app.get '/', (req, res) ->
		blog.findAll (posts) ->
				console.log posts[0].title
				res.render 'index'
					title : 'Blog'
					posts : posts
	
	app.get '/post', (req, res) ->
		res.render 'post', 
			title: 'Blog'
			postedOn : new Date().toDateString() 

module.exports = routes