require "should"

mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/lighter';

blog = (require '../models/blog')(mongoose)

describe 'create', ->
	describe 'post', ->
		before  (done)->
				blog.createPost
					title 	: "test"
					author 	:	"mehfuz"
					body		: "some text", (result)->
						console.log result._id
						done()
				return
		it 'should assert find by title', (done)->
			blog.findByTitle "test", (data) ->
				# data.should.not.equal null
				data.title.should.equal "test"
				done()
			return
		after (done)->
				console.log "remove all"
				blog.removeAll()
				done()
		  return
			