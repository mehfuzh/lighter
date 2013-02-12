routes = (app, settings) => 
	util = require('util')
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
		
	parseCategory = (entry)->
		categories = []
		# process category.
		if typeof(entry.category) != 'undefined'
				for cat in entry.category
					categories.push(cat.$.term)
		categories
		
					
	app.get '/api/atom', (req, res) ->
		res.header({'Content-Type': 'application/xml' })      
		res.render 'atom/atom', 
			title : 'Blog entries'
			host	: app.host

	app.get '/api/atom/categories', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		category.all (result)->
			res.render 'atom/categories',
				categories:result

	app.get '/api/atom/feeds', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.find (result)->
			res.render 'atom/feeds',
				host		:	app.host
				title		:	result.title
				updated	:	result.updated
				posts		:	result.posts
	
	app.post '/api/atom/feeds', authorize, (req, res) -> 
		parser = new xml2js.Parser()  
		parser.parseString req.rawBody, (err, result) -> 
			blog.create
				posts : [{
					title   		: result.entry.title[0]._
					body    		: result.entry.content[0]._
					author 			: 'Mehfuz Hossain'
					categories 	: parseCategory result.entry
				}], (result)->
					location = app.host + 'api/atom/entries/' + result._id
					res.header({
						'Content-Type'	: req.headers['content-type'] 
						'Location'			: location
						})
					# post is created.
					res.statusCode = 201
					res.render 'atom/entries', 
						post : result
						host  : app.host 
			
	app.get '/api/atom/entries/:id', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.findPostById req.params.id, (result)->
				res.render 'atom/entries', 
					post : result
					host  : app.host

	app.put '/api/atom/entries/:id',authorize, (req, res)->
			parser = new xml2js.Parser()
			parser.parseString req.rawBody, (err, result) ->
				blog.updatePost 
					id		:	req.params.id
					title	:	result.entry.title[0]._ 
					body	:	result.entry.content[0]._
					categories	: parseCategory result.entry, (result)->
				  res.render 'atom/entries', 
						post : result
						host  : app.host

	app.delete '/api/atom/entries/:id', authorize , (req, res)->
		blog.deletePost req.params.id,()->
			res.end()

	app.get '/rsd.xml', (req, res) ->
					res.header({'Content-Type': 'application/xml' })
					res.render 'rsd',
						host : app.host
						engine : settings.engine
				
	app.get '/:year/:month/:title', (req, res) ->
		link = util.format("%s/%s/%s", req.params.year, req.params.month, req.params.title)
		if recent.length is 0
			# get the most recent posts, to be displayed on the right
			blog.findMostRecent (result)=>
				recent = result
				return
		blog.findPost link, (result)->  
			result.host = app.host
			result.recent = recent
			res.render 'post', result
								
	app.get '/', (req, res) ->
		blog.findFormatted (result) ->
			if (recent.length == 0)
				for post in result.posts[0...5]
					recent.push({
							title		:	post.title
							permaLink	:	post.permaLink
					})
			result.host = app.host
			result.recent = recent
			res.render 'index', result
				
module.exports = routes
