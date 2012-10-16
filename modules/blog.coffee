module.exports = (mongoose)->
	class Blog
		constructor: (mongoose) ->
			Schema = mongoose.Schema
			ObjectId = Schema.ObjectId

			CategoriesSchema = new Schema
					title	: String

			CommentsSchema = new Schema
					title : String
					text	:	String
					date		:	Date
						
			PostSchema = new Schema
					author 		: String
					title			: String
					permaLink	: String
					body			: String
					date			: Date
					
					categories: [CategoriesSchema]
					comments	:	[CommentsSchema]
					publish		: Boolean

			@Post = mongoose.model 'post', PostSchema
			@helper = (require __dirname + '/helper')()

		create: (obj, callback) ->				
			link =  @helper.linkify(obj.title)
			@findByPermaLink link, (data) =>
				if data == null
					post = new @Post
							title 		: obj.title
							permaLink	:	link
							author 		:	obj.author
							body 			: obj.body
							publish : 1
							date			:	new Date()
					post.save (err, data) ->
						if err != null
							throw err.message
						callback(data)
						return
				else
					callback("duplicate post")
		
		findByPermaLink: (permaLink, callback) ->
			@Post.findOne 
				permaLink : permaLink, (err, data) ->
					if err != null
						throw err.message
					callback(data)
					return
		findAll: (callback)->
			@Post.find (err, data) ->
				if err!= null
					throw err.message
				callback(data)
				return
			
		removeAll:->
			@Post.remove {}, ->
				console.log "completed"
					
	new Blog mongoose