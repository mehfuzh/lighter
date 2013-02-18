// Generated by CoffeeScript 1.4.0
(function() {

  module.exports = function() {
    var Settings;
    Settings = (function() {

      function Settings(app) {
        var url;
        this.mongoose = require('mongoose');
        url = process.env.MONGODB_URI || process.env.MONGOLAB_URI || 'mongodb://localhost/lighter';
        this.mongoose.connect(url);
        this.marked = require('marked');
        this.marked.setOptions({
          highlight: function(code, lang) {
            var hl;
            hl = require('highlight.js');
            hl.tabReplace = '    ';
            return (hl.highlightAuto(code)).value;
          }
        });
      }

      Settings.prototype.marked = Settings.marked;

      Settings.prototype.mongoose = Settings.mongoose;

      Settings.prototype.url = '/';

      Settings.prototype.title = process.env.BLOG_TITLE || 'Mehfuz\'s Blog';

      Settings.prototype.username = process.env.USERNAME || 'admin';

      Settings.prototype.password = process.env.PASSWORD || 'admin';

      Settings.prototype.feedUrl = process.env.FEED_URL || null;

      Settings.prototype.updated = new Date();

      Settings.prototype.engine = 'Lighter Blog Engine';

      Settings.prototype.format = function(content) {
        return require(__dirname + '/helper')().htmlEscape(this.marked(content));
      };

      return Settings;

    })();
    return new Settings();
  };

}).call(this);
