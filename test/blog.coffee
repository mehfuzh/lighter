require 'should'      
helper = (require '../modules/helper')() 
blog = (require __dirname + '/init')

describe 'Blog', ->    
	describe 'findPost', ->
		expected = 'test post'
		_id = ''
		beforeEach (done)->     
		  	blog.create
				  posts			: [{
						title		: expected
						author 	:	'Mehfuz Hossain'
						body		:	'Empty body'}]
						,(result) =>
							_id = result._id
							done()
  	
	 	it 'should return expected for permaLink', (done)->
	 		blog.findPost helper.linkify('test post'), (data) ->
				 data.post.title.should.equal expected
				 console.log data
				 done()
	  
	  afterEach (done)->        
				blog.deletePost _id, ()->
			  	done()  
 