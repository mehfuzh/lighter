require 'should'      
helper = (require '../modules/helper')() 
blog = require __dirname + '/init'

describe 'Blog', ->    
	describe 'findPost', ->
		expected = 'test post'
		beforeEach (done)->     
		  	blog.create
				  posts			: [{
						title		: expected
						author 	:	'Mehfuz Hossain'
						body		:	'Empty body'}]
						,(result) =>
							console.log result.id
							done()
  	
	 	it 'should return expected for permaLink', (done)->    
				blog.findPost helper.linkify(expected), (data) ->
				 	data.title.should.equal expected
				 	console.log data
				 	done()
	  
	  afterEach (done)->        
				blog.delete ()->
			  	done()  
 