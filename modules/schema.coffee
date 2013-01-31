module.exports = (mongoose)->
	class Schema
		constructor: (mongoose)->
				Schema = mongoose.Schema
				ObjectId = Schema.ObjectId 
				
				UserSchema = new Schema
					username	: String
					password	:	String
					acive		  : Boolean 
					created		:	Date

				CategorySchema = new Schema
						permaLink	: String
						title	: String

				CommentSchema = new Schema
						title : String
						text	:	String
						date	:	Date

				PostSchema = new Schema
						id				:	ObjectId
						author 		: String
						title			: String
						permaLink	: String
						body			: String
						date			: Date
						categories:	[String]
						comments	:	[CommentSchema]
						publish		: Boolean

				 BlogSchema = new Schema
						url			: String
						title		: String
						updated : Date                
						
				mongoose.model 'user', UserSchema
				mongoose.model 'blog', BlogSchema
				mongoose.model 'category', CategorySchema
				mongoose.model 'post', PostSchema

	new Schema(mongoose)
