module.exports = (mongoose)->
	class Schema
		constructor: (mongoose)->
				Schema = mongoose.Schema
				ObjectId = Schema.ObjectId

				CategoriesSchema = new Schema
						title	: String

				CommentsSchema = new Schema
						title : String
						text	:	String
						date		:	Date

				PostSchema = new Schema
						id				:	ObjectId
						author 		: String
						title			: String
						permaLink	: String
						body			: String
						date			: Date
						categories: [CategoriesSchema]
						comments	:	[CommentsSchema]
						publish		: Boolean

				 BlogSchema = new Schema
						url			: String
						title		: String
						updated : Date
				
				mongoose.model 'blog', BlogSchema
				mongoose.model 'post', PostSchema

	new Schema(mongoose)
