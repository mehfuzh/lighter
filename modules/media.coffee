module.exports = (settings)->
	class Media
		constructor:(settings)->
			@media = settings.mongoose.model 'media'
			@helper = (require __dirname + '/helper')()
			@settings = settings
	
		create:(res)->
			promise = new @settings.Promise
			link = @helper.linkify(res.slug)
			
			@media.findOne link, (err, data)=>				
				if data is null
					media = new @media
						title:res.slug
						id:res.id
						url:link
						type:res.type
						date:new Date()
					media.save (err, data) ->   
						 	 promise.resolve(data)
				else
					promise.resolve(data)

			return promise
		
		get:(url)->
			promise = new @settings.Promise
			@media.findOne url: url, (err, data)=>
				if data isnt null
					promise.resolve data
				else
					promise.resolve null

			return promise				
					
	new Media(settings)