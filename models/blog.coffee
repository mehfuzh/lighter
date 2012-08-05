module.exports = (mongoose)->
	class Blog
		constructor: (mongoose) ->
			Schema = mongoose.Schema
			ObjectId = Schema.ObjectId

			CommentsSchema = new Schema
						title 	: String
						text	:	String
						date	:	Date

			PostSchema = new Schema
			    author	: {type 	: String, index : true}
			   	title   	: String
			   	body    	: String
			   	date    	: Date
			   	comments	: [CommentsSchema]

			@Post = mongoose.model 'post', PostSchema

		createPost: (obj, callback) ->
				post = new @Post
					title 	:	obj.title
					author 	:	obj.author
					body 		: obj.body
					date		:	new Date()
				post.save (err, data) ->
						callback(data)
						return
					
		findByTitle: (title, callback) ->
			@Post.findOne 
				title : title, (err, data) ->
					callback(data)
					return
					
		removeAll:->
			@Post.remove {}, ->
				console.log "completed"
					
	new Blog mongoose