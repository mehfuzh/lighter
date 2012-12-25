module.exports = ()->
	class Helper
		linkify: (source) ->
			source = source.toLowerCase()
			source = source.replace(/^\s*|\s*$/g, '')
			source = source.replace(/:+/g, '')
			source = source.replace(/\s+/g, '-')
			source.replace(/[?#&]+/g, '')			
			
	return new Helper()