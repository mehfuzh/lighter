path = require 'path'
settings = (require path.join(__dirname, '../modules/settings'))()
require(path.join(__dirname, '../modules/schema'))(settings.mongoose)
blog = (require '../modules/blog')(settings)

module.exports = blog