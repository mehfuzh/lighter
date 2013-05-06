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

describe 'atom feed', ()->
	request = request(app)
	describe 'POST /api/atom/feeds', ()->	
		id = ''
		it 'should return 401 for unauthorized request', (done)->
				post = request.post('/api/atom/feeds')
				post.expect(401).end (err, res)->
					if err != null
						throw err
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
			promise = blog.create
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
			promise = blog.create
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