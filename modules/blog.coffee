module.exports = (mongoose)->
	class Blog
		constructor: (mongoose) ->
			@blog = mongoose.model 'blog'
			@post = mongoose.model 'post'
			@helper = (require __dirname + '/helper')()

		create: (obj, callback) ->		
			@blog.findOne url : obj.url, (err, data)=>
				if data isnt null
					@_post
						id 		: data._id
						posts	: obj.posts
						, (data)->
								callback(data)
								return
				else
					blog = new @blog
						url		: obj.url
						title	: obj.title
						updated : obj.updated
					blog.save (err, data) =>
							if err == null
								@_post
									id : data._id
									posts: obj.posts
									, (data)->
											callback(data)
											return

		find: (url, callback)->
			@blog.findOne url : url, (err, data) =>
				if err!= null
					throw err.message
				blog = data
				@post.find({id : blog._id}).sort({date: -1}).exec (err, data)=>
					posts = []
					for post in data
						posts.push post
					callback({
						id 		: blog._id
						url 	: blog.url 
						title : blog.title
						updated : blog.updated
						posts :	posts
					})
				return
				
		findMostRecent: (url, callback) ->
			@blog.findOne url: url, (err, data) =>
				@post.find({id : data._id}).sort({date: -1}).limit(5).exec (err, data)=>
						recent = []
						for post in data
								recent.push({
									title 		: post.title
									permaLink :	post.permaLink
								})
						callback(recent)
				return
				
		findPost: (url, permaLink, callback)->
			@blog.findOne url: url, (err, data) =>
				@post.findOne 
					id : data._id 
					permaLink: permaLink,(err, data)=>
						callback(data)
				return
	
		delete: (url) ->
				@blog.find url : url, (err, data) =>
					for blog in data
							@post.remove id : blog._id, ()=>
									@blog.remove url : url

		_post: (obj, callback) ->
			for post in obj.posts
				link =  @helper.linkify(post.title)
				postSchema = new @post
						id 				: obj.id
						title 		: post.title
						permaLink	:	link
						author 		:	post.author
						body 			: post.body
						publish : 1
						date			:	new Date()		
				postSchema.save (err, data) ->
					if err != null
							callback(err.message)
						callback(data)
						return
																	
	new Blog mongoose