module.exports = (settings) ->
	blog = require(__dirname + '/blog')(settings) 		
	if process.env.NODE_ENV != 'production'
		fs = require('fs')
		user = require(__dirname + '/user')(settings) 
		fs.readFile __dirname + '/../bin/post.md','utf8', (err, result)->  
		 	blog.delete ()->
				posts = []	
				for post in result.split('#post')
					if post != ''
						content = post.split('#block')
						categories = []
						for category in content[3].split(' ')
							category = category.replace(/^\n*|\n*$/g, '')
							categories.push(category)
						promise = blog.createPost
							title 	:	content[0]
							body 	:	content[1]
							author	:	settings.author
							publish	: 	true
							categories : categories	
							
						promise.then (result)->
							if result.id isnt null
								console.log '[%s]', result.permaLink
				console.log 'BootStrapping with data'

