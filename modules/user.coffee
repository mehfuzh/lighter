module.exports = (settings)->
	class User
		constructor:(settings)->
			@settings = settings 
			@user	= settings.mongoose.model 'user'
			@crypto = require('crypto')
			
		# 	initializes the user from settings.
		init:	(callback)->
			 	@user.findOne username : settings.username, (err, data)=>
						if data is null
							password = @crypto.createHash('md5').update(settings.password.trim()).digest('hex')
							console.log password
							user = new @user
								username	:	settings.username
								password	:	password
								active		:	true 
								created		:	new Date()
							user.save (err, data)->
								if err isnt null
									throw err
								callback(data)
						else    
					  	callback(data) 
		find:(username, password, callback)->
			password = password.trim()
			password = @crypto.createHash('md5').update(password).digest('hex')
			@user.findOne 
				username	:	username.trim()
				password	:	password, (err, data)-> 
					callback(data)
		
		delete: (callback)->
			@user.remove ()->
				callback()
				
	new User(settings)	
		
	