module.exports = (settings) ->
	fs = require('fs')
	blog = require(__dirname + '/blog')(settings.mongoose);
	
	fs.readFile __dirname + '/../bin/post.md','utf8', (err, result)->
		 	blog.removeAll()
				parts =  result.split('#block')
				blog.create
					title 	: parts[0]
					body 		: settings.marked(parts[1])
					author	: parts[2], (result)->
						if result.id
							console.log result.id