module.exports = (settings) ->
	fs = require('fs')
	blog = require(__dirname + '/blog')(settings);	
	fs.readFile __dirname + '/../bin/post.md','utf8', (err, result)->
	 	blog.delete()
			posts = []	
			for post in result.split('#post')
				if post != ''
					content = post.split('#block')
			
					categories = []
			
					for category in content[3].split(' ')
						category = category.replace(/^\n*|\n*$/g, '')
						categories.push(category)
					
					posts.push
						title 	: content[0]
						body 	: content[1]
						author	: content[2]				
						categories : categories		
			blog.create
				posts : posts, (result)->
					if result.id
						console.log result.permaLink
													
								