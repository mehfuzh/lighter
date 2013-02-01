routes = (app, settings) =>
	blog = (require __dirname+'/modules/blog')(settings) 
	helper = (require __dirname+'/modules/helper')()
	
	category = (require __dirname + '/modules/category')(settings) 
	request = (require __dirname + '/modules/request')(settings)
	xml2js = require 'xml2js'

	recent = []

	authorize = (req, res, next)->
		request.validate req, (result)->
				if result != null
					console.log result
					next()
					return
				else
					res.send(401) 
					return
		return
					
	app.get '/api/atom',authorize, (req, res) ->
		res.header({'Content-Type': 'application/xml' })      
		res.render 'atom/atom', 
			title : 'Blog entries'
			url	: settings.url

	app.get '/api/atom/categories', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		category.all (result)->
			res.render 'atom/categories',
				categories:result

	app.get '/api/atom/feeds', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.find (result)->
			res.render 'atom/feeds', result
	
	app.post '/api/atom/feeds', (req, res) -> 
		parser = new xml2js.Parser()
		req.addListener 'data', (data) =>
			parser.parseString data, (err, result) =>
				categories = []
			  
				# process category.
				if typeof(result.entry.category) != 'undefined'
						for cat in result.entry.category
							categories.push(cat.$.term)
	    
				blog.create
					posts : [{
						title   		: result.entry.title[0]._
						body    		: result.entry.content[0]._
						author 			: 'Mehfuz Hossain'
						categories 	: categories
					}], (result)->
						location = settings.url + 'api/atom/entries/' + result._id
						res.header({
							'Content-Type'	: req.headers['content-type'] 
							'Location'			: location
							})
						# post is created.
						res.statusCode = 201
						res.render 'atom/entries', 
							post : result
							url  : settings.url
			
	app.get '/api/atom/entries/:id', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.findPostById req.params.id, (result)->
				res.render 'atom/entries', 
					post : result
					url  : settings.url        

	app.put '/api/atom/entries/:id' , (req, res)->
		blog.findPostById req.params.id, (result)->
			console.log req.rawBody
			res.render 'atom/entries', 
				post : result
				url  : settings.url        

	app.delete '/api/atom/entries/:id', authorize , (req, res)->
		blog.deletePost req.params.id,()->
			res.end()

	app.get '/rsd.xml', (req, res) ->
					res.header({'Content-Type': 'application/xml' })
					res.render 'rsd',
						url : settings.url
						engine : settings.engine
				
	app.get '/:title', (req, res) ->
		if recent.length is 0
			# get the most recent posts, to be displayed on the right
			blog.findMostRecent (result)=>
				recent = result
				return

		blog.findPost req.params.title, (result)->
			res.render 'post', 
				host 				: settings.url
				title  			: result.title
				body   			: result.body
				categories 	: result.categories
				date   			: result.date
				recent 			: recent
		,true		

				
	app.get '/', (req, res) ->
		blog.findFormatted (result) ->
			if (recent.length == 0)
				for post in result.posts[0...5]
					recent.push({
							title		:	post.title
							permaLink	:	post.permaLink
					})
			res.render 'index'
				host : result.url
				title : result.title
				posts : result.posts
				recent : recent
				
module.exports = routes