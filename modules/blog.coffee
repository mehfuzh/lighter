module.exports = (settings)->
	class Blog
		constructor: (settings) ->
			@settings = settings
			@blog = settings.mongoose.model 'blog'
			@post = settings.mongoose.model 'post'
			@helper = (require __dirname + '/helper')()
			@category = (require __dirname + '/category')(settings)
			@map = settings.mongoose.model 'map'

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
						if data isnt null
							@_post
								id : data._id
								post :  obj
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
							promise.resolve(null)
							return
						data.body = @settings.format(data.body)
						promise.resolve({
							title	:	blog.title
							post	:	data
						})
			return promise
		
		hasPostMoved: (permaLink)->
			promise = new @settings.Promise
			@map.findOne
				permaLink : permaLink, (err, data)->
					promise.resolve(data)
			return promise

		findPostById: (id, callback)->
			@post.findOne 
				_id : id, (err, data)=>
					callback(data)
		
		updatePost: (post)->
			promise = new @settings.Promise
			@post.findOne
				_id : post.id, (err, data)=>
					previous =
						id 			: data._id
						title 		: data.title
						permaLink 	: data.permaLink
						body  		: data.body
 
					data.body = post.body
					data.title = post.title
					data.permaLink = @helper.linkify post.title
					data.categories = post.categories

					if (data.categories)
						for category in data.categories
							@category.refresh category

					data.save (err, data)=>
						post = data
						permaLink = previous.permaLink
						@map.findOne
							permaLink : permaLink, (err, data)=>
								if data is null
									map = new @map
									map.permaLink = permaLink
								else
									map = data

								map.content = JSON.stringify({
										id : post.id,
										title : post.title,
										permaLink : post.permaLink,
										body : post.body	
									})

								map.save (err, data)->
									if err is null
										promise.resolve(post)
									else
										throw err
			return promise
		
		deletePost: (id, callback)->
			@post.remove
				_id : id, ()=>
					@map.remove ()->
					callback()
		
		delete: (callback) ->  
			@blog.find url : @settings.url, (err, data) =>
				for blog in data
					@post.remove id : blog._id, ()=>
						@blog.remove url : @settings.url
			@category.clear () ->
			@map.remove ()->
				callback()

		_post: (obj, callback) ->
			post = obj.post
			permaLink = @helper.linkify(post.title)

			if typeof post.permaLink != 'undefined'
				permaLink = post.permaLink

			postSchema = new @post
					id 			: 	obj.id
					title 		: 	post.title
					permaLink	:	permaLink
					author 		:	post.author
					body 		: 	post.body
					publish 	: 	1
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