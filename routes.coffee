routes = (app, settings) =>
	blog = (require __dirname+'/modules/blog')(settings.mongoose)
	recent = []			
				
	app.get '/api/atom', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		res.render 'atom/atom', 
			title : 'Blog entries'
			feedUrl	: settings.url + 'api/atom/feeds'

	app.get '/api/atom/feeds', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.find settings.url, (result)->
				res.render 'atom/feeds', result
	
	app.post '/api/atom/feeds', (req, res) ->
		res.header({
			'Content-Type': 'application/atom+xml' 
			'Content-Location' : '/entries/blogs/1'
			})
		# post is created.
		res.statusCode = 201;
		
		xml2js = require 'xml2js'
		parser = new xml2js.Parser({
			ignoreAttrs 	: true
			explicitArray : false
		})
		req.addListener 'data', (data) ->
				parser.parseString data, (err, result) ->
					console.log result.entry
		# blog.find settings.url, (result)->
		# 		res.render 'atom/feeds', result	
		
			
	app.get '/api/atom/entries/:id', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.findPostById req.params.id, (result)->
				res.render 'atom/entries', 
					post : result
					url  : settings.url 

	app.get '/rsd.xml', (req, res) ->
					res.header({'Content-Type': 'application/xml' })
					res.render 'rsd',
						url : settings.url
						engine : settings.engine
				
	app.get '/:title', (req, res) ->
		if recent.length is 0
			# get the most recent posts, to be displayed on the right
			blog.findMostRecent settings.url, (result)=>
				recent = result
				return

		blog.findPost settings.url, req.params.title, (result)->
			res.render 'post', 
				host 		:	settings.url
				title  	: result.title
				body   	: result.body
				date   	: result.date
				recent 	: recent	
	
				
	app.get '/', (req, res) ->
		host  = settings.url
		blog.find host, (result) ->
				if (recent.length == 0)
					for post in result.posts[0...5]
						recent.push({
								title		:	post.title
								permaLink	:	post.permaLink
						})
				res.render 'index'
					host : host
					title : result.title
					posts : result.posts
					recent : recent
				
	# app.post '/api/wlwmanifest.xml', (req, res) ->
	# 	res.header({'Content-Type': 'text/xml' })
	# 	res.render 'wlwmanifest', 
	# 		service : settings.engine
	# 		host	: settings.url	
					
module.exports = routes