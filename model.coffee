model = (app) =>

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Comments = new Schema
			title : String
			text	:	String
			date	:	Date

Post = new Schema
    author    : ObjectId
   	title     : String
   	body      : String
   	buf       : Buffer
   	date      : Date
   	comments  : [Comments]
 

module.exports = model