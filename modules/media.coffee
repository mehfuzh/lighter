module.exports = (settings)->
	class Media
		constructor:(settings)->
			@media = settings.mongoose.model 'media'
			@helper = (require __dirname + '/helper')()
			@settings = settings
	
		create:(resource)->
			promise = new @settings.Promise
			url = @helper.linkify(resource.slug)
			@media.findOne url:url, (err, data)=>				
				if data is null
					db = @settings.mongoose.connection.db
					gridStore = new settings.GridStore(db, url, 'w')
					gridStore.open (err, gs)=>
						gs.write resource.body, (err, gs)=>
							gs.close (err)=>
								if err isnt null 
									throw err
								media = new @media
									title:resource.slug
									id:resource.id
									url:url
									type:resource.type
									date:new Date()
								media.save (err, data) ->
							 	 	promise.resolve(data)
				else
					promise.resolve(data)

			return promise
		
		get:(url)->
			promise = new @settings.Promise
			@media.findOne url:url, (err, data)=>
				if data isnt null
					db = @settings.mongoose.connection.db
					gridStore = new @settings.GridStore(db, data.url, 'r')
					gridStore.open (err, gs)->
						if typeof gs isnt 'undefined'
							gs.seek 0, ()->
								gs.read (err, data)->
									gs.close (err)=>
										promise.resolve data
						else
							promise.resolve null
				else
					promise.resolve null

			return promise
		
		delete:(url, callback)->
			@media.remove url:url ,()=>
					db = @settings.mongoose.connection.db
					gridStore = new @settings.GridStore(db, url, 'r')
					gridStore.open (err, gs)=>
						gs.unlink (err, result)=>
							if err != null
								throw err
							callback()
		clear:(callback)=>
			@media.find (err, data)=>
				count = 1
				for media in data
					@.delete media.url, ()->
						if (count == data.length)
							callback()
						count++

					
	new Media(settings)