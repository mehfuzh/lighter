module.exports = ()->
	util = require('util')
	date = new Date()  

	class Helper
		linkify: (source) ->
			source = source.toLowerCase()
			source = source.replace(/^\s*|\s*$/g, '')
			source = source.replace(/:+/g, '')
			source = source.replace(/\s+/g, '-')
			source.replace(/[?#&]+/g, '') 
			util.format("%s/%s/%s", date.getFullYear(), date.getMonth() + 1, source)   
				
	return new Helper()