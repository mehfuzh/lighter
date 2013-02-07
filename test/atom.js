// Generated by CoffeeScript 1.4.0
(function() {
  var app, blog, express, fs, helper, path, request, util, xml2js;

  require('should');

  helper = (require('../modules/helper'))();

  express = require('express');

  request = require('supertest');

  xml2js = require('xml2js');

  util = require('util');

  blog = require(__dirname + '/init');

  path = require('path');

  fs = require('fs');

  app = express();

  (require(path.join(__dirname, '../config')))(app);

  (require(path.join(__dirname, '../routes')))(app, blog.settings);

  describe('POST /api/atom/feeds', function() {
    request = request(app);
    return describe('Without authorizaiton header', function() {
      it('should return unauthorized response', function(done) {
        var post;
        post = request.post('/api/atom/feeds');
        return post.expect(401).end(function(err, res) {
          if (err !== null) {
            throw err;
          }
          return done();
        });
      });
      return describe('With authorization header', function() {
        var id,
          _this = this;
        id = '';
        it('should respond correct status code', function(done) {
          var post;
          post = request.post('/api/atom/feeds');
          post.set('Content-Type', 'application/atom+xml');
          post.set('authorization', util.format('Basic %s', new Buffer('admin:admin').toString('base64')));
          return fs.readFile(__dirname + '/post.xml', 'utf8', function(err, result) {
            post.write(result);
            return post.expect(201).end(function(err, res) {
              var parser;
              if (err !== null) {
                throw err;
              }
              parser = new xml2js.Parser();
              parser.parseString(res.text, function(err, result) {
                var lastIndex;
                result.entry.title[0].should.be.ok;
                result.entry.content[0].should.be.ok;
                result.entry.id[0].should.be.ok;
                lastIndex = result.entry.id[0].lastIndexOf('/') + 1;
                return id = result.entry.id[0].substr(lastIndex);
              });
              return done();
            });
          });
        });
        return afterEach(function(done) {
          return blog.deletePost(id, function() {
            return done();
          });
        });
      });
    });
  });

}).call(this);
