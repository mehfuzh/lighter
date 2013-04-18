require 'should'      
helper = (require '../modules/helper')() 
blog = (require __dirname + '/init')

describe 'Blog', ->    
	describe 'findPost', ->
		expected = 'test post'
		_id = ''
		beforeEach (done)->
			promise = blog.create
				title	: 	expected,
				author 	:	'Mehfuz Hossain'
				body	:	'Empty body'
			promise.then (result) =>
				_id = result._id
				done()
					
		it 'should return expected for permaLink', (done)->
	 		promise = blog.findPost helper.linkify('test post')
	 		promise.then (data) ->
				 data.post.title.should.equal expected
				 console.log data
				 done() 
		afterEach (done)->
			blog.deletePost _id, ()->
				done() 

	describe 'update post', ->
		id = '' 
		expected = 'test post'

		beforeEach (done)->
			promise = blog.create
				title	: 	expected,
				author 	:	'Mehfuz Hossain'
				body	:	'Empty body'
			promise.then (result) =>
				id = result._id
				done()

		it 'should update the permalink', (done)->
			promise = blog.updatePost
				id : id
				title : 'updated post'
				body : 'nothing'
			promise.then (result)=>
				console.log result
				result.permaLink.should.equal helper.linkify('updated post')
				done()
		afterEach (done)->
			blog.deletePost id, ()->
				done()

 