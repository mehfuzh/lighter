path = require 'path'
settings = (require path.join(__dirname, '../modules/settings'))()   
require(path.join(__dirname, '../modules/schema'))(settings.mongoose)

module.exports = (require '../modules/blog')(settings)
	