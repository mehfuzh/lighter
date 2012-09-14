require 'should'

mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/lighter';

blog = (require '../modules/blog')(mongoose)
helper = (require '../modules/helper')()

describe 'blog', ->
	describe 'create', ->
		before  (done)->
				blog.create
					title 	: "this is a test"
					author 	:	"mehfuz"
					body		: "some text", (result) ->
						console.log result.id
						done()
				return

		it 'should return the same for permalink', (done)->
			blog.findByPermaLink helper.linkify("this is a test"), (data) ->
				(data != null).should.be.true
				done()
			return
		after (done)->
				console.log "remove all"
				blog.removeAll()
				done()
		  return
			