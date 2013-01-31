module.exports = (settings)->
	class Category
		constructor:(settings)->
			@category = settings.mongoose.model 'category'
			@helper = (require __dirname + '/helper')()
			@cats = []
	
		refresh:(category, callback)->
			link = @helper.linkify(category)
			@category.findOne permaLink:link, (err, data)=>				
		  	if data is null
					category = new @category
						title : category.trim()
						permaLink	: link
					category.save (err, data) ->   
						 	 callback(data._id)
				else
			  	callback(data._id)				
																
		all:(callback)->
			@category.find (err, data)->
				callback(data)
								
		clear:(callback)->
			@category.remove ()->
				callback()
					
	new Category(settings)