routes = (app, mongoose) =>
	app.get '/', (req, res) ->
		blog = (require __dirname+'/modules/blog')(mongoose)
		
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