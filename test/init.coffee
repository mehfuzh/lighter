
class TestBase
	constructor: ()->	
		path = require 'path'
		settings = (require path.join(__dirname, '../modules/settings'))()
		require(path.join(__dirname, '../modules/schema'))(settings.mongoose)
		@blog = (require '../modules/blog')(settings)
		@category = (require '../modules/category')(settings)

	blog : @blog
	category : @category

module.exports = new TestBase()