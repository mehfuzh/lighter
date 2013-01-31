module.exports = (settings)->
	class User
		constructor:(settings)->
			@settings = settings 
			@user	= settings.mongoose.model 'user'
			
		# 	initializes the user from settings.
		init:	(callback)->
			 	@user.findOne username : settings.username, (err, data)=>
						if data is null
							user = new @user
								username	: settings.username
								password	:	settings.password
								active		:	true 
								created		:	new Date()
							
							user.save	(err, data)->
								if err isnt null
									throw err
								callback(data)
						else    
					  	callback(data) 
		find:(username, password, callback)->
			@user.findOne 
				username	:	username
				password	:	password, (err, data)-> 
					callback(data)
		
		delete: ()->
			@user.remove ()->
				
	new User(settings)	
		
	