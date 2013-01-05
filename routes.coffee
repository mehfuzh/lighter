routes = (app, settings) =>
	blog = (require __dirname+'/modules/blog')(settings)
	recent = []			
				
	app.get '/api/atom', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		res.render 'atom/atom', 
			title : 'Blog entries'
			url	: settings.url
			
	app.get '/api/atom/categories', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		res.render 'atom/categories'

	app.get '/api/atom/feeds', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.find (result)->
			res.render 'atom/feeds', result
	
	app.post '/api/atom/feeds', (req, res) ->
		xml2js = require 'xml2js'
		parser = new xml2js.Parser({
			ignoreAttrs 	: true
			explicitArray : false
		})
		req.addListener 'data', (data) ->
			parser.parseString data, (err, result) ->
				console.log result
				blog.create
					posts : [{
						title   : result.entry.title
						body    : result.entry.content
						author : 'Mehfuz Hossain' 
					}], (result)->
						location = settings.url + 'api/atom/entries/' + result._id
						res.header({
							'Content-Type'		: req.headers['content-type'] 
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
				host 	: settings.url
				title  	: result.title
				body   	: result.body
				date   	: result.date
				recent 	: recent
		,true		

				
	app.get '/', (req, res) ->
		blog.find (result) ->
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
		,true
				
module.exports = routes