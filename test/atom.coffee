require 'should'      
helper = (require '../modules/helper')()     

xml2js = require 'xml2js'      
util = require('util')                               

path = require 'path'
fs = require('fs')  

express = require('express')
request = require 'supertest'

app = express()         

blog = (require __dirname + '/init').blog

(require path.join(__dirname, '../config'))(app)
(require path.join(__dirname, '../routes'))(app, blog.settings)

credentials = util.format('%s:%s', blog.settings.username, blog.settings.password)

describe 'Atom', ()->
	request = request(app)
	describe 'list posts', ()->
		id = ''
		expected = 'test post'
		before (done)->
			promise = blog.createPost
					title	: 	expected
					author 	:	'Mehfuz Hossain'
					body	:	'Empty body'
					publish	:	false
			promise.then (result) =>
				id = result._id
				done()
		it 'should return drafts when authorized', (done)=>
			get = request.get('/api/atom/feeds')
			get.set('authorization', util.format('Basic %s', new Buffer(credentials).toString('base64')))
			get.expect(200).end (err, res)=>
				if err isnt null
					throw err
				parser = new xml2js.Parser();
				parser.parseString res.text, (err, result)=>
					match = false
					for entry in result.feed.entry
						if entry.title[0] is expected
							match = true
					match.should.be.true
					done()
		it 'should return only the published when not authorized', (done)=>
			get = request.get('/api/atom/feeds')
			get.expect(200).end (err, res)=>
				if err isnt null
					throw err
				parser = new xml2js.Parser();
				parser.parseString res.text, (err, result)=>
					match = false
					# there are post already
					if typeof result.feed.entry isnt 'undefined'
						for entry in result.feed.entry
							entry.title[0].should.not.equal expected
					done()

		after (done)->
			blog.deletePost id, ()->
				done() 

	describe 'POST /api/atom/feeds', ()->	
		id = ''
		it 'should return 401 for unauthorized request', (done)->
				post = request.post('/api/atom/feeds')
				post.expect(401).end (err, res)->
					if err != null
						throw err
					done()
		it 'should return www authentication header for unauthorized request', (done)->
				post = request.post('/api/atom/feeds')
				post.expect(401).end (err, res)->
					if err != null
						throw err
					wwwAuthHeader = res.headers['WWW-Authenticate'.toLowerCase()]
					wwwAuthHeader.should.be.ok
					wwwAuthHeader.indexOf('Basic').should.equal 0
					done()					
		it 'should return expceted resultset and statuscode', (done)=>
			post = request.post('/api/atom/feeds')
			post.set('Content-Type', 'application/atom+xml')
			post.set('authorization', util.format('Basic %s', new Buffer(credentials).toString('base64')))

			fs.readFile __dirname + '/post.xml','utf8', (err, result)=>   
					post.write(result)
					post.expect(201).end (err, res)->
						if err != null
							 throw err
						parser = new xml2js.Parser();
						parser.parseString res.text, (err, result)->
							result.entry.title[0].should.be.ok
							result.entry.content[0].should.be.ok 
							result.entry.id[0].should.be.ok   
							lastIndex = result.entry.id[0].lastIndexOf('/') + 1
							id = result.entry.id[0].substr(lastIndex)
						done()
		afterEach (done)->
			blog.deletePost id, ()->
				done() 
				
	describe 'PUT /api/atom/entries/:id', ()->	
		id = '' 
		expected = 'test post' 
		before (done)->
			promise = blog.createPost
					title	: 	expected
					author 	:	'Mehfuz Hossain'
					body	:	'Empty body'
			promise.then (result) =>
				id = result._id
				done()
		it 'should return 401 for unauthorized request', (done)->
				req = request.put(util.format('/api/atom/entries/%s', id))
				req.expect(401).end (err, res)->
					if err != null
						throw err
					done()
			it 'should update post return correct status code when authorized', (done)=>
				req = request.put(util.format('/api/atom/entries/%s', id)) 
				req.set('Content-Type', 'application/atom+xml')
				req.set('authorization', util.format('Basic %s', new Buffer(credentials).toString('base64')))
				fs.readFile __dirname + '/post.xml','utf8', (err, result)=>   
						req.write(result)
						req.expect(200).end (err, res)->
							if err != null
								 throw err
							parser = new xml2js.Parser();
							parser.parseString res.text, (err, result)->
								result.entry.title[0].should.be.ok 
								result.entry.content[0]._.length.should.not.equal(0)
								result.entry.id[0].should.be.ok
							done()
		after (done)->
			blog.deletePost id, ()->
				done()   
				
	describe 'DELETE /api/atom/entries/:id', ()->
		expected = 'test post'
		id = ''
		before (done)->
			promise = blog.createPost
					title	: expected
					author 	:	'Mehfuz Hossain'
					body	:	'Empty body'
			promise.then (result) =>
				id = result._id
				done()
		it 'should return 401 for unauthorized request', (done)->
			req = request.del(util.format('/api/atom/entries/%s', id))
			req.expect(401).end (err, res)->   
			 if err != null
					throw err
			 done()	 
		it 'should return expected for authorized request', (done)->
			req = request.del(util.format('/api/atom/entries/%s', id))
			req = req.set('authorization', util.format('Basic %s', new Buffer(credentials).toString('base64')))
			req.expect(200).end (err, res)->   
			 if err != null
					throw err
			 done() 