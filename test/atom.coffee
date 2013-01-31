require 'should'      
helper = (require '../modules/helper')()     

express = require('express')
request = require 'supertest'
xml2js = require 'xml2js'                                     

blog = require __dirname + '/init'
path = require 'path'
fs = require('fs')  

app = express()         

(require path.join(__dirname, '../config'))(app)
(require path.join(__dirname, '../routes'))(app, blog.settings)                                                      

describe 'POST /api/atom/feeds', ()-> 
	it 'respond correct status code', (done)->    
	  request = request(app).post('/api/atom/feeds').set('Content-Type', 'application/atom+xml'); 
	  fs.readFile __dirname + '/post.xml','utf8', (err, result)->
				request.write(result)
				request.expect(201).end (err, res)->
					if err != null
						 throw err        
					parser = new xml2js.Parser();
					parser.parseString res.text, (err, result)->
						result.entry.title[0].should.be.ok
						result.entry.content[0].should.be.ok
					done() 
	 
		
	