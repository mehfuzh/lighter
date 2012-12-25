routes = (app, settings) =>
	blog = (require __dirname+'/modules/blog')(settings.mongoose)
	recent = []

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
				for post in result.posts[0...5]
					recent.push({
							title			:	post.title
							permaLink	:	post.permaLink
					})
				res.render 'index'
					host : host
					title : result.title
					posts : result.posts
					recent : recent
			
	app.get '/atom', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		res.render 'atom', 
			title : 'Blog entries'
			feedUrl	: settings.url + 'atom/feeds'

	app.get '/atom/feeds', (req, res) ->
		res.header({'Content-Type': 'application/xml' })
		blog.find settings.url, (result)->
			res.render 'feeds', result

module.exports = routes