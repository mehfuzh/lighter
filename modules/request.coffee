module.exports = (settings)->
		user = require(__dirname + '/user')(settings)
		class Request
			constructor:(settings)->
				@settings = settings
				
			validate:(req, callback)->  
				authValue = req.headers['authorization']     
				if authValue.indexOf('Basic') >= 0
					buff = new Buffer(authValue.split(' ')[1] ,'base64')
					content = buff.toString('utf8')
					if content.indexOf(':') >= 0
						credentials = content.split(':') 
						user.find credentials[0], credentials[1], (data)->
							callback(data)
				else			 
					callback(null)
				
		new Request(settings)
          