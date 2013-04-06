module.exports = (settings)->
	class Blog
		constructor: (settings) ->
			@settings = settings
			@blog = settings.mongoose.model 'blog'
			@post = settings.mongoose.model 'post'
			@helper = (require __dirname + '/helper')()
			@category = (require __dirname + '/category')(settings)

		create: (obj) ->
			promise = new @settings.Promise()
			@blog.findOne url : @settings.url, (err, data)=>
				# format
				obj.title = obj.title.trim()
				if data isnt null
					@_post
						id 	: data._id
						post: obj
						, (data)->
							promise.resolve data
				else
					blog = new @blog
						url		: @settings.url
						title	: @settings.title
						updated : @settings.updated
					blog.save (err, data) =>
						if err == null
							@_post
								id : data._id
								posts: obj
								, (data)->
									promise.resolve data
			return promise

		find:(format)->
			promise = new @settings.Promise()
			@blog.findOne url : @settings.url, (err, data) =>
				if err!= null
					throw err.message
				blog = data
				@post.find({id : blog._id}).sort({date: -1}).exec (err, data)=>
					posts = []
					for post in data 
						if format is 'encode'
							body = @settings.format(post.body)
							post.body = @helper.htmlEscape(body)
						else if format is 'sanitize'
							post.body = @settings.format(post.body) 
						posts.push post
					promise.resolve({
						id 		: blog._id
						title : blog.title
						updated : blog.updated
						posts :	posts
					})
			return promise
				
		findMostRecent: () ->
			promise = new @settings.Promise()
			@blog.findOne url: @settings.url, (err, data) =>
				@post.find({id : data._id}).sort({date: -1}).limit(5).exec (err, data)=>
						recent = []
						for post in data
								recent.push({
									title 		: post.title
									permaLink :	post.permaLink
								})
						promise.resolve(recent)
			return promise
				
		findPost: (permaLink)->
			promise = new @settings.Promise
			@blog.findOne url: @settings.url, (err, data) =>
				blog = data
				@post.findOne 
					id : blog._id 
					permaLink: permaLink,(err, data)=>
						if err != null or data == null
							callback(null)
							return
						data.body = @settings.format(data.body)
						promise.resolve({
							title	:	blog.title
							post	:	data
						})
			return promise
			
		findPostById: (id, callback)->
			@post.findOne 
				_id : id, (err, data)=>
					callback(data)
		
		updatePost: (post, callback)->
			@post.findOne
				_id : post.id, (err, data)=>
					data.body = post.body
					data.title = post.title
					data.categories = post.categories
					if (data.categories)
						for category in data.categories
							@category.refresh category, (id)->
					data.save (err, data)->
						callback(data)
		
		deletePost: (id, callback)->
			@post.remove
				_id : id, ()->
					callback()
		
		delete: (callback) ->  
			@blog.find url : @settings.url, (err, data) =>
				for blog in data
					@post.remove id : blog._id, ()=>
						@blog.remove url : @settings.url
				@category.clear () ->
						callback()

		_post: (obj, callback) ->
			post = obj.post
			postSchema = new @post
					id 			: obj.id
					title 		: post.title
					permaLink	:	 @helper.linkify(post.title)
					author 		:	post.author
					body 		: post.body
					publish 	: 1
					date		:	new Date()		
					categories : post.categories
			postSchema.save (err, data) =>
					if err != null
						callback(err.message)
					if (data.categories)
						for category in data.categories
							@category.refresh category, (id)->
					callback(data)
					return
																	
	new Blog settings