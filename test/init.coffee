path = require 'path'
app = {}
settings = (require path.join(__dirname, '../modules/settings'))(app)
require(path.join(__dirname, '../modules/schema'))(settings.mongoose)
blog = (require '../modules/blog')(settings)

module.exports = blog