helper = require './helper'

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
					date	:	Date
		
			PostSchema = new Schema
					author 		: String
					title			: String
					body			: String
					date			: Date
					categories: [CategoriesSchema]
					comments	:	[CommentsSchema]
					publish		: Boolean

			@Post = mongoose.model 'post', PostSchema

		create: (obj, callback) ->				
			@findByTitle obj.title, (data) =>
				if data == null
					title =  helper.linkify(title)
					post = new @Post
							title 		: title
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
					throw 'duplicate post'
		
		findByTitle: (title, callback) ->
			title =  helper.linkify(title)
			@Post.findOne 
				title : title, (err, data) ->
					if err != null
						throw err.message
					callback(data)
					return
					
		removeAll:->
			@Post.remove {}, ->
				console.log "completed"
					
	new Blog mongoose