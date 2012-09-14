module.exports = (mongoose) ->
	fs = require('fs')
	blog = require(__dirname + '/blog')(mongoose);

	fs.readFile __dirname + '/../bin/post.md','utf8', (err, result)->
		 	parts =  result.split('#block')
				blog.create
					title 	: parts[0]
					body 		:	parts[1]
					author	: parts[2], (result)->
						if result.id
							console.log result.id
					