require 'should'      

helper = (require '../modules/helper')()     
media = (require __dirname + '/init').media
fs = require('fs')

ObjectId = require('mongodb').ObjectID

describe 'Media', ()->
	buffer = null

	before (done)->
		fs.readFile __dirname + '/../public/logo.png', (err, result)->
			buffer = result
			if Buffer.isBuffer(buffer)
				promise = media.create	
					id:new ObjectId()
					slug:'logo.png'
					type:'image/png'
					body:buffer
				promise.then (result)->
					done()

	it 'should assert the content created', (done)->
		url = helper.linkify 'logo.png'
		promise = media.get url 
		promise.then (result)->
			Buffer.isBuffer(result.data).should.be.ok
			result.data.length.should.equal buffer.length
			result.type.should.equal 'image/png'
			for i in [0...result.length]
				result[i].data.should.equal buffer[i]
			done()

	after (done)->
		url = helper.linkify 'logo.png'
		media.remove url, ()->
			done()


