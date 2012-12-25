module.exports = ->
	class Settings
		constructor: ->
			@mongoose = require('mongoose')
			# init mongo
			@mongoose.connect('mongodb://localhost/lighter');
			@marked = require('marked')			
			@marked.setOptions
				highlight:(code,lang) ->
					hl = require('highlight.js')
					hl.tabReplace = '    '
					(hl.highlightAuto code).value
					
		marked: @marked
		mongoose: @mongoose
		url:'http://localhost:3000/'			
	new Settings()
	