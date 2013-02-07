// Generated by CoffeeScript 1.4.0
(function() {
  var blog, helper;

  require('should');

  helper = (require('../modules/helper'))();

  blog = require(__dirname + '/init');

  describe('Blog', function() {
    return describe('findPost', function() {
      var expected, _id;
      expected = 'test post';
      _id = '';
      beforeEach(function(done) {
        var _this = this;
        return blog.create({
          posts: [
            {
              title: expected,
              author: 'Mehfuz Hossain',
              body: 'Empty body'
            }
          ]
        }, function(result) {
          _id = result._id;
          return done();
        });
      });
      it('should return expected for permaLink', function(done) {
        return blog.findPost(helper.linkify(expected), function(data) {
          data.title.should.equal(expected);
          console.log(data);
          return done();
        });
      });
      return afterEach(function(done) {
        return blog.deletePost(_id, function() {
          return done();
        });
      });
    });
  });

}).call(this);
